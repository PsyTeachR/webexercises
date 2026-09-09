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
  real horseshoe(real z, real lambda, real tau, real c2) {
    real lambda2 = square(lambda);
    real lambda_tilde = sqrt(c2 * lambda2 ./ (c2 + tau^2 * lambda2));
    return z .* lambda_tilde * tau;
  }
}
data {
  real<lower=0> df;  // local degrees of freedom
  real<lower=0> df_global;  // global degrees of freedom
  real<lower=0> df_slab;  // slab degrees of freedom
  real<lower=0> scale_global;  // global prior scale
  real<lower=0> scale_slab;  // slab prior scale
}
parameters {
  // local parameters for horseshoe prior
  real zb;
  real hs_local;
  real<lower=0> hs_global;  // global shrinkage parameters
  real<lower=0> hs_slab;  // slab regularization parameter
}
transformed parameters {
  real b;  // population-level effects
  b = horseshoe(zb, hs_local, hs_global, scale_slab^2 * hs_slab);
}
model {
  // priors including constants
  target += std_normal_lpdf(zb);
  target += student_t_lpdf(hs_local | df, 0, 1)
    - log(0.5);
  target += student_t_lpdf(hs_global | df_global, 0, scale_global)
    - 1 * log(0.5);
  target += inv_gamma_lpdf(hs_slab | 0.5 * df_slab, 0.5 * df_slab);
}
