#' @title Plot posterior distributions for BRMA models
#' @description To perform a rudimentary sensitivity analysis,
#' plot the posterior distributions of multiple BRMA models
#' and compare them visually.
#' @param ... Objects of class `brma`. If the argument `model_names`
#' is `NULL`, the names of these objects are used to label the plot.
#' @param parameters Optional character vector with the names of
#' parameters that exist in the models in `...`,
#' Default: `NULL`.
#' @param model_names Optional character vector with the names used
#' to label the models in `...`, Default: `NULL`
#' @return An object of class `ggplot`
#' @examples
#' plot_sensitivity(samples = list(
#' data.frame(Parameter = "b",
#' Value = rnorm(10),
#' Model = "M1"),
#' data.frame(Parameter = "b",
#' Value = rnorm(10, mean = 2),
#' Model = "M2")),
#' parameters = "b")
#' @export
#' @importFrom ggplot2 ggplot
plot_sensitivity <- function(..., parameters = NULL, model_names = NULL){
  models <- list(...)
  UseMethod("plot_sensitivity", models[[1]])
}

#' @method plot_sensitivity brma
#' @export
plot_sensitivity.brma <- function(..., parameters = NULL, model_names = NULL){
  if(is.null(model_names)){
    model_names <- as.list(match.call())
    model_names <- model_names[-c(1L, which(names(model_names) %in% c("parameters")))]
    model_names <- sapply(model_names, deparse)
  }

  if(!all(sapply(models, inherits, what = "brma"))){
    stop("Argument 'models' must be a named list of brma models.")
  }
  names(models) <- model_names
  dfs <- lapply(names(models), function(m){
    sim <- models[[m]]$fit@sim

    row_int <- which(sim$fnames_oi == "Intercept")
    row_beta <- which(startsWith(sim$fnames_oi, "betas"))
    row_tau <- which(startsWith(sim$fnames_oi, "tau2"))
    keepthese <- c(row_int, row_beta, row_tau)
    samps <- sapply(keepthese, .extract_samples, sim = sim)
    namz <- rownames(models[[m]]$coefficients)
    data.frame(Parameter = ordered(rep(namz, each = nrow(samps)), levels = rev(namz)),
               Value = as.vector(samps),
               Model = m)
  })
  cl <- match.call()
  cl[[1L]] <- str2lang("pema:::plot_sensitivity.default")
  cl <- cl[c(1L, which(names(cl) %in% c("parameters", "model_names")))]
  cl[["samples"]] <- dfs
  if(is.null(parameters)){
    parameters <- unique(as.character(sapply(dfs, `[[`, "Parameter")))
    cl[["parameters"]] <- parameters
  }
  eval.parent(cl)
}

#' @method plot_sensitivity default
#' @export
plot_sensitivity.default <- function(..., parameters = NULL, model_names = NULL){
  dots <- list(...)
  plotlist <- lapply(dots[["samples"]], function(i){
    par_exists <- parameters %in% i$Parameter
    if(!any(par_exists)) return(NULL)
    do.call(rbind, lapply(parameters[par_exists], function(p){
      densdat <- density(i$Value[i$Parameter == p])
      data.frame(x = densdat$x, y = densdat$y, Parameter = p, Model = i$Model[1])
    }))
  })
  df_plot <- do.call(rbind, plotlist)
  par_exists <- parameters %in% df_plot$Parameter
  if(!any(par_exists)) stop("Requested 'parameters' do not exist in any of the models provided.")
  parameters <- parameters[par_exists]
  df_plot <- df_plot[df_plot$Parameter %in% parameters, , drop = FALSE]
  df_plot$Parameter <- factor(df_plot$Parameter)
  divby <- tapply(df_plot$y, df_plot$Parameter, max, na.rm = TRUE)
  df_plot$y <- df_plot$y/ divby[df_plot$Parameter]
  df_plot$y <- df_plot$y + as.integer(df_plot$Parameter)
  df_plot$grp <- paste0(df_plot$Parameter, df_plot$Model)
  ggplot2::ggplot(df_plot, aes(x = .data[["x"]], y = .data[["y"]], colour = .data[["Model"]], group = .data[["grp"]])) +
    ggplot2::geom_path() +
    theme_bw() +
    scale_y_continuous(breaks = seq_along(levels(df_plot$Parameter)), labels = levels(df_plot$Parameter)) +
    theme(axis.title = element_blank(), panel.grid.minor.y = element_blank())
}
