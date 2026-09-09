data {
  real<lower=0> df;  // prior degrees of freedom
  real<lower=0> scale;  // prior scale
}
parameters {
  real b;  // population-level effects
  real<lower=0> lasso_inv_lambda;
}
model {
  // priors including constants
  target += double_exponential_lpdf(b | 0, scale * lasso_inv_lambda);
  target += chi_square_lpdf(lasso_inv_lambda | df);
}
