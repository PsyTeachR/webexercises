### R code from vignette source 'Inserting_bibtex_references.Rnw'

###################################################
### code chunk number 1: Inserting_bibtex_references.Rnw:19-21
###################################################
library(Rdpack)
pd <- packageDescription("Rdpack")


###################################################
### code chunk number 2: Inserting_bibtex_references.Rnw:250-254
###################################################
.onLoad <- function(lib, pkg){
    Rdpack::Rdpack_bibstyles(package = pkg, authors = "LongNames")
    invisible(NULL)
}


