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

## ----warnings=FALSE, message=FALSE--------------------------------------------
library("rstan")
library("loo")
library("matrixStats")
options(mc.cores = parallel::detectCores(), parallel=FALSE)
set.seed(24877)

## ----stancode_horseshoe-------------------------------------------------------
# Note: some syntax used in this program requires RStan >= 2.26 (or CmdStanR)
# To use an older version of RStan change the line declaring `y` to:
#    int<lower=0,upper=1> y[N];
stancode_horseshoe <- "
data {
  int <lower=0> N;
  int <lower=0> P;
  array[N] int <lower=0, upper=1> y;
  matrix [N,P] X;
  real <lower=0> scale_global;
  int <lower=0,upper=1> mixis;
}
transformed data {
  real<lower=1> nu_global=1; // degrees of freedom for the half-t priors for tau
  real<lower=1> nu_local=1;  // degrees of freedom for the half-t priors for lambdas
                             // (nu_local = 1 corresponds to the horseshoe)
  real<lower=0> slab_scale=2;// for the regularized horseshoe
  real<lower=0> slab_df=100; // for the regularized horseshoe
}
parameters {
  vector[P] z;                // for non-centered parameterization
  real <lower=0> tau;         // global shrinkage parameter
  vector <lower=0>[P] lambda; // local shrinkage parameter
  real<lower=0> caux;
}
transformed parameters {
  vector[P] beta;
  { 
    vector[P] lambda_tilde;   // 'truncated' local shrinkage parameter
    real c = slab_scale * sqrt(caux); // slab scale
    lambda_tilde = sqrt( c^2 * square(lambda) ./ (c^2 + tau^2*square(lambda)));
    beta = z .* lambda_tilde*tau;
  }
}
model {
  vector[N] means=X*beta;
  vector[N] log_lik;
  target += std_normal_lpdf(z);
  target += student_t_lpdf(lambda | nu_local, 0, 1);
  target += student_t_lpdf(tau | nu_global, 0, scale_global);
  target += inv_gamma_lpdf(caux | 0.5*slab_df, 0.5*slab_df);
  for (n in 1:N) {
    log_lik[n]= bernoulli_logit_lpmf(y[n] | means[n]);
  }
  target += sum(log_lik);
  if (mixis) {
    target += log_sum_exp(-log_lik);
  }
}
generated quantities {
  vector[N] means=X*beta;
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = bernoulli_logit_lpmf(y[n] | means[n]);
  }
}
"

## ----results='hide', warning=FALSE, message=FALSE, error=FALSE----------------
data(voice)
y <- voice$y
X <- voice[2:length(voice)]
n <- dim(X)[1]
p <- dim(X)[2]
p0 <- 10
scale_global <- 2*p0/(p-p0)/sqrt(n-1)
standata <- list(N = n, P = p, X = as.matrix(X), y = c(y), scale_global = scale_global, mixis = 0)

## ----results='hide', warning=FALSE--------------------------------------------
chains <- 4
n_iter <- 2000
warm_iter <- 1000
stanmodel <- stan_model(model_code = stancode_horseshoe)
fit_post <- sampling(stanmodel, data = standata, chains = chains, iter = n_iter, warmup = warm_iter, refresh = 0)
loo_post <-loo(fit_post)

## -----------------------------------------------------------------------------
print(loo_post)

## ----results='hide', warnings=FALSE-------------------------------------------
standata$mixis <- 1
fit_mix <- sampling(stanmodel, data = standata, chains = chains, iter = n_iter, warmup = warm_iter, refresh = 0, pars = "log_lik")
log_lik_mix <- extract(fit_mix)$log_lik

## -----------------------------------------------------------------------------
l_common_mix <- rowLogSumExps(-log_lik_mix)
log_weights <- -log_lik_mix - l_common_mix
elpd_mixis <- logSumExp(-l_common_mix) - rowLogSumExps(t(log_weights))

## -----------------------------------------------------------------------------
data(voice_loo)
elpd_loo <- voice_loo$elpd_loo

## -----------------------------------------------------------------------------
elpd_psis <- loo_post$pointwise[,1]
print(paste("RMSE(PSIS) =",round( sqrt(mean((elpd_loo-elpd_psis)^2)) ,2)))
print(paste("RMSE(MixIS) =",round( sqrt(mean((elpd_loo-elpd_mixis)^2)) ,2)))

## -----------------------------------------------------------------------------
elpd_psis <- loo_post$pointwise[,1]
print(paste("ELPD (PSIS)=",round(sum(elpd_psis),2)))
print(paste("ELPD (MixIS)=",round(sum(elpd_mixis),2)))
print(paste("ELPD (brute force)=",round(sum(elpd_loo),2)))

