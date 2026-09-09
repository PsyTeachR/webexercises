params <-
list(EVAL = TRUE)

## ----SETTINGS-knitr, include=FALSE--------------------------------------------
stopifnot(require(knitr))
opts_chunk$set(
  comment=NA,
  eval = if (isTRUE(exists("params"))) params$EVAL else FALSE,
  dev = "png",
  dpi = 150,
  fig.asp = 0.618,
  fig.width = 5,
  out.width = "60%",
  fig.align = "center"
)

## ----setup, message=FALSE-----------------------------------------------------
library("rstan")
library("loo")
set.seed(4711)

## ----llfun_logistic-----------------------------------------------------------
# we'll add an argument log to toggle whether this is a log-likelihood or 
# likelihood function. this will be useful later in the vignette.
llfun_logistic <- function(data_i, draws, log = TRUE) {
  x_i <- as.matrix(data_i[, which(grepl(colnames(data_i), pattern = "X")), drop=FALSE])
  logit_pred <- draws %*% t(x_i)
  dbinom(x = data_i$y, size = 1, prob = 1/(1 + exp(-logit_pred)), log = log)
}

## ----eval=FALSE---------------------------------------------------------------
# # Prepare data
# url <- "http://stat.columbia.edu/~gelman/arm/examples/arsenic/wells.dat"
# wells <- read.table(url)
# wells$dist100 <- with(wells, dist / 100)
# X <- model.matrix(~ dist100 + arsenic, wells)
# standata <- list(y = wells$switch, X = X, N = nrow(X), P = ncol(X))
# 
# # Compile
# stan_mod <- stan_model("logistic.stan")
# 
# # Fit model
# fit_1 <- sampling(stan_mod, data = standata, seed = 4711)
# print(fit_1, pars = "beta")

## ----eval=FALSE---------------------------------------------------------------
# # used for draws argument to loo_i
# parameter_draws_1 <- extract(fit_1)$beta
# 
# # used for data argument to loo_i
# stan_df_1 <- as.data.frame(standata)
# 
# # compute relative efficiency (this is slow and optional but is recommended to allow
# # for adjusting PSIS effective sample size based on MCMC effective sample size)
# r_eff <- relative_eff(llfun_logistic,
#                       log = FALSE, # relative_eff wants likelihood not log-likelihood values
#                       chain_id = rep(1:4, each = 1000),
#                       data = stan_df_1,
#                       draws = parameter_draws_1,
#                       cores = 2)
# 
# loo_i(i = 1, llfun_logistic, r_eff = r_eff, data = stan_df_1, draws = parameter_draws_1)

## ----eval=FALSE---------------------------------------------------------------
# set.seed(4711)
# loo_ss_1 <-
#   loo_subsample(
#     llfun_logistic,
#     observations = 100, # take a subsample of size 100
#     cores = 2,
#     # these next objects were computed above
#     r_eff = r_eff,
#     draws = parameter_draws_1,
#     data = stan_df_1
#   )
# print(loo_ss_1)

## ----eval=FALSE---------------------------------------------------------------
# set.seed(4711)
# loo_ss_1b <-
#   update(
#     loo_ss_1,
#     observations = 200, # subsample 200 instead of 100
#     r_eff = r_eff,
#     draws = parameter_draws_1,
#     data = stan_df_1
#   )
# print(loo_ss_1b)

## ----eval=FALSE---------------------------------------------------------------
# set.seed(4711)
# loo_ss_1c <-
#   loo_subsample(
#     x = llfun_logistic,
#     r_eff = r_eff,
#     draws = parameter_draws_1,
#     data = stan_df_1,
#     observations = 100,
#     estimator = "hh_pps", # use Hansen-Hurwitz
#     loo_approximation = "lpd", # use lpd instead of plpd
#     loo_approximation_draws = 100,
#     cores = 2
#   )
# print(loo_ss_1c)

## ----eval=FALSE---------------------------------------------------------------
# fit_laplace <- optimizing(stan_mod, data = standata, draws = 2000,
#                           importance_resampling = TRUE)
# parameter_draws_laplace <- fit_laplace$theta_tilde # draws from approximate posterior
# log_p <- fit_laplace$log_p # log density of the posterior
# log_g <- fit_laplace$log_g # log density of the approximation

## ----eval=FALSE---------------------------------------------------------------
# set.seed(4711)
# loo_ap_1 <-
#   loo_approximate_posterior(
#     x = llfun_logistic,
#     draws = parameter_draws_laplace,
#     data = stan_df_1,
#     log_p = log_p,
#     log_g = log_g,
#     cores = 2
#   )
# print(loo_ap_1)

## ----eval=FALSE---------------------------------------------------------------
# set.seed(4711)
# loo_ap_ss_1 <-
#   loo_subsample(
#     x = llfun_logistic,
#     draws = parameter_draws_laplace,
#     data = stan_df_1,
#     log_p = log_p,
#     log_g = log_g,
#     observations = 100,
#     cores = 2
#   )
# print(loo_ap_ss_1)

## ----eval=FALSE---------------------------------------------------------------
# standata$X[, "arsenic"] <- log(standata$X[, "arsenic"])
# fit_2 <- sampling(stan_mod, data = standata)
# parameter_draws_2 <- extract(fit_2)$beta
# stan_df_2 <- as.data.frame(standata)
# 
# # recompute subsampling loo for first model for demonstration purposes
# 
# # compute relative efficiency (this is slow and optional but is recommended to allow
# # for adjusting PSIS effective sample size based on MCMC effective sample size)
# r_eff_1 <- relative_eff(
#   llfun_logistic,
#   log = FALSE, # relative_eff wants likelihood not log-likelihood values
#   chain_id = rep(1:4, each = 1000),
#   data = stan_df_1,
#   draws = parameter_draws_1,
#   cores = 2
# )
# 
# set.seed(4711)
# loo_ss_1 <- loo_subsample(
#   x = llfun_logistic,
#   r_eff = r_eff_1,
#   draws = parameter_draws_1,
#   data = stan_df_1,
#   observations = 200,
#   cores = 2
# )
# 
# # compute subsampling loo for a second model (with log-arsenic)
# 
# r_eff_2 <- relative_eff(
#   llfun_logistic,
#   log = FALSE, # relative_eff wants likelihood not log-likelihood values
#   chain_id = rep(1:4, each = 1000),
#   data = stan_df_2,
#   draws = parameter_draws_2,
#   cores = 2
# )
# loo_ss_2 <- loo_subsample(
#   x = llfun_logistic,
#   r_eff = r_eff_2,
#   draws = parameter_draws_2,
#   data = stan_df_2,
#   observations = 200,
#   cores = 2
# )
# 
# print(loo_ss_2)

## ----eval=FALSE---------------------------------------------------------------
# # Compare
# comp <- loo_compare(loo_ss_1, loo_ss_2)
# print(comp)

## ----eval=FALSE---------------------------------------------------------------
# loo_ss_2 <-
#   loo_subsample(
#     x = llfun_logistic,
#     r_eff = r_eff_2,
#     draws = parameter_draws_2,
#     data = stan_df_2,
#     observations = loo_ss_1,
#     cores = 2
#   )

## ----eval=FALSE---------------------------------------------------------------
# idx <- obs_idx(loo_ss_1)
# loo_ss_2 <- loo_subsample(
#   x = llfun_logistic,
#   r_eff = r_eff_2,
#   draws = parameter_draws_2,
#   data = stan_df_2,
#   observations = idx,
#   cores = 2
# )

## ----eval=FALSE---------------------------------------------------------------
# comp <- loo_compare(loo_ss_1, loo_ss_2)
# print(comp)

## ----eval=FALSE---------------------------------------------------------------
# # use loo() instead of loo_subsample() to compute full PSIS-LOO for model 2
# loo_full_2 <- loo(
#   x = llfun_logistic,
#   r_eff = r_eff_2,
#   draws = parameter_draws_2,
#   data = stan_df_2,
#   cores = 2
# )
# loo_compare(loo_ss_1, loo_full_2)

