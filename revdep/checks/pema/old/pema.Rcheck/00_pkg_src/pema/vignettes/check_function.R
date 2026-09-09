if(!require("metaforest")) install.packages("metaforest", dependencies = TRUE)
if(!require("pema")) install.packages("pema", dependencies = TRUE)
check_data <- function(df){
  any_errors <- FALSE
  # Check df
  deps <- c("methods", "rstan", "Rcpp", "RcppParallel", "rstantools", "sn", 
            "shiny", "gtable", "grid", "ggplot2", "metafor", "ranger", "data.table")
  has_dep <- sapply(deps, requireNamespace, quietly = FALSE)
  
  if(any(!has_dep)){
    usethis::ui_oops(paste0("You are missing essential packages. Please run the following code:\n\n", paste0("lapply(c(",
                                                                                                           paste0(shQuote(names(has_dep)[!has_dep], type="sh"), collapse=", "),
                                                                                                           "), install.packages)")))
    any_errors <- TRUE
  }
  
  if(!inherits(df, what = "data.frame")){
    df <- try(as.data.frame(df))
    if(inherits(df, what = "try-error")){
      usethis::ui_oops("Your data are not an object of type 'data.frame', please convert them to a 'data.frame'.")
    } else {
      usethis::ui_todo("Your data are not an object of type 'data.frame', please convert them to a 'data.frame'.")
    }
    any_errors <- TRUE
  }
  if(!"yi" %in% names(df)){
    usethis::ui_todo("There is no column named 'yi' in your data. If you have an effect size column, it will be easier to do the tutorial if you rename it, using syntax like this:\n\nnames(df)[which(names(df) == 'youreffectsize')] <- 'yi'\n\nIf you do not yet have an effect size column, you may need to compute it first. Run ?metafor::escalc to see the help for this function.")
    any_errors <- TRUE
  }
  if(!"vi" %in% names(df)){
    usethis::ui_todo("There is no column named 'vi' in your data. If you have a column with the variance of the effect size, it will be easier to do the tutorial if you rename it, using syntax like this:\n\nnames(df)[which(names(df) == 'yourvariance')] <- 'vi'\n\nIf you do not yet have a column with the variance of the effect size, you may need to compute it first. Run ?metafor::escalc to see the help for this function.")
    any_errors <- TRUE
  }
  # Check measurement levels
  numvars <- sapply(df, inherits, what = c("numeric", "integer"))
  catvars <- sapply(df, inherits, what = c("factor"))
  charvars <- sapply(df, inherits, what = c("character"))
  othervars <- !(numvars | catvars | charvars)
  
  if(any(othervars)){
    usethis::ui_oops(paste0("You have variables with an unusual type. Consider manually recoding these to either numeric of factor type variables, whichever is most appropriate: ", paste0(names(df)[othervars], collapse = ", ")))
    any_errors <- TRUE
  }
  
  if(any(charvars)){
    usethis::ui_todo(paste0("You have character-type variables. Consider converting these to factor-type variables using syntax like this:\ndf[c(", paste0(paste0("'", names(df)[charvars], "'"), collapse = ", "), ")] <- lapply(df[c(", paste0(paste0("'", names(df)[charvars], "'"), collapse = ", "), ")], factor)"))
    any_errors <- TRUE
  }
  if(!any_errors){
    usethis::ui_done("Looks like you're all set to do the workshop!")
  }
    
}

check_data(metaforest::fukkink_lont)