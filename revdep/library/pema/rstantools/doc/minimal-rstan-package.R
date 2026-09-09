params <-
list(EVAL = FALSE)

## ----SETTINGS-knitr, include=FALSE--------------------------------------------
stopifnot(require(knitr))
opts_chunk$set(
  comment=NA,
  eval = if (isTRUE(exists("params"))) params$EVAL else FALSE
)
td <- tempdir()
PATH <- file.path(td, "rstanlm")
if(dir.exists(PATH)) {
  unlink(PATH, recursive = TRUE, force = TRUE)
}

## ----rstan_create_package, eval=FALSE-----------------------------------------
# library("rstantools")
# rstan_create_package(path = 'rstanlm')

## ----rstan_create_package-eval, echo=FALSE,warning=FALSE----------------------
# library("rstantools")
# rstan_create_package(path = PATH, rstudio=FALSE, open=FALSE)

## ----eval=FALSE---------------------------------------------------------------
# setwd("rstanlm")
# list.files(all.files = TRUE)

## ----echo=FALSE---------------------------------------------------------------
# list.files(PATH, all.files = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# file.show("DESCRIPTION")

## ----echo=FALSE---------------------------------------------------------------
# DES <- readLines(file.path(PATH, "DESCRIPTION"))
# cat(DES, sep = "\n")

## ----eval=FALSE---------------------------------------------------------------
# file.show("Read-and-delete-me")

## ----echo=FALSE---------------------------------------------------------------
# cat(readLines(file.path(PATH, "Read-and-delete-me")), sep = "\n")

## ----eval=FALSE---------------------------------------------------------------
# file.remove('Read-and-delete-me')

## ----echo=FALSE---------------------------------------------------------------
# file.remove(file.path(PATH, 'Read-and-delete-me'))

## ----include=FALSE------------------------------------------------------------
# stan_prog <- "
# data {
#   int<lower=1> N;
#   vector[N] x;
#   vector[N] y;
# }
# parameters {
#   real intercept;
#   real beta;
#   real<lower=0> sigma;
# }
# model {
#   // ... priors, etc.
# 
#   y ~ normal(intercept + beta * x, sigma);
# }
# "
# writeLines(stan_prog, con = file.path(PATH, "inst", "stan", "lm.stan"))

## ----eval=FALSE---------------------------------------------------------------
# # Save this file as `R/lm_stan.R`
# 
# #' Bayesian linear regression with Stan
# #'
# #' @export
# #' @param x Numeric vector of input values.
# #' @param y Numeric vector of output values.
# #' @param ... Arguments passed to `rstan::sampling` (e.g. iter, chains).
# #' @return An object of class `stanfit` returned by `rstan::sampling`
# #'
# lm_stan <- function(x, y, ...) {
#   standata <- list(x = x, y = y, N = length(y))
#   out <- rstan::sampling(stanmodels$lm, data = standata, ...)
#   return(out)
# }
# 

## ----include=FALSE------------------------------------------------------------
# Rcode <- "
# #' Bayesian linear regression with Stan
# #'
# #' @export
# #' @param x Numeric vector of input values.
# #' @param y Numeric vector of output values.
# #' @param ... Arguments passed to `rstan::sampling`.
# #' @return An object of class `stanfit` returned by `rstan::sampling`
# lm_stan <- function(x, y, ...) {
#   out <- rstan::sampling(stanmodels$lm, data=list(x=x, y=y, N=length(y)), ...)
#   return(out)
# }
# "
# writeLines(Rcode, con = file.path(PATH, "R", "lm_stan.R"))

## ----eval=FALSE---------------------------------------------------------------
# file.show(file.path("R", "rstanlm-package.R"))

## ----echo=FALSE---------------------------------------------------------------
# cat(readLines(file.path(PATH, "R", "rstanlm-package.R")), sep = "\n")

## ----eval = FALSE-------------------------------------------------------------
# roxygen2::roxygenize(load_code = roxygen2::load_source)
# rstantools::rstan_config()

## ----echo=FALSE, results="hide"-----------------------------------------------
# roxygen2::roxygenize(PATH, load_code = roxygen2::load_source)
# rstan_config(PATH)

## ----eval=FALSE---------------------------------------------------------------
# # using ../rstanlm because already inside the rstanlm directory
# install.packages("../rstanlm", repos = NULL, type = "source")

## ----echo=FALSE---------------------------------------------------------------
# install.packages(PATH, repos = NULL, type = "source")

## -----------------------------------------------------------------------------
# library(rstanlm)
# fit <- lm_stan(y = rnorm(10), x = rnorm(10),
#                # arguments passed to sampling
#                iter = 2000, refresh = 500)
# print(fit)

## ----echo=FALSE---------------------------------------------------------------
# unlink(PATH, recursive = TRUE, force = TRUE)

