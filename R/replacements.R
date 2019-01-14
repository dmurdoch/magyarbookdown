ref_to_number = function(ref, ref_table, backslash) {
  if (length(ref) == 0) return(ref)
  magyar_article = function(num) {
    ifelse(grepl("^5", num) |
           (grepl("^1", num) & (nchar(num) %% 3 == 1)), "ar", "a")
  }
  aref = grepl("@aref", ref)
  lab = gsub(if (backslash) '^\\\\@a?ref\\(|\\)$' else '^@a?ref\\(|\\)$', '', ref)
  ref = prefix_section_labels(lab)
  num = ref_table[ref]
  i = is.na(num)
  if (any(i)) {
    if (!isTRUE(opts$get('preview')))
      warning('The label(s) ', paste(lab[i], collapse = ', '), ' not found', call. = FALSE)
    num[i] = '<strong>??</strong>'
  }
  ar <- magyar_article(num[aref])
  # equation references should include parentheses
  i = grepl('^eq:', ref)
  num[i] = paste0('(', num[i], ')')
  num[aref] <- paste(ar, num[aref])
  res = sprintf('<a href="#%s">%s</a>', ref, num)
  # do not add relative links to equation numbers in ePub/Word (not implemented)
  ifelse(backslash & i, num, res)
}

environment(ref_to_number) <- environment(bookdown:::ref_to_number)

resolve_refs_html = function(content, global = FALSE) {
  content = resolve_ref_links_html(content)

  res = parse_fig_labels(content, global)
  content = res$content
  ref_table = c(res$ref_table, parse_section_labels(content))

  # look for @ref(label) or @aref(label) and resolve to actual figure/table/section numbers
  m = gregexpr('(?<!\\\\)(@a?ref)\\(([-:[:alnum:]]+)\\)', content, perl = TRUE)
  refs = regmatches(content, m)
  for (i in seq_along(refs)) {
    if (length(refs[[i]]) == 0) next
    # strip off html tags when resolve numbers in <img>'s alt attribute because
    # the numbers may contain double quotes, e.g. <img alt="<a
    # href="#foo">1.2</a>"" width=...
    ref = ref_to_number(refs[[i]], ref_table, FALSE)
    if (is_img_line(content[i])) ref = strip_html(ref)
    refs[[i]] = ref
  }
  regmatches(content, m) = refs
  content
}

environment(resolve_refs_html) <- environment(bookdown:::resolve_refs_html)

resolve_refs_latex = function(x) {
  # equation references \eqref{}
  x = gsub(
    '(?<!\\\\textbackslash{})@a?ref\\((eq:[-/:[:alnum:]]+)\\)', '\\\\eqref{\\1}', x,
    perl = TRUE
  )
  # normal references \ref{} or \aref{}
  x = gsub(
    '(?<!\\\\textbackslash{})@(a?)ref\\(([-/:[:alnum:]]+)\\)', '\\\\\\1ref{\\2}', x,
    perl = TRUE
  )
  x = gsub(sprintf('\\(\\\\#((%s):[-/[:alnum:]]+)\\)', reg_label_types), '\\\\label{\\1}', x)
  x
}

environment(resolve_refs_latex) <- environment(bookdown:::resolve_refs_latex)
