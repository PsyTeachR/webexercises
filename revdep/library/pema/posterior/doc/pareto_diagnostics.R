## ----setup--------------------------------------------------------------------
library(posterior)
library(dplyr)
options(pillar.neg = FALSE, pillar.subtle=FALSE, pillar.sigfig=2)

## ----simulate-data-1----------------------------------------------------------
N <- 1000
phi <- 0.3
set.seed(6534)
dr <- array(data=replicate(4,as.numeric(arima.sim(n = N,
                                                list(ar = c(phi)),
                                                sd = sqrt((1-phi^2))))),
         dim=c(N,4,1)) %>%
  as_draws_df() %>%
  set_variables('xn')

## ----simulate-data-2----------------------------------------------------------
drt <- dr %>%
  mutate_variables(xt3=qt(pnorm(xn), df=3),
                   xt2_5=qt(pnorm(xn), df=2.5),
                   xt2=qt(pnorm(xn), df=2),
                   xt1_5=qt(pnorm(xn), df=1.5),
                   xt1=qt(pnorm(xn), df=1))

## ----summarise_draws----------------------------------------------------------
drt %>%
  summarise_draws()

## ----summarise_draws-mcse-----------------------------------------------------
drt %>%
  summarise_draws(mean, sd, mcse_mean, ess_bulk, ess_basic)

## ----summarise_draws-pareto_khat----------------------------------------------
drt %>%
  summarise_draws(mean, sd, mcse_mean, ess_basic, pareto_khat)

## ----pareto_smooth------------------------------------------------------------
drts <- drt %>% 
  mutate_variables(xt3_s=pareto_smooth(xt3),
                   xt2_5_s=pareto_smooth(xt2_5),
                   xt2_s=pareto_smooth(xt2),
                   xt1_5_s=pareto_smooth(xt1_5),
                   xt1_s=pareto_smooth(xt1)) %>%
  subset_draws(variable="_s", regex=TRUE)

## ----summarise_draws-pareto_khat-2--------------------------------------------
drts %>%
  summarise_draws(mean, mcse_mean, ess_basic, pareto_khat)

## ----summarise_draws-min_ss---------------------------------------------------
drt %>%
  summarise_draws(mean, mcse_mean, ess_basic,
                  pareto_khat, min_ss=pareto_min_ss)

## ----summarise_draws-conv_rate------------------------------------------------
drt %>%
  summarise_draws(mean, mcse_mean, ess_basic,
                  pareto_khat, min_ss=pareto_min_ss,
                  conv_rate=pareto_convergence_rate)

## ----summarise_draws-khat_threshold-------------------------------------------
drt %>%
  subset_draws(iteration=1:100) %>%
  summarise_draws(mean, mcse_mean, ess_basic,
                  pareto_khat, min_ss=pareto_min_ss,
                  khat_thres=pareto_khat_threshold,
                  conv_rate=pareto_convergence_rate)

## ----summarise_draws-pareto_diags---------------------------------------------
drt %>%
  mutate_variables(xt2_5_sq=xt2_5^2) %>%
  subset_draws(variable="xt2_5_sq") %>%
  summarise_draws(mean, mcse_mean,
                  pareto_diags)

