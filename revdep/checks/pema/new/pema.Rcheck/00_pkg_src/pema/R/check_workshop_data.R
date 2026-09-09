#' @importFrom utils installed.packages packageDescription packageVersion
check_dependencies <- function (packages = "metaforest")
{
  with_cli_try("Checking R package dependencies.", {
    available <- data.frame(utils::installed.packages())
    thesedeps <- unique(unlist(lapply(packages, function(package){

        pks <- utils::packageDescription(package)
        if (isTRUE(is.na(pks))){
          return(vector("character"))
        } else {
          pks <- pks[c("Depends", "Imports", "Suggests")]
          pks <- lapply(pks, function(p){
            p <- gsub("\n", "", p, fixed = TRUE)
            p <- gsub("\\s", "", p)
            strsplit(p, ",")[[1]]
          })
          return(do.call(c, pks))
        }
    })))
    if(any(grepl("^R\\b", thesedeps))) thesedeps <- thesedeps[!grepl("^R\\b", thesedeps)]
    # setdiff(pks, c("R", "stats", "graphics", "grDevices",
    #                "utils", "datasets", "methods", "base", "tools"))
    has_version <- grepl("(", thesedeps, fixed = TRUE)
    correct_vers <- rep(TRUE, length(thesedeps))
    if (any(has_version)) {
      vers <- data.frame(do.call(rbind, strsplit(thesedeps[has_version],
                                                 "(", fixed = TRUE)))
      vers[, 2] <- gsub(")", "", vers[, 2], fixed = TRUE)
      vers$op <- gsub("[0-9\\.]", "", vers[, 2])
      vers[, 2] <- gsub("[^0-9.-]", "", vers[, 2])
      thesedeps[has_version] <- vers[, 1]
      correct_vers[has_version] <- sapply(seq_along(vers$X1), function(i) {
        tryCatch({
          n = vers$X1[i]
          if(n == "R") return(TRUE)
          do.call(vers$op[i], list(x = utils::packageVersion(n),
                                                y = vers[i, 2]))
        }, error = function(e) {
          FALSE
        })
      })
    }
    is_avlb <- thesedeps %in% available$Package
    if (all(is_avlb & correct_vers)) {
      out <- list(pass = list(dependencies = TRUE), errors = list(dependencies = ""))
    }
    else {
      errors <- thesedeps[which(!(is_avlb & correct_vers))]
      errors <- paste0("lapply(c(", paste0("'", errors,
                                           "'", collapse = ", "), "), install.packages)")
      cli_msg(i = "The following packages are not installed (or their correct versions are not installed), run {.code {errors}}.")
      stop()
    }
  })
}


#' @title Check Data for BRMA Workshop
#' @description This function checks that argument `df` is a suitable
#' `data.frame` for completing the workshop on Bayesian Regularized
#' Meta-Regression, and checks that `pema` package dependencies are correctly
#' installed. It suggests how to remedy any failed checks.
#' @param df A `data.frame`.
#' @return Invisibly returns a logical TRUE/FALSE, indicating whether all checks
#' have passed.
#' @examples
#' check_workshop_data(bonapersona)
#' @rdname check_workshop_data
#' @export
check_workshop_data <- function(df = NULL){
  if(is.null(df)){
    df <- pema::bonapersona
  }
  no_errors <- TRUE
  has_dep <- no_errors & check_dependencies(packages = c("pema", "metaforest", "ranger"))

  # Check df
  no_errors <- no_errors & with_cli_try("Checking if data are of type 'data.frame'", {
    if(!inherits(df, what = "data.frame")){
      df <- try(as.data.frame(df))
      if(!inherits(df, what = "try-error")){
        cli_msg(i = "Convert your data to 'data.frame' using {.code as.data.frame(df)}")
      } else {
        cli_msg("!" = "Your data are not an object of type 'data.frame', please convert them to a 'data.frame'.")
      }
      stop()
    }
  })
  no_errors <- no_errors & with_cli_try("Checking colum names", {
    if(!all(c("yi", "vi") %in% names(df))){
      if(!"yi" %in% names(df)){
      cli_msg(i = "There is no column named 'yi' in your data. If you have an effect size column, it will be easier to do the tutorial if you rename it, using syntax like this:\n\n`names(df)[which(names(df) == 'youreffectsize')] <- 'yi'`\n\nIf you do not yet have an effect size column, you may need to compute it first. Run `?metafor::escalc` to see the help for this function.")
      }
      if(!"vi" %in% names(df)){
      cli_msg(i = "There is no column named 'vi' in your data. If you have a column with the variance of the effect size, it will be easier to do the tutorial if you rename it, using syntax like this:\n\n`names(df)[which(names(df) == 'yourvariance')] <- 'vi'`\n\nIf you do not yet have a column with the variance of the effect size, you may need to compute it first. Run `?metafor::escalc` to see the help for this function.")
      }
      stop()
    }
  })
  no_errors <- no_errors & with_cli_try("Checking variable measurement levels", {
    # Check measurement levels
    numvars <- sapply(df, inherits, what = c("numeric", "integer"))
    catvars <- sapply(df, inherits, what = c("factor"))
    charvars <- sapply(df, inherits, what = c("character"))
    othervars <- !(numvars | catvars | charvars)
    if(any(charvars | othervars)){
      if(any(othervars)){
        cli_msg(i = "You have variables with an unusual type. Consider manually recoding these to either numeric of factor type variables, whichever is most appropriate: {paste0(names(df)[othervars], collapse = ', ')}")
        no_errors <- TRUE
      }

      if(any(charvars)){
        cli_msg(i = "You have character-type variables. Consider converting these to factor-type variables using syntax like this:\n`df[c({ paste0(paste0('\"', names(df)[charvars], '\"'), collapse = ', ')})] <- lapply(df[c({ paste0(paste0('\"', names(df)[charvars], '\"'), collapse = ', ')})], factor)")
        no_errors <- TRUE
      }
      stop()
    }
  })

  if(no_errors){
    cli_msg("v" = "Looks like you're all set to do the workshop!")
  }
  return(invisible(no_errors))
}
