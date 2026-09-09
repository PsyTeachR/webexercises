metadat: Meta-Analysis Datasets for R
=====================================

[![License: GPL (>=2)](https://img.shields.io/badge/license-GPL-blue)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![R build status](https://github.com/wviechtb/metadat/workflows/R-CMD-check/badge.svg)](https://github.com/wviechtb/metadat/actions)
[![CRAN Version](https://www.r-pkg.org/badges/version/metadat)](https://cran.r-project.org/package=metadat)
[![devel Version](https://img.shields.io/badge/devel-1.7--0-brightgreen.svg)](https://github.com/wviechtb/metadat)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/metadat)](https://cran.r-project.org/package=metadat)

## Description

The `metadat` package contains a large collection of meta-analysis datasets. These datasets are useful for teaching purposes, illustrating/testing meta-analytic methods, and validating published analyses.

## Installation

The current official (i.e., [CRAN](https://cran.r-project.org/package=metadat)) release can be installed within R with:

```r
install.packages("metadat")
```

The development version of the package can be installed with:

```r
install.packages("remotes")
remotes::install_github("wviechtb/metadat")
```

This builds the package from source based on the current version on [GitHub](https://github.com/wviechtb/metadat).

## Browsing and Searching for Datasets

A listing of all datasets in the package can be obtained with `help(package=metadat)`. Each dataset is also tagged with one or multiple concept terms. These concept terms refer to various aspects of a dataset, such as the field/topic of research, the outcome measure used for the analysis, the model(s) used for analyzing the data, and the methods/concepts that can be illustrated with the dataset. The [`datsearch()`](https://wviechtb.github.io/metadat/reference/datsearch.html) function can be used to search among the existing datasets in the package based on their concept terms or based on a full-text search of their corresponding help files.

You can also read the documentation online at [https://wviechtb.github.io/metadat/](https://wviechtb.github.io/metadat/) (where the output from the example analyses corresponding to each dataset is provided).

## Contributing New Datasets

We welcome contributions of new datasets to the package. For each dataset, there must be a citable reference, ideally in a peer-reviewed journal or publication. The general workflow for contributing a new dataset is as follows:

- Install the `metadat` package in R in the usual manner (i.e., `install.packages("metadat")`).
- If you are familiar with Git/GitHub and making pull requests, fork the [package repository](https://github.com/wviechtb/metadat). Otherwise, [download](https://github.com/wviechtb/metadat/archive/master.zip) the source version of the package from GitHub and unzip the file to some directory on your computer.
- Place the raw data (in a non-binary format) in the `data-raw` directory. The file should be named `dat.<author><year>.<ext>`, where `<author>` is the last name of the first author of the publication from which the data come, `<year>` is the publication year, and `<ext>` is the file extension (e.g., `.txt`, `.csv`).
- Place a corresponding R script in the `data-raw` directory named `dat.<author><year>.r` that reads in the data, possibly does some data cleaning/processing, and then saves the dataset to the `data` directory (using `save()`), with name `dat.<author><year>.rda`.
- Start R, load the `metadat` package (i.e., `library(metadat)`), and then run the `prep_dat()` function (either set the working directory to the location of the source package beforehand or use the `pkgdir` argument of the `prep_dat()` function to specify the source package location).
- For a new dataset, this should create a boilerplate template for a corresponding help file in the `man` directory, named `dat.<author><year>.Rd`. Edit the help file, adding the title and a short description of the dataset in general, a description of each variable in the dataset, further details on the dataset (e.g., the field of research, how the data was collected, the purpose of the dataset or what it was used for, the effect size or outcome measure used in the analysis, the types of analyses/models that can be illustrated with the dataset), a reference for the source of the dataset, one or multiple concept terms, the name and email address of the contributor of the dataset, and (optionally) example code to illustrate the analysis of the dataset.
- Either make a pull request (if you are familiar with this workflow) or zip up the `dat.<author><year>.<ext>`, `dat.<author><year>.r`, `dat.<author><year>.rda`, and `dat.<author><year>.Rd` files and open up a new [issue at GitHub](https://github.com/wviechtb/metadat/issues), attaching the zip file.
- If the above makes no sense to you, you can also open an issue or email one of the package authors and attach a zip file including a cleaned, raw data file in `.txt` or `.csv` format, along with a meta-data file (format doesn't matter) that includes the information described above.

## Citing the Package

If you use these data, please cite both the `metadat` package (see `citation("metadat")` for the reference) and the original source of the data as given under the help file of a dataset.

## Bug/Error Reports

If you think you have found an error in an existing dataset or a bug in the package in general, please go to https://github.com/wviechtb/metadat/issues and open up a new issue.
