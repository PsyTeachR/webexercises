
<!-- README.md is generated from README.Rmd. Please edit that file -->

# QuickJSR

<!-- badges: start -->

[![R-CMD-check](https://github.com/andrjohns/QuickJSR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/andrjohns/QuickJSR/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/QuickJSR)](https://CRAN.R-project.org/package=QuickJSR)
[![Monthly
Downloads](https://cranlogs.r-pkg.org/badges/QuickJSR?color=blue)](https://CRAN.R-project.org/package=QuickJSR)
[![Total
Downloads](https://cranlogs.r-pkg.org/badges/grand-total/QuickJSR)](https://cranlogs.r-pkg.org/badges/grand-total/QuickJSR)
[![QuickJSR status
badge](https://andrjohns.r-universe.dev/badges/QuickJSR)](https://andrjohns.r-universe.dev/QuickJSR)
<!-- badges: end -->

A portable, lightweight, zero-dependency JavaScript engine for R, using
[QuickJS](https://bellard.org/quickjs/).

Values and objects are directly passed between R and QuickJS, with no
need for serialization or deserialization. This both reduces overhead
and allows for more complex data structures to be passed between R and
JavaScript - including functions.

## Installation

You can install the development version of QuickJSR from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("andrjohns/QuickJSR")
```

Or you can install pre-built binaries from R-Universe:

``` r
install.packages("QuickJSR", repos = c("https://andrjohns.r-universe.dev",
                                        "https://cran.r-project.org"))
```

## Usage

For standalone or simple JavaScript code, you can use the `qjs_eval()`
function:

``` r
library(QuickJSR)

qjs_eval("1 + 1")
#> [1] 2
qjs_eval("Math.random()")
#> [1] 0.816737
```

For more complex interactions, you can create a QuickJS context and
evaluate code within that context:

``` r
ctx <- JSContext$new()
```

Use the `$source()` method to load JavaScript code into the context:

``` r
# Code can be provided as a string
ctx$source(code = "function add(a, b) { return a + b; }")

# Or read from a file
subtract_js <- tempfile(fileext = ".js")
writeLines("function subtract(a, b) { return a - b; }", subtract_js)
ctx$source(file = subtract_js)
```

Then use the `$call()` method to call a specified function with
arguments:

``` r
ctx$call("add", 1, 2)
#> [1] 3
ctx$call("subtract", 5, 3)
#> [1] 2
```

### Interacting with R objects, environments, and functions

As QuickJSR uses the respective C APIs of R and QuickJS to pass values
between the two, this allows for more complex data structures to be
passed between R and JavaScript.

For example, you can also pass R functions to be evaluated using
JavaScript arguments:

``` r
ctx$source(code = "function callRFunction(f, x, y) { return f(x, y); }")
ctx$call("callRFunction", function(x, y) x + y, 1, 2)
#> [1] 3
ctx$call("callRFunction", function(x, y) paste0(x, ",", y), "a", "b")
#> [1] "a,b"
```

You can pass R environments to JavaScript, and both access and update
their contents:

``` r
env <- new.env()
env$x <- 1
env$y <- 2

ctx$source(code = "function accessEnv(env) { return env.x + env.y; }")
ctx$call("accessEnv", env)
#> [1] 3

ctx$source(code = "function updateEnv(env) { env.z = env.x * env.y; return env.z;}")
ctx$call("updateEnv", env)
#> [1] 2

env$z
#> [1] 2
```

QuickJSR also provides a global `R` object, which you can use to access
objects and functions from various R packages:

``` r
qjs_eval('R.package("base")["Sys.Date"]()')
#> [1] "2026-08-21 08:00:00 AWST"
```
