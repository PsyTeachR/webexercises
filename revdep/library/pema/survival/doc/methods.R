### R code from vignette source 'methods.Rnw'

###################################################
### code chunk number 1: setup
###################################################
library(survival)


###################################################
### code chunk number 2: test
###################################################
tfun <- function(start, gap, birth= as.Date("1960-01-01")) {
    as.numeric(start-birth)/365.25 - as.numeric((start + gap)-birth)/365.25
}

test <- logical(200)
for (i in 1:200) {
    test[i] <- tfun(as.Date("2010/01/01"), 29) ==
               tfun(as.Date("2010/01/01") + i, 29)
}
table(test)


###################################################
### code chunk number 3: survrepeat
###################################################
getOption("SweaveHooks")[["fig"]]()
fit1a <- survfit(Surv(entry, futime, death) ~ 1, myeloma)
fit1b <- survfit(Surv(entry, futime, death) ~ 1, myeloma, id=id, robust=TRUE)
matplot(fit1a$time/365.25, cbind(fit1a$std.err, fit1b$std.err/fit1b$surv), 
        type='s',lwd=2, lty=1, col=2:3, #ylim=c(0, .6),
        xlab="Years post diagnosis", ylab="Estimated sd of log(surv)")
#
# when two valve seats failed at the same inspection, we need to jitter one
#  of the times, to avoid a (time1, time2) interval of length 0
ties <- which(with(valveSeat, diff(id)==0 & diff(time)==0))  #first of a tie
temp <- valveSeat$time
temp[ties] <- temp[ties] - .1
vdata <- valveSeat
vdata$time1 <- ifelse(!duplicated(vdata$id), 0, c(0, temp[-length(temp)]))
vdata$time2 <- temp
fit2a <- survfit(Surv(time1, time2, status) ~1, vdata)
fit2b <- survfit(Surv(time1, time2, status) ~1, vdata, id=id)
plot(fit2a, cumhaz=TRUE, xscale=365.25, xlab="Years in service",
     ylab="Estimated number of repairs")
lines(fit2b, cumhaz=TRUE, lty=c(1,3,3))
legend(150, 1.5, c("Estimate", "asymptotic se", "robust se"), lty=1:3, bty='n')

#
# PBC data, categorized by most recent bilirubin
# as an example of the EKM
pdata <- tmerge(subset(pbcseq, !duplicated(id), c(id, trt, age, sex, stage)),
                subset(pbcseq, !duplicated(id, fromLast=TRUE)), id,
                death= event(futime, status==2))
bcut <- cut(pbcseq$bili, c(0, 1.1, 5, 100), c('normal', 'moderate', 'high'))
pdata <- tmerge(pdata, pbcseq, id, cbili = tdc(day, bcut))
pdata$ibili <- pdata$cbili[match(pdata$id, pdata$id)] # initial bilirubin

ekm <- survfit(Surv(tstart, tstop, death) ~ cbili, pdata, id=id)
km  <- survfit(Surv(tstart, tstop, death) ~ ibili, pdata, id=id)
plot(ekm, fun='event', xscale=365.25, lwd=2, col=1:3, conf.int=TRUE,
     lty=2, conf.time=c(4,8,12)*365.25,
     xlab="Years post enrollment", ylab="Death")
lines(km, fun='event', lwd=1, col=1:3, lty=1)
#      conf.time= c(4.1, 8.1, 12.1)*365.25)
text(c(4600, 4300, 2600), c(.23, .56, .78), c("Normal", "Moderate", "High"),
     col=1:3, adj=0)
legend("topleft", c("KM", "EKM"), lty=1:2, col=1, lwd=2, bty='n')


###################################################
### code chunk number 4: auc
###################################################
getOption("SweaveHooks")[["fig"]]()
test <- survfit(Surv(time, status) ~1, aml, subset=(x=="Maintained"))
ntime <- length(test$time)
oldpar <- par(mfrow=c(1,2), mar=c(5,5,1,1))
plot(test, conf.int=FALSE, xmax=60)
jj <- (test$n.event > 0)
segments(test$time[jj], test$surv[jj], test$time[jj], 0, lty=2)
segments(55, test$surv[9], 55, 0, lty=2)
points(c(0, test$time[jj]), c(1, test$surv[jj]))
segments(0,0,55,0)
segments(0,0,0,1)

plot(test, conf.int=FALSE, xmax=60)
segments(pmin(test$time,55), test$surv, 55, test$surv, lty=2)
segments(55,test$surv[ntime],55,1)
segments(test$time[1], 1, 55, 1, lty=2)
points(c(test$time[jj],100),  .5*(c(1, test$surv[jj]) + c(test$surv[jj], 0)))
par(oldpar)


###################################################
### code chunk number 5: entrydata
###################################################
getOption("SweaveHooks")[["fig"]]()
mtest <- data.frame(id= c(1, 1, 1,  2,  3,  4, 4, 4,  5, 5, 5, 5),
                    t1= c(0, 4, 9,  0,  2,  0, 2, 8,  1, 3, 6, 8),
                    t2= c(4, 9, 10, 5,  9,  2, 8, 9,  3, 6, 8, 11),
                    st= c(1, 2,  1, 2,  3,  1, 3, 0,  2,  0,2, 0))

mtest$state <- factor(mtest$st, 0:3, c("censor", "a", "b", "c"))

temp <- survcheck(Surv(t1, t2, state) ~1, mtest, id=id)
plot(c(0,11), c(1,5.1), type='n', xlab="Time", ylab= "Subject")
with(mtest, segments(t1+.1, id, t2, id, lwd=2, col=as.numeric(temp$istate)))
event <- subset(mtest, state!='censor')
text(event$t2, event$id+.2, as.character(event$state))


###################################################
### code chunk number 6: methods.Rnw:1126-1128 (eval = FALSE)
###################################################
## survival::coxph(survival::Surv(time, status) ~ 
##                     age + sex + survival::strata(inst), data=lung)


###################################################
### code chunk number 7: methods.Rnw:1307-1310 (eval = FALSE)
###################################################
## temp1 <- outer(hazard, z, '*') - xbar
## temp2 <- apply(temp1, 2, cumsum)
## v2 <-  rowSums((temp2 %*% vmat)* temp2)


###################################################
### code chunk number 8: tdcoef
###################################################
vet2 <- survSplit(Surv(time, status) ~ ., data= veteran, cut=c(90, 180), 
                  episode= "tgroup", id="id", start="time1", end="time2")
vfit2 <- coxph(Surv(time1, time2, status) ~ trt + prior +
                  I(karno/10):strata(tgroup), data=vet2)
vfit2

cdata <- data.frame(time1 = rep(c(0,90,180), 2),
                    time2 =  rep(c(90,180, 365), 2),
                    status= rep(0,6),   #necessary, but ignored
                    tgroup= rep(1:3, 2),
                    trt  =  rep(1,6),
                    prior=  rep(0,6),
                    karno=  rep(c(40, 75), each=3),
                    curve=  rep(1:2, each=3))
cdata
vsurv <- survfit(vfit2, newdata=cdata, id=curve)


###################################################
### code chunk number 9: nafld1
###################################################
mstate <- c("0mc", "1mc", "2mc", "3mc", "death")
mmat <- matrix(0, 5, 5, dimnames=list(mstate, mstate))
mmat[1,2] <- mmat[2,3] <- mmat[3,4] <- 1
mmat[1:4, 5] <- 1
mmat[1,3] <- mmat[1,4] <- mmat[2,4] <- .5
statefig(rbind(4,1), mmat, alty=c(1,2,1,2,2,1,1,1,1,1))


###################################################
### code chunk number 10: ndata
###################################################
ndata <- nafld1
ndata$nafld <- with(ndata, 1*(id==case.id))
caseid <-  subset(nafld1, id==case.id)$id
tdata1 <- subset(ndata, case.id %in% caseid)
# the endpoints of interest
enddata <- subset(nafld3, (id %in% tdata1$id) & 
                        (event %in% c("diabetes","dyslipidemia",  "htn")))
ndata <- tmerge(tdata1[c(1,2,3,6,10)], tdata1, id=id, 
                 death= event(futime, status),
                 options=list(tstartname="day1", tstopname="day2"))
ndata <- tmerge(ndata, enddata, id=id, mcount=cumtdc(days), 
                 mevent= cumevent(days))

ndata$cstate <- factor(ndata$mcount, 0:3, mstate[1:4])
ndata$event  <- with(ndata, factor(ifelse(death==1, 4, mevent), 0:4, 
                     c("censor", mstate[-1])))
ndata$age1 <- ndata$age + ndata$day1/365.25   # analysis on age scale
ndata$age2 <- ndata$age + ndata$day2/365.25

check <- survcheck(Surv(age1, age2, event) ~ 1, ndata, id=id, istate=cstate)

ndata$notzero <- 1*(ndata$cstate != "0mc")
nfit <- coxph(list(Surv(age1, age2, event) ~ nafld + male,
                    1:2 + 1:3 + 1:4 ~ nafld + male / common,
                    2:3 + 2:4 ~ nafld + male/common,
                    c(2,3,4):5 ~ notzero,
                    0:5  ~ 1 / common), 
               data=ndata, id= id, istate= cstate)
print(nfit, digits=2)
nfit$cmap
nfit$smap
nfit$share


###################################################
### code chunk number 11: amyloidsstate
###################################################
getOption("SweaveHooks")[["fig"]]()
astate <- c(outer( c("miss", "low", "mod", "high"),c("ND", "dem"),
                  paste, sep="\n"), "death")
amat <- matrix(0, 9, 9, dimnames=list(astate, astate))
for (i in 1:3) { amat[i, i+1] <- 1; amat[i+4, i+5] <- 1} # right arrows
for (i in 1:4) {amat[i, i+4] <- 1} #down arrows
amat[1:8,9] <- 1
amat[1,3] <- amat[1,4] <- .6

amat2 <- amat
amat2[2,4] <- amat2[6,8] <- .6
amat2[3,2] <- amat2[4,3] <- 1
amat2[1,6] <- amat2[1,7] <- amat2[1,8] <- amat2[2,7] <- 1

temp <- sum(amat2[,-9] >0)
statefig(rbind(4,4,1), amat2, acol=rep(1:0, c(temp,8)),
         alty= (1 + 1*(amat2 != amat))[amat2 >0], offset=.01)


###################################################
### code chunk number 12: methods.Rnw:1678-1680 (eval = FALSE)
###################################################
## fit <- coxph(list(Surv(time1, time2, state) ~ x1 + x2, 
##                   1:2 + 2:3~ x3/common,  1:3 ~ x4- x2), ...)


###################################################
### code chunk number 13: competecheck
###################################################
m2 <- mgus2
m2$etime <- with(m2, ifelse(pstat==0, futime, ptime))
m2$event <- with(m2, ifelse(pstat==0, 2*death, 1))
m2$event <- factor(m2$event, 0:2, c('censor', 'pcm', 'death'))
m2$id <-1:nrow(m2)

# 20 year reporting time (240 months)
mfit <- survfit(Surv(etime, event) ~1, m2, id=id)

y3 <- (mfit$time <= 360 & rowSums(mfit$n.event) >0)  # rows of mfit, of interest
etot <- sum(m2$n.event[y3,])
nrisk <- mean(mfit$n.risk[y3,1])


###################################################
### code chunk number 14: checknafld
###################################################
ndata <- tmerge(nafld1[,1:8], nafld1, id=id, death= event(futime, status))
ndata <- tmerge(ndata, subset(nafld3, event=="nafld"), id, 
                nafld= tdc(days))
ndata <- tmerge(ndata, subset(nafld3, event=="diabetes"), id = id,
                diabetes = tdc(days), e1= cumevent(days))
ndata <- tmerge(ndata, subset(nafld3, event=="htn"),  id = id,
                htn = tdc(days), e2 = cumevent(days))
ndata <- tmerge(ndata, subset(nafld3, event=="dyslipidemia"), id=id,
                lipid = tdc(days), e3= cumevent(days))
ndata <- tmerge(ndata, subset(nafld3, event %in% c("diabetes", "htn", 
                                                   "dyslipidemia")), 
                id=id, comorbid= cumevent(days))
ndata$cstate <- with(ndata, factor(diabetes + htn + lipid, 0:3, 
                                   c("0mc", "1mc", "2mc", "3mc")))
temp <- with(ndata, ifelse(death, 4, comorbid))
ndata$event <- factor(temp, 0:4, 
         c("censored", "1mc", "2mc", "3mc", "death"))
ndata$age1 <- ndata$age + ndata$tstart/365.25   # analysis on age scale
ndata$age2 <- ndata$age + ndata$tstop/365.25

ndata2 <- subset(ndata, age2 > 50 & age1 < 90)
nfit <- survfit(Surv(age1, age2, event) ~1, ndata, id=id, start.time=50,
                p0=c(1,0,0,0,0), istate=cstate, se.fit = FALSE)
netime <- (nfit$time <=90 & rowSums(nfit$n.event) > 0)
# the number at risk at any time is all those in the intial state of a transition
#  at that time
from <- as.numeric(sub(":[0-9]*", "", colnames(nfit$n.transition)))
fmat <- model.matrix(~ factor(from, 1:5) -1)
temp <- (nfit$n.transition %*% fmat) >0 # TRUE for any transition 'from' state
frisk <- (nfit$n.risk * ifelse(temp,1, 0))
nrisk <- rowSums(frisk[netime,])
maxrisk <- apply(frisk[netime,],2,max)


###################################################
### code chunk number 15: skiplist1
###################################################
getOption("SweaveHooks")[["fig"]]()
sort2 <- order(ndata$age2)
plot(1:200, rev(sort2)[1:200], xlab="Addition to the list",
     ylab="Row index of the addition")


###################################################
### code chunk number 16: skiplist2
###################################################
getOption("SweaveHooks")[["fig"]]()
# simulate a skiplist with period 3
set.seed(1953)
n <- 30
yval <- sort(sample(1:200, n))
phat <- c(2/3, 2/9, 2/27)
y.ht <- rep(c(1,1,2,1,1,1,1,3,1,1,2,1,1,1,2,1), length=n)
plot(yval, rep(1,n), ylim=c(1,3), xlab="Data", ylab="")
indx <- which(y.ht > 1)
segments(yval[indx], rep(1, length(indx)), yval[indx], y.ht[indx])

y1 <- yval[indx]
y2 <- yval[y.ht==3]
lines(c(0, y2[1], y2[1], y1[5], y1[5], max(yval[yval < 100])),
      c(3,3, 2,2,1,1), lwd=2, col=2, lty=3)
