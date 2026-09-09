## ----setup, include = FALSE---------------------------------------------------
library(posterior)

set.seed(1234)

## ----x_rvar_rnorm-------------------------------------------------------------
x <- rvar(rnorm(4000, mean = 1, sd = 1))
x

## ----x_rvar_array-------------------------------------------------------------
n <- 4   # length of output vector
x <- rvar(array(rnorm(4000*n, mean = 1, sd = 1), dim = c(4000, n)))
x

## ----x_matrix-----------------------------------------------------------------
rows <- 4
cols <- 3
x <- rvar(array(rnorm(4000 * rows * cols, mean = 1, sd = 1), dim = c(4000, rows, cols)))
x

## ----str_draws----------------------------------------------------------------
str(draws_of(x))

## ----x_matrix_with_chains-----------------------------------------------------
iterations <- 1000
chains <- 4
rows <- 4
cols <- 3
x_array <- array(
  rnorm(iterations * chains * rows * cols, mean = 1, sd = 1),
  dim = c(iterations, chains, rows, cols)
)
x <- rvar(x_array, with_chains = TRUE)
x

## ----rvar_factor--------------------------------------------------------------
x <- rvar(sample(c("a","b","c"), 4000, prob = c(0.7, 0.2, 0.1), replace = TRUE))
x

## ----rvar_ordered-------------------------------------------------------------
x <- rvar_ordered(sample(c("a","b","c"), 4000, prob = c(0.7, 0.2, 0.1), replace = TRUE))
x

## ----x_lte_b------------------------------------------------------------------
x <= "b"

## ----x_in_ac------------------------------------------------------------------
x %in% c("a", "c")

## ----draws_rvars--------------------------------------------------------------
d <- draws_rvars(x = x, y = rvar(rnorm(iterations * chains), nchains = 4))
d

## ----post---------------------------------------------------------------------
post <- as_draws_rvars(example_draws("multi_normal"))
post

## ----variables_draws_rvars----------------------------------------------------
variables(post)

## ----variables_draws_list-----------------------------------------------------
variables(as_draws_list(post))

## ----mu_plus_1----------------------------------------------------------------
mu <- post$mu
Sigma <- post$Sigma

mu + 1

## ----matrix_mult--------------------------------------------------------------
Sigma %**% diag(1:3)

## ----mu-----------------------------------------------------------------------
mu

## ----E_mu---------------------------------------------------------------------
E(mu)

## ----Pr-----------------------------------------------------------------------
Pr(mu > 0)

## ----rvar_mean_mu-------------------------------------------------------------
rvar_mean(mu)

## ----mean_mu------------------------------------------------------------------
mean(mu)

## ----summarise_draws_mu_mean--------------------------------------------------
summarise_draws(mu, mean)

## ----const--------------------------------------------------------------------
const <- as_rvar(1:3)
const

## ----mu_plus_const------------------------------------------------------------
mu + const

## ----rfun_defs----------------------------------------------------------------
rvar_norm <- rfun(rnorm)
rvar_gamma <- rfun(rgamma)

## ----rfun_ex------------------------------------------------------------------
mu <- rvar_norm(4, mean = 1:4, sd = 1)
sigma <- rvar_gamma(1, shape = 1, rate = 1)
x <- rvar_norm(4, mu, sigma)
x

## ----mu_rdo-------------------------------------------------------------------
mu <- rdo(rnorm(4, mean = 1:4, sd = 1))
mu

## ----mu_rdo_ndraws------------------------------------------------------------
mu <- rdo(rnorm(4, mean = 1:4, sd = 1), ndraws = 1000)
mu

## ----rdo_ex-------------------------------------------------------------------
mu <- rdo(rnorm(4, mean = 1:4, sd = 1))
sigma <- rdo(rgamma(1, shape = 1, rate = 1))
x <- rdo(rnorm(4, mu, sigma))
x

## ----rvar_r_ex----------------------------------------------------------------
mu <- rvar_rng(rnorm, 4, mean = 1:4, sd = 1)
sigma <- rvar_rng(rgamma, 1, shape = 1, rate = 1)
x <- rvar_rng(rnorm, 4, mu, sigma)
x

## ----X_matrix-----------------------------------------------------------------
X <- rdo(rnorm(12, 1:12), dim = c(4,3))
X

## ----y_vector-----------------------------------------------------------------
y <- rdo(rnorm(3, 3:1))
y

## ----X_plus_y, error = TRUE---------------------------------------------------
try({
X + y
})

## ----mean_X_plus_y------------------------------------------------------------
mean(X) + mean(y)

## ----row_y--------------------------------------------------------------------
row_y = t(y)
row_y

## ----X_plus_row_y-------------------------------------------------------------
X + row_y

## -----------------------------------------------------------------------------
component = rvar_rng(rnorm, 2, mean = c(1, 5))
component

## -----------------------------------------------------------------------------
i = rvar_rng(rbinom, 1, size = 1, p = 0.75) + 1L
i

## -----------------------------------------------------------------------------
mixture = component[[1]]
mixture[i == 2] = component[[2]][i == 2]
mixture

## ----mixture, eval = requireNamespace("ggplot2", quietly = TRUE) && requireNamespace("ggdist", quietly = TRUE)----
library(ggplot2)

ggplot() + ggdist::stat_slab(aes(xdist = mixture))

## -----------------------------------------------------------------------------
x = rvar_ifelse(i == 1, component[[1]], component[[2]])
x

## -----------------------------------------------------------------------------
x = component[[i]]
x

## ----multidim_array-----------------------------------------------------------
set.seed(3456)
x <- rvar_rng(rnorm, 24, mean = 1:24)
dim(x) <- c(2,3,4)
x

## ----apply--------------------------------------------------------------------
apply(x, c(1,2), length)

## ----rvar_apply_one_dim-------------------------------------------------------
rvar_apply(x, 1, rvar_mean)

## ----rvar_apply_multi_dim-----------------------------------------------------
rvar_apply(x, c(2,3), rvar_mean)

## ----eight_schools_parcoord, fig.width = 6, fig.height = 4--------------------
eight_schools <- as_draws_rvars(example_draws())

plot(1, type = "n",
  xlim = c(1, length(eight_schools$theta)),
  ylim = range(range(eight_schools$theta)),
  xlab = "school", ylab = "theta"
)

# use for_each_draw() to make a parallel coordinates plot of all draws
# of eight_schools$theta
for_each_draw(eight_schools, {
  lines(seq_along(theta), theta, col = rgb(1, 0, 0, 0.05))
})

# add means and 90% intervals
lines(seq_along(eight_schools$theta), mean(eight_schools$theta))
with(summarise_draws(eight_schools$theta), 
  segments(seq_along(eight_schools$theta), y0 = q5, y1 = q95)
)

## ----data_frame_with_y--------------------------------------------------------
df <- data.frame(group = c("a","b","c","d"), mu)
df

## ----data_frame_plot, eval = requireNamespace("ggplot2", quietly = TRUE) && requireNamespace("ggdist", quietly = TRUE)----
library(ggplot2)
library(ggdist)

ggplot(df) +
  stat_halfeye(aes(y = group, xdist = mu))

