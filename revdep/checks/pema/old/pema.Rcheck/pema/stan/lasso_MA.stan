// generated with brms 2.15.0
functions {
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  vector<lower=0>[N] se;  // known sampling error
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  // data for the lasso prior
  real<lower=0> df;  // prior degrees of freedom
  real<lower=0> scale;  // prior scale
  // data for group-level effects of ID 1
  int<lower=1> N_1;  // number of grouping levels
  int<lower=1> M_1;  // number of coefficients per level
  array[N] int<lower=1> J_1;  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_1_1;
  int prior_only;  // should the likelihood be ignored?
  vector[K] means_X;  // column means of X before standardizing
  vector[K] sds_X;  // SDs of X before standardizing
}
parameters {
  vector[K] b;  // population-level effects
  real Int_c;  // temporary intercept for standardized predictors
  // lasso shrinkage parameter
  real<lower=0> lasso_inv_lambda;
  vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  array[M_1] vector[N_1] z_1;  // standardized group-level effects
}
transformed parameters {
  real<lower=0> sigma = 0;  // residual SD
  vector[N_1] r_1_1;  // actual group-level effects
  r_1_1 = (sd_1[1] * (z_1[1]));
}
model {
  // likelihood including constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu = Int_c + X * b;
    for (n in 1:N) {
      // add more terms to the linear predictor
      mu[n] += r_1_1[J_1[n]] * Z_1_1[n];
    }
    target += normal_lpdf(Y | mu, se);
  }
  // priors including constants
  target += double_exponential_lpdf(b | 0, scale * lasso_inv_lambda);
  target += student_t_lpdf(Int_c | 3, 0.1, 2.5);
  target += chi_square_lpdf(lasso_inv_lambda | df);
  target += student_t_lpdf(sd_1 | 3, 0, 2.5)
    - 1 * student_t_lccdf(0 | 3, 0, 2.5);
  target += std_normal_lpdf(z_1[1]);
}
generated quantities {
  // restore parameters to unstandardized scale
  real Intercept = Int_c - sum(b .* (means_X ./ sds_X));
  vector[K] betas = b ./ sds_X;  // actual group-level effects
  real tau2 = sd_1[1]^2;
}
