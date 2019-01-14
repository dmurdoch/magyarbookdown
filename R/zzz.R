.onLoad <- function(libname, pkgname) {
  assignInNamespace("resolve_refs_html", resolve_refs_html, "bookdown")
  assignInNamespace("resolve_refs_latex", resolve_refs_latex, "bookdown")
  assignInNamespace("ref_to_number", ref_to_number, "bookdown")
}
