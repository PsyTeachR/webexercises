## reformulas

<!-- badges: start -->
  [![R-CMD-check](https://github.com/bbolker/reformulas/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bbolker/reformulas/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->

`reformulas` (**r**andom **e**ffects formulas) is a utility package for processing "`lme4`-style" random effects formulas in R (i.e., formulas where the random effects are included in the form `(f|g)` as components of an overall model formula, where `f` represents a sub-formula for the varying effects and `g` represents a sub-formula for the grouping variable(s).

The package contains functions like `findbars` (extract terms containing `|`, i.e. random-effects terms), `nobars` (drop terms containing bars from a formula), etc.. The goal of `reformulas` is to be used upstream of `lme4` and `glmmTMB` (and possibly other packages) as a unified toolkit for processing formulas.

