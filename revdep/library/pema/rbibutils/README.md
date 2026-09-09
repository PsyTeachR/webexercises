[![CRANStatusBadge](http://www.r-pkg.org/badges/version/rbibutils)](https://cran.r-project.org/package=rbibutils)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/rbibutils)](https://www.r-pkg.org/pkg/rbibutils)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/grand-total/rbibutils?color=blue)](https://r-pkg.org/pkg/rbibutils)
[![R build status](https://github.com/GeoBosh/rbibutils/workflows/R-CMD-check/badge.svg)](https://github.com/GeoBosh/rbibutils/actions)
[![codecov](https://codecov.io/gh/GeoBosh/rbibutils/branch/master/graph/badge.svg?token=SNUE0KC0TX)](https://app.codecov.io/gh/GeoBosh/rbibutils)

Read and write 'BibTeX' files. Convert bibliography files between various
formats, including BibTeX, BibLaTeX, PubMed, EndNote and Bibentry. Includes an R
port of the `bibutils` utilities.


# Installing rbibutils

Install the  [latest stable version](https://cran.r-project.org/package=rbibutils) from CRAN:

    install.packages("rbibutils")

You can also install the [development version](https://github.com/GeoBosh/rbibutils) of `rbibutils` from Github:

    library(devtools)
    install_github("GeoBosh/rbibutils")



# Overview

Import and export 'BibTeX' files. Convert bibliography files between various
formats.  All formats supported by the `bibutils` utilities are available, see
`bibConvert()` for a complete list.  In addition, conversion from and to
`bibentry`, the R native representation based on Bibtex, is supported.

`readBib()` and `writeBib()` import/export BiBTeX files.  `readBibentry()` and
`writeBibentry()` import/export `R` source files in which the references are
represented by `bibentry()` calls.

The convenience function `charToBib()` takes input from a character vector,
rather than a file. It calls `readBib()` or `bibConvert()`.

`bibConvert()` takes an input bibliography file in one of the supported formats,
converts its contents to another format, and writes the result to a file. All
formats, except for `rds` (see below) are plain text files. `bibConvert()` tries
to infer the input/output formats from the file extentions. There is ambiguity
however about `bib` files, which can be either Bibtex or Biblatex. Bibtex is
assumed if the format is not specified. Also, the `xml` extension is shared by
XML-based formats. Its default is 'XML MODS intermediate' format.

The default encoding is UTF-8 for both, input and output. All encodings handled
by `bibutils` are supported. Besides UTF-8, these include `gb18030` (Chinese),
ISO encodings such as `iso8859_1`, Windows code pages (e.g. `cp1251` for Windows
Cyrillic) and many others. Common alternative names are also accepted
(e.g. `latin1`).

Bibentry objects can be input from an `R` source file or from an `rds` file. The
`rds` file should contain a `bibentry` R object, saved from R with `saveRDS()`.
The `rds` format is a compressed binary format`. Alternatively, an R source file
containing one or more bibentry instructions and maybe other commands can be
used.  The R file is sourced and all bibentry objects created by it are
collected.



# Examples:

## readBib

The examples in this section import the following file:

    bibacc <- system.file("bib/latin1accents_utf8.bib", package = "rbibutils")

Note that some characters may not be displayed on some locales. Also, on Windows
some characters may be "approximated" by other characters.

Import the above bibtex file into a `bibentry` object. By default TeX escape
sequences representing characters are kept as is:

    be0 <- readBib(bibacc)
    be0
    print(be0, style = "bibtex")

As above, using the direct option:

    be1 <- readBib(bibacc, direct = TRUE)
    ## readBib(bibacc, direct = TRUE, texChars = "keep") # same
    be1
    print(be1, style = "bibtex")


Use the `"convert"` option to convert TeX sequences to true characters:

    be2 <- readBib(bibacc, direct = TRUE, texChars = "convert")
    be2
    print(be2, style = "R")

(On Windows the Greek characters alpha and delta may be printed as 'a' and 'd'
but internally they are alpha and delta.)

Use the `"export"` option to convert other characters to ASCII TeX sequences,
when possible (currently this option doesn't handle well mathematical
expressions):

    be3 <- readBib(bibacc, direct = TRUE, texChars = "export")
    print(be3, style = "bibtex")
  

## bibConvert


Convert Bibtex file `myfile.bib` to a `bibentry` object and save the latter to
`"myfile.rds":

    bibConvert("myfile.bib", "myfile.rds", informat = "bibtex", outformat = "bibentry")
    bibConvert("myfile.bib", "myfile.rds")

Convert Bibtex file `myfile.bib` to a Biblatex save to `"biblatex.bib":

    bibConvert("myfile.bib", "biblatex.bib", "bibtex", "biblatex")
    bibConvert("myfile.bib", "biblatex.bib", outfile = "biblatex")

Convert Bibtex file `myfile.bib` to Bibentry and save as `rds` or `R`:

    bibConvert("myfile.bib", "myfile.rds")
    bibConvert("myfile.bib", "myfile.R")

Read back the above files and/or convert them to other formats:

    readLines("myfile.R")
    file.show("myfile.R")
    readRDS("myfile.rds")
    bibConvert("myfile.rds", "myfile.bib")
    bibConvert("myfile.R", "myfile.bib")


Assuming `myfile.bib` is a Biblatex file, convert it to Bibtex and save to  `bibtex.bib`:

    bibConvert("myfile.bib", "bibtex.bib", "biblatex", "bibtex")
    bibConvert("myfile.bib", "bibtex.bib", "biblatex")


Assuming "myfile.med" is a PubMed file, convert it to Bibtex:

    bibConvert(infile = "myfile.med", outfile = "bibtex.bib", informat = "med", outformat = "bib")
    bibConvert(infile = "myfile.med", outfile = "bibtex.bib", informat = "med") # same


See `bibConvert()` for further examples and their results.
