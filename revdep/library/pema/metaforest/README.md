<!-- README.md is generated from README.Rmd. Please edit that file -->

# MetaForest <a href='https://cjvanlissa.github.io/metaforest/'><img src='https://github.com/cjvanlissa/metaforest/raw/master/docs/metaforest_icon.png' align="right" height="139" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/metaforest)](https://cran.r-project.org/package=metaforest)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#maturing)
[![R-CMD-check](https://github.com/cjvanlissa/metaforest/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/cjvanlissa/metaforest/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# Background

The goal of MetaForest is to explore heterogeneity in meta-analytic
data, identify important moderators, and explore the functional form of
the relationship between moderators and effect size. To do so,
MetaForest conducts a weighted random forest analysis, using
random-effects or fixed-effects weights, as in classic meta-analysis, or
uniform weights (unweighted random forest). Simulation studies have
demonstrated that this technique has substantial power to detect
relevant moderators, even in datasets as small as 20 cases (based on
cross-validated *R*<sup>2</sup>). Using a variable importance plot,
important moderators can be identified, and using partial prediction
plots, the shape of the marginal relationship between moderators and
effect size can be visualized. MetaForest can be readily integrated in
classical meta-analytic approaches: If MetaForest is conducted as a
primary analysis, classic meta-analysis can be used to quantify
heterogeneity (in fact, MetaForest by default reports a random-effects
meta-analysis on the raw data, and the residuals of the random forests
analysis), or to provide a simplified representation of the linear
effects of important predictors. Conversely, a theory-driven classical
meta-analysis could be complemented by an exploratory MetaForest
analysis, as a final check to ensure that important moderators have not
been overlooked. We hope that this approach will be of use to
researchers, and that the availability of user-friendly R functions will
facilitate its adoption.

# Installation

You can install `metaforest` from CRAN with:

``` r
install.packages("metaforest")
```

# Documentation

Every user-facing function in the package is documented, and the
documentation can be accessed by running `?function_name` in the R
console, e.g., `?graph`, or by checking the [project
website](https://cjvanlissa.github.io/metaforest/reference/index.html)

# Citing metaforest

You can cite the method by referencing this open access book chapter:

Van Lissa, C. J. (2020). Small sample meta-analyses: Exploring
heterogeneity using MetaForest. In R. Van De Schoot & M. Miočević
(Eds.), *Small Sample Size Solutions (Open Access): A Guide for Applied
Researchers and Practitioners.* CRC Press.
<https://doi.org/10.4324/9780429273872-16>

The simulation study supporting the method is available in:

Van Lissa, C. J. (2018). MetaForest: Exploring heterogeneity in
meta-analysis using random forests. PsyArxiv.
<https://doi.org/10.31234/osf.io/myg6s>

# Contributing and Contact Information

If you have ideas, please get involved. You can contribute by opening an
issue on GitHub, or sending a pull request with proposed features.

-   File a GitHub issue [here](https://github.com/cjvanlissa/metaforest)
-   Make a pull request
    [here](https://github.com/cjvanlissa/metaforest/pulls)

By participating in this project, you agree to abide by the [Contributor
Code of Conduct v2.0](https://www.contributor-covenant.org/).
Contributions to the package must adhere to the [tidyverse style
guide](https://style.tidyverse.org/). When contributing code, please add
tests for that contribution to the `tests/testthat` folder, and ensure
that these tests pass in the [GitHub Actions
panel](https://github.com/cjvanlissa/worcs/actions/workflows/R-CMD-check).

# Example analysis

This example demonstrates how one might go about conducting a
meta-analysis using MetaForest. For more information, check the [package
vignette](https://cjvanlissa.github.io/metaforest/articles/Introduction_to_metaforest.html).

``` r
#Load metaforest package
library(metaforest)

#Simulate a meta-analysis dataset with 20 studies, 1 relevant moderator, and 4 irrelevant moderators
set.seed(42)
data <- SimulateSMD()$training

#Conduct an unweighted MetaForest analysis, to estimate the residual tau2
mf.unif <- MetaForest(formula = yi ~ ., data = data,
                      whichweights = "unif", method = "DL", num.trees = 2000)

#Extract the result of this analysis and print them
results <- summary(mf.unif)
results
#> MetaForest results
#>                                          
#> Type of analysis:              MetaForest
#> Number of studies:             20        
#> Number of moderators:          5         
#> Number of trees in forest:     2000      
#> Candidate variables per split: 2         
#> Minimum terminal node size:    5         
#> OOB prediction error (MSE):    0.1012    
#> R squared (OOB):               0.2970    
#> 
#> Tests for Heterogeneity: 
#>                                tau2   tau2_SE I^2     H^2    Q-test  df Q_p   
#> Raw effect sizes:              0.0553 0.0486  37.2642 1.5940 30.2857 19 0.0483
#> Residuals (after MetaForest):  0.0099 0.0334  9.6420  1.1067 21.0275 19 0.3353
#> 
#> 
#> Random intercept meta-analyses:
#>                                Intercept se     ci.lb   ci.ub   p     
#> Raw effect sizes:              -0.2136   0.0875 -0.3851 -0.0421 0.0147
#> Residuals (after MetaForest):  0.0357    0.0720 -0.1053 0.1768  0.6197

#Conduct a weighted MetaForest analysis, using the residual tau2 from the
#unweighted analysis above
mf.random <- MetaForest(formula = yi ~ ., data = data,
                      whichweights = "random", method = "DL", 
                      tau2 = results$rma[2,1],
                      num.trees = 2000)

#Print the result of this analysis
summary(mf.random)
#> MetaForest results
#>                                          
#> Type of analysis:              MetaForest
#> Number of studies:             20        
#> Number of moderators:          5         
#> Number of trees in forest:     2000      
#> Candidate variables per split: 2         
#> Minimum terminal node size:    5         
#> OOB prediction error (MSE):    0.0945    
#> R squared (OOB):               0.3438    
#> 
#> Tests for Heterogeneity: 
#>                                tau2   tau2_SE I^2     H^2    Q-test  df Q_p   
#> Raw effect sizes:              0.0553 0.0486  37.2642 1.5940 30.2857 19 0.0483
#> Residuals (after MetaForest):  0.0031 0.0312  3.2094  1.0332 19.6300 19 0.4171
#> 
#> 
#> Random intercept meta-analyses:
#>                                Intercept se     ci.lb   ci.ub   p     
#> Raw effect sizes:              -0.2136   0.0875 -0.3851 -0.0421 0.0147
#> Residuals (after MetaForest):  0.0298    0.0693 -0.1059 0.1656  0.6666
```
