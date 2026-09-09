
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tzdb

<!-- badges: start -->

[![R-CMD-check](https://github.com/r-lib/tzdb/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-lib/tzdb/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/tzdb/graph/badge.svg)](https://app.codecov.io/gh/r-lib/tzdb)
<!-- badges: end -->

tzdb is a developer focused R package with two purposes:

- It ships an up-to-date copy of the IANA time zone database files.

- It provides low-level access to the C++ library,
  [date](https://github.com/HowardHinnant/date).

To use the C++ API supplied by tzdb:

- Add tzdb to both Imports and LinkingTo.

- Call `tzdb::tzdb_initialize()` from your `.onLoad()`.

- Access the date API through `#include <tzdb/*.h>` where `*` is
  replaced with the date header you want to use.

Note that while `tzdb/tz.h` declares many functions and types, most of
their implementations are not present in the header file. This means
that the functions in `tzdb/tz.h` are *not* safe to call from your R
package. Instead, the most critical helpers have been exposed in a safe
way in `tzdb/tzdb.h`. Use these instead.

## Installation

You can install the released version of tzdb from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("tzdb")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("r-lib/tzdb")
```
