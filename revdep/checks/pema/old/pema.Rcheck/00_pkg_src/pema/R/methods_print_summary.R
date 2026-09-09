#' @importFrom utils getFromNamespace
# .invcalc <- getFromNamespace(".invcalc", "metafor")
# .tr  <- getFromNamespace(".tr", "metafor")
#' @method summary brma
#' @export
summary.brma <- function(object, ...){
  # sums <- summary(object$fit)$summary
  # keepthese <- c(which(rownames(sums) == "Intercept"),
  #                which(startsWith(rownames(sums), "b[")),
  #                which(rownames(sums) == "sd_1[1]"))
  # sums <- sums[keepthese, , drop = FALSE]
  #
  #
  # sdpar <- match("sd_1[1]", sim$fnames_oi)
  # sim <- object$fit@sim
  # tau2 <- .extract_samples(sim, sdpar)^2
  # addrow <- sums["sd_1[1]",]
  # addrow[c("mean", "sd", "2.5%", "25%", "50%", "75%", "97.5%")] <-
  #   c(mean(tau2), sd(tau2), quantile(tau2, c(.025, .25, .5, .75,.975)))
  # addrow["se_mean"] <- addrow["sd"]/sqrt(addrow[["n_eff"]])
  # tau <- unlist(lapply(object$fit@sim$samples, `[[`, "sd_1[1]"))
  # sums <- rbind(sums, tau2 = addrow)
  # rownames(sums)[2:(ncol(object$X))] <- colnames(object$X)[-1]
  # rownames(sums)[rownames(sums) == "sd_1[1]"] <- "tau"
  # tau2 <- unname(addrow["mean"])
  # rma_res <- rma(yi = object$Y, vi = object$vi)
  # Wi <- 1 / vi
  # yi <- object$Y
  # k <- length(object$Y)
  # tau2_before <-
  #   max(0, (sum(Wi * (yi - (
  #     sum(Wi * yi) / sum(Wi)
  #   )) ^ 2) - (k - 1)) / (sum(Wi) - (sum(Wi ^ 2) / sum(Wi))))
  #
  # R2 <- max(0, 100 * (tau2_before-tau2)/tau2_before)
  # I2 <- 100 * tau2/(vt + tau2)
  # H2 <- tau2/vt + 1
  out <- object[na.omit(match(c("coefficients", "tau2", "I2", "H2", "R2", "k", "study_column", "study"), names(object)))]
  out$method <- object$fit@stan_args[[1]]$method
  out$algorithm <- object$fit@stan_args[[1]]$algorithm
  class(out) <- c("brma_sum", class(out))
  return(out)
}

.extract_samples <- function(sim, par, ...){
  unlist(lapply(1:sim$chains, function(i) {
    if (sim$warmup2[i] == 0){
      sim$samples[[i]][[par]]
    } else {
      sim$samples[[i]][[par]][-(1:sim$warmup2[i])]
    }
  }))
}


#' @method print brma
#' @export
print.brma <- function(x, ...){
  print(summary(x))
}

#' @method print brma_sum
#' @export
print.brma_sum <- function(x, digits = 2, ...){
  #res$tau2/unaccounted
  cat("BRMA ", c("three-level ", "")[is.null(x[["study_column"]])+1], "mixed-effects model (k = ", x$k, "), method: ", x$algorithm, " ", x$method, "\n", sep = "")
  taus <- x$coefficients[startsWith(rownames(x$coefficients), "tau2"), c("mean", "se_mean"), drop = FALSE]
  if(nrow(taus) == 1){
    cat("tau^2 (n = ", x$k, "): ", formatC(taus[1,1], digits = digits, format = "f"), " (SE = ", formatC(taus[1,2], digits = digits, format = "f"),")\n\n", sep = "")
  } else {
    cat("tau^2 (n = ", x$k, "): ", formatC(taus["tau2_w",1], digits = digits, format = "f"), " (SE = ", formatC(taus["tau2_w",2], digits = digits, format = "f"),")\n", sep = "")
    cat("tau^2 between ", x$study_column, " (k = ", length(unique(x$study)), "): ", formatC(taus["tau2_b",1], digits = digits, format = "f"), " (SE = ", formatC(taus["tau2_b",2], digits = digits, format = "f"),")\n\n", sep = "")
  }
  #cat("I^2 (residual heterogeneity / unaccounted variability): 15.66%
  # H^2 (unaccounted variability / sampling variability):   1.19
  # R^2 (amount of heterogeneity accounted for):            92.75%
  coefs <- x$coefficients
  pstars <- c("*", "")[as.integer(apply(coefs[, c("2.5%", "97.5%")], 1, function(x){sum(sign(x)) == 0}))+1]
  coefs <- formatC(coefs, digits = digits, format = "f")
  coefs <- cbind(coefs, pstars)
  colnames(coefs)[ncol(coefs)] <- ""
  prmatrix(coefs, quote = FALSE, right = TRUE, na.print = "")
  cat("\n*: This coefficient is significant, as the 95% credible interval excludes zero. n_eff is the effective sample size, Rhat is the potential scale reduction for multiple chains (Rhat = 1 indicates convergence).")
}

# Mixed-Effects Model (k = 48; tau^2 estimator: REML)
#
# tau^2 (estimated amount of residual heterogeneity):     0.0411 (SE = 0.0180)
# tau (square root of estimated tau^2 value):             0.2027
# I^2 (residual heterogeneity / unaccounted variability): 52.43%
# H^2 (unaccounted variability / sampling variability):   2.10
# R^2 (amount of heterogeneity accounted for):            17.73%
#
# Test for Residual Heterogeneity:
#   QE(df = 46) = 95.1352, p-val < .0001
#
# Test of Moderators (coefficient 2):
#   QM(df = 1) = 4.4841, p-val = 0.0342
#
# Model Results:
#
#   estimate      se     zval    pval    ci.lb    ci.ub
# intrcpt    0.3242  0.0665   4.8737  <.0001   0.1938   0.4546  ***
#   ni100     -0.0666  0.0315  -2.1176  0.0342  -0.1283  -0.0050    *
#
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
