data {
  real<lower = 0> tausq0; // prior info global scale
  int<lower = 0> D; // total number of variables
  int<lower = 0> n; // sample size
  int<lower = 0> sigma; // estimate residual variance
  vector<lower = 0>[D] s2; // variable variances
}
parameters {
  real<lower = 0> tau; // global shrinkage parameter
  vector<lower = 0>[D] lambda; // local shrinkage parameter
}
transformed parameters{
  vector<lower = 0, upper = 1>[D] k; // shrinkage factors
  real<lower = 0> meff; // effective number of nonzero coefficients
  for(d in 1:D){
     k[d] = 1/(1 + n*sigma^-2*tau^2*s2[d]*lambda[d]^2);
  }
  meff = sum(1-k);
}
model {
  target += cauchy_lpdf(tau | 0, tausq0);
  target += cauchy_lpdf(lambda | 0, 1);
}
