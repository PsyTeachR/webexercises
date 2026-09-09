.onLoad <- function(libname, pkgname) {
  invisible(suppressPackageStartupMessages(
    sapply(c("rstan", "StanHeaders"),
           requireNamespace, quietly = TRUE)
  ))
}
