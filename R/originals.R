check <- function(fun, env) {
  saved <- get(paste0(fun, "0"))
  saved <- removeSource(saved)
  current <- get(fun, env)
  current <- removeSource(current)
  if (!identical(body(saved), body(current)))
    warning("Code in ", paste0("bookdown::", fun), " has changed.")
  if (!identical(args(saved), args(current)))
    warning("Arguments for ", paste0("bookdown::", fun), " have changed.")
}

ref_to_number0 <- function (ref, ref_table, backslash)
{
  if (length(ref) == 0)
    return(ref)
  lab = gsub(if (backslash)
    "^\\\\@ref\\(|\\)$"
    else "^@ref\\(|\\)$", "", ref)
  ref = prefix_section_labels(lab)
  num = ref_table[ref]
  i = is.na(num)
  if (any(i)) {
    if (!isTRUE(opts$get("preview")))
      warning("The label(s) ", paste(lab[i], collapse = ", "),
              " not found", call. = FALSE)
    num[i] = "<strong>??</strong>"
  }
  i = grepl("^eq:", ref)
  num[i] = paste0("(", num[i], ")")
  res = sprintf("<a href=\"#%s\">%s</a>", ref, num)
  ifelse(backslash & i, num, res)
}

resolve_refs_html0 <- function (content, global = FALSE)
{
  content = resolve_ref_links_html(content)
  res = parse_fig_labels(content, global)
  content = res$content
  ref_table = c(res$ref_table, parse_section_labels(content))
  m = gregexpr("(?<!\\\\)@ref\\(([-:[:alnum:]]+)\\)", content,
               perl = TRUE)
  refs = regmatches(content, m)
  for (i in seq_along(refs)) {
    if (length(refs[[i]]) == 0)
      next
    ref = ref_to_number(refs[[i]], ref_table, FALSE)
    if (is_img_line(content[i]))
      ref = strip_html(ref)
    refs[[i]] = ref
  }
  regmatches(content, m) = refs
  content
}

resolve_refs_latex0 <- function (x)
{
  x = gsub("(?<!\\\\textbackslash{})@ref\\((eq:[-/:[:alnum:]]+)\\)",
           "\\\\eqref{\\1}", x, perl = TRUE)
  x = gsub("(?<!\\\\textbackslash{})@ref\\(([-/:[:alnum:]]+)\\)",
           "\\\\ref{\\1}", x, perl = TRUE)
  x = gsub(sprintf("\\(\\\\#((%s):[-/[:alnum:]]+)\\)", reg_label_types),
           "\\\\label{\\1}", x)
  x
}
