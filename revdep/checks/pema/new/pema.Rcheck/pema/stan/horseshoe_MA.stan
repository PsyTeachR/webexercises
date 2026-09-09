// generated with brms 2.15.0
functions {
  /* Efficient computation of the horseshoe prior
   * see Appendix C.1 in https://projecteuclid.org/euclid.ejs/1513306866
   * Args:
   *   z: standardized population-level coefficients
   *   lambda: local shrinkage parameters
   *   tau: global shrinkage parameter
   *   c2: slap regularization parameter
   * Returns:
   *   population-level coefficients following the horseshoe prior
   */
  vector horseshoe(vector z, vector lambda, real tau, real c2) {
    int K = rows(z);
    vector[K] lambda2 = square(lambda);
    vector[K] lambda_tilde = sqrt(c2 * lambda2 ./ (c2 + tau^2 * lambda2));
    return z .* lambda_tilde * tau;
  }
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  vector<lower=0>[N] se;  // known sampling error
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  // data for the horseshoe prior
  real<lower=0> df;  // local degrees of freedom
  real<lower=0> df_global;  // global degrees of freedom
  real<lower=0> df_slab;  // slab degrees of freedom
  real<lower=0> scale_global;  // global prior scale
  real<lower=0> scale_slab;  // slab prior scale
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
  // local parameters for horseshoe prior
  vector[K] zb;
  vector<lower=0>[K] hs_local;
  real Int_c;  // temporary intercept for centered predictors
  // horseshoe shrinkage parameters
  real<lower=0> hs_global;  // global shrinkage parameters
  real<lower=0> hs_slab;  // slab regularization parameter
  vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  array[M_1] vector[N_1] z_1;  // standardized group-level effects
}
transformed parameters {
  vector[K] b;  // population-level effects
  real<lower=0> sigma = 0;  // residual SD
  vector[N_1] r_1_1;  // actual group-level effects
  // compute actual regression coefficients
  b = horseshoe(zb, hs_local, hs_global, scale_slab^2 * hs_slab);
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
  target += std_normal_lpdf(zb);
  target += student_t_lpdf(hs_local | df, 0, 1)
    - rows(hs_local) * log(0.5);
  target += student_t_lpdf(Int_c | 3, 0.1, 2.5);
  target += student_t_lpdf(hs_global | df_global, 0, scale_global)
    - 1 * log(0.5);
  target += inv_gamma_lpdf(hs_slab | 0.5 * df_slab, 0.5 * df_slab);
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
