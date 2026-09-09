### R code from vignette source 'rbibutils.Rnw'

###################################################
### code chunk number 1: rbibutils.Rnw:57-59
###################################################
library(rbibutils)
pd <- packageDescription("rbibutils")


###################################################
### code chunk number 2: rbibutils.Rnw:122-126
###################################################
bibdir <- system.file("bib", package = "rbibutils")
wuertzetal <- readBib(file.path(bibdir, "WuertzEtalGarch.bib"), direct = TRUE)
wuertzetal
print(wuertzetal, style = "bibtex")


###################################################
### code chunk number 3: rbibutils.Rnw:131-133
###################################################
wuertzetal$note <- NULL
wuertzetal


###################################################
### code chunk number 4: rbibutils.Rnw:143-144
###################################################
wuertzetal$year


###################################################
### code chunk number 5: rbibutils.Rnw:153-156
###################################################
wuertzetal$author

class(wuertzetal$author)


###################################################
### code chunk number 6: rbibutils.Rnw:160-161
###################################################
wuertzetal$key


###################################################
### code chunk number 7: rbibutils.Rnw:164-165
###################################################
wuertzetal$bibtype


###################################################
### code chunk number 8: rbibutils.Rnw:172-175 (eval = FALSE)
###################################################
## wuertzetal[["author"]]
## ## Warning message:
## ## In `[[.bibentry`(wuertzetal, "author") : subscript out of bounds


###################################################
### code chunk number 9: rbibutils.Rnw:181-182
###################################################
wuertzetal[[1, "note"]]


###################################################
### code chunk number 10: rbibutils.Rnw:189-189
###################################################



###################################################
### code chunk number 11: rbibutils.Rnw:190-191 (eval = FALSE)
###################################################
## wuertzetal[["WuertzEtalGarch"]]


