#' @title Maximum a posteriori parameter estimate
#' @description Find the parameter estimate with the highest posterior
#' probability density given a vector of samples.
#' @param x Numeric vector.
#' @param dens Optional object of class `density`. Defaults to `NULL`.
#' @param ... Arguments passed to \code{\link[stats]{density}}
#' @return Atomic numeric vector with the maximum a-posteriori estimate of
#' vector `x`.
#' @examples
#' maxap(c(1,2,3,4,5))
#' @export
#' @importFrom stats density
maxap <- function(x, dens = NULL, ...) {
  rangex <- range(x)
  if(is.null(dens)) dens <- density(x, bw = "SJ", from = rangex[1], to = rangex[2], ...)
  dens$x[which.max(dens$y)]
}

#
# highest_alpha <- function(alpha, df, x.min, x.max, ...) {
#   p <- function(h) {
#     g <- function(x) {y <- df(x); ifelse(y > h, y, 0)}
#     integrate(g, x.min, x.max, ...)$value - alpha
#   }
#   uniroot(p, c(x.min, x.max), tol=1e-12)$root
# }
# as.pdf <- function(x, y, ...) {
#   f <- approxfun(x, y, method="linear", yleft=0, yright=0, rule=2)
#   const <- integrate(f, min(x), max(x), ...)$value
#   approxfun(x, y/const, method="linear", yleft=0, yright=0, rule=2)
# }
# highest_alpha(.95, as.pdf(dens$x, dens$y), rangex[1], rangex[2])
# bayestestR::hdi(x)
#
# hpdi <- function(x, ci = 0.95, dens = NULL, ...) {
#   x <- unname(sort.int(x, method = "quick"))
#   if(is.null(dens)) dens <- density(x, bw = "SJ", from = rangex[1], to = rangex[2], ...)
#   pointdens <- approx(dens$x, dens$y, xout = x)
#   best <- 0
#   for(lb in 1:(length(x) - 1)){
#     for (ub in (lb + 1) : length(x)){
#       mass = sum(diff(x[lb : ub]) * dens$y[dens$x > x[lb] & dens$x <= x[ub]])
#       if (mass >= ci && mass / (x[ub] - x[lb]) > best){
#         best = mass / (x[ub] - x[lb])
#         lb.best = lb
#         ub.best = ub
#       }
#     }
#   }
#
#   c(x[lb.best], x[ub.best])}
#
#
#
#   window_size <- ceiling(ci * length(x_sorted))
#
#   if (window_size < 2) {
#     if (verbose) {
#       warning("`ci` is too small or x does not contain enough data points, returning NAs.")
#     }
#     return(data.frame(
#       "CI" = ci,
#       "CI_low" = NA,
#       "CI_high" = NA
#     ))
#   }
#
#   nCIs <- length(x_sorted) - window_size
#
#   if (nCIs < 1) {
#     if (verbose) {
#       warning("`ci` is too large or x does not contain enough data points, returning NAs.")
#     }
#     return(data.frame(
#       "CI" = ci,
#       "CI_low" = NA,
#       "CI_high" = NA
#     ))
#   }
#
#   ci.width <- sapply(1:nCIs, function(.x) x_sorted[.x + window_size] - x_sorted[.x])
#
#   # find minimum of width differences, check for multiple minima
#   min_i <- which(ci.width == min(ci.width))
#   n_candies <- length(min_i)
#
#   if (n_candies > 1) {
#     if (any(diff(sort(min_i)) != 1)) {
#       if (verbose) {
#         warning("Identical densities found along different segments of the distribution, choosing rightmost.", call. = FALSE)
#       }
#       min_i <- max(min_i)
#     } else {
#       min_i <- floor(mean(min_i))
#     }
#   }
#
#   data.frame(
#     "CI" = ci,
#     "CI_low" = x_sorted[min_i],
#     "CI_high" = x_sorted[min_i + window_size]
#   )
# }
