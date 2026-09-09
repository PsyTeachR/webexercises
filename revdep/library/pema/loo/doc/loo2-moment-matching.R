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
  for (n in 1:N) {
    log_lik[n] = poisson_lpmf(y[n] | exp(x[n] * beta + intercept + offset_[n]));
  }
}
"

## ----setup, message=FALSE-----------------------------------------------------
library("rstan")
library("loo")
seed <- 9547
set.seed(seed)

## ----modelfit, message=FALSE--------------------------------------------------
# Prepare data
data(roaches, package = "rstanarm")
roaches$roach1 <- sqrt(roaches$roach1)
y <- roaches$y
x <- roaches[, c("roach1", "treatment", "senior")]
offset <- log(roaches[, "exposure2"])
n <- dim(x)[1]
k <- dim(x)[2]

standata <- list(
  N = n,
  K = k,
  x = as.matrix(x),
  y = y,
  offset_ = offset,
  beta_prior_scale = 2.5,
  alpha_prior_scale = 5.0
)

# Compile
stanmodel <- stan_model(model_code = stancode)

# Fit model
fit <- sampling(stanmodel, data = standata, seed = seed, refresh = 0)
print(fit, pars = "beta")

## ----loo1---------------------------------------------------------------------
loo1 <- loo(fit)
loo1

## ----loo_moment_match---------------------------------------------------------
# available in rstan >= 2.21
loo2 <- loo(fit, moment_match = TRUE)
loo2

## ----stanfitfuns--------------------------------------------------------------
# create a named list of draws for use with rstan methods
.rstan_relist <- function(x, skeleton) {
  out <- utils::relist(x, skeleton)
  for (i in seq_along(skeleton)) {
    dim(out[[i]]) <- dim(skeleton[[i]])
  }
  out
}

# rstan helper function to get dims of parameters right
.create_skeleton <- function(pars, dims) {
  out <- lapply(seq_along(pars), function(i) {
    len_dims <- length(dims[[i]])
    if (len_dims < 1) {
      return(0)
    }
    return(array(0, dim = dims[[i]]))
  })
  names(out) <- pars
  out
}

# extract original posterior draws
post_draws_stanfit <- function(x, ...) {
  as.matrix(x)
}

# compute a matrix of log-likelihood values for the ith observation
# matrix contains information about the number of MCMC chains
log_lik_i_stanfit <- function(x, i, parameter_name = "log_lik", ...) {
  loo::extract_log_lik(x, parameter_name, merge_chains = FALSE)[,, i]
}

# transform parameters to the unconstraint space
unconstrain_pars_stanfit <- function(x, pars, ...) {
  skeleton <- .create_skeleton(x@sim$pars_oi, x@par_dims[x@sim$pars_oi])
  upars <- apply(pars, 1, FUN = function(theta) {
    rstan::unconstrain_pars(x, .rstan_relist(theta, skeleton))
  })
  # for one parameter models
  if (is.null(dim(upars))) {
    dim(upars) <- c(1, length(upars))
  }
  t(upars)
}

# compute log_prob for each posterior draws on the unconstrained space
log_prob_upars_stanfit <- function(x, upars, ...) {
  apply(
    upars,
    1,
    rstan::log_prob,
    object = x,
    adjust_transform = TRUE,
    gradient = FALSE
  )
}

# compute log_lik values based on the unconstrained parameters
log_lik_i_upars_stanfit <- function(
  x,
  upars,
  i,
  parameter_name = "log_lik",
  ...
) {
  S <- nrow(upars)
  out <- numeric(S)
  for (s in seq_len(S)) {
    out[s] <- rstan::constrain_pars(x, upars = upars[s, ])[[parameter_name]][i]
  }
  out
}

## ----loo_moment_match.default, message=FALSE----------------------------------
loo3 <- loo::loo_moment_match.default(
  x = fit,
  loo = loo1,
  post_draws = post_draws_stanfit,
  log_lik_i = log_lik_i_stanfit,
  unconstrain_pars = unconstrain_pars_stanfit,
  log_prob_upars = log_prob_upars_stanfit,
  log_lik_i_upars = log_lik_i_upars_stanfit
)
loo3

