### R code from vignette source 'matrix.Rnw'

###################################################
### code chunk number 1: init
###################################################
options(continue="  ", width=60)
options(SweaveHooks=list(fig=function() par(mar=c(4.1, 4.1, .3, 1.1))))
pdf.options(pointsize=8) #text in graph about the same as regular text
library(survival, quietly=TRUE)
library(Matrix, quietly=TRUE)


###################################################
### code chunk number 2: matrix.Rnw:160-170
###################################################
A = rbind(c(-.2, .1, .1), c(0, -1.1, 1.1), c(0, 0,0))
expm(A)
B <- A + 1.1*diag(3)
exp(-1.1) * expm(B)   # verify the formula

diag(3) + A   # the bad estimate
diag(3) + A + A^2/2 + A^3/6

exp(-1.1) *(diag(3)+ B)
exp(-1.1) *(diag(3)+ B + B^2/2 + B^3/6)
