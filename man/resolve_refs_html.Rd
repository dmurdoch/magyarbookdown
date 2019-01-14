\name{resolve_refs_html}
\alias{resolve_refs_html}
\alias{resolve_refs_latex}
\alias{ref_to_number}
\title{
Substitute resolve functions for bookdown
}
\description{
These functions are monkey-patched into bookdown to allow it
to support Hungarian language with code like \code{@aref(figure)}.
}
\usage{
resolve_refs_html(content, global = FALSE)
resolve_refs_latex(x)
ref_to_number(ref, ref_table, backslash)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{content, global, x, ref, ref_table, backslash}{
What the original args meant.
}
}

\value{
These return what the original \pkg{bookdown} functions would
return.
}

\author{
The bulk of the text of these functions was written by the
authors of \pkg{bookdown}.
}

\examples{
bookdown:::resolve_refs_html(c('<caption>(#tab:foo) A nice table.</caption>', '<p>See Table @ref(tab:foo), or in
Hungarian, @aref(tab:foo) Table</p>'), TRUE)
}
