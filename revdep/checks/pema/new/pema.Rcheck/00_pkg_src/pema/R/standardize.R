x <- model.matrix(~.-1, iris)
x[5,5]<-NA
scale_continuous <- function(x, center = TRUE, scale = TRUE, continuous = apply(x, 2, function(i){length(unique(na.omit(i))) > 2})){
  if(any(continuous)){
    these <- which(continuous)
    standardize <- list(center = rep(0, ncol(x)), scale = rep(1, ncol(x)))
    stdz <- x[, these, drop = FALSE]
    stdz <- scale(stdz, center = center, scale = scale)
    standardize$center[these] <- attr(stdz, "scaled:center")
    standardize$scale[these] <- attr(stdz, "scaled:scale")
    x[, these] <- stdz
  }
  class(x) <- c("pema_std", class(x))
  x
}
