## ----setup, include = FALSE---------------------------------------------------
library(rstan)
knitr::opts_chunk$set(eval = .Platform$OS.type != "windows")

## ----eval = FALSE-------------------------------------------------------------
#  output <- sbc(beta_binomial, data = list(N = 10, a = 1, b = 1), M = 500, refresh = 0)

## ----include = FALSE----------------------------------------------------------
# This fakes what would happen if we actually took the time to run Stan.
N <- 10
M <- 500
pars_ <- rbeta(M, 1, 1)
y_ <- matrix(rbinom(pars_, size = N, prob = pars_), ncol = M)
post_ <- matrix(rbeta(M * 1000L, 1 + y_, 1 + N - y_), ncol = M)
ranks_ <- lapply(1:M, FUN = function(m) {
  matrix(post_[ , m] > pars_[m], ncol = 1, 
         dimnames = list(NULL, "pi"))
})
log_lik <- t(sapply(1:M, FUN = function(m) {
  c(dbinom(rep(1, y_[m]), size = 1, prob = pars_[m], log = TRUE),
    dbinom(rep(1, N - y_[m]), size = 1, prob = pars_[m], log = TRUE))
}))
sampler_params <- array(0, dim = c(1000, 6, M))
colnames(sampler_params) <- c("accept_stat__", "stepsize__", "treedepth__",   
                              "n_leapfrog__",  "divergent__",   "energy__")
output <- list(ranks = ranks_, Y = y_, pars = pars_, 
               log_lik = log_lik, sampler_params = sampler_params)
class(output) <- "sbc"

## -----------------------------------------------------------------------------
print(output)
plot(output, bins = 10) # it is best to specify the bins argument yourself

