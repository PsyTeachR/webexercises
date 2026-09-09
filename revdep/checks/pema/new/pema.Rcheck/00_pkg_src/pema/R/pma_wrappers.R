if(FALSE){
#### Conduct LASSO penalized Meta-Analysis
####
#### This function conducts Bayesian regularized meta-regression, determining the
#### value of tau2 via cross-validation. This method is not yet validated.
#### @param ... Arguments passed on to other functions.
#### @return A `list` object of class `pma`, with the following structure:
#### ```
#### list(
####   rma          # A random effects meta-analysis of class rma
####   lasso        # A LASSO-penalized regression model of class cv.glmnet
####   tau2_cv      # The residual heterogeneity tau2 based on cross-validation
#### )
#### ```
# @examples
# data("curry")
# df <- curry[c(1:5, 50:55), c("d", "vi", "sex", "age", "donorcode")]
# suppressWarnings({res <- pma(d~., data = df, ntau = 2)})
#### @importMethodsFrom rstan summary
#### @importFrom stats model.matrix na.omit quantile sd
#### @importFrom metafor rma
#### @importFrom glmnet cv.glmnet
pma <- function(x, ...){
  UseMethod("pma")
}

#### @param formula An object of class `formula` (or one that can be coerced to
#### that class), see \code{\link[stats]{lm}}.
#### @param data Either a `data.frame` containing the variables in the model,
#### see \code{\link[stats]{lm}}, or a `list` of multiple imputed `data.frame`s,
#### or an object returned by \code{\link[mice]{mice}}.
#### @param vi Character. Name of the column in the \code{data} that
#### contains the variances of the effect sizes. This column will be removed from
#### the data prior to analysis. Defaults to \code{"vi"}.
#### @param study Character. Name of the column in the
#### \code{data} that contains the study id. Use this when the data includes
#### multiple effect sizes per study. This column can be a vector of integers, or
#### a factor. This column will be removed from the data prior to analysis.
#### See \code{Details} for more information about analyzing dependent data.
#### @param ntau Numeric, the numer of `tau2` values to try during
#### cross-validation.
#### @method pma formula
#### @export
#### @rdname pma
pma.formula <-
  function(formula,
           data,
           vi = "vi",
           study = NULL,
           ntau = 10,
           ...) {
    cl <- match.call()
    # Check for complete data
    if(anyNA(data)) stop("The function pma() requires complete data.")
    # Bookkeeping for columns that should not be in X or Y
    data_cleaned <- .pema_prep_dat(data, vi, study)
    # Make model matrix
    mf <- match.call(expand.dots = FALSE)
    mf <- mf[c(1L, match(c("formula", "subset", "na.action"), names(mf), nomatch = 0L))]
    mf[["data"]] <- data_cleaned$data
    mf$drop.unused.levels <- TRUE
    mf[[1L]] <- str2lang("stats::model.frame")
    mf <- eval(mf, parent.frame())
    Y <- mf[[1]]
    mt <- attr(mf, "terms")
    X <- model.matrix(mt, mf)
    if(all(X[,1] == 1)){
      intercept <- TRUE
      X <- X[, -1, drop = FALSE]
    } else {
      intercept <- FALSE
    }
    cl[names(cl) %in% c("formula", "data")] <- NULL
    cl[[1L]] <- str2lang("pema::pma")
    cl[["x"]] <- X
    cl[["y"]] <- Y
    cl[c("vi", "study")] <- data_cleaned[c("vi", "study")]
    cl[["intercept"]] <- intercept
    cl[["formula"]] <- formula
    eval.parent(cl)
}

#### @param x An k x m numeric matrix, where k is the number of effect sizes and m
#### is the number of moderators.
#### @param y A numeric vector of k effect sizes.
#### @param intercept Logical, indicating whether or not an intercept should be included
#### in the model.
#### @method pma default
#### @export
#### @rdname pma
pma.default <-
  function(x,
           y,
           vi,
           study = NULL,
           intercept,
           ntau = 10,
           ...) {
    X <- x
    Y <- y
    # Check for complete data
    if(anyNA(X) | anyNA(Y)) stop("The function pma() requires complete data.")
    # Determine CV folds
    if(!hasArg(foldid)){
      if(!hasArg(nfolds)){
        nfolds <- 10
      }
      if(is.null(study)){
        foldid <- sample(rep(seq(nfolds), length = length(y)))
      } else {
        nstudies <- length(unique(study))
        if(nstudies < nfolds*20) message("Number of unique studies is small relative to the number of cross-validation folds. Decrease 'nfolds'.")
        foldid <- sample(rep(seq(nfolds), length = nstudies))
        foldid <- foldid[study]
      }
    }
    mf_nomod <- metafor::rma(y, vi)
    tau2_max <- mf_nomod$tau2
    mf_allmod <- metafor::rma(yi = y, vi = vi, mods = x)
    tau2_min <- mf_allmod$tau2
    tau_seq <- seq(from = tau2_min, to = tau2_max, length.out = ntau)
    wts <- 1/(vi + tau_seq[1])
    res <- vector(mode = "list", length = ntau)
    res[[1]] <- glmnet::cv.glmnet(x = X, y = y, weights = wts, keep = TRUE, foldid = foldid)
    for(i in 2:ntau){
      wts <- 1/(vi + tau_seq[i])
      res[[i]] <- cv.glmnet(x = X, y = y, weights = wts, foldid = foldid)
    }
    err_min <- sapply(res, function(i){min(i$cvm)})
    tau2_cv <- tau_seq[which.min(err_min)]
    out <- res[[which.min(err_min)]]
    browser()
    out <- c(out,
             list(
               rma = mf_nomod,
               tau2_cv = tau2_cv,
               x = x,
               y = y,
               vi = vi,
               study = study,
               foldid = foldid
               ))
    class(out) <- c("pma", "cv.glmnet")
    return(out)
}



.pema_prep_dat <- function(data, vi, study){
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
  return(list(vi = vi, study = study, data = data))
}


#### Convert an object to cv.glmnet
####
#### Create a `cv.glmnet` object from an object for which a method exists,
#### so that all methods for `cv.glmnet` objects can be used.
#### @param x An object for which a method exists.
#### @param ... Arguments passed to or from other methods.
#### @return An object of class `cv.glmnet`,
#### as documented in [glmnet::cv.glmnet()].
#### @export
#### @examples
#### x <- "a"
#### converted <- as.cv.glmnet(x)
as.cv.glmnet <- function(x, ...){
  UseMethod("as.cv.glmnet", x)
}

#### @method as.cv.glmnet pma
#### @export
as.cv.glmnet.pma <- function(x, ...){
  out <- x[["lasso"]]
  class(out) <- c(class(out), "pma_cv_glmnet")
  attr(out, "tau2_cv") <- x$tau2_cv
  attr(out, "tau2") <- x$rma$tau2
  return(out)
}

#### @method as.cv.glmnet character
#### @export
as.cv.glmnet.character <- function(x, ...){
  class(x) <- c("cv.glmnet", "character")
  return(x)
}

#### @method predict pma
#### @export
predict.pma <- function(object, newdata, s = "lambda.min", ...){
  cl <- match.call()
  cl[[1L]] <- quote(predict)
  cl[["object"]] <- as.cv.glmnet(object)
  names(cl)[names(cl) == "newdata"] <- "newx"
  eval.parent(cl)
}

#### @method predict pma
#### @export
predict.pma <- function(object, newdata = NULL, s = "lambda.min", ...){
  cl <- match.call()
  cl[[1L]] <- quote(predict)
  class(object) <- "cv.glmnet"
  cl[["object"]] <- object
  cl[["s"]] <- s
  if(is.null(newdata)){
    cl[["newdata"]] <- object$x
  }
  names(cl)[names(cl) == "newdata"] <- "newx"
  eval.parent(cl)
}


#### @method coef pma
#### @export
coef.pma <- function(object, s = "lambda.min", ...){
  cl <- match.call()
  cl[[1L]] <- quote(coef)
  class(object) <- "cv.glmnet"
  cl[["object"]] <- object
  cl[["s"]] <- s
  eval.parent(cl)
}
}
