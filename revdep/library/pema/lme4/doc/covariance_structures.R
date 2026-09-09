## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----cs-fit-------------------------------------------------------------------
library(lme4)
fm1.cs <- lmer(Reaction ~ Days + cs(1 + Days | Subject), sleepstudy)

## ----getReCovs----------------------------------------------------------------
print(fm1.cs_cov <- getReCovs(fm1.cs))

## ----getInfo------------------------------------------------------------------
getME(fm1.cs, "par")
getME(fm1.cs, "theta")

## ----lambda-mat---------------------------------------------------------------
library(Matrix)
image(getME(fm1.cs, "Lambda"))

## ----varcorr------------------------------------------------------------------
vc_mat <- VarCorr(fm1.cs)
vc_mat$Subject

