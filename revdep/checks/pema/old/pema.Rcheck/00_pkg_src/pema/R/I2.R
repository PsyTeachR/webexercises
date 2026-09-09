#' @title Compute I2
#' @description I2 represents the amount of heterogeneity relative to the total
#' amount of variance in the observed effect sizes (Higgins & Thompson, 2002).
#' For three-level meta-analyses, it is additionally broken down into I2_w
#' (amount of within-cluster heterogeneity) and I2_b (amount of between-cluster
#' heterogeneity).
#' @param x An object for which a method exists.
#' @param ... Arguments passed to other functions.
#' @return Numeric matrix, with rows corresponding to I2 (total heterogeneity),
#' and optionally I2_w and I2_b (within- and between-cluster heterogeneity).
#' @examples
#' I2(matrix(1:20, ncol = 1))
#' @rdname I2
#' @export
I2 <- function(x, ...){
  UseMethod("I2", x)
}

#' @method I2 brma
#' @export
I2.brma <- function(x, ...){

  fit <- x$fit
  taus <- sapply(grep("^tau2", rownames(x$coefficients), value = TRUE), function(p){
    .extract_samples(fit@sim, par = p)
  })

  W <- diag(1/x$vi)
  X <- x$X
  P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W

  I2mat <- 100 * taus / (rowSums(taus) + (x$k-ncol(x$X))/sum(diag(P)))
  colnames(I2mat) <- gsub("tau", "I", colnames(I2mat), fixed = TRUE)
  if(ncol(I2mat) > 1) I2mat <- cbind(I2mat, I2mat = rowSums(I2mat))
  I2(I2mat)
}

#' @method I2 default
#' @export
I2.default <- function(x, ...){
  cbind(
    mean = colMeans(x),
    sd = apply(x, 2, sd),
    t(apply(x, 2, quantile, probs = c(.025, .25, .5, .75, .975)))
  )
}
