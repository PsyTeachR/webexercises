#' Conduct Bayesian Regularized Meta-Analysis
#'
#' This function conducts Bayesian regularized meta-regression (Van Lissa & Van
#' Erp, 2021). It uses the \code{stan} function
#' [rstan::sampling] to fit the model. A lasso or horseshoe prior is used to
#' shrink the regression coefficients of irrelevant moderators towards zero.
#' See Details.
#' @param formula An object of class `formula` (or one that can be coerced to
#' that class), see \code{\link[stats]{lm}}.
#' @param data Either a `data.frame` containing the variables in the model,
#' see \code{\link[stats]{lm}}, or a `list` of multiple imputed `data.frame`s,
#' or an object returned by \code{\link[mice]{mice}}.
#' @param vi Character. Name of the column in the \code{data} that
#' contains the variances of the effect sizes. This column will be removed from
#' the data prior to analysis. Defaults to \code{"vi"}.
#' @param study Character. Name of the column in the
#' \code{data} that contains the study id. Use this when the data includes
#' multiple effect sizes per study. This column can be a vector of integers, or
#' a factor. This column will be removed from the data prior to analysis.
#' See \code{Details} for more information about analyzing dependent data.
#' @param method Character, indicating the type of regularizing prior to use.
#' Supports one of \code{c("hs", "lasso")}, see Details. Defaults to
#' \code{"hs"}.
#' @param standardize Either a logical argument or a list. If `standardize` is
#' logical, it controls whether all predictors are standardized prior to
#' analysis or not. Parameter estimates are restored to the predictors' original
#' scale. Alternatively, users can provide a list to `standardize` to gain
#' more control over the standardization process. In this case, it is assumed
#' that the standardization has already taken place. This list must have two
#' elements: `list(center = c(mean(X1)
#' , mean(X2), mean(X...)), scale = c(sd(X1), sd(X2), sd(X...)))`. It is used
#' only to restore parameter estimates to the original scale of the predictors.
#' This is useful, e.g., to standardize continuous and dichotomous variables
#' separately. Defaults to \code{TRUE}, which is recommended so that shrinking
#' affects all parameters similarly.
#' @param prior Numeric vector, specifying the prior to use. Note that the
#' different \code{method}s require this vector to contain specific named
#' elements.
# @param iter A positive integer specifying the number of iterations for each
# chain (including warmup). Defaults to 2000.
#  the model statement. Defaults to .5.
# @param chains A positive integer specifying the number of Markov chains.
# Defaults to 4.
#' @param mute_stan Logical, indicating whether mute all 'Stan' output or not.
# @param prior_only Logical, indicating whether to sample from the prior
# (`prior_only = TRUE`) or from the posterior.
#' @param ... Additional arguments passed on to [rstan::sampling()].
#' Use this, e.g., to override default arguments of that function.
#' @details The Bayesian regularized meta-analysis algorithm (Van Lissa & Van
#' Erp, 2021) penalizes meta-regression coefficients either via the
#' lasso prior (Park & Casella, 2008) or the regularized horseshoe prior
#' (Piironen & Vehtari, 2017).
#' \describe{
#'   \item{lasso}{ The Bayesian equivalent of the lasso penalty is obtained when
#'   placing independent Laplace (i.e., double exponential) priors on the
#'   regression coefficients centered around zero. The scale of the Laplace
#'   priors is determined by a global scale parameter \code{scale}, which
#'   defaults to 1 and an inverse-tuning parameter \eqn{\frac{1}{\lambda}}
#'   which is given a chi-square prior governed by a degrees of freedom
#'   parameter \code{df} (defaults to 1). If \code{standardize = TRUE},
#'   shrinkage will
#'   affect all coefficients equally and it is not necessary to adapt the
#'   \code{scale} parameter. Increasing the \code{df} parameter will allow
#'   larger values for the inverse-tuning parameter, leading to less shrinkage.}
#'   \item{hs}{ One issue with the lasso prior is that it has relatively light
#'   tails. As a result, not only does the lasso have the desirable behavior of
#'   pulling small coefficients to zero, it also results in too much shrinkage
#'   of large coefficients. An alternative prior that improves upon this
#'   shrinkage pattern is the horseshoe prior (Carvalho, Polson & Scott, 2010).
#'   The horseshoe prior has an infinitely large spike at zero, thereby pulling
#'   small coefficients toward zero but in addition has fat tails, which allow
#'   substantial coefficients to escape the shrinkage. The regularized horseshoe
#'   is an extension of the horseshoe prior that allows the inclusion of prior
#'   information regarding the number of relevant predictors and can
#'   be more numerically stable in certain cases (Piironen & Vehtari, 2017).
#'   The regularized horseshoe has a global shrinkage parameter that influences
#'   all coefficients similarly and local shrinkage parameters that enable
#'   flexible shrinkage patterns for each coefficient separately. The local
#'   shrinkage parameters are given a Student's t prior with a default \code{df}
#'   parameter of 1. Larger values for \code{df} result in lighter tails and
#'   a prior that is no longer strictly a horseshoe prior. However, increasing
#'   \code{df} slightly might be necessary to avoid divergent transitions in
#'   Stan (see also \url{https://mc-stan.org/misc/warnings.html}). Similarly,
#'   the degrees of freedom for the Student's t prior on the global shrinkage
#'   parameter \code{df_global} can be increased from the default of 1 to, for
#'   example, 3 if divergent transitions occur although the resulting
#'   prior is then strictly no longer a horseshoe. The scale for the Student's t
#'   prior on the global shrinkage parameter \code{scale_global} defaults to 1
#'   and can be decreased to achieve more shrinkage. Moreover, if prior
#'   information regarding the number of relevant moderators is available, it is
#'   recommended to include this information via the \code{relevant_pars}
#'   argument by setting it to the expected number of relevant moderators. When
#'   \code{relevant_pars} is specified, \code{scale_global} is ignored and
#'   instead based on the available prior information. Contrary to the horseshoe
#'   prior, the regularized horseshoe applies additional regularization on large
#'   coefficients which is governed by a Student's t prior with a
#'   \code{scale_slab} defaulting to 2 and \code{df_slab} defaulting to 4.
#'   This additional regularization ensures at least some shrinkage of large
#'   coefficients to avoid any sampling problems.}
#' }
#' @references
#' Van Lissa, C. J., van Erp, S., & Clapper, E. B. (2023). Selecting relevant
#' moderators with Bayesian regularized meta-regression. Research Synthesis
#' Methods. \doi{10.31234/osf.io/6phs5}
#'
#' Park, T., & Casella, G. (2008). The Bayesian Lasso. Journal of the American
#' Statistical Association, 103(482), 681–686. \doi{10.1198/016214508000000337}
#'
#' Carvalho, C. M., Polson, N. G., & Scott, J. G. (2010). The horseshoe
#' estimator for sparse signals. Biometrika, 97(2), 465–480.
#' \doi{10.1093/biomet/asq017}
#'
#' Piironen, J., & Vehtari, A. (2017). Sparsity information and regularization
#' in the horseshoe and other shrinkage priors. Electronic Journal of
#' Statistics, 11(2). \url{https://projecteuclid.org/journals/electronic-journal-of-statistics/volume-11/issue-2/Sparsity-information-and-regularization-in-the-horseshoe-and-other-shrinkage/10.1214/17-EJS1337SI.pdf}
#' @return A `list` object of class `brma`, with the following structure:
#' ```
#' list(
#'   fit          # An object of class stanfit, for compatibility with rstan
#'   coefficients # A numeric matrix with parameter estimates; these are
#'                # interpreted as regression coefficients, except tau2 and tau,
#'                # which are interpreted as the residual variance and standard
#'                # deviation, respectively.
#'   formula      # The formula used to estimate the model
#'   terms        # The predictor terms in the formula
#'   X            # Numeric matrix of moderator variables
#'   Y            # Numeric vector with effect sizes
#'   vi           # Numeric vector with effect size variances
#'   tau2         # Numeric, estimated tau2
#'   R2           # Numeric, estimated heterogeneity explained by the moderators
#'   k            # Numeric, number of effect sizes
#'   study        # Numeric vector with study id numbers
#' )
#' ```
#' @export
#' @examples
#' data("curry")
#' df <- curry[c(1:5, 50:55), c("d", "vi", "sex", "age", "donorcode")]
#' suppressWarnings({res <- brma(d~., data = df, iter = 10)})
#' @importMethodsFrom rstan summary
#' @importFrom stats model.matrix na.omit quantile sd
#' @importFrom RcppParallel RcppParallelLibs CxxFlags
#' @importFrom rstantools bayes_R2
# The line above is just to avoid CRAN warnings that RcppParallel is not
# imported from, despite RcppParallel being a necessary dependency of rstan.
brma <- function(x, ...){
  UseMethod("brma")
}

#' @method brma formula
#' @export
#' @rdname brma
brma.formula <-
  function(formula,
           data,
           vi = "vi",
           study = NULL,
           method = "hs",
           standardize = TRUE,
           prior = switch(method,
                          "lasso" = c(df = 1, scale = 1),
                          "hs" = c(df = 1, df_global = 1, df_slab = 4, scale_global = 1, scale_slab = 2, relevant_pars = NULL)),
           mute_stan = TRUE,
           #prior_only = FALSE,
           ...) {
    cl <- match.call()
    # Check if data is multiply imputed
    if(inherits(data, "mids")){
      if(!requireNamespace("mice", quietly = TRUE)){
        message("The `mice` package must be installed when providing multiply imputed data to the `data` argument of brma().")
        return(NULL)
      }
      data <- mice::complete(data, action = "all")
    }
    if(inherits(data, "list") & !inherits(data, "data.frame")){
      cl[["data"]] <- data
      return(brma_imp(cl = cl))
    }
    # Check for complete data
    if(anyNA(data)) stop("The function brma() requires complete data.")
    # Bookkeeping for columns that should not be in X or Y
    vi_column <- NULL
    study_column <- NULL
    if(inherits(vi, "character")){
      vi_column <- vi
      vi <- data[[vi]]
      data[[vi_column]] <- NULL
    }
    if(!is.null(study)){
      if(inherits(study, "character")){
        if(!study %in% names(data)) stop("Argument 'study' is not a column of 'data'.")
        study_column <- study
        cl[["study"]] <- data[[study]]
        data[[study_column]] <- NULL
      } else {
        if(!length(study) == nrow(data)){
          stop("Argument 'study' must be a character string referencing a column in 'data', or a vector of study IDs with length equal to the number of rows in 'data'.")
        }
      }
    }
    # Make model matrix
    mf <- match.call(expand.dots = FALSE)
    mf <- mf[c(1L, match(c("formula", "subset", "na.action"), names(mf), nomatch = 0L))]
    mf[["data"]] <- data
    mf$drop.unused.levels <- TRUE
    mf[[1L]] <- str2lang("stats::model.frame")
    mf <- eval(mf, parent.frame())
    Y <- mf[[1]]
    #X <- mf[, -1, drop = FALSE]
    mt <- attr(mf, "terms")
    X <- model.matrix(mt, mf)
    if(all(X[,1] == 1)){
      intercept <- TRUE
      X <- X[, -1, drop = FALSE]
    } else {
      intercept <- FALSE
    }
    if(!inherits(standardize, c("logical", "list"))) stop("Argument 'standardize' must be either logical (TRUE/FALSE) or a list with two elements: list(center = c(mean(X1), mean(X2), mean(X...)), scale = c(sd(X1), sd(X2), sd(X...))).")
    if(is.logical(standardize)){
      if(standardize){
        X <- scale(X)
        standardize <- list(center = attr(X, "scaled:center"), scale = attr(X, "scaled:scale"))
      } else {
        standardize <- list(rep(0, ncol(X)), rep(1, ncol(X)))
      }
    } else {
      standardize <- standardize[c("center", "scale")]
    }

    cl[names(cl) %in% c("formula", "data")] <- NULL
    cl[[1L]] <- str2lang("pema::brma")
    cl[["x"]] <- X
    cl[["y"]] <- Y
    cl[["vi"]] <- vi
    cl[["prior"]] <- prior
    cl[["mute_stan"]] <- mute_stan
    cl[["standardize"]] <- standardize
    cl[["intercept"]] <- intercept
    cl[["formula"]] <- formula
    if(!is.null(vi_column)) cl[["vi_column"]] <- vi_column
    if(!is.null(study_column)) cl[["study_column"]] <- study_column
    eval.parent(cl)
}

#' @param x An k x m numeric matrix, where k is the number of effect sizes and m
#' is the number of moderators.
#' @param y A numeric vector of k effect sizes.
#' @param intercept Logical, indicating whether or not an intercept should be included
#' in the model.
#' @method brma default
#' @export
#' @rdname brma
brma.default <-
  function(x,
           y,
           vi,
           study = NULL,
           method = "hs",
           standardize,
           prior,
           mute_stan = TRUE,
           intercept,
           #prior_only = FALSE,
           ...) {
    X <- x
    Y <- y
    # Check for complete data
    if(anyNA(X) | anyNA(Y)) stop("The function brma() requires complete data.")

    dots <- list(...)
    outputdots <- match(c("formula", "vi_column", "study_column"), names(dots), nomatch = 0L)
    if(any(outputdots > 0)){
      foroutput <- dots[outputdots]
      dots <- dots[-outputdots]
    } else {
      foroutput <- NULL
    }
    # Check validity of prior
    if(is.null(ncol(X))) stop("Object 'X' must be a matrix.")
    if(dim(X)[2] == 0) stop("The function 'brma()' performs moderator selection, but this model does not include any moderators.")
    # Check method
    use_method <- switch(method,
                         hs = "horseshoe_MA",
                         lasso = "lasso_MA",
                         "invalid")
    if(use_method == "invalid") stop("Method '", method, "' is not valid.")

    # Clean up prior
    prior_template <- list(
      lasso = c(df = 1, scale = 1),
      hs = c(df = 1, df_global = 1,
             df_slab = 4, scale_global = 1, scale_slab = 2, relevant_pars = NA))[[method]]
    legalnames <- names(prior_template)
    is_legal <- names(prior) %in% legalnames
    if(any(!is_legal)){
      wrongnames <- names(prior)[!is_legal]
      message("Unknown prior parameter(s): ", paste0(wrongnames, collapse = ", "))
      prior <- prior[which(is_legal)]
    }
    if(isTRUE(length(prior) > 0)){
      prior_template[names(prior)] <- prior
      prior <- prior_template
    }
    if(isTRUE(sign(prior["relevant_pars"]) == 1)){ # use prior information if available
        prior["scale_global"] <- prior["relevant_pars"]/((ncol(X) - prior["relevant_pars"]) * sqrt(nrow(X))) # multiplication with sigma happens within stan model
    }


    # Check if this is a three-level meta-analysis
    if(is.null(study)){
      threelevel <- FALSE
    } else {
      threelevel <- length(unique(study)) > 1
    }
    # Check if standardize is valid
    if(!length(standardize) == 2) stop("Argument 'standardize' must be a list with two elements: list(center = c(mean(X1), mean(X2), mean(X...)), scale = c(sd(X1), sd(X2), sd(X...))).")
    if(!(length(standardize[[1]] == ncol(X) & length(standardize[[2]] == ncol(X))))){
      stop("Both elements of argument 'standardize' must be as long as the number of predictors.")
    }
    Xunscale <- do.call(unscale, c(list(x = X), standardize))
    names(standardize) <- c("means_X", "sds_X")
    if(ncol(X) == 1){
      standardize <- lapply(standardize, as.array)
    }
    # Prepare standat for study-level data
    N <- length(Y)
    standat <- list(
      N_1 = N,
      M_1 = 1,
      J_1 = 1:N,
      Z_1_1 = rep(1, N))
    # Add threelevel data to standat
    if(threelevel){
      standat <- c(standat, list(
        N_2 = length(unique(study)),
        M_2 = 1,
        J_2 = as.integer(factor(study)),
        Z_2_1 = rep(1, N)
      ))
      foroutput[["study"]] <- study
    }
    # Prepare standard error
    se <- sqrt(vi)
    # Finalize standat
    standat <- c(
      list(
        N = N,
        Y = Y,
        se = se,
        K = ncol(X),
        X = X),
      as.list(prior),
      standat,
      list(
        prior_only = FALSE
      ),
      standardize
      )
    cl <- do.call("call",
                  c(list(name = "sampling",
                         object = stanmodels[[paste0(use_method,
                                                     c("", "_ml")[threelevel+1],
                                                     c("_noint", "")[intercept+1]
                                                     )]],
                         data = standat
                  ),
                  dots))
    # Mute stan
    if(!any(c("show_messages", "verbose", "refresh") %in% names(dots))){
      if(mute_stan){
        cl[["show_messages"]] <- FALSE
        cl[["verbose"]] <- FALSE
        cl[["refresh"]] <- 0
      }
    }
    fit <- eval(cl)
    sums <- make_sums(fit, colnames(X))
    tau2 <- sums[which(startsWith(rownames(sums), "tau2"))[1], 1]
    foroutput <- c(
      list(fit = fit,
           coefficients = sums,
           X = Xunscale,
           Y = Y,
           vi = vi,
           tau2 = tau2,
           R2 = calc_r2(tau2, vi, Y, N),
           k = N),
      foroutput
    )
    return(do.call(stanfit_to_brma, foroutput))
  }

#' @importFrom rstan sflist2stanfit
brma_imp <- function(cl){
  Args <- as.list(cl)
  cl[[1L]] <- quote(brma)
  out <- lapply(cl[["data"]], function(df){
    cl[["data"]] <- df
    eval.parent(cl)
  })
  foroutput <- out[[1]]
  fit <- sflist2stanfit(sapply(out, `[[`, "fit"))
  sums <- make_sums(fit, colnames(foroutput[["X"]]))
  tau2 <- sums[which(startsWith(rownames(sums), "tau2"))[1], 1]
  foroutput[["fit"]] <- fit
  foroutput[["coefficients"]] <- sums
  foroutput[["X"]] <- lapply(out,`[[`, "X")
  foroutput[["Y"]] <- lapply(out,`[[`, "Y")
  foroutput[["vi"]] <- lapply(out,`[[`, "vi")
  # Check if all Y is the same; if so, compute tau2 and R2 over all chains.
  # If not, take mean of tau2s and R2s
  foroutput[["tau2"]] <- mean(sapply(out,`[[`, "tau2"))
  foroutput[["R2"]] <- mean(sapply(out,`[[`, "R2"))
  if(!is.null(foroutput[["study"]])) foroutput[["study"]] <- lapply(out,`[[`, "study")
  return(do.call(stanfit_to_brma, foroutput))
}

make_sums <- function(fit, parnames){
  sums <- summary(fit)$summary
  rnam <- rownames(sums)
  row_int <- which(startsWith(rnam, "Intercept"))
  row_beta <- which(startsWith(rnam, "betas"))
  row_tau <- which(startsWith(rnam, "tau2"))
  keepthese <- c(row_int, row_beta, row_tau)
  sums <- sums[keepthese, , drop = FALSE]
  if(length(row_beta) == length(parnames)){
    rownames(sums)[startsWith(rownames(sums), "betas")] <- parnames
  }
  return(sums)
}

calc_r2 <- function(tau2, vi, Y, N){
  #tau2 <- sums[which(startsWith(rownames(sums), "tau2"))[1], 1]
  Wi <- 1 / vi
  tau2_before <-
    max(0, (sum(Wi * (Y - (
      sum(Wi * Y) / sum(Wi)
    )) ^ 2) - (N - 1)) / (sum(Wi) - (sum(Wi ^ 2) / sum(Wi))))
  return(max(0, 100 * (tau2_before-tau2)/tau2_before))
}

stanfit_to_brma <- function(fit, coefficients, X, Y, vi, tau2, R2, k, ...){
  frmls <- names(formals(stanfit_to_brma))
  frmls <- frmls[-length(frmls)]
  out <- replicate(length(frmls), NULL)
  names(out) <- frmls
  Args <- as.list(match.call()[-1])
  if(any(names(out) %in% names(Args))){
    repthese <- names(out)[which(names(out) %in% names(Args))]
    out[repthese] <- Args[repthese]
    Args[repthese] <- NULL
  }
  out <- c(out, Args)
  # out <- list(fit = fit,
  #             coefficients = sums,
  #             X = Xunscale,
  #             Y = Y,
  #             vi = vi,
  #             tau2 = tau2,
  #             R2 = R2,
  #             k = N)
  #if(!is.null(foroutput)) out <- c(out, foroutput)
  #if(threelevel) out$study <- study
  class(out) <- c("brma", class(out))
  return(out)
}
