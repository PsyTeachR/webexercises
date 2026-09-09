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

## ----stancode-----------------------------------------------------------------
# Note: some syntax used in this Stan program requires RStan >= 2.26 (or CmdStanR)
# To use an older version of RStan change the line declaring `y` to: int y[N];
stancode <- "
data {
  int<lower=1> K;
  int<lower=1> N;
  matrix[N,K] x;
  array[N] int y;
  vector[N] offset_; // offset is reserved keyword in Stan so use offset_

  real beta_prior_scale;
  real alpha_prior_scale;
}
parameters {
  vector[K] beta;
  real intercept;
}
model {
  y ~ poisson(exp(x * beta + intercept + offset_));
  beta ~ normal(0,beta_prior_scale);
  intercept ~ normal(0,alpha_prior_scale);
}
generated quantities {
  vector[N] log_lik;
  for (n in 1:N)
    log_lik[n] = poisson_lpmf(y[n] | exp(x[n] * beta + intercept + offset_[n]));
}
"

## ----setup, message=FALSE-----------------------------------------------------
library("rstan")
library("loo")
seed <- 9547
set.seed(seed)

## ----modelfit-holdout, message=FALSE------------------------------------------
# Prepare data
data(roaches, package = "rstanarm")
roaches$roach1 <- sqrt(roaches$roach1)
roaches$offset <- log(roaches[,"exposure2"])
# 20% of the data goes to the test set:
roaches$test <- 0
roaches$test[sample(.2 * seq_len(nrow(roaches)))] <- 1
# data to "train" the model
data_train <- list(y = roaches$y[roaches$test == 0],
                   x = as.matrix(roaches[roaches$test == 0,
                                         c("roach1", "treatment", "senior")]),
                   N = nrow(roaches[roaches$test == 0,]),
                   K = 3,
                   offset_ = roaches$offset[roaches$test == 0],
                   beta_prior_scale = 2.5,
                   alpha_prior_scale = 5.0
                   )
# data to "test" the model
data_test <- list(y = roaches$y[roaches$test == 1],
                   x = as.matrix(roaches[roaches$test == 1,
                                         c("roach1", "treatment", "senior")]),
                   N = nrow(roaches[roaches$test == 1,]),
                   K = 3,
                   offset_ = roaches$offset[roaches$test == 1],
                   beta_prior_scale = 2.5,
                   alpha_prior_scale = 5.0
                   )

## ----fit-train----------------------------------------------------------------
# Compile
stanmodel <- stan_model(model_code = stancode)
# Fit model
fit <- sampling(stanmodel, data = data_train, seed = seed, refresh = 0)

## ----gen-test-----------------------------------------------------------------
gen_test <- gqs(stanmodel, draws = as.matrix(fit), data= data_test)
log_pd <- extract_log_lik(gen_test)

## ----elpd-holdout-------------------------------------------------------------
(elpd_holdout <- elpd(log_pd))

## ----prepare-folds, message=FALSE---------------------------------------------
# Prepare data
roaches$fold <- kfold_split_random(K = 10, N = nrow(roaches))

## -----------------------------------------------------------------------------
# Prepare a matrix with the number of post-warmup iterations by number of observations:
log_pd_kfold <- matrix(nrow = 4000, ncol = nrow(roaches))
# Loop over the folds
for(k in 1:10){
  data_train <- list(y = roaches$y[roaches$fold != k],
                   x = as.matrix(roaches[roaches$fold != k,
                                         c("roach1", "treatment", "senior")]),
                   N = nrow(roaches[roaches$fold != k,]),
                   K = 3,
                   offset_ = roaches$offset[roaches$fold != k],
                   beta_prior_scale = 2.5,
                   alpha_prior_scale = 5.0
                   )
  data_test <- list(y = roaches$y[roaches$fold == k],
                   x = as.matrix(roaches[roaches$fold == k,
                                         c("roach1", "treatment", "senior")]),
                   N = nrow(roaches[roaches$fold == k,]),
                   K = 3,
                   offset_ = roaches$offset[roaches$fold == k],
                   beta_prior_scale = 2.5,
                   alpha_prior_scale = 5.0
                   )
  fit <- sampling(stanmodel, data = data_train, seed = seed, refresh = 0)
  gen_test <- gqs(stanmodel, draws = as.matrix(fit), data= data_test)
  log_pd_kfold[, roaches$fold == k] <- extract_log_lik(gen_test)
}

## ----elpd-kfold---------------------------------------------------------------
(elpd_kfold <- elpd(log_pd_kfold))

