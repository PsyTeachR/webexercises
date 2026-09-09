Vectorized bivariate normal CDF
===============================

`pbivnorm` is an R package containing a vectorized function to compute the
bivariate normal CDF.  It is based on
[the `mnormt` package](http://cran.r-project.org/web/packages/mnormt/index.html)
by [Adelchi Azzalini](http://azzalini.stat.unipd.it/index-en.html), which uses
Fortran code by [Alan Genz](http://www.math.wsu.edu/faculty/genz/homepage) to
compute integrals of multivariate normal densities.

A call to `pbivnorm()` produces identical output to a corresponding set of
calls to `mnormt::pmnorm()`, but at lower computational cost due to
vectorization (i.e., looping in Fortran rather than in R).

    R> library("pbivnorm")
    R> library("mnormt")
    R> set.seed(9497)
    R> x1 <- rnorm(10)
    R> x2 <- rnorm(10)
    R> X <- cbind(x1, x2)
    R> all.equal(pbivnorm(X), apply(X, 1, pmnorm, mean = c(0, 0), varcov = diag(2)))
    ## [1] TRUE
    
    R> library("microbenchmark")
    R> microbenchmark(pbivnorm = pbivnorm(X),
       mnormt = apply(X, 1, pmnorm, mean = c(0, 0), varcov = diag(2)))
    ## Unit: microseconds
    ##      expr      min       lq   median       uq     max neval
    ##  pbivnorm   59.373   61.851   66.987   73.373  140.38   100
    ##    mnormt 1052.671 1074.699 1091.472 1120.907 2283.88   100

