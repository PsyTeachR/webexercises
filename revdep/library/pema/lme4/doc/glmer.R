## ----preliminaries,include=FALSE,cache=FALSE,message=FALSE,echo=FALSE----
options(width=69, show.signif.stars=FALSE, str=strOptions(strict.width="cut"))
library(knitr)
library(lme4)
library(ggplot2)
theme_set(theme_bw())
revguide <- guide_legend(reverse = TRUE)
library(grid)
library(gridExtra)
zmargin <- theme(panel.margin=unit(0,"lines"))
library(lattice)
library(DHARMa)
library(performance)
opts_chunk$set(engine='R',dev='pdf',fig.width=10,
               fig.height=6.5,prompt=TRUE,
               ## strip.white=all,
               error=FALSE, ## stop on error
               tidy=FALSE,comment=NA)
## using knitr::knit2pdf() may lead to xcolor 'incompatible color definition'
## warnings. The code below resolves that, but simultaneously breaks
## vignette compilation in other contexts ...
## https://tex.stackexchange.com/questions/148188/knitr-xcolor-incompatible-color-definition               
## knit_hooks$set(document = function(x) {sub('\\usepackage[]{xcolor}', '\\usepackage[dvipsnames]{xcolor}', x, fixed = TRUE)})


## ----m1------------------------------------------------------------
print(m1 <- glmer(cbind(incidence, size-incidence) ~ period + (1|herd),
      cbpp, binomial), corr=FALSE)

## ----density-utils, echo = FALSE-----------------------------------
zeta <- function(m, zmin=-3, zmax=3, npts=301L, rank = FALSE) {
    stopifnot (is(m, "glmerMod"),
               length(m@flist) == 1L,    # single grouping factor
              length(m@cnms[[1]]) == 1L) # single column for that grouping factor
    pp <- m
    rr <- m@resp
    u0 <- getME(pp,"u")
    sd <- 1/getME(pp,"L")@x
    ff <- as.integer(getME(pp,"flist")[[1]])
    fc <- getME(pp,"X") %*% getME(pp,"beta") # fixed-effects contribution to linear predictor
    ZL <- t(getME(pp,"Lambdat") %*% getME(pp,"Zt"))
    dc <- function(z) { # evaluate the unscaled conditional density on the deviance scale
        uu <- u0 + z * sd
        rr$updateMu(fc + ZL %*% uu)
        unname(as.vector(tapply(rr$devResid(), ff, sum))) + uu * uu
    }
    zvals <- seq(zmin, zmax, length.out = npts)
    d0 <- dc(0) # because this is the last evaluation, the model is restored to its incoming state
    # signed square root
    sqrtmat <- t(sqrt(vapply(zvals, dc, d0, USE.NAMES=FALSE) - d0)) *
      array(ifelse(zvals < 0, -1, 1), c(npts, length(u0)))
    if (rank) {
      ## order by 'badness' (variance of normalized profile)
      nvals <- exp(-0.5*sqrtmat^2)/sqrt(2*pi)/dnorm(zvals)
      colnames(sqrtmat) <- seq(ncol(sqrtmat))
      sqrtmat <- sqrtmat[,order(apply(sqrtmat, 2, var), decreasing = TRUE)]
    }
    list(zvals=zvals,
         sqrtmat= sqrtmat 
         )
}
smult <- function(x, y) { sweep(x, y, MARGIN = 2, FUN = "*") }
lagr_basis_i <- function(i, xvec, q) {
  num <- sapply(xvec, \(x) prod(x-q[-i]))
  denom <- prod(q[i]-q[-i])
  num/denom
}
lagr_basis_deriv_i <- function(i, xvec, q) {
  if (length(q)==1) return(rep(0, length(xvec)))
  f <- function(j) sapply(xvec, \(x) prod(x-q[-c(i,j)]))
  num <- rowSums(sapply(seq_along(q)[-i], f))
  denom <- prod(q[i]-q[-i])
  num/denom
}
lagr_basis <- function(xvec, q, deriv = FALSE) {
  FUN <- if (!deriv) lagr_basis_i else lagr_basis_deriv_i
  sapply(seq_along(q), \(i) FUN(i, xvec, q))
}
calc_h <- function(xvec, Q) {
  gg <- GHrule(Q)
  ell <- lagr_basis(xvec, gg[,"z"])
  ## dl_i/dx(x_i)
  bb <- lagr_basis(gg[,"z"], gg[,"z"], deriv = TRUE)
  d_ell <- if (length(bb) == 1) bb else diag(bb)
  xdiff <- outer(xvec, gg[,"z"], "-")
  h <- (1 - 2*smult(xdiff, d_ell))*ell^2
  hbar <- xdiff*ell^2
  list(h = h, hbar = hbar)
}
## FIXME: modify to work when Q = 1
ghq_fun <- function(Q, zvals, f, fbar, H = NULL) {
  q <- GHrule(Q)[,"z"]
  H <- H %||% calc_h(zvals, Q = Q)
  dz <- diff(zvals[1:2])
  Qvals <- sapply(q, \(x) which.min(abs(zvals - x)))
  if (any(Qvals == 1)) stop("need to extend zm calculation")
  q_approx <- rowSums(smult(H$h, f[Qvals])) +
    rowSums(smult(H$hbar, fbar[Qvals]))
  q_approx
}
calc_q <- function(Q, zm) {
  dz <- diff(zm$zvals[1:2])
  dmat <- exp(-0.5*zm$sqrtmat^2)/sqrt(2*pi)/dnorm(zm$zvals)
  ## finite difference (NA to match dimension)
  d_dmat <- rbind(NA,apply(dmat, 2, function(x) diff(x)/dz))
  H <- calc_h(zm$zvals, Q = Q)
  res <- sapply(1:ncol(dmat),
                \(i) ghq_fun(Q, zm$zvals, dmat[,i], d_dmat[,i], H = H)
                )
  attr(res, "nAGQ") <- Q
  res
}
plot_zeta <- function(z, q_approx = NULL, norm = FALSE,
                      ylab = if (!norm) "density" else "t(z)",
                      which = NULL, layout = c(5,3), ylim = NULL,
                      auto.key = list(lines = TRUE, points = FALSE)) {
  dmat <- exp(-0.5*z$sqrtmat^2)/sqrt(2*pi)
  Q <- attr(q_approx, "nAGQ") ## rescue attribute before subsetting
  if (!is.null(which)) {
    dmat <- dmat[, which]
    q_approx <- q_approx[, which]
  }
  ## columnwise scaling/unscaling
  ## q_approx is normalized by default
  if (norm) dmat <- dmat/dnorm(z$zvals)
  if (!norm) q_approx <- q_approx*dnorm(z$zvals)
  
  nobs   <- nrow(dmat)
  npanel <- ncol(dmat)
  idx    <- gl(npanel, nobs)
  ngrp <- 3
  
  ref_val <- if (!norm) dnorm(z$zvals) else rep(1, nobs)
  ref_val <- rep(ref_val, npanel)

  grps <- c("conditional\ndensity",
            sprintf("AGQ(%d)", Q),
            if (!norm) "N(0,1)" else "")
  groups <- factor(rep(grps, each = nobs * npanel),
                   levels = grps)
  resp <- c(as.vector(dmat), as.vector(q_approx), ref_val)
  ylim <- ylim %||% extendrange(resp)
  zvec <- rep(z$zvals, ngrp * npanel)
  xyplot(resp ~ zvec | rep(idx, ngrp),
         groups = groups,
         type = c("g", "l"), aspect = 0.6, layout = layout,
         xlab = "z", ylab = ylab,
         auto.key = auto.key,
         par.settings = list(superpose.line = list(lty = 1:3)),
         ylim = ylim)
}

## ----densities,echo=FALSE,fig.height=5-----------------------------
zm <- zeta(m1, -3.750440, 3.750440)
qq <- calc_q(3, zm)
plot_zeta(zm, q_approx = qq)

## ----GHrule5-------------------------------------------------------
GHrule(5)

## ----tfunc,echo=FALSE----------------------------------------------
plot_zeta(zm, q_approx = qq, norm = TRUE, ylim = c(0.5, 1.5))

## ----toenail, echo = FALSE-----------------------------------------
data("toenail", package = "lme4")
ttab <- with(toenail, table(table(patientID)))
## sum(as.numeric(names(ttab))*ttab/sum(ttab))

## ----toenailplot,echo=FALSE----------------------------------------
data("toenail", package = "lme4")
toemod <- glmer(outcome ~ time*treatment + (1 | patientID), 
                     data = toenail, family = binomial(link = "logit"))
zm <- zeta(toemod)
q_toe <- calc_q(3, zm)
set.seed(101); s <- sample(ncol(zm$sqrtmat), size = 9)

gridExtra::grid.arrange(
             plot_zeta(zm, q_approx = q_toe, which = s, layout = c(3,3), auto.key = FALSE),
             plot_zeta(zm, which = s, norm = TRUE, q_approx = q_toe, layout = c(3,3),
                       ylim = c(0, 5)), nrow = 1,
             ## widths hand-tweaked to equalize plot size with/without scale
             widths = c(0.5, 0.63))


## ----newcbpp2,echo=FALSE-------------------------------------------
cbpp2 <- read.csv(system.file("vignette_data", "cbpp2.csv",
            package = "lme4"))
cbpp2 <- transform(cbpp2,period=factor(period),
                   treatment=factor(treatment,
                   levels=c("Partial/null","Complete","Unknown")))

## ----cbppPlot,echo=FALSE,fig.cap="Incidence (proportion of cows becoming seropositive per observation period) vs. period. Colours show treatment category for each herd; point sizes reflect the number of seronegative cows at the start of each period. Lines connect the sets of observations from each herd.",fig.scap="Incidence"----
g0 <- ggplot(cbpp2,aes(period, incidence/size, colour=treatment, shape = treatment)) +
    ## scale_y_continuous(limits = c(0, 1))+
    labs(x="Period",y="Proportional incidence")+
    scale_colour_brewer(palette="Dark2")
## faceted plot
## g0 + 
##     geom_point(aes(size = size)) +
##     facet_wrap(~herd) +
##     zmargin
## 
g0 +  geom_point(aes(size = size),alpha=0.4) +
    geom_line(aes(group=herd),alpha=0.3)
## geom_boxplot(fill="black",alpha=0.1,width=0.5,
## aes(group=interaction(period,treatment)))
## 
## boxplot(incidence/size ~ period, data = cbpp, las = 1,
##        xlab = 'Period', ylab = 'Probability of sero-positivity')

## ----cbppModelI----------------------------------------------------
gm1 <- glmer(incidence/size ~ period + treatment + avg_size + (1 | herd),
             family = binomial,
             data = cbpp2, weights = size)

## ----cbpp_diag,eval=FALSE,echo=FALSE-------------------------------
# ## diagnostic junk about N-M vs bobyqa differences
# tmpf <- function(x) c(deviance(x), unlist(getME(x,c("theta","beta"))))
# gm1 <- glmer(incidence/size ~ period + treatment + avg_size + (1 | herd),
#              family = binomial,
#              data = cbpp2, weights = size)
# gm1B <- update(gm1,control=glmerControl(optimizer="bobyqa"))
# cbind(tmpf(gm1),tmpf(gm1B))
# dd1 <- update(gm1,devFunOnly=TRUE)
# dd1B <- update(gm1B,devFunOnly=TRUE)
# gm1@optinfo$derivs$gradient
# gm1B@optinfo$derivs$gradient
# gm1@optinfo$derivs$gradient/gm1B@optinfo$derivs$gradient
# library(numDeriv)
# grad(dd1,tmpf(gm1)[-1])
# grad(dd1B,tmpf(gm1B)[-1])

## ----cbppModelII, warning=FALSE, message=FALSE---------------------
cbpp2 <- transform(cbpp2,obs=factor(seq(nrow(cbpp2))))
bob_opt <- glmerControl(optimizer = "bobyqa")
## herd and observation-level REs
gm2 <- update(gm1,.~.+(1|obs), control = bob_opt)  
## observation-level REs only
gm3 <- update(gm1,.~.-(1|herd)+(1|obs))  

## ----diagnose, echo=FALSE, warning=FALSE, message=FALSE, results='hide'----
aa <- allFit(gm2, verbose=FALSE)
ok <- summary(aa)[["which.OK"]]
lapply(aa[ok], \(x) x@optinfo$conv$lme4$messages)

## ----summary1,echo=FALSE-------------------------------------------
ss <- summary(gm1)
cc <- capture.output(print(summary(gm1)))
reRow <- grep("^Random effects",cc)
cat(cc[1:(reRow-2)],sep="\n")

## ----summary2,echo=FALSE-------------------------------------------
feRow <- grep("^Fixed effects",cc)
cat(cc[reRow:(feRow-2)],sep="\n")

## ----summary3,echo=FALSE-------------------------------------------
corRow <- grep("^Correlation",cc)
cat(cc[feRow:(corRow-2)],sep="\n")

## ----summary4,echo=FALSE-------------------------------------------
cat(cc[corRow:length(cc)],sep="\n")

## ----glmerDiagFake,eval=FALSE--------------------------------------
# ## basic residual plot
# plot(gm1)
# ## scale-location plot
# plot(gm1,sqrt(abs(resid(.)))~fitted(.),type=c("p","smooth"))
# ## boxplot of residuals grouped by a categorical predictor
# plot(gm1,period~resid(.))
# ## Q-Q plot
# qqmath(gm1)

## ----glmerDiag,fig.cap="Graphical diagnostics (using package built-in functions)",warning=FALSE,echo=FALSE----
p1 <- plot(gm1,type=c("p","smooth"),
    main="Default (Pearson resid vs. fitted)")
p2 <- plot(gm1,sqrt(abs(resid(.)))~fitted(.),type=c("p","smooth"),
     main="Scale-location")
p3 <- plot(gm1,period~resid(.), main = "Grouped residuals")
p4 <- qqmath(gm1,main="Quantile-quantile plot",type=c("p","r"))
grid.arrange(p1,p2,p3,p4,nrow=2)

## ----glmerRanefplot,fig.cap="Graphical display of random effects. \\emph{Left}: conditional modes $\\pm 1.96 \\times \\text{conditional standard deviation}$, ordered by magnitude. \\emph{Right}: quantile-quantile plot, with linear regression line overlaid.",echo=FALSE----
rr <- ranef(gm1, condVar=TRUE)
dd <- dotplot(rr)
qq <- qqmath(rr, type=c("p","r"))
grid.arrange(dd$herd, qq$herd, ncol=2)

## ----perf_chk_mod_cbpp,fig.cap="Model diagnostics using \\code{performance::check\\_model}. The plot showcasing the normality of random effects (lower right panel) is the transpose of the right panel in Figure 6.",fig.height=10,echo=FALSE----
check_model(gm1, check = c("pp_check", "binned_residuals",
                           "qq", "reqq"))

## ----dharma_mod_cbpp,fig.cap="Model assumption checks using the DHARMa package. \\code{n.s.} denotes ``not significant''.",echo=FALSE,warning=FALSE----
## FIXME: versions of DHARMa before 0.5.0 gave a significant nonlinearity test, so the caption
## included: 'Other exploration (such as \\code{plot(simulationOutput, form = cbpp2\\$period)}) does not reveal any obvious problems such as nonlinear responses, so we proceed with the analysis despite the significant adjusted quantile test.'
## Post 0.5.0, there are no test rejections; instead we get the warning 'In getSimulations.merMod(fittedModel, nsim = n, simulateREs = simulateREs,  :
##  Model was fit with prior weights. These will be ignored in the simulation. See ?getSimulations for details.'
## (is this a false positive?)
## 
simulationOutput <- simulateResiduals(fittedModel = gm1)
plot(simulationOutput)

## ----loadbatch,echo=FALSE------------------------------------------
cbpp_batch_vars <- load(system.file("vignette_data", "cbpp_batch.rda", package = "lme4"))
contr_batch_vars <- load(system.file("vignette_data", "Contraception_batch.rda", package = "lme4"))

## ----cbppConfidence,echo=FALSE-------------------------------------
des_ord <- c("sd_(Intercept)|herd", "sd_(Intercept)|obs",
             "avg_size", "treatmentUnknown", "treatmentComplete")
combCI <- subset(cbpp_combCI,var!="(Intercept)" & !grepl("^period",var))
combCI <- transform(combCI,  var = factor(var, levels = rev(des_ord)))
combCI <- transform(combCI,
            vartype = factor(ifelse(grepl("^sd", var), "random effects", "fixed effects"))
)                    

## ----cbppcompplot,fig.cap="CBPP example: comparison of point and confidence interval estimation for different methods. Wald CIs are missing for random-effects parameters when the fitted model is singular.",fig.scap="CBPP comparison",echo=FALSE,fig.width=7,fig.height=5,warning=FALSE----
mnames <- cbpp_df_name$mnames
pd <- position_dodge(width=0.6)
ggplot(combCI, aes(var, est, colour=type, shape=model)) +
  geom_pointrange(aes(ymin=lwr, ymax=upr),
                  position=pd) +
  labs(x="", y="Estimate (log-odds of seropositivity)") +
  geom_hline(yintercept=0, lty=2) +
  coord_flip() +
  scale_colour_brewer(palette="Dark2", guide = revguide) +
  scale_shape(guide=revguide, labels = mnames) +
  facet_wrap(~ vartype, ncol = 1, scale = "free")

## ----allfit_cbpp1,message=FALSE,warning=FALSE----------------------
gm_all <- allFit(gm1)

## ----allfit_cbpp2--------------------------------------------------
ss <- summary(gm_all)
ss$sdcor

## ----covar_cbpp----------------------------------------------------
gm.ar1 <- glmer(incidence/size ~ ar1(1 + herd | period),
                family = binomial,
                data = cbpp, weights = size)
print(VarCorr(gm.ar1))

## ----loadContraception, echo=FALSE---------------------------------
library(mlmRev)
data(Contraception)

## ----graphContraception,echo=FALSE,fig.cap="Contraception example: proportion of contraceptive use by centered age, number of living children (line type), and urban/rural residence (facet). Curves fitted using generalized additive models with cubic spline smoothing. Density plots along bottom and top margins show the age distributions of women not using contraception (bottom) and using contraception (top)."----
Contraception <- transform(Contraception, 
                        facet_urban = ifelse(urban=="Y","Urban","Rural"))
gg0 <- ggplot(Contraception) +
  geom_smooth(aes(age, ifelse(use == "Y",1,0), colour = livch, fill = livch,
                  linetype = livch),
                method = "gam", alpha = 0.1,
                method.args = list(gamma = 0.6),
                formula = y ~ s(x, bs = "cs")) +
    facet_wrap(~facet_urban) +
    scale_x_continuous("Centered age") + 
  scale_y_continuous("Proportion", limits = c(0, 1), expand = c(0,0)) +
  scale_linetype("Number\nof living\nchildren") +
  scale_colour_brewer("Number\nof living\nchildren", palette="Dark2") +
  scale_fill_brewer("Number\nof living\nchildren", palette="Dark2",
                    guide = guide_legend(override.aes = list(alpha = 0.1))) +
  ## wider key to see line types:
  ## https://stackoverflow.com/a/7624378/190277
  theme(legend.key.width = unit(3, "line"))

## add marginal density ribbons
gg0 + geom_density(
        data = subset(Contraception, use == "N"),
        aes(x = age, y = after_stat(density), fill = livch),
        alpha = 0.3, colour = NA) +
  geom_ribbon(
    data = subset(Contraception, use == "Y"),
    stat = "density",
    aes(
      x = age,  
      ymin = 1 - after_stat(density) * 0.5,
      ymax = 1,
      fill = livch
    ),
    alpha = 0.3, colour = NA
  )


## ----ch,echo=FALSE-------------------------------------------------
Contraception <- transform(Contraception,
   ch = factor(livch != 0, labels = c("N","Y")),
   age_s = age/(2*sd(age)))

## ----cm1,message=FALSE---------------------------------------------
cm1 <- glmer(use ~ age_s + I(age_s^2) + urban + livch + (1|district), 
                           Contraception, binomial)
## switch from livch (ordinal) to ch (binary)
cm2 <- update(cm1, . ~ . - livch + ch)
## add age by children interaction
cm3 <- update(cm2, . ~ . + age_s:ch)
## allow urban effect to vary across districts (correlated)
cm4 <- update(cm3, . ~ . - (1|district) + (1+urban|district))
## compound symmetric/nested formulation
cm5 <- update(cm3, . ~ . - (1|district) + (1 | district/urban))
## as above but drop district effect
cm6 <- update(cm3, . ~ . - (1|district) + (1 | district:urban))

## ----anovaContraception, echo = FALSE------------------------------
## copy of bbmle::AICtab
AICtab <- function(..., mnames) {
  aic_df <- do.call(AIC, list(...))
  LLvec <- sapply(list(...), function(x) c(logLik(x)))
  rownames(aic_df) <- mnames
  aic_df <- transform(aic_df,
                        Δnegloglik = -LLvec - min(-LLvec),
                        ΔAIC = AIC - min(AIC))
  aic_df <- subset(aic_df, select = -AIC)
  aic_df <- aic_df[order(aic_df$ΔAIC),]
  aic_df
}

mod_list <- c(cm1, cm2, cm3, cm4, cm5, cm6)
op <- options(digits = 3)
mnamevec <- c("int_child    + age  + (1 | district)",
              "binary_child + age  + (1 | district)",
                "binary_child × age + (1 | district)",
                "binary_child × age + (1 + urban | district)",
                "binary_child × age + (1 | district/urban)",
                "binary_child × age + (1 | district:urban)")
aictab <- do.call(AICtab, c(mod_list, list(mnames = mnamevec)))

## ----aictab, echo  = FALSE, results = "asis"-----------------------
knitr::kable(aictab, digits = 3)

## ----contr-predplot, warning = FALSE, fig.cap="Predictions for contraception fit (\\code{(1|district/urban)} model). Heavy lines and ribbons show population-level predictions; light lines show district-level predictions.", echo = FALSE----
agevec <- seq(-15, 20)
pframe <- with(Contraception, expand.grid(age = agevec, urban = levels(urban), ch = levels(ch)))
pframe <- transform(pframe, age_s = age/(2*sd(Contraception$age)),
                    facet_urban = ifelse(urban=="Y","Urban","Rural"))
pred  <- predict(cm5, newdata = pframe, se.fit = TRUE, re.form = NA)
pframe$use <- plogis(pred$fit)
pframe$lwr <- plogis(pred$fit-1.96*pred$se.fit)
pframe$upr <- plogis(pred$fit+1.96*pred$se.fit)
pframe2 <- with(Contraception, expand.grid(age = agevec, urban = levels(urban), ch = levels(ch),
                 district = levels(district)))
pframe2 <- transform(pframe2, age_s = age/(2*sd(Contraception$age)),
            facet_urban = ifelse(urban=="Y","Urban","Rural"),
            dist_urb = paste(urban, district, sep = ":"))
c_urb <- unique(with(Contraception, paste(urban, district, sep = ":")))
pframe2 <- subset(pframe2, dist_urb %in% c_urb)
pred2  <- predict(cm5, newdata = pframe2, re.form = NULL)
pframe2$use <- plogis(pred2)
pframe2$ch <- factor(pframe2$ch,
                     levels = c("N", "Y"),
                     labels = c("no", "yes"))
pframe$ch <- factor(pframe$ch,
                     levels = c("N", "Y"),
                     labels = c("no", "yes"))

ggplot(pframe, aes(age)) + 
  geom_line(aes(y = use, colour = ch)) +
  geom_ribbon(aes(ymin = lwr, ymax = upr, fill = ch), color = NA, alpha = 0.3) +
  facet_wrap(~facet_urban) +
  scale_x_continuous("Centered age") + 
  scale_y_continuous("Proportion", limits = c(0, 1), expand = c(0,0)) +
  scale_colour_brewer("Living\nchildren", palette="Dark2",
                      guide = guide_legend(reverse = TRUE)) +
  scale_fill_brewer("Living\nchildren", palette="Dark2",
                    guide = guide_legend(reverse = TRUE)) +
  geom_line(data = pframe2, aes(group = interaction(dist_urb, ch), colour = ch, y = use), alpha = 0.2)


## ----ContraceptionBatch,echo=FALSE---------------------------------
contr_combCI <- subset(contr_combCI, var != "(Intercept)")
combCI <- transform(contr_combCI,
    vartype = factor(ifelse(grepl("^(sd|cor)", var), "random effects", "fixed effects")),
    model = factor(model, levels = rev(levels(model)))  ## flip AND flip order of guide below
    )

## ----contracompplot,fig.cap="Contraception example: comparison of point and confidence interval estimation for different methods. (Note that the Wald CI for variation in the intercept across districts, in the \\code{(1|district/urban)} model, includes negative values.)",fig.scap="Contraception comparison",echo=FALSE,fig.width=10,fig.height=10,warning=FALSE----
ggplot(combCI, aes(var, est, colour=type, shape=model)) +
  geom_pointrange(aes(ymin=lwr, ymax=upr),
                  position=position_dodge(width=0.6)) +
  labs(x="", y="Estimate (log-odds of seropositivity)") +
  geom_hline(yintercept=0, lty=2) +
  coord_flip() +
  scale_colour_brewer(palette="Dark2", guide = revguide) +
  scale_shape(guide=revguide) +
  facet_wrap(~vartype, ncol = 1, scale = "free", space = "free_y") +
  theme(legend.position = "inside",
  legend.justification = c("left", "top"),
  legend.box = "horizontal",
      legend.background = element_rect(fill = "white", colour = "grey50"),
      #legend.margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt"),
      legend.box.margin = margin(t = 10, l = 10, unit = "pt"))

## ----cm_varcorr, echo = FALSE--------------------------------------
cc <- glmerControl(check.conv.grad = .makeCC("warning", tol = 1e-2), check.conv.hess = "ignore")
base_form <- use ~ age*ch + I(age^2) + urban
cm.diag <- glmer(update(base_form, . ~ . + diag(1 + urban|district)), Contraception, binomial, control = cc )
cm.homdiag <- glmer(update(base_form, . ~ . + diag(1 + urban|district, hom = TRUE)), Contraception, binomial, control = cc)
cm.homcs <- glmer(update(base_form, . ~ . + cs(1 + urban|district, hom = TRUE)), Contraception, binomial, control = cc)

## ----cm_cs, message = FALSE, warning = FALSE-----------------------
cm.cs <- glmer(use ~ age*ch + I(age^2) + urban + cs(1 + urban | district),
               Contraception, binomial, control = cc)

## ----cm_varcorr_view-----------------------------------------------
print(VarCorr(cm.cs))

## ----pkgs, echo=FALSE----------------------------------------------
pkglist <- c("lme4", "performance", "DHARMa", "see")
pp <- sapply(pkglist, function(x)
  sprintf("%s: %s", x, format(packageVersion(x))))
ppp <- paste(pp, collapse  = "; ")

