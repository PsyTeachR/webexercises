
# pema: Penalized Meta-Analysis <!--a href='https://doi.org/10.31234/osf.io/6phs5'><img src='https://github.com/cjvanlissa/pema/raw/master/docs/pema_icon.png' align="right" height="139" /></a-->

[![CRAN
status](https://www.r-pkg.org/badges/version/pema)](https://CRAN.R-project.org/package=pema)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/grand-total/pema?color=blue)](https://cran.r-project.org/package=pema)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/cjvanlissa/pema/workflows/R-CMD-check/badge.svg)](https://github.com/cjvanlissa/pema/actions)
<!-- [![R-CMD-check](https://github.com/cjvanlissa/pema/workflows/R-CMD-check/badge.svg)](https://github.com/cjvanlissa/pema/actions) -->
<!-- [![codecov](https://codecov.io/gh/cjvanlissa/pema/branch/master/graph/badge.svg?token=7S9XKDRT4M)](https://codecov.io/gh/cjvanlissa/pema) -->
[![Contributor
Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](https://www.contributor-covenant.org/version/2/0/code_of_conduct.html)
<!-- [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3969/badge)](https://bestpractices.coreinfrastructure.org/projects/3969) -->

Conduct *pe*nalized *m*eta-*a*nalysis (*“pema”*) In meta-analysis, there
are often between-study differences. These can be coded as moderator
variables, and controlled for using meta-regression. However, if the
number of moderators is large relative to the number of studies, such an
analysis may be overfitted. Penalized meta-regression is useful in these
cases, because it shrinks the regression slopes of irrelevant moderators
towards zero.

## Where do I start?

For most users, the recommended starting point is to [read the
paper](https://doi.org/10.31234/osf.io/6phs5) published in **Research
Synthesis Methods**, which introduces the method, validates it, and
provides a tutorial example.

## Installing the package

Use [CRAN](https://CRAN.R-project.org/package=pema) to install the
latest release of `pema`:

    install.packages("pema")

Alternatively, use [R-universe](https://cjvanlissa.r-universe.dev) to
install the development version of `pema` by running the following code:

``` r
options(repos = c(
    cjvanlissa = 'https://cjvanlissa.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'))

install.packages('pema')
```

## Citing pema

You can cite `pema` using the following citation (please use the same
citation for either the package, or the paper):

> Van Lissa, C. J., van Erp, S., & Clapper, E. B. (2023). Selecting
> relevant moderators with Bayesian regularized meta-regression.
> *Research Synthesis Methods*. <https://doi.org/10.31234/osf.io/6phs5>

## About this repository

This repository contains the source code for the R-package called
`pema`.

## Contributing and Contact Information

We are always eager to receive user feedback and contributions to help
us improve both the workflow and the software. Major contributions
warrant coauthorship to the package. Please contact the lead author at
<c.j.vanlissa@uu.nl>, or:

- [File a GitHub issue](https://github.com/cjvanlissa/pema) for
  feedback, bug reports or feature requests
- [Make a pull request](https://github.com/cjvanlissa/pema/pulls) to
  contribute your code or prose

By participating in this project, you agree to abide by the [Contributor
Code of Conduct v2.0](https://www.contributor-covenant.org/).
Contributions to the package must adhere to the [tidyverse style
guide](https://style.tidyverse.org/). When contributing code, please add
tests for that contribution to the `tests/testthat` folder, and ensure
that these tests pass in the [GitHub Actions
panel](https://github.com/cjvanlissa/pema/actions/workflows/R-CMD-check).
