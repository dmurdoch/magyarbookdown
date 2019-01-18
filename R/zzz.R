.onLoad <- function(libname, pkgname) {
  env <- environment(bookdown::resolve_refs_html)

  unlockBinding("resolve_refs_html", env)
  assignInNamespace("resolve_refs_html", resolve_refs_html, "bookdown")
  lockBinding("resolve_refs_html", env)

  unlockBinding("resolve_refs_latex", env)
  assignInNamespace("resolve_refs_latex", resolve_refs_latex, "bookdown")
  lockBinding("resolve_refs_latex", env)

  unlockBinding("ref_to_number", env)
  assignInNamespace("ref_to_number", ref_to_number, "bookdown")
  lockBinding("ref_to_number", env)
}
