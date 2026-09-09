
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ucminf

<!-- badges: start -->

[![R-CMD-check](https://github.com/hdakpo/ucminf/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/hdakpo/ucminf/actions/workflows/R-CMD-check.yaml)
[![Downloads](https://cranlogs.r-pkg.org/badges/ucminf)](https://CRAN.R-project.org/package=ucminf)
[![](https://img.shields.io/github/languages/code-size/hdakpo/ucminf.svg)](https://github.com/hdakpo/ucminf)
[![](https://img.shields.io/badge/license-GPL-blue)](https://github.com/hdakpo/ucminf)
[![CRAN
status](https://www.r-pkg.org/badges/version/ucminf)](https://CRAN.R-project.org/package=ucminf)
<!-- badges: end -->

The goal of *ucminf* is to provide an algorithm for general-purpose
unconstrained non-linear optimization. The algorithm is of quasi-Newton
type with BFGS updating of the inverse Hessian and soft line search with
a trust region type monitoring of the input to the line search
algorithm. The interface of *ucminf* is designed for easy interchange
with `optim`

## Installation

You can install the development version of ucminf from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("hdakpo/ucminf")
```

## Example

``` r
library(ucminf)
# Rosenbrock Banana function
fR <- function(x) (1 - x[1])^2 + 100 * (x[2] - x[1]^2)^2
gR <- function(x) c(-400 * x[1] * (x[2] - x[1] * x[1]) - 2 * (1 - x[1]),
                     200 * (x[2] - x[1] * x[1]))
##  Find minimum and show trace
optRes <- ucminf(par = c(2,.5), fn = fR, gr = gR, control = list(trace = 1))
#>  neval =   1, F(x) = 1.2260e+03, max|g(x)| = 2.8020e+03
#>  x = 2.0000e+00, 5.0000e-01
#>  Line search: alpha = 1.0000e+00, dphi(0) =-2.8881e+03, dphi(1) =-1.4263e+02
#>  neval =   2, F(x) = 1.0123e+01, max|g(x)| = 1.3111e+02
#>  x = 1.0298e+00, 7.4237e-01
#>  Line search: alpha = 1.0000e+00, dphi(0) =-3.1743e+01, dphi(1) = 1.0180e+01
#>  neval =   3, F(x) = 1.7049e+00, max|g(x)| = 6.3969e+01
#>  x = 1.2600e+00, 1.7155e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-2.5788e+00, dphi(1) =-5.6182e-01
#>  neval =   4, F(x) = 1.1612e-01, max|g(x)| = 1.2343e+01
#>  x = 1.2174e+00, 1.5083e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-1.5867e-01, dphi(1) = 1.2108e-02
#>  neval =   5, F(x) = 4.2253e-02, max|g(x)| = 1.8638e+00
#>  x = 1.2033e+00, 1.4449e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-1.1826e-03, dphi(1) =-3.2371e-04
#>  neval =   6, F(x) = 4.1500e-02, max|g(x)| = 8.6681e-01
#>  x = 1.2035e+00, 1.4474e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-5.9673e-04, dphi(1) =-4.7194e-04
#>  neval =   7, F(x) = 4.0965e-02, max|g(x)| = 4.8839e-01
#>  x = 1.2024e+00, 1.4456e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-3.9731e-03, dphi(1) =-2.3018e-03
#>  neval =   8, F(x) = 3.7853e-02, max|g(x)| = 8.5215e-01
#>  x = 1.1928e+00, 1.4254e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-8.0453e-03, dphi(1) =-6.3954e-03
#>  neval =   9, F(x) = 3.0800e-02, max|g(x)| = 2.0990e+00
#>  x = 1.1676e+00, 1.3685e+00
#>  Line search: alpha = 8.2084e-01, dphi(0) =-4.4175e-02, dphi(1) = 1.8746e-02
#>  neval =  11, F(x) = 4.8486e-03, max|g(x)| = 2.2862e+00
#>  x = 1.0458e+00, 1.0884e+00
#>  Line search: alpha = 3.8293e-01, dphi(0) =-4.8734e-03, dphi(1) = 4.6817e-04
#>  neval =  13, F(x) = 4.0485e-03, max|g(x)| = 1.1863e+00
#>  x = 1.0584e+00, 1.1177e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-6.4354e-04, dphi(1) =-5.6879e-04
#>  neval =  14, F(x) = 3.4426e-03, max|g(x)| = 1.1238e+00
#>  x = 1.0535e+00, 1.1074e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-4.7371e-03, dphi(1) =-1.0920e-03
#>  neval =  15, F(x) = 6.1678e-04, max|g(x)| = 7.3075e-01
#>  x = 1.0180e+00, 1.0347e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-7.9043e-04, dphi(1) =-2.5377e-04
#>  neval =  16, F(x) = 1.0437e-04, max|g(x)| = 1.6394e-01
#>  x = 1.0096e+00, 1.0189e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-1.8089e-04, dphi(1) =-1.8237e-05
#>  neval =  17, F(x) = 5.8219e-06, max|g(x)| = 9.1455e-02
#>  x = 1.0009e+00, 1.0016e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-1.3102e-05, dphi(1) = 2.0222e-06
#>  neval =  18, F(x) = 2.9162e-07, max|g(x)| = 1.7185e-02
#>  x = 1.0003e+00, 1.0007e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-5.9332e-07, dphi(1) = 1.1234e-08
#>  neval =  19, F(x) = 1.2578e-10, max|g(x)| = 2.0751e-04
#>  x = 9.9999e-01, 9.9998e-01
#>  Line search: alpha = 1.0000e+00, dphi(0) =-2.5270e-10, dphi(1) = 1.1297e-12
#>  neval =  20, F(x) = 3.5670e-15, max|g(x)| = 2.0836e-06
#>  x = 1.0000e+00, 1.0000e+00
#>  Line search: alpha = 1.0000e+00, dphi(0) =-7.1150e-15, dphi(1) =-1.8980e-17
#>  Optimization has converged
#> Stopped by small gradient (grtol). 
#>  maxgradient     laststep      stepmax        neval 
#> 1.020598e-08 6.480989e-08 1.225000e-01 2.100000e+01
```
