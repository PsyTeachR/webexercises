## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  echo = TRUE,
  eval = FALSE,
  comment = "#>"
)
options(digits=2)
run_everything = FALSE

## ----eval = FALSE, echo = TRUE------------------------------------------------
# library(pema)
# library(tidySEM)
# library(ggplot2)
# options(mc.cores = 4)

## ----eval = TRUE, echo = FALSE------------------------------------------------
library(pema)
library(ggplot2)
options(mc.cores = 4)
data("bonapersona")

## ----eval = run_everything, echo = FALSE--------------------------------------
# descs <- tidySEM::descriptives(bonapersona)[, c("name", "type", "n", "unique", "mean", "sd", "v")]
# saveRDS(descs, "descs.RData")

## ----data, eval = FALSE-------------------------------------------------------
# descriptives(bonapersona)[, c("name", "type", "n", "unique", "mean", "sd", "v")]

## ----echo = FALSE, eval = TRUE------------------------------------------------
descs <- readRDS("descs.RData")
descs

## -----------------------------------------------------------------------------
# bonapersona$ageWeek[is.na(bonapersona$ageWeek)] <- median(bonapersona$ageWeek, na.rm = TRUE)

## -----------------------------------------------------------------------------
# datsel <- bonapersona[ , c("yi", "vi", "author", "mTimeLength", "year", "model", "ageWeek", "strainGrouped", "bias", "species", "domain", "sex")]

## -----------------------------------------------------------------------------
# dat2l <- datsel
# dat2l[["author"]] <- NULL

## ----echo = TRUE, eval = F----------------------------------------------------
# fit_lasso <- brma(yi ~ .,
#                   data = dat2l,
#                   vi = "vi",
#                   method = "lasso",
#                   prior = c(df = 1, scale = 1),
#                   mute_stan = FALSE)

## ----echo = FALSE, eval = TRUE------------------------------------------------
if(run_everything){
  bonapersona$ageWeek[is.na(bonapersona$ageWeek)] <- median(bonapersona$ageWeek, na.rm = TRUE)
  datsel <- bonapersona[ , c("yi", "vi", "author", "mTimeLength", "year", "model", "ageWeek", "strainGrouped", "bias", "species", "domain", "sex")]
  dat2l <- datsel
  dat2l[["author"]] <- NULL
  fit_lasso <- brma(yi ~ .,
                    data = dat2l,
                    vi = "vi",
                    method = "lasso",
                    prior = c(df = 1, scale = 1),
                    mute_stan = FALSE)
  saveRDS(fit_lasso, "fitlasso.RData")
  sum <- summary(fit_lasso)
  saveRDS(sum$coefficients[, c("mean", "sd", "2.5%", "97.5%", "n_eff", "Rhat")], "sum.RData")
  saveRDS(I2(fit_lasso), "i2.RData")
}
sums <- readRDS("sum.RData")
i2s <- readRDS("i2.RData")

## ----eval = F-----------------------------------------------------------------
# sum <- summary(fit_lasso)
# sum$coefficients[, c("mean", "sd", "2.5%", "97.5%", "n_eff", "Rhat")]

## ----eval = TRUE, echo = FALSE------------------------------------------------
sums

## -----------------------------------------------------------------------------
# I2(fit_lasso)

## ----echo = FALSE, eval = TRUE------------------------------------------------
i2s

## ----hs, echo = TRUE, eval = F------------------------------------------------
# # use the default settings
# fit_hs1 <- brma(yi ~ .,
#                 data = dat2l,
#                 vi = "vi",
#                 method = "hs",
#                 prior = c(df = 1, df_global = 1, df_slab = 4, scale_global = 1, scale_slab = 1, relevant_pars = NULL),
#                 mute_stan = FALSE)
# 
# # reduce the global scale
# fit_hs2 <- brma(yi ~ .,
#                 data = dat2l,
#                 vi = "vi",
#                 method = "hs",
#                 prior = c(df = 1, df_global = 1, df_slab = 4, scale_global = 0.1, scale_slab = 1, relevant_pars = NULL),
#                 mute_stan = FALSE)
# 
# # increase the scale of the slab
# fit_hs3 <- brma(yi ~ .,
#                 data = dat2l,
#                 vi = "vi",
#                 method = "hs",
#                 prior = c(df = 1, df_global = 1, df_slab = 4, scale_global = 1, scale_slab = 5, relevant_pars = NULL),
#                 mute_stan = FALSE)
# 

## ----echo = FALSE, eval = TRUE------------------------------------------------
if(run_everything){
  # use the default settings
  fit_hs1 <- brma(yi ~ .,
                  data = dat2l,
                  vi = "vi",
                  method = "hs",
                  prior = c(df = 1, df_global = 1, df_slab = 4, scale_global = 1, scale_slab = 1, relevant_pars = NULL),
                  mute_stan = FALSE)
  
  # reduce the global scale
  fit_hs2 <- brma(yi ~ .,
                  data = dat2l,
                  vi = "vi",
                  method = "hs",
                  prior = c(df = 1, df_global = 1, df_slab = 4, scale_global = 0.1, scale_slab = 1, relevant_pars = NULL),
                  mute_stan = FALSE)
  
  # increase the scale of the slab
  fit_hs3 <- brma(yi ~ .,
                  data = dat2l,
                  vi = "vi",
                  method = "hs",
                  prior = c(df = 1, df_global = 1, df_slab = 4, scale_global = 1, scale_slab = 5, relevant_pars = NULL),
                  mute_stan = FALSE)
  saveRDS(fit_hs1, "fit_hs1.RData")
  saveRDS(fit_hs2, "fit_hs2.RData")
  saveRDS(fit_hs3, "fit_hs3.RData")
  fit_hs1 <- readRDS("fit_hs1.RData")
fit_hs2 <- readRDS("fit_hs2.RData")
fit_hs3 <- readRDS("fit_hs3.RData")
}


## ----eval = FALSE, echo = TRUE------------------------------------------------
# make_plotdat <- function(fit, prior){
#   plotdat <- data.frame(fit$coefficients)
#   plotdat$par <- rownames(plotdat)
#   plotdat$Prior <- prior
#   return(plotdat)
# }
# 
# df0 <- make_plotdat(fit_lasso, prior = "lasso")
# df1 <- make_plotdat(fit_hs1, prior = "hs default")
# df2 <- make_plotdat(fit_hs2, prior = "hs reduced global scale")
# df3 <- make_plotdat(fit_hs3, prior = "hs increased slab scale")
# 
# df <- rbind.data.frame(df0, df1, df2, df3)
# df <- df[!df$par %in% c("Intercept", "tau2"), ]
# pd <- 0.5
# ggplot(df, aes(x=mean, y=par, group = Prior)) +
#   geom_errorbar(aes(xmin=X2.5., xmax=X97.5., colour = Prior), width=.1, position = position_dodge(width = pd)) +
#   geom_point(aes(colour = Prior), position = position_dodge(width = pd)) +
#   geom_vline(xintercept = 0) +
#   theme_bw() + xlab("Posterior mean") + ylab("")

## ----eval = TRUE, echo = FALSE, out.width='80%'-------------------------------
# make_plotdat <- function(fit, prior){
#   plotdat <- data.frame(fit$coefficients)
#   plotdat$par <- rownames(plotdat)
#   plotdat$Prior <- prior
#   return(plotdat)
# }
# 
# df0 <- make_plotdat(fit_lasso, prior = "lasso")
# df1 <- make_plotdat(fit_hs1, prior = "hs default")
# df2 <- make_plotdat(fit_hs2, prior = "hs reduced global scale")
# df3 <- make_plotdat(fit_hs3, prior = "hs increased slab scale")
# 
# df <- rbind.data.frame(df0, df1, df2, df3)
# df <- df[!df$par %in% c("Intercept", "tau2"), ]
# pd <- 0.5
# p <- ggplot(df, aes(x=mean, y=par, group = Prior)) + 
#   geom_errorbar(aes(xmin=X2.5., xmax=X97.5., colour = Prior), width=.1, position = position_dodge(width = pd)) +
#   geom_point(aes(colour = Prior), position = position_dodge(width = pd)) +
#   geom_vline(xintercept = 0) +
#   theme_bw() + xlab("Posterior mean") + ylab("")
# ggsave("sensitivity.png", p, device = "png", width = 3, height = 1.5, dpi = 300, scale = 2.5)
knitr::include_graphics("sensitivity.png")

## ----echo = TRUE, eval = F----------------------------------------------------
# fit_3l <- brma(yi ~ .,
#                data = datsel,
#                vi = "vi",
#                study = "author",
#                method = "lasso",
#                standardize = FALSE,
#                prior = c(df = 1, scale = 1),
#                mute_stan = FALSE)

## ----eval = TRUE, echo = F----------------------------------------------------
if(run_everything){
  fit_3l <- brma(yi ~ .,
                 data = datsel,
                 vi = "vi",
                 study = "author",
                 method = "lasso",
                 prior = c(df = 1, scale = 1),
                 mute_stan = FALSE)
  saveRDS(fit_3l, "fit_3l.RData")
  fit_3l <- readRDS("fit_3l.RData")
}


## ----echo = FALSE, eval = TRUE------------------------------------------------

if(run_everything){
  moderators <- model.matrix(yi~ageWeek + strainGrouped, data = datsel)[, -1]
  scale_age <- scale(moderators[,1])
  stdz <- list(center = c(attr(scale_age, "scaled:center"), rep(0, length(levels(datsel$strainGrouped))-1)),
               scale = c(attr(scale_age, "scaled:scale"),   rep(1, length(levels(datsel$strainGrouped))-1)))
  moderators <- data.frame(datsel[c("yi", "vi", "author")], moderators)
  fit_std <- brma(yi ~ .,
                  data = moderators,
                  vi = "vi",
                  study = "author",
                  method = "lasso",
                  prior = c(df = 1, scale = 1),
                  standardize = stdz,
                  mute_stan = FALSE)
  saveRDS(fit_std, "fit_std.RData")
  fit_std <- readRDS("fit_std.RData")
}



## ----echo = TRUE, eval = FALSE------------------------------------------------
# moderators <- model.matrix(yi~ageWeek + strainGrouped, data = datsel)[, -1]
# scale_age <- scale(moderators[,1])
# stdz <- list(center = c(attr(scale_age, "scaled:center"), rep(0, length(levels(datsel$strainGrouped))-1)),
#              scale = c(attr(scale_age, "scaled:scale"),   rep(1, length(levels(datsel$strainGrouped))-1)))
# moderators <- data.frame(datsel[c("yi", "vi", "author")], moderators)
# fit_std <- brma(yi ~ .,
#                 data = moderators,
#                 vi = "vi",
#                 study = "author",
#                 method = "lasso",
#                 prior = c(df = 1, scale = 1),
#                 standardize = stdz,
#                 mute_stan = FALSE)
# 

