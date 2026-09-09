# mitml
#### Tools for multiple imputation in multilevel modeling

This [R](https://www.r-project.org/) package provides tools for multiple imputation of missing data in multilevel modeling.
It includes a user-friendly interface to the packages `pan` and `jomo`, and several functions for visualization, data management, and the analysis of multiply imputed data sets.

The purpose of `mitml` is to provide users with a set of effective and user-friendly tools for multiple imputation of multilevel data without requiring advanced knowledge of its statistical underpinnings.
Examples and additional information can be found in the official [documentation](https://cran.r-project.org/package=mitml/mitml.pdf) of the package and in the [Wiki](https://github.com/simongrund1/mitml/wiki) pages on GitHub.

If you use `mitml` and have suggestions for improvement, please email me (see [here](https://cran.r-project.org/package=mitml)) or file an [issue](https://github.com/simongrund1/mitml/issues) at the GitHub repository.

#### CRAN version

The official version of `mitml` is hosted on CRAN and may be found [here](https://cran.r-project.org/package=mitml). The CRAN version can be installed from within R using:

```r
install.packages("mitml")
```

[![CRAN release](http://www.r-pkg.org/badges/version/mitml)](https://cran.r-project.org/package=mitml) [![CRAN downloads](http://cranlogs.r-pkg.org/badges/mitml)](https://cran.r-project.org/package=mitml)

#### GitHub version

The version hosted here is the development version of `mitml`, allowing better tracking of [issues](https://github.com/simongrund1/mitml/issues) and possibly containing features and changes in advance. The GitHub version can be installed using `devtools` as:

```r
install.packages("devtools")
devtools::install_github("simongrund1/mitml")
```

![Github commits](https://img.shields.io/github/commits-since/simongrund1/mitml/latest.svg?colorB=green)
