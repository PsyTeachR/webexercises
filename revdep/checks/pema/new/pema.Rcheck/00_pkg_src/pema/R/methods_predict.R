#' @method predict brma
#' @export
predict.brma <- function(object, newdata, type = c("mean", "median", "samples"), ...){
  if (missing(newdata) || is.null(newdata)) {
    X <- object$X
  } else {
    if(isTRUE(all(colnames(object$X) %in% colnames(newdata)))){
      X <- newdata[, colnames(object$X), drop = FALSE]
    } else {
      X <- try({
        mf <- model.matrix(object$formula, data = newdata)
        X <- mf[, colnames(object$X), drop = FALSE]
        })
      if(inherits(X, "try-error")) stop("Could not construct a valid model.frame from argument 'newdata'.")
    }
  }
  switch(type[1],
         "mean" = .pred_brma_summary(object, X, parcol = "mean"),
         "median" = .pred_brma_summary(object, X, parcol = "50%"),
         "samples" = .pred_brma_samples(object, X))
}



.pred_brma_samples <- function(object, X, ...){
  sim <- object$fit@sim
  keepthese <- c(which(sim$fnames_oi == "sd_1[1]"),
                 which(sim$fnames_oi == "Intercept"),
                 grep("^betas\\[\\d+\\]$", sim$fnames_oi))

  row_int <- which(sim$fnames_oi == "Intercept")
  row_beta <- which(startsWith(sim$fnames_oi, "betas"))
  row_tau <- which(startsWith(sim$fnames_oi, "tau2"))
  keepthese <- c(row_int, row_beta, row_tau)
  samps <- sapply(keepthese, .extract_samples, sim = sim)
  if(isTRUE(row_int > 0)){
    X <- cbind(1, X)
  }
  preds <- apply(samps[, 1:(ncol(samps)-length(row_tau)), drop = FALSE], 1, function(thisrow){ rowSums(X %*% diag(thisrow)) })
  attr(preds, "tau2") <- samps[,((ncol(samps)-length(row_tau))+1):ncol(samps), drop = FALSE]
  class(preds) <- c("brma_preds", class(preds))
  return(preds)
}

.pred_brma_summary <- function(object, X, parcol, ...){
  X <- as.matrix(X)
  # Prepare coefs -----------------------------------------------------------
  coefs <- object$coefficients
  coefs <- coefs[-which(startsWith(rownames(coefs), "tau2")), ][, parcol, drop = TRUE]
  if(length(coefs)-ncol(X) == 1){
    X <- cbind(1, X)
  }
  # Produce prediction ------------------------------------------------------
  unname(rowSums(X %*% diag(coefs)))
}
