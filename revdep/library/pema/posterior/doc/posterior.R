## ----install, eval=FALSE------------------------------------------------------
# install.packages("posterior")

## ----install_github, eval=FALSE-----------------------------------------------
# # install.packages("remotes")
# remotes::install_github("stan-dev/posterior")

## ----setup--------------------------------------------------------------------
library("posterior")

## ----example-drawss-----------------------------------------------------------
eight_schools_array <- example_draws("eight_schools")
print(eight_schools_array, max_variables = 3)

## ----draws_array-structure----------------------------------------------------
str(eight_schools_array)

## ----draws_df-----------------------------------------------------------------
eight_schools_df <- as_draws_df(eight_schools_array)
str(eight_schools_df)
print(eight_schools_df)

## ----draws_matrix-from-matrix-------------------------------------------------
x <- matrix(rnorm(50), nrow = 10, ncol = 5)
colnames(x) <- paste0("V", 1:5)
x <- as_draws_matrix(x)
print(x)

## ----draws_matrix-from-vectors------------------------------------------------
x <- draws_matrix(alpha = rnorm(50), beta = rnorm(50))
print(x)

## ----subset-df----------------------------------------------------------------
sub_df <- subset_draws(eight_schools_df, variable = "mu", chain = 1:2, iteration = 1:5)
str(sub_df)

## ----subset-array-------------------------------------------------------------
sub_arr <- subset_draws(eight_schools_array, variable = "mu", chain = 1:2, iteration = 1:5)
str(sub_arr)

## ----subset-compare, results='hold'-------------------------------------------
identical(sub_df, as_draws_df(sub_arr))
identical(as_draws_array(sub_df), sub_arr)

## ----subset-standard----------------------------------------------------------
eight_schools_array[1:5, 1:2, "mu"]

## ----mutate-------------------------------------------------------------------
x <- mutate_variables(eight_schools_df, phi = (mu + tau)^2)
x <- subset_draws(x, c("mu", "tau", "phi"))
print(x)

## ----rename-------------------------------------------------------------------
# mu is a scalar, theta is a vector
x <- rename_variables(eight_schools_df, mean = mu, alpha = theta)
variables(x)

## ----rename-element-----------------------------------------------------------
x <- rename_variables(x, a1 = `alpha[1]`)
variables(x)

## ----objects-to-bind----------------------------------------------------------
x1 <- draws_matrix(alpha = rnorm(5), beta = rnorm(5))
x2 <- draws_matrix(alpha = rnorm(5), beta = rnorm(5))
x3 <- draws_matrix(theta = rexp(5))

## ----bind-variable------------------------------------------------------------
x4 <- bind_draws(x1, x3, along = "variable")
print(x4)

## ----bind-draw----------------------------------------------------------------
x5 <- bind_draws(x1, x2, along = "draw")
print(x5)

## ----summary------------------------------------------------------------------
# summarise_draws or summarize_draws
summarise_draws(eight_schools_df)

## ----summary-with-measures----------------------------------------------------
# the function mcse_mean is provided by the posterior package
s1 <- summarise_draws(eight_schools_df, "mean", "mcse_mean") 
s2 <- summarise_draws(eight_schools_df, mean, mcse_mean) 
identical(s1, s2)
print(s1)

## ----change-summary-names-----------------------------------------------------
summarise_draws(eight_schools_df, posterior_mean = mean, posterior_sd = sd)

## ----summary-.args------------------------------------------------------------
weighted_mean <- function(x, wts) {
  sum(x * wts)/sum(wts)
}
summarise_draws(
  eight_schools_df, 
  weighted_mean, 
  .args = list(wts = rexp(ndraws(eight_schools_df)))
)

## ----standard-quantile, eval = FALSE------------------------------------------
# function(x) quantile(x, probs = c(0.4, 0.6))

## ----lambda-quantile, eval = FALSE--------------------------------------------
# # for multiple arguments `.x` and `.y` can be used, see ?rlang::as_function
# ~quantile(., probs = c(0.4, 0.6))

## ----lambda-syntax------------------------------------------------------------
summarise_draws(eight_schools_df, function(x) quantile(x, probs = c(0.4, 0.6)))

summarise_draws(eight_schools_df, ~quantile(.x, probs = c(0.4, 0.6)))

