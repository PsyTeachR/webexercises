#' Convert an object to stanfit
#'
#' Create a `stanfit` object from an object for which a method exists,
#' so that all methods for `stanfit` objects can be used.
#' @param x An object for which a method exists.
#' @param ... Arguments passed to or from other methods.
#' @return An object of class `stanfit`, as documented in [rstan::stan].
#' @export
#' @examples
#' stanfit <- "a"
#' class(stanfit) <- "stanfit"
# brmaobject <- list(fit = stanfit)
# class(brmaobject) <- "brma"
#' converted <- as.stan(stanfit)
#' @importFrom stats rbinom rnorm rt
#' @importFrom sn rsn
as.stan <- function(x, ...){
  UseMethod("as.stan", x)
}

#' @method as.stan brma
#' @export
as.stan.brma <- function(x, ...){
  if(is.null(x[["fit"]])) stop("Could not coerce object to class 'stanfit'.")
  if(!inherits(x[["fit"]], "stanfit")) stop("Could not coerce object to class 'stanfit'.")
  out <- x[["fit"]]
  as_atts <- names(x)[!names(x) %in% c("fit")]
  for(thisatt in as_atts){
    attr(out, which = thisatt) <- x[[thisatt]]
  }

  # Try to replace all betas with true parameter names
  renm <- rownames(x$coefficients)
  renm <- renm[!renm %in% c("Intercept", "tau2", "tau2_w", "tau2_b")]
  names(renm) <- paste0("betas[", 1:x$fit@par_dims$betas, "]")

  oldposition <- which(names(out@sim$samples[[1]]) %in% names(renm))
  oldnames <- names(out@sim$samples[[1]])[oldposition]
  newnames <- unname(renm[oldnames])

  for(thischain in seq_along(out@sim$samples)){
    names(out@sim$samples[[thischain]])[oldposition] <- newnames
  }

  isbetas <- which(out@sim$pars_oi == "betas")
  out@sim$pars_oi <- append(out@sim$pars_oi, newnames, after = isbetas)
  out@sim$pars_oi <- out@sim$pars_oi[-isbetas]

  out@model_pars <- append(out@model_pars, newnames, after = isbetas)
  out@model_pars <- out@model_pars[-isbetas]

  out@sim$fnames_oi[oldposition] <- newnames

  appendthis <- replicate(length(newnames), {vector(mode = "numeric")})
  names(appendthis) <- newnames

  out@sim$dims_oi <- append(out@sim$dims_oi, appendthis, after = isbetas)
  out@sim$dims_oi <- out@sim$dims_oi[-isbetas]

  out@par_dims <- append(out@par_dims, appendthis, after = isbetas)
  out@par_dims <- out@par_dims[-isbetas]

  for(thischain in seq_along(out@inits)){
    appendthis <- as.list(out@inits[[thischain]][["betas"]])
    names(appendthis) <- newnames
    out@inits[[thischain]] <- append(out@inits[[thischain]], appendthis, after = isbetas)
    out@inits[[thischain]][["betas"]] <- NULL
  }

  attr(out, which = "type") <- "brma"
  return(out)
}

#' @method as.stan default
#' @export
as.stan.default <- function(x, ...){
  if(inherits(x, "stanfit")){
    return(x)
  } else {
    message("Could not coerce to 'stanfit'.")
    return(NULL)
  }

}
