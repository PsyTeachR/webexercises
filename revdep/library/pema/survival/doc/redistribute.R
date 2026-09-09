### R code from vignette source 'redistribute.Rnw'

###################################################
### code chunk number 1: redistribute.Rnw:20-24
###################################################
options(continue="  ", width=60)
options(SweaveHooks=list(fig=function() par(mar=c(4.1, 4.1, .3, 1.1))))
pdf.options(pointsize=8) #text in graph about the same as regular text
library(survival, quietly=TRUE)


###################################################
### code chunk number 2: km
###################################################
km <- rbind(time= c(0, 1, 2, 3, 5, 8, 9),
            km = cumprod(c(1, 9/10, 8/9, 6/7, 3/4, 1/2, 0/1)))
km


###################################################
### code chunk number 3: g
###################################################
G <- cumprod(c(1, 7/8, 4/6, 2/3))
names(G) <- c(0, "2+", "4+", "5+")
G
7/G


###################################################
### code chunk number 4: rotterdam
###################################################
# recurrent free survival (earlier of death or progression)
#  see help(rotterdam) for explanation of ignore variable
ignore <- with(rotterdam, recur ==0 & death==1 & rtime < dtime)
rfs <- with(rotterdam, ifelse(recur==1 | ignore, recur, death))
rfstime <- with(rotterdam, ifelse(recur==1 | ignore, rtime, dtime))/365.25
rsurv <- survfit(Surv(rfstime, rfs) ~1, rotterdam)
rsurv
ybar <- 1- summary(rsurv, time=4)$surv

rfit <- coxph(Surv(rfstime, rfs) ~ pspline(age) + meno + size + pmin(nodes,12),
              rotterdam)
psurv <- survfit(rfit, newdata= rotterdam)
dim(psurv)
yhat <- 1- summary(psurv, time=4)$surv


###################################################
### code chunk number 5: brier1
###################################################
wt4 <- rttright(Surv(rfstime, rfs) ~ 1, times =4, rotterdam)
table(wt4 ==0)

brier1 <- sum(wt4 * (rfs- yhat)^2)/ sum(wt4)
brier0 <- sum(wt4 * (rfs- ybar)^2) / sum(wt4)
r2 <- 1- (brier1/brier0)
temp <- c(numerator= brier1, denominator = brier0, rsquared = r2)
round(temp,3)


###################################################
### code chunk number 6: bfit1
###################################################
cutoff <- seq(1, 12, by=.1)
bfit <- brier(rfit, cutoff)
names(bfit)


###################################################
### code chunk number 7: bfit1
###################################################
getOption("SweaveHooks")[["fig"]]()
oldpar <- par(mar=c(5,5,1,1), mfrow=c(1,2))
b0 <- bfit$brier/(1-bfit$rsquare)
matplot(cutoff, cbind(b0, bfit$brier, bfit$rsquare), type='l',
        lwd=2, lty=3:1, col=1,  xlab="Cutoff (tau)", ylab="Value")
legend(4, .2, c("B0", "B1", "R-square"), lty=3:1, lwd=2, col=1, bty='n')
abline(v=2, lty=3)
plot(rsurv, xmax=12, lwd=2, conf.int=FALSE,  
     xlab="Years since enrollment", ylab="RFS")
abline(v=2, lty=3)
par(oldpar)


###################################################
### code chunk number 8: tdroc
###################################################
rwt <- rttright(Surv(rfstime, rfs) ~1, rotterdam, times= cutoff)
cstat <- matrix(0, length(cutoff), 4)
for (i in 1:length(cutoff)) {
    temp1 <- concordance(rfit, ymax= cutoff[i])
    ycut  <- ifelse(rfstime > cutoff[i], 1, 0)
    temp2 <- concordance(ycut ~ rfit$linear.predictor, weight= rwt[,i],
                         reverse=TRUE)
    cstat[i,] <- c(temp1$concordance, temp2$concordance, 
                   sqrt(temp1$var), sqrt(temp2$var))
}
dimnames(cstat) <- list(cutoff, 
                        c("Threshold C", "Discrete time C", "sd1", "sd2"))


###################################################
### code chunk number 9: tdroc2
###################################################
getOption("SweaveHooks")[["fig"]]()
oldpar <- par(mfrow=c(1,2), mar=c(5,5,1,1))
yhat <- cbind(cstat[,1] + outer(cstat[,3], c(0, -1.96, 1.96), "*"),
               cstat[,2] + outer(cstat[,4], c(0, -1.96, 1.96), "*"))
matplot(cutoff, yhat[,c(1,4)], ylim=range(yhat), type='l', lwd=2, lty=1,
        xlab="Cutoff (tau)", ylab="Concordance")
ii <- match(c(1,2,4,6,8, 10,12), cutoff)
eps <- .02
segments(cutoff[ii]-eps, yhat[ii, 2], cutoff[ii]-eps, yhat[ii,3])
segments(cutoff[ii]+eps, yhat[ii, 5], cutoff[ii]+eps, yhat[ii,6], col=2)
matplot(cutoff, cstat[,3:4], type='l', lty=1, lwd=2, ylim=c(0, max(cstat[,3:4])),
        xlab= "Cutoff (tau)", ylab="Standard error")
par(oldpar)
