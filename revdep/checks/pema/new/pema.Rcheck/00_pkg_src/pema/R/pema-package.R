#' pema: Conduct penalized meta-regression.
#'
#' @description Penalized meta-regression shrinks the regression slopes of
#' irrelevant moderators towards zero (Van Lissa & Van Erp, 2021).
#'
#' @name pema-package
#' @aliases pema
#' @useDynLib pema, .registration = TRUE
#' @import methods
#' @import Rcpp
#' @importFrom rstan sampling
#'
#' @references
#' Van Lissa, C. J., van Erp, S., & Clapper, E. B. (2023).
#' Selecting relevant moderators with Bayesian regularized
#' meta-regression. Research Synthesis Methods.
#' \doi{10.31234/osf.io/6phs5}
#'
#' Stan Development Team (NA). RStan: the R interface to Stan. R package version
#' 2.26.2. \url{https://mc-stan.org}
#'
"_PACKAGE"
