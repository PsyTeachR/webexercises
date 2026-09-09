#' Simulates a meta-analytic dataset
#'
#' This function simulates a meta-analytic dataset based on the random-effects
#' model. The simulated effect size is Hedges' G, an estimator of the
#' Standardized Mean Difference (Hedges, 1981; Li, Dusseldorp, & Meulman, 2017).
#' The functional form of the model can be specified, and moderators can be
#' either normally distributed or Bernoulli-distributed. See Van Lissa, in
#' preparation, for a detailed explanation of the simulation procedure.
#' @param k_train Atomic integer. The number of studies in the training dataset.
#'  Defaults to 20.
#' @param k_test Atomic integer. The number of studies in the testing dataset.
#' Defaults to 100.
#' @param mean_n Atomic integer. The mean sample size of each simulated study in
#' the meta-analytic dataset. Defaults to `40`. For each simulated study, the
#' sample size n is randomly drawn from a normal distribution with mean mean_n,
#' and sd mean_n/3.
#' @param es Atomic numeric vector. The effect size, also known as beta, used in
#'  the model statement. Defaults to `.5`.
#' @param tau2 Atomic numeric vector. The residual heterogeneity. For a range of
#'  realistic values encountered in psychological research, see Van Erp,
#'  Verhagen, Grasman, & Wagenmakers, 2017. Defaults to `0.04`.
#' @param alpha Vector of slant parameters, passed to [sn::rsn].
#' @param moderators Atomic integer. The number of moderators to simulate for
#' each study. Make sure that the number of moderators to be simulated is at
#' least as large as the number of moderators referred to in the model
#' parameter. Internally, the matrix of moderators is referred to as `"x"`.
#' Defaults to 5.
#' @param distribution Atomic character. The distribution of the moderators.
#' Can be set to either `"normal"` or `"bernoulli"`. Defaults to `"normal"`.
#' @param model Expression. An expression to specify the model from which to
#' simulate the mean true effect size, mu. This formula may use the terms `"es"`
#' (referring to the es parameter of the call to simulate_smd), and `"x\[, \]"`
#' (referring to the matrix of moderators, x). Thus, to specify that the mean
#' effect size, mu, is a function of the effect size and the first moderator,
#' one would pass the value \code{model = "es * x\[ , 1\]"}.
#' Defaults to `"es * x\[ , 1\]"`.
#' @return List of length 4. The "training" element of this list is a data.frame
#' with k_train rows. The columns are the variance of the effect size, vi; the
#' effect size, yi, and the moderators, X. The "testing" element of this list is
#' a data.frame with k_test rows. The columns are the effect size, yi, and the
#' moderators, X. The "housekeeping" element of this list is a data.frame with
#' k_train + k_test rows. The columns are n, the sample size n for each
#' simulated study; mu_i, the mean true effect size for each simulated study;
#' and theta_i, the true effect size for each simulated study.
#' @export
#' @examples
#' set.seed(8)
#' simulate_smd()
#' simulate_smd(k_train = 50, distribution = "bernoulli")
#' simulate_smd(distribution = "bernoulli", model = "es * x[ ,1] * x[ ,2]")
#' @importFrom stats rbinom rnorm rt
#' @importFrom sn rsn
simulate_smd <- function(k_train = 20, k_test = 100, mean_n = 40, es = .5,
                         tau2 = 0.04, alpha = 0, moderators = 5, distribution = "normal",
                         model = "es * x[, 1]")
{
  # Make label for training and test datasets
  training <- c(rep(1, k_train), rep(0, k_test))

  # Randomly determine n from a normal distribution with mean
  # mean_n and sd mean_n/3
  n <- rnorm(length(training), mean = mean_n, sd = mean_n/3)
  # Round to even number
  n <- ceiling(n) - ceiling(n)%%2
  # Truncate n so the lowest value can be 8; cases where n=2 will result
  # in errors
  n[n < 8] <- 8

  # Generate moderator matrix x:
  if(distribution == "normal") x <- matrix(rnorm(length(n) * moderators), ncol = moderators)
  if(distribution == "bernoulli") x <- matrix(rbinom((length(n) * moderators), 1, .5), ncol = moderators)
  if(!(distribution %in% c("normal", "bernoulli"))) stop(paste0(distribution, "is not a valid distribution for simulate_smd"))

  # Sample true effect sizes theta.i from a normal distribution with mean
  # mu, and variance tau2, where mu is the average
  # population effect size. The value of mu depends on the values of the
  # moderators and the true model mu <- eval(model)
  model <- parse(text = model)
  mu <- eval(model)

  # theta.i: true effect size of study i
  theta.i <- mu + rsn(n = length(n), xi = 0, omega = sqrt(tau2), alpha = alpha)

  # Then the observed effect size yi is sampled from a non-central
  # t-distribution under the assumption that the treatment group and
  # control group are both the same size
  p_ntk <- 0.5  #Percentage of cases in the treatment group
  ntk <- p_ntk * n  #n in the treatment group for study i
  nck <- (1 - p_ntk) * n  #n in the control group for study i
  df <- n - 2  #degrees of freedom
  j <- 1 - 3/(4 * df - 1)  #correction for bias
  nk <- (ntk * nck)/(ntk + nck)
  ncp <- theta.i * sqrt(nk)  #Non-centrality parameter

  # Standardized mean difference drawn from a non-central t-distribution
  SMD <- mapply(FUN = rt, n = 1, df = df, ncp = ncp)

  # yi is Hedges' g for study i
  yi <- SMD/((j^-1) * (nk^0.5))

  # Calculate the variance of the effect size
  vi <- j^2 * (((ntk + nck)/(ntk * nck)) + ((yi/j)^2/(2 * (ntk + nck))))

  # Dersimonian and Laird estimate of tau2
  Wi <- 1/vi[1:k_train]
  tau2_est <- max(0, (sum(Wi * (yi[1:k_train] - (sum(Wi * yi[1:k_train])/sum(Wi)))^2) -
                        (k_train - 1))/(sum(Wi) - (sum(Wi^2)/sum(Wi))))

  data <- data.frame(training, vi, yi, x)

  list(training = subset(data, training == 1, -1), testing = subset(data,
                                                                    training == 0, -c(1, 2)), housekeeping = data.frame(n = n, mu_i = mu, theta_i = theta.i),
       tau2_est = tau2_est)
}
