
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/bain)](https://cran.r-project.org/package=bain)
[![R-CMD-check](https://github.com/cjvanlissa/bain/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cjvanlissa/bain/actions/workflows/R-CMD-check.yaml)
[![](https://cranlogs.r-pkg.org/badges/bain)](https://cran.r-project.org/package=bain)
[![test-coverage](https://github.com/cjvanlissa/bain/workflows/test-coverage/badge.svg)](https://github.com/cjvanlissa/bain/actions)
[![Contributor
Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](https://www.contributor-covenant.org/version/2/0/code_of_conduct.html)
[![CII Best
Practices](https://bestpractices.coreinfrastructure.org/projects/3871/badge)](https://bestpractices.coreinfrastructure.org/projects/3871)

# bain

Bain stands for Bayesian informative hypothesis evaluation. It computes
Bayes factors for informative hypotheses in a wide variety of
statistical models. Just run your analysis as usual, and then apply bain
to the output. A tutorial is available at
[DOI:10.1037/met0000201](https://doi.org/10.1037/met0000201). A sequel
with the focus on Structural Equation Models is available at
<https://doi.org/10.1080/10705511.2020.1745644>.

## Installation

Install the latest release version of `bain` from CRAN:

``` r
install.packages("bain")
```

You can also install the latest development version of `bain` from
GitHub. This requires a working toolchain, to compile the Fortran source
code. [Step 3 in this
tutorial](https://cjvanlissa.github.io/worcs/articles/setup.html)
explains how to set up the toolchain. Then, run:

``` r
install.packages("devtools")
devtools::install_github("cjvanlissa/bain")
```

## Workflow

Add bain to your existing R workflow, and obtain Bayes factors for your
familiar R analyses! Bain is compatible with the pipe operator. Here is
an example for testing an informative hypothesis about mean differences
in an ANOVA:

``` r
# Load bain
library(bain)
# dplyr to access the %>% operator
library(dplyr)
# Iris as example data
iris %>%
  # Select outcome and predictor variables
  select(Sepal.Length, Species) %>%      
  # Add -1 to the formula to estimate group means, as in ANOVA
  lm(Sepal.Length ~ -1 + Species, .) %>% 
  bain("Speciessetosa < Speciesversicolor = Speciesvirginica;
       Speciessetosa < Speciesversicolor < Speciesvirginica")
#> Bayesian informative hypothesis testing for an object of class lm (ANOVA):
#> 
#>    Fit   Com   BF.u  BF.c             PMPa  PMPb  PMPc 
#> H1 0.000 0.224 0.000 0.000            0.000 0.000 0.000
#> H2 1.000 0.166 6.027 502986932347.232 1.000 0.858 1.000
#> Hu                                          0.142      
#> Hc 0.000 0.834 0.000                              0.000
#> 
#> Hypotheses:
#>   H1: Speciessetosa<Speciesversicolor=Speciesvirginica
#>   H2: Speciessetosa<Speciesversicolor<Speciesvirginica
#> 
#> Note: BF.u denotes the Bayes factor of the hypothesis at hand versus the unconstrained hypothesis Hu. BF.c denotes the Bayes factor of the hypothesis at hand versus its complement. PMPa contains the posterior model probabilities of the hypotheses specified. PMPb adds Hu, the unconstrained hypothesis. PMPc adds Hc, the complement of the union of the hypotheses specified.
```

## Documentation

Every user-facing function in the package is documented, and the
documentation can be accessed by running `?function_name` in the R
console, e.g., `?bain`.

Moreover, you can read the *Introduction to bain* vignette by running
`vignette("Introduction_to_bain", package = "bain")`

## Citing bain

You can cite the R-package with the following citation:

> Gu, X., Hoijtink, H., Mulder, J., & van Lissa, C. (2019). bain: Bayes
> factors for informative hypotheses. (Version 0.2.3) \[R package\].
> <https://CRAN.R-project.org/package=bain>

## Contributing and Contact Information

If you have ideas, please get involved. You can contribute by opening an
issue on GitHub, or sending a pull request with proposed features.
Contributions in code must adhere to the [tidyverse style
guide](https://style.tidyverse.org/).

- File a GitHub issue [here](https://github.com/cjvanlissa/bain)
- Make a pull request [here](https://github.com/cjvanlissa/bain/pulls)

By participating in this project, you agree to abide by the [Contributor
Code of Conduct
v2.0](https://www.contributor-covenant.org/version/2/0/code_of_conduct.html).
