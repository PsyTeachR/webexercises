### R code from vignette source 'timeline.Rnw'

###################################################
### code chunk number 1: timeline.Rnw:24-30
###################################################
options(continue="  ", width=70)
options(SweaveHooks=list(fig=function() par(mar=c(4.1, 4.1, .3, 1.1))))
pdf.options(pointsize=10) #text in graph about the same as regular text
options(contrasts=c("contr.treatment", "contr.poly")) #ensure default
library("survival")
palette(c("#000000", "#D95F02", "#1B9E77", "#7570B3", "#E7298A", "#66A61E"))


###################################################
### code chunk number 2: counting1
###################################################
p1 <- subset(pbcseq, !duplicated(id))
pdata <- tmerge(p1[,c(1,3:5)], p1, id=id, death= event(futime, status==2))
pdata <- tmerge(pdata, pbcseq, id=id, bili= tdc(day, bili), 
                ascites=tdc(day, ascites),
                chol = tdc(day, chol))
pdata$age <- round(pdata$age,1)
pdata$death <- 1*pdata$death
subset(pdata, id<3, c(id, tstart, tstop, death, age, bili, ascites, chol))


###################################################
### code chunk number 3: bstate
###################################################
bstate <- c("normal", "bili (1,4]", "bili >4", "death")
bmat <- matrix(0,4,4, dimnames= list(bstate, bstate))
bmat[1,2] <- bmat[2,3] <- 1
bmat[2,1] <- bmat[3,2] <- 1
bmat[1:3, 4] <- 1
bmat[1,3] <- 0.75
bmat[3,1] <- 1.5
lty <- (1+ 1*(bmat!=1))[bmat!=0]
statefig(rbind(3,1), bmat, offset=.01, acol=c("black", "gray")[lty])


###################################################
### code chunk number 4: pbc2
###################################################
p1 <- subset(pbcseq, !duplicated(id))
pdata <- tmerge(p1[,c(1,3:5)], p1, id=id, death= event(futime, 1*(status==2)))
pdata <- tmerge(pdata, pbcseq, id=id, bili= tdc(day, bili), 
                ascites=tdc(day, ascites),
                chol = tdc(day, chol))
pdata$age <- round(pdata$age,1)

bili3 <- cut(pbcseq$bili, c(0, 1, 4, 50), c("normal", "1-4", "4+"))
# two 0-1 visits in a row is not a transition
b3e <- nostutter(pbcseq$id, as.numeric(bili3)) 

pdata2 <- tmerge(pdata, pbcseq, id= id,
                 bili3 = tdc(day, bili3), bstate= event(day, b3e))
temp <- with(pdata2, ifelse(death==1, 4*death, as.numeric(bstate) -1L))
pdata2$bstate <- factor(temp, 0:4, 
                        c("censor", "normal", "1-4", "4+", "death"))

subset(pdata2, id<3, c(id, tstart, tstop, death, age, bili, ascites, chol,
                      bili3, bstate))


###################################################
### code chunk number 5: check
###################################################
survcheck(Surv(tstart, tstop, bstate) ~1, pdata2, id=id, istate=bili3)


###################################################
### code chunk number 6: pbc2b
###################################################
pcox1 <- coxph(Surv(tstart, tstop, death) ~ bili3, pdata2,
                  id=id)
psurv1a <- survfit(Surv(tstart, tstop, bstate) ~ 1, pdata2,
                  id= id, istate= bili3, p0=c(1,0,0,0))
psurv1b <- survfit(Surv(tstart, tstop, bstate) ~ 1, pdata2,
                  id= id, istate= bili3, p0=c(0,1,0,0))
psurv1c <- survfit(Surv(tstart, tstop, bstate) ~ 1, pdata2,
                  id= id, istate= bili3, p0=c(0,0,1,0))

plot(psurv1c[4], col=3, lwd=2, conf.int=F, xscale=365.25,
     xlab= "Years from randomization", ylab="Death")
lines(psurv1b[4], col=2, lwd=2, conf.int=F)
lines(psurv1a[4], col=1, lwd=2, conf.int=F)


###################################################
### code chunk number 7: lung1
###################################################
lung2 <- data.frame(id=1:228, time=0, death=0, lung[, -(2:3)])
temp <- data.frame(id=1:228, time=lung$time, death= lung$status-1)
lung2 <- merge(lung2, temp, all=TRUE)
subset(lung2, id<4, c(id, time, death, inst, age, sex, ph.ecog, pat.karno))


###################################################
### code chunk number 8: pbc3
###################################################
# separate out death, and add it on the end 
# death yes/no *is* observed every visit
temp <- with(subset(pbcseq, !duplicated(id)),
             data.frame(id=id, day =futime, death= 1*(status==2)))
pdata3 <- cbind(pbcseq[, -(2:3)], death=0)
pdata3 <- merge(pdata3, temp, all=TRUE)

# create a factor for joint outcome
pdata3$bili3 <- cut(pdata3$bili, c(0,1,4, 50),  c("normal","1-4", "4+"))
temp <- with(pdata3, ifelse(!duplicated(id, fromLast=TRUE), 4*death,
                as.numeric(bili3)))
pdata3$bstate <- factor(temp, 0:4, c("censor", "normal","1-4", "4+", "death"))

subset(pdata3, id<3, c(id, day, death, age, bili, ascites, chol,
                     bili3,  bstate))

pcox2 <-  coxph(Surv2(day, death) ~ bili3, pdata3, id= id, ties="efron")
all.equal(coef(pcox1), coef(pcox2))

psurv2a <- survfit(Surv2(day, bstate) ~1, pdata3, id=id, p0=c(1,0,0,0))
all.equal(psurv1a$pstate, psurv2a$pstate)


###################################################
### code chunk number 9: eyes
###################################################
rfit1 <- survfit(Surv(futime, status) ~ trt, id=id, retinopathy)
rfit2 <- survfit(Surv(futime, status) ~ trt, cluster=id, retinopathy)


###################################################
### code chunk number 10: mtest
###################################################
tdata <- tmerge(myeloid[,1:4], myeloid, id=id, death=event(futime,death),
                priortx = tdc(txtime), sct= event(txtime))
tdata$event <- factor(with(tdata, sct + 2*death), 0:2,
                      c("censor", "sct", "death"))
tdata$sex[tdata$id %in% 273:275] <- NA   # obs 425 to 428
tdata$flt3[tdata$id %in% 271:273] <- NA  # obs 422 to 425
tdata$event[tdata$id==270 & tdata$tstart>0] <- NA

subset(tdata, id %in% 270:275)

check1 <- survcheck(Surv(tstart, tstop, event) ~1, tdata, id=id)
check1

check2 <- survcheck(Surv(tstart, tstop, event) ~sex, tdata, id=id)

fit <- coxph(list(Surv(tstart, tstop, event) ~ trt, 
                  1:3 + 2:3 ~ sex,
                  1:2 + 2:3 ~ flt3), tdata, id=id)
fit

check1$transitions- fit$transitions
