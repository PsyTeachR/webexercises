
<!-- badges: start -->

[![R-CMD-check](https://github.com/rstudio/jquerylib/workflows/R-CMD-check/badge.svg)](https://github.com/rstudio/jquerylib/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/jquerylib)](https://CRAN.R-project.org/package=jquerylib)
<!-- badges: end -->

# jquerylib

Obtain ‘jQuery’ as an HTML dependency object

## Installation

**jquerylib** can be installed with:

``` r
install.packages("jquerylib")
```

## Usage

The **jquerylib** package currently has one function,`jquery_core()`,
which returns a `htmltools::htmlDependency()` object that [bundles a
stable version of jQuery Core](https://code.jquery.com/). Here we use it
to obtain jQuery 3.x, but currently 2.x and 1.x are also supported. You
likely won’t need to use this package directly, but packages like
**shiny** and **rmarkdown** will eventually use this package to avoid
bundling redundant copies jQuery.

``` r
jquerylib::jquery_core(3)
```

    ## List of 10
    ##  $ name      : chr "jquery"
    ##  $ version   : chr "3.6.0"
    ##  $ src       :List of 1
    ##   ..$ file: chr "lib/3.6.0"
    ##  $ meta      : NULL
    ##  $ script    : chr "jquery-3.6.0.min.js"
    ##  $ stylesheet: NULL
    ##  $ head      : NULL
    ##  $ attachment: NULL
    ##  $ package   : chr "jquerylib"
    ##  $ all_files : logi TRUE
    ##  - attr(*, "class")= chr "html_dependency"
