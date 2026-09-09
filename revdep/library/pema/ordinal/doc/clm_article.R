### R code from vignette source 'clm_article.Rnw'

###################################################
### code chunk number 1: preliminaries
###################################################
options(prompt = "R> ", continue = "+  ", width = 70, useFancyQuotes = FALSE)
library("ordinal")
library("xtable")


###################################################
### code chunk number 2: clm_article.Rnw:742-744
###################################################
clm_args <- gsub("function ", "clm", deparse(args(clm)))
cat(paste(clm_args[-length(clm_args)], "\n"))


###################################################
### code chunk number 3: clm_article.Rnw:759-761
###################################################
cc_args <- gsub("function ", "clm.control", deparse(args(clm.control)))
cat(paste(cc_args[-length(cc_args)], "\n"))


###################################################
### code chunk number 4: clm_article.Rnw:792-802
###################################################
## data(wine)
tab <- with(wine, table(temp:contact, rating))
mat <- cbind(rep(c("cold", "warm"), each = 2),
             rep(c("no", "yes"), 2),
             tab)
colnames(mat) <- c("Temperature", "Contact",
                   paste("~~", 1:5, sep = ""))
xtab <- xtable(mat)
print(xtab, only.contents = TRUE, include.rownames = FALSE,
      sanitize.text.function = function(x) x)


###################################################
### code chunk number 5: clm_article.Rnw:830-833
###################################################
library("ordinal")
fm1 <- clm(rating ~ temp + contact, data = wine)
summary(fm1)


###################################################
### code chunk number 6: latent_dist_1
###################################################
fm1_fig <- clm(rating ~ contact + temp, data=wine, link="probit")
## Version with arbitrary location and scale parameterization:
alpha_ast <- .6
sigma_ast <- 1.4
theta <- fm1_fig$alpha
beta <- fm1_fig$beta[2]
theta_ast <- theta * sigma_ast
beta_ast <- beta * sigma_ast

par(mar = c(3,0,0.5,0)+.2)
Min <- -3; Max <- 5; H <- 1; loft <- 2
xx <- seq(Min, Max, len=1e3)
plot(c(Min, Max), c(0, loft), type = "n", axes=FALSE, xlab="", ylab="")
axis(1, at=-alpha_ast + seq(-2, 5, 1), line=1,
     labels = seq(-2, 5, 1))
lines(xx, dnorm(xx, sd = sigma_ast))
lines(xx, H+dnorm(xx, beta_ast, sd=sigma_ast))
abline(h=c(0, H))
text(Max-.3, .15, "cold")
text(Max-.3, H+.15, "warm")
## alpha:
mtext(expression(paste(alpha, '*')), side=1, at=0)
segments(0, -.02, 0, .02)
## beta arrow:
segments(0, dnorm(0, sd=sigma_ast), 0, dnorm(0, sd=sigma_ast)+H+.3, 
         lty=3, lwd=2)
segments(beta_ast, H+dnorm(0, sd=sigma_ast), beta_ast, 
         dnorm(0, sd=sigma_ast)+H+.3, lty=3,
         lwd=2)
arrows(0, H+.3+dnorm(0, sd=sigma_ast), beta_ast, 
       H+.3+dnorm(0, sd=sigma_ast), length=.1)
text(beta_ast-.25, H+.3+dnorm(0, sd=sigma_ast)+.05, expression(paste(beta, '*')))
## add thresholds and Y-scale:
abline(h=loft)
theta.text <- c(expression(paste(theta[1], '*')), 
                expression(paste(theta[2], '*')),
                expression(paste(theta[3], '*')),
                expression(paste(theta[4], '*')))
mtext(theta.text, at=theta_ast, side=1)
segments(theta_ast, -2, theta_ast, 10, col="red")
mtext(c("Y:", 1:5), side=3, line=-.5, at=c(-2.5, -1.5, theta_ast+.5),
      col="red")
text(-2, H/2, expression(paste("P(Y = 2|cold)")), col="red")
arrows(-2, H/2-.04, -.2, .2, length=.1, col="red")


###################################################
### code chunk number 7: latent_dist_2
###################################################
## Version of figure with standardized location and scale:
alpha_ast <- 0
sigma_ast <- 1
theta <- fm1_fig$alpha
beta <- fm1_fig$beta[2]
theta_ast <- theta * sigma_ast
beta_ast <- beta * sigma_ast

par(mar = c(3,0,0.5,0)+.2)
Min <- -3; Max <- 5; H <- 1; loft <- 2
xx <- seq(Min, Max, len=1e3)
plot(c(Min, Max), c(0, loft), type = "n", axes=FALSE, xlab="", ylab="")
axis(1, at=-alpha_ast + seq(-2, 4, 1), line=1,
     labels = seq(-2, 4, 1))
lines(xx, dnorm(xx, sd = sigma_ast))
lines(xx, H+dnorm(xx, beta_ast, sd=sigma_ast))
abline(h=c(0, H))
text(Max-.3, .15, "cold")
text(Max-.3, H+.15, "warm")
segments(0, -.02, 0, .02)
## beta arrow:
segments(0, dnorm(0, sd=sigma_ast), 0, dnorm(0, sd=sigma_ast)+H+.3, 
         lty=3, lwd=2)
segments(beta_ast, H+dnorm(0, sd=sigma_ast), beta_ast, 
         dnorm(0, sd=sigma_ast)+H+.3, lty=3,
         lwd=2)
arrows(0, H+.3+dnorm(0, sd=sigma_ast), beta_ast, 
       H+.3+dnorm(0, sd=sigma_ast), length=.1)
text(beta_ast-.25, H+.3+dnorm(0, sd=sigma_ast)+.05, expression(paste(beta)))
## add thresholds and Y-scale:
abline(h=loft)
theta.text <- c(expression(paste(theta[1])), 
                expression(paste(theta[2])),
                expression(paste(theta[3])),
                expression(paste(theta[4])))
mtext(theta.text, at=theta_ast, side=1)
segments(theta_ast, -2, theta_ast, 10, col="red")
mtext(c("Y:", 1:5), side=3, line=-.5, at=c(-2.5, -1.5, theta_ast+.5),
      col="red")
text(-2, H/2, expression(paste("P(Y = 2|cold)")), col="red")
arrows(-2, H/2-.04, -.2, .2, length=.1, col="red")


###################################################
### code chunk number 8: clm_article.Rnw:973-974
###################################################
anova(fm1, type = "III")


###################################################
### code chunk number 9: clm_article.Rnw:978-980
###################################################
fm2 <- clm(rating ~ temp, data = wine)
anova(fm2, fm1)


###################################################
### code chunk number 10: clm_article.Rnw:986-987
###################################################
drop1(fm1, test = "Chi")


###################################################
### code chunk number 11: clm_article.Rnw:992-994
###################################################
fm0 <- clm(rating ~ 1, data = wine)
add1(fm0, scope = ~ temp + contact, test = "Chi")


###################################################
### code chunk number 12: clm_article.Rnw:998-999
###################################################
confint(fm1)


###################################################
### code chunk number 13: clm_article.Rnw:1034-1036
###################################################
fm.nom <- clm(rating ~ temp, nominal = ~ contact, data = wine)
summary(fm.nom)


###################################################
### code chunk number 14: figNom2
###################################################
fm_fig.nom <- clm(rating ~ temp, nominal =~ contact, data=wine,
              link="probit")
th1 <- unlist(fm_fig.nom$Theta[1, 2:5]) # thresholds for contact: "no"
th2 <- unlist(fm_fig.nom$Theta[2, 2:5]) # thresholds for contact: "yes"

## Figure:
par(mar = c(2,0,1,0)+.2)
Min <- -3; Max <- 5; H <- 1; loft <- 2
xx <- seq(Min, Max, len=1e3)
plot(c(Min, Max), c(0, loft), type = "n", axes=FALSE, xlab="", ylab="")
lines(xx, dnorm(xx))
lines(xx, H+dnorm(xx, fm_fig.nom$beta[1]))
abline(h=c(0, H))
text(Max-.3, .15, "cold")
text(Max-.3, H+.15, "warm")
segments(0, -.02, 0, .02)
## beta arrow:
segments(0, dnorm(0), 0, dnorm(0)+H+.3, lty=3, lwd=2)
segments(fm_fig.nom$beta[1], H+dnorm(0), fm_fig.nom$beta[1], dnorm(0)+H+.3,
         lty=3, lwd=2)
arrows(0, H+.3+dnorm(0), fm_fig.nom$beta[1], H+.3+dnorm(0), length=.1)
text(fm_fig.nom$beta[1]-.2, loft-.22, expression(beta))
abline(h=loft)
theta.text <- c(expression(theta[1]), expression(theta[2]),
                expression(theta[3]), expression(theta[4]))
mtext(theta.text, at=th1, side=1, col="red")
segments(th1, -.05, th1, loft, col="red")
mtext("contact: no", at=4.3, side=1, col="red")

mtext(theta.text, at=th2, side=3, col="blue")
segments(th2, 0, th2, loft+.05, col="blue")
mtext("contact: yes", at=4.3, side=3, col="blue")


###################################################
### code chunk number 15: clm_article.Rnw:1100-1101
###################################################
fm.nom$Theta


###################################################
### code chunk number 16: clm_article.Rnw:1110-1111
###################################################
anova(fm1, fm.nom)


###################################################
### code chunk number 17: clm_article.Rnw:1122-1123
###################################################
fm.nom2 <- clm(rating ~ temp + contact, nominal = ~ contact, data = wine)


###################################################
### code chunk number 18: clm_article.Rnw:1126-1127
###################################################
fm.nom2


###################################################
### code chunk number 19: clm_article.Rnw:1131-1132
###################################################
nominal_test(fm1)


###################################################
### code chunk number 20: clm_article.Rnw:1151-1153
###################################################
fm.sca <- clm(rating ~ temp + contact, scale = ~ temp, data = wine)
summary(fm.sca)


###################################################
### code chunk number 21: clm_article.Rnw:1158-1159
###################################################
scale_test(fm1)


###################################################
### code chunk number 22: figSca
###################################################
## Scale differences:
fm_fig.sca <- clm(rating ~ contact + temp, scale=~temp,
              data=wine, link="probit")
## Exagerate the scale for better visual:
sca <- 1.5 # exp(fm_fig.sca$zeta)

## Figure:
par(mar = c(2,0,1,0)+.2)
Min <- -3; Max <- 5; H <- 1; loft <- 2
xx <- seq(Min, Max, len=1e3)
plot(c(Min, Max), c(0, loft), type = "n", axes=FALSE, xlab="", ylab="")
lines(xx, dnorm(xx))
lines(xx, H+dnorm(xx, fm_fig.sca$beta[2], sca))
abline(h=c(0, H))
text(Max-.3, .15, "cold")
text(Max-.3, H+.15, "warm")
## alpha:
## mtext(expression(alpha), side=1, at=0)
segments(0, -.02, 0, .02)
## beta arrow:
segments(0, dnorm(0), 0, dnorm(0, ,sca)+H+.3, lty=3, lwd=2)
segments(fm_fig.sca$beta[2], H+dnorm(0, ,sca), fm_fig.sca$beta[2],
         dnorm(0, ,sca)+H+.3, lty=3, lwd=2)
arrows(0, H+.3+dnorm(0, ,sca), fm_fig.sca$beta[2], H+.3+dnorm(0, ,sca), length=.1)
text(fm_fig.sca$beta[2]-.2, loft-.35, expression(beta))
abline(h=loft)
theta.text <- c(expression(theta[1]), expression(theta[2]),
                expression(theta[3]), expression(theta[4]))
mtext(theta.text, at=fm_fig.sca$alpha, side=1)
segments(fm_fig.sca$alpha, -2, fm_fig.sca$alpha, 10, col="red")
mtext(c("Y:", 1:5), side=3, line=-.5, at=c(-2.5, -1.5, fm_fig.sca$alpha+.5),
      col="red")


###################################################
### code chunk number 23: clm_article.Rnw:1216-1219
###################################################
fm.equi <- clm(rating ~ temp + contact, data = wine,
               threshold = "equidistant")
summary(fm.equi)


###################################################
### code chunk number 24: clm_article.Rnw:1226-1227
###################################################
drop(fm.equi$tJac %*% coef(fm.equi)[c("threshold.1", "spacing")])


###################################################
### code chunk number 25: clm_article.Rnw:1234-1235
###################################################
mean(diff(coef(fm1)[1:4]))


###################################################
### code chunk number 26: clm_article.Rnw:1241-1242
###################################################
anova(fm1, fm.equi)


###################################################
### code chunk number 27: figFlex
###################################################
fm_fig.flex <- clm(rating ~ contact + temp, data=wine,
               link="probit")
th <- fm_fig.flex$alpha
par(mar = c(2,0,0.5,0)+.2)
Min <- -3; Max <- 5; H <- 1; loft <- 2
xx <- seq(Min, Max, len=1e3)
plot(c(Min, Max), c(0, loft), type = "n", axes=FALSE, xlab="", ylab="")
lines(xx, dnorm(xx))
lines(xx, H+dnorm(xx, fm_fig.flex$beta[2]))
abline(h=c(0, H))
text(Max-.3, .15, "cold")
text(Max-.3, H+.15, "warm")
## alpha:
# mtext(expression(alpha), side=1, at=0)
segments(0, -.02, 0, .02)
## beta arrow:
segments(0, dnorm(0), 0, dnorm(0)+H+.3, lty=3, lwd=2)
segments(fm_fig.flex$beta[2], H+dnorm(0), fm_fig.flex$beta[2], dnorm(0)+H+.3,
         lty=3, lwd=2)
arrows(0, H+.3+dnorm(0), fm_fig.flex$beta[2], H+.3+dnorm(0), length=.1)
text(fm_fig.flex$beta[2]-.2, loft-.22, expression(beta))
## add thresholds and Y-scale:
abline(h=loft)
theta.text <- c(expression(theta[1]), expression(theta[2]),
                expression(theta[3]), expression(theta[4]))
mtext(theta.text, at=th, side=1)
segments(th, -2, th, 10, col="red")
mtext(c("Y:", 1:5), side=3, line=-.5, at=c(-2.5, -1.5,
               th+.6),  col="red")
text(-2, H/2, expression(paste("P(Y = 2|cold)")), col="red")
arrows(-2, H/2-.04, -.2, .2, length=.1, col="red")
arrows(th[-4], loft-.05, th[-1], loft-.05, length=.1)
text(th[-4]+.6, loft-.1, c(expression(Delta[1]), expression(Delta[2]),
                           expression(Delta[3])))


###################################################
### code chunk number 28: figEqui
###################################################
fm_fig.equi <- clm(rating ~ contact + temp, data=wine,
               threshold="equidistant", link="probit")
th <- c(fm_fig.equi$alpha[1], fm_fig.equi$alpha[1] +
        cumsum(rep(fm_fig.equi$alpha[2], 3)))
par(mar = c(2,0,0.5,0)+.2)
Min <- -3; Max <- 5; H <- 1; loft <- 2
xx <- seq(Min, Max, len=1e3)
plot(c(Min, Max), c(0, loft), type = "n", axes=FALSE, xlab="", ylab="")
lines(xx, dnorm(xx))
lines(xx, H+dnorm(xx, fm_fig.equi$beta[2]))
abline(h=c(0, H))
text(Max-.3, .15, "cold")
text(Max-.3, H+.15, "warm")
## alpha:
## mtext(expression(alpha), side=1, at=0)
segments(0, -.02, 0, .02)
## beta arrow:
segments(0, dnorm(0), 0, dnorm(0)+H+.3, lty=3, lwd=2)
segments(fm_fig.equi$beta[2], H+dnorm(0), fm_fig.equi$beta[2], dnorm(0)+H+.3,
         lty=3, lwd=2)
arrows(0, H+.3+dnorm(0), fm_fig.equi$beta[2], H+.3+dnorm(0), length=.1)
text(fm_fig.equi$beta[2]-.2, loft-.22, expression(beta))
## add thresholds and Y-scale:
abline(h=loft)
theta.text <- c(expression(theta[1]), expression(theta[2]),
                expression(theta[3]), expression(theta[4]))
mtext(theta.text, at=th, side=1)
segments(th, -2, th, 10, col="red")
mtext(c("Y:", 1:5), side=3, line=-.5, at=c(-2.5, -1.5,
               th+.6),  col="red")
text(-2, H/2, expression(paste("P(Y = 2|cold)")), col="red")
arrows(-2, H/2-.04, -.2, .2, length=.1, col="red")
arrows(th[-4], loft-.05, th[-1], loft-.05, length=.1)
text(th[-4]+.6, loft-.1, c(expression(Delta), expression(Delta),
                           expression(Delta)))


###################################################
### code chunk number 29: clm_article.Rnw:1336-1337
###################################################
with(soup, table(PROD, PRODID))


###################################################
### code chunk number 30: clm_article.Rnw:1341-1344
###################################################
fm_binorm <- clm(SURENESS ~ PRODID, scale = ~ PROD, 
                 data = soup, link="probit")
summary(fm_binorm)


###################################################
### code chunk number 31: clm_article.Rnw:1347-1349
###################################################
fm_nom <- clm(SURENESS ~ PRODID, nominal = ~ PROD, 
              data = soup, link="probit")


###################################################
### code chunk number 32: clm_article.Rnw:1353-1355
###################################################
fm_location <- update(fm_binorm, scale = ~ 1)
anova(fm_location, fm_binorm, fm_nom)


###################################################
### code chunk number 33: clm_article.Rnw:1360-1365
###################################################
fm_cll_scale <- clm(SURENESS ~ PRODID, scale = ~ PROD, 
              data = soup, link="cloglog")
fm_cll <- clm(SURENESS ~ PRODID, 
               data = soup, link="cloglog")
anova(fm_cll, fm_cll_scale, fm_binorm)


###################################################
### code chunk number 34: clm_article.Rnw:1369-1371
###################################################
fm_loggamma <- clm(SURENESS ~ PRODID, data = soup, link="log-gamma")
summary(fm_loggamma)


###################################################
### code chunk number 35: profileLikelihood
###################################################
pr1 <- profile(fm1, alpha = 1e-4)
plot(pr1)


###################################################
### code chunk number 36: prof1
###################################################
plot(pr1, which.par = 1)


###################################################
### code chunk number 37: prof2
###################################################
plot(pr1, which.par = 2)


###################################################
### code chunk number 38: clm_article.Rnw:1430-1433
###################################################
slice.fm1 <- slice(fm1, lambda = 5)
par(mfrow = c(2, 3))
plot(slice.fm1)


###################################################
### code chunk number 39: slice11
###################################################
plot(slice.fm1, parm = 1)


###################################################
### code chunk number 40: slice12
###################################################
plot(slice.fm1, parm = 2)


###################################################
### code chunk number 41: slice13
###################################################
plot(slice.fm1, parm = 3)


###################################################
### code chunk number 42: slice14
###################################################
plot(slice.fm1, parm = 4)


###################################################
### code chunk number 43: slice15
###################################################
plot(slice.fm1, parm = 5)


###################################################
### code chunk number 44: slice16
###################################################
plot(slice.fm1, parm = 6)


###################################################
### code chunk number 45: slice2
###################################################
slice2.fm1 <- slice(fm1, parm = 4:5, lambda = 1e-5)
par(mfrow = c(1, 2))
plot(slice2.fm1)


###################################################
### code chunk number 46: slice24
###################################################
plot(slice2.fm1, parm = 1)


###################################################
### code chunk number 47: slice25
###################################################
plot(slice2.fm1, parm = 2)


###################################################
### code chunk number 48: clm_article.Rnw:1494-1495
###################################################
convergence(fm1)


###################################################
### code chunk number 49: clm_article.Rnw:1521-1522
###################################################
head(pred <- predict(fm1, newdata = subset(wine, select = -rating))$fit)


###################################################
### code chunk number 50: clm_article.Rnw:1526-1529
###################################################
stopifnot(isTRUE(all.equal(fitted(fm1), t(pred)[
  t(col(pred) == wine$rating)])),
  isTRUE(all.equal(fitted(fm1), predict(fm1, newdata = wine)$fit)))


###################################################
### code chunk number 51: clm_article.Rnw:1532-1536
###################################################
newData <- expand.grid(temp    = levels(wine$temp),
                       contact = levels(wine$contact))
cbind(newData, round(predict(fm1, newdata = newData)$fit, 3),
      "class" = predict(fm1, newdata = newData, type = "class")$fit)


###################################################
### code chunk number 52: clm_article.Rnw:1539-1540
###################################################
head(apply(pred, 1, function(x) round(weighted.mean(1:5, x))))


###################################################
### code chunk number 53: clm_article.Rnw:1543-1547
###################################################
p1 <- apply(predict(fm1, newdata = subset(wine, select=-rating))$fit, 1,
            function(x) round(weighted.mean(1:5, x)))
p2 <- as.numeric(as.character(predict(fm1, type = "class")$fit))
stopifnot(isTRUE(all.equal(p1, p2, check.attributes = FALSE)))


###################################################
### code chunk number 54: clm_article.Rnw:1552-1554
###################################################
predictions <- predict(fm1, se.fit = TRUE, interval = TRUE)
head(do.call("cbind", predictions))


###################################################
### code chunk number 55: clm_article.Rnw:1590-1596
###################################################
wine <- within(wine, {
  rating_comb3 <- factor(rating, labels = c("1", "2-4", "2-4", "2-4", "5"))
}) 
ftable(rating_comb3 ~ temp, data = wine)
fm.comb3 <- clm(rating_comb3 ~ temp, data = wine)
summary(fm.comb3)


###################################################
### code chunk number 56: clm_article.Rnw:1601-1603
###################################################
fm.comb3_b <- clm(rating_comb3 ~ 1, data = wine)
anova(fm.comb3, fm.comb3_b)


###################################################
### code chunk number 57: clm_article.Rnw:1608-1610
###################################################
fm.nom2 <- clm(rating ~ contact, nominal = ~ temp, data = wine)
summary(fm.nom2)


###################################################
### code chunk number 58: clm_article.Rnw:1621-1623
###################################################
fm.soup <- clm(SURENESS ~ PRODID * DAY, data = soup)
summary(fm.soup)


###################################################
### code chunk number 59: clm_article.Rnw:1626-1627
###################################################
with(soup, table(DAY, PRODID))


###################################################
### code chunk number 60: clm_article.Rnw:1638-1644
###################################################
wine <- within(wine, {
  rating_comb2 <- factor(rating, labels = c("1-2", "1-2", "3-5", "3-5", "3-5"))
}) 
ftable(rating_comb2 ~ contact, data = wine)
fm.comb2 <- clm(rating_comb2 ~ contact, scale = ~ contact, data = wine)
summary(fm.comb2)


###################################################
### code chunk number 61: clm_article.Rnw:1647-1661
###################################################
## Example with unidentified parameters with 3 response categories
## not shown in paper:
wine <- within(wine, {
  rating_comb3b <- rating
  levels(rating_comb3b) <- c("1-2", "1-2", "3", "4-5", "4-5")
}) 
wine$rating_comb3b[1] <- "4-5" # Remove the zero here to avoid inf MLE
ftable(rating_comb3b ~ temp + contact, data = wine)

fm.comb3_c <- clm(rating_comb3b ~ contact * temp, 
                  scale   = ~contact * temp, 
                  nominal = ~contact, data = wine)
summary(fm.comb3_c)
convergence(fm.comb3_c)


###################################################
### code chunk number 62: clm_article.Rnw:1670-1672
###################################################
rho <- update(fm1, doFit=FALSE)
names(rho)


###################################################
### code chunk number 63: clm_article.Rnw:1675-1677
###################################################
rho$clm.nll(rho)
c(rho$clm.grad(rho))


###################################################
### code chunk number 64: clm_article.Rnw:1680-1682
###################################################
rho$clm.nll(rho, par = coef(fm1))
print(c(rho$clm.grad(rho)), digits = 3)


###################################################
### code chunk number 65: clm_article.Rnw:1687-1697
###################################################
nll <- function(par, envir) {
  envir$par <- par
  envir$clm.nll(envir)
}
grad <- function(par, envir) {
  envir$par <- par
  envir$clm.nll(envir)
  envir$clm.grad(envir)
}
nlminb(rho$par, nll, grad, upper = c(rep(Inf, 4), 2, 2), envir = rho)$par


###################################################
### code chunk number 66: clm_article.Rnw:1706-1711
###################################################
artery <- data.frame(disease = factor(rep(0:4, 2), ordered = TRUE),
                     smoker  = factor(rep(c("no", "yes"), each = 5)),
                     freq    = c(334, 99, 117, 159, 30, 350, 307, 
                                 345, 481, 67))
addmargins(xtabs(freq ~ smoker + disease, data = artery), margin = 2)


###################################################
### code chunk number 67: clm_article.Rnw:1715-1717
###################################################
fm <- clm(disease ~ smoker, weights = freq, data = artery)
exp(fm$beta)


###################################################
### code chunk number 68: clm_article.Rnw:1722-1725
###################################################
fm.nom <- clm(disease ~ 1, nominal = ~ smoker, weights = freq, 
              data = artery, sign.nominal = "negative")
coef(fm.nom)[5:8]


###################################################
### code chunk number 69: clm_article.Rnw:1728-1729
###################################################
coef(fm.lm <- lm(I(coef(fm.nom)[5:8]) ~ I(0:3)))


###################################################
### code chunk number 70: clm_article.Rnw:1732-1739
###################################################
nll2 <- function(par, envir) {
  envir$par <- c(par[1:4], par[5] + par[6] * (0:3))
  envir$clm.nll(envir)
}
start <- unname(c(coef(fm.nom)[1:4], coef(fm.lm)))
fit <- nlminb(start, nll2, envir = update(fm.nom, doFit = FALSE))
round(fit$par[5:6], 2)
