#' @title Add webexercises support
#' @description This convenience function can be called within an 'Rmarkdown'
#' document to add the 'css' and 'JavaScript' code required for webexercises'
#' html output.
#' @return Character string of class `HTML`.
#' @examples
#' invisible(rmd_webex_support())
#' @seealso
#'  \code{\link[htmltools]{HTML}}
#' @rdname rmd_webex_support
#' @export
#' @importFrom htmltools HTML
rmd_webex_support <- function(){
  css_code <- paste("<style>",
                    paste(readLines(system.file("reports/default/webex.css", package = "webexercises"), warn = FALSE), collapse = "\n"),
                    "</style>",
                    sep = "\n"
  )

  js_code <- paste(readLines(system.file("reports/default/webex.js", package = "webexercises"), warn = FALSE), collapse = "\n")

  return(htmltools::HTML(paste0(css_code, "\n", js_code)))
}

#' Add support for latex to quarto file
#' @keywords internal
add_latex_support <- function(filename){
  with_cli_try("Adding latex support to {.value {filename}}.", {
  if(!file.exists(filename)) stop("File does not exist.")

  lnz <- readLines(filename)

  # Extract YAML frontmatter ------------------------------------------------

  delim_lnz <- which(lnz == "---")
  if(!isTRUE(length(delim_lnz) >= 2 & delim_lnz[1] == 1)){
    stop()
  }
  yml <- lnz[(delim_lnz[1]+1L):(delim_lnz[2]-1L)]
  yml <- yaml::read_yaml(text = yml)

  if(endsWith(tolower(filename), ".qmd")){

    # Add to the YAML frontmatter ---------------------------------------------
    if(is.null(yml[["format"]][["pdf"]])|isTRUE(yml[["format"]][["pdf"]] == "default")){
      yml[["format"]][["pdf"]] <- list(`include-in-header` = list(list(text = "\\usepackage[most]{tcolorbox}")))
    } else {
      if(!isTRUE(any(unlist(yml[["format"]][["pdf"]]) == "\\usepackage[most]{tcolorbox}"))){
        yml[["format"]][["pdf"]][["include-in-header"]] <- c(
          yml[["format"]][["pdf"]][["include-in-header"]],
          list(list(text = "\\usepackage[most]{tcolorbox}")))
      }
    }
  }

  if(endsWith(tolower(filename), ".rmd")){
    # Add to the YAML frontmatter ---------------------------------------------

    if(is.null(yml[["output"]][["pdf_document"]])|isTRUE(yml[["output"]][["pdf_document"]] == "default")){
      yml[["output"]][["pdf_document"]] <- list(extra_dependencies = list(tcolorbox = "most"))
    } else {
      if(!isTRUE("tcolorbox" %in% names(unlist(yml[["output"]][["pdf_document"]][["extra_dependencies"]])))){
        yml[["output"]][["pdf_document"]][["extra_dependencies"]] <- c(yml[["output"]][["pdf_document"]][["extra_dependencies"]], list(tcolorbox = "most"))
      }
    }
  }

    # Put YAML back in place --------------------------------------------------
    format_yml <- yaml::as.yaml(yml)
    format_yml <- gsub(": yes", ": true", format_yml, fixed = TRUE)
    format_yml <- gsub(": no", ": false", format_yml, fixed = TRUE)
    lnz <- c("---", gsub("\\n$", "", format_yml), lnz[delim_lnz[2]:length(lnz)])
    writeLines(lnz, filename)
  })
}

#' Add support for latex to html file
#' @keywords internal
add_html_support <- function(filename){
  with_cli_try("Adding html support to {.value {filename}}.", {
    if(!file.exists(filename)) stop("File does not exist.")

    lnz <- readLines(filename)

    # Extract YAML frontmatter ------------------------------------------------

    delim_lnz <- which(lnz == "---")
    if(!isTRUE(length(delim_lnz) >= 2 & delim_lnz[1] == 1)){
      stop()
    }
    yml <- lnz[(delim_lnz[1]+1L):(delim_lnz[2]-1L)]
    yml <- yaml::read_yaml(text = yml)

    if(endsWith(tolower(filename), ".qmd")){

      css <- system.file("reports/default/webex.css", package = "webexercises")
      js <- system.file("reports/default/webex.js", package = "webexercises")

      # make sure include and script directories exist
      incdir <- dirname(filename)

      # add or update helper files
      file.copy(css, incdir, overwrite = TRUE)
      file.copy(js, incdir, overwrite = TRUE)


      # Add to the YAML frontmatter ---------------------------------------------
      if(is.null(yml[["format"]][["html"]])|isTRUE(yml[["format"]][["html"]] == "default")){
        yml[["format"]][["html"]] <- list(css = "webex.css",
                                          `include-after-body` = "webex.js", `embed-resources` = TRUE)
      } else {
        if(!isTRUE(sum(grepl("webex", unlist(yml[["format"]][["html"]]), fixed = TRUE)) == 2)){
          yml[["format"]][["html"]]$css <- "webex.css"
          yml[["format"]][["html"]]$`include-after-body` <- "webex.js"
          yml[["format"]][["html"]]$`embed-resources` <- TRUE
        }
      }
    }

    if(endsWith(tolower(filename), ".rmd")){
      # Add convenience function to body ---------------------------------------------
      if(!isTRUE(any(grepl("rmd_webex_support", lnz, fixed = TRUE)))){
        lnz <- c(lnz[1:delim_lnz[2]],
                 "",
                 "```{r, echo = FALSE, eval = knitr::is_html_output()}",
                 "webexercises::rmd_webex_support()",
                 "```",
                 "",
                 lnz[(delim_lnz[2]+1L):length(lnz)])
      }
    }

    # Put YAML back in place --------------------------------------------------
    format_yml <- yaml::as.yaml(yml)
    format_yml <- gsub(": yes", ": true", format_yml, fixed = TRUE)
    format_yml <- gsub(": no", ": false", format_yml, fixed = TRUE)
    lnz <- c("---", gsub("\\n$", "", format_yml), lnz[delim_lnz[2]:length(lnz)])
    writeLines(lnz, filename)
  })
}

#' Add webexercises 'YAML' metadata
#'
#' Adds the necessary 'YAML' metadata to an existing 'Quarto' or 'Rmarkdown'
#' file.
#' @param filename The name of the file to edit.
#' @return No return value, called for side effects.
#' @export
#' @rdname add_to_quarto_file
add_to_quarto_file <- function(filename){
  add_latex_support(filename = filename)
  add_html_support(filename = filename)
}

#' @export
#' @rdname add_to_quarto_file
add_to_rmarkdown_file <- add_to_quarto_file
