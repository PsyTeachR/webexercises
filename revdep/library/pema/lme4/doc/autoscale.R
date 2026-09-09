## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(lme4)

set.seed(1)
sleepstudy$var1 = runif(nrow(sleepstudy), 1e6, 1e7)

fit1 <- lmer(Reaction ~ var1 + Days + (Days | Subject), sleepstudy)

## ----fit----------------------------------------------------------------------
fit2 <- lmer(Reaction ~ var1 + Days + (Days | Subject), 
             control = lmerControl(autoscale = TRUE), sleepstudy)
all.equal(fixef(fit1), fixef(fit2))
all.equal(vcov(fit2), vcov(fit2))

## ----echo = FALSE-------------------------------------------------------------
## https://stackoverflow.com/a/67456510/190277
get_val <- function(x) as.numeric(gsub("^.*?(\\d+\\.?\\d+e?[+-]?\\d+).*$", "\\1", x))
get_tol <- function(x,y, dig=1) signif(get_val(all.equal(x, y, tolerance = 0)), dig)
ftol <- get_tol(fixef(fit1), fixef(fit2))
vtol <- get_tol(vcov(fit1), vcov(fit2))

