#' Add webexercises helper files to pkgdown
#'
#' Adds the necessary helper files to an existing pkgdown project.
#'
#' @param pkgdown_dir The base directory for your pkgdown project
# @param include_dir The directory where you want to put the css and
#   js files (defaults to "pkgdown")
#' @return No return value, called for side effects.
#' @importFrom yaml read_yaml write_yaml
#' @export
add_to_pkgdown <- function(pkgdown_dir = "."){
  if(!requireNamespace("pkgdown", quietly = TRUE)){
    return(NULL)
  }
  usethis::with_project(pkgdown_dir, {
    css <- system.file("reports/default/webex.css", package = "webexercises")
    css_lines <- readLines(css)
    js <- system.file("reports/default/webex.js", package = "webexercises")
    js_lines <- readLines(js)
    js_lines <- js_lines[-grep("</?script>", js_lines)]
    include_dir <- "pkgdown"
    if(!dir.exists(file.path(include_dir))){
      dir.create(file.path(include_dir))
    }
    # Write extra.css
    if(file.exists(file.path(include_dir, "extra.css"))){
      css_existing <- readLines(file.path(include_dir, "extra.css"))
      if(!any(grepl("webex-check", css_existing, fixed = TRUE))){
        writeLines(c(css_existing, css_lines), file.path(include_dir, "extra.css"))
      }
    } else {
      writeLines(css_lines, file.path(include_dir, "extra.css"))
    }
    # Write extra.js
    if(file.exists(file.path(include_dir, "extra.js"))){
      js_existing <- readLines(file.path(include_dir, "extra.js"))
      if(!any(grepl("webex-solution", js_existing, fixed = TRUE))){
        writeLines(c(js_existing, js_lines), file.path(include_dir, "extra.js"))
      }
    } else {
      writeLines(js_lines, file.path(include_dir, "extra.js"))
    }

    # Write extra.js
    if(file.exists(file.path("_pkgdown.yml"))){
      pkgdown_location <- file.path("_pkgdown.yml")
    } else {
      if(file.exists(file.path(include_dir, "_pkgdown.yml"))){
        pkgdown_location <- file.path("_pkgdown.yml")
      } else {
        stop("No _pkgdown.yml found.")
      }
    }
    yml_existing <- yaml::read_yaml(pkgdown_location)
    if(!is.null(yml_existing[["template"]][["include"]][["after_body"]])){
      if(!grepl("extra.js", yml_existing[["template"]][["include"]][["after_body"]])){
        yml_existing[["template"]][["include"]][["after_body"]] <- paste0(yml_existing[["template"]][["include"]][["after_body"]], '<script scr="extra.js"></script>')
      }
    } else {
      yml_existing[["template"]][["include"]][["after_body"]] <- '<script scr="extra.js"></script>'
    }
    yaml::write_yaml(yml_existing, pkgdown_location)
    pkgdown::init_site()
  })

  invisible(NULL)
}


#' Create a webexercises vignette
#'
#' Wraps \link[usethis]{use_vignette} to add a vignette or article to
#' `vignettes/` with support for `webexercises`.
#' @param name Atomic character, vignette name. See
#' \link[usethis]{use_vignette}.
#' @param title Atomic character, vignette title. See
#' \link[usethis]{use_vignette}.
#' @param type Atomic character, one of `c("vignette", "article")`, defaults to
#' `"vignette"`.
#' @return Returns `NULL` invisibly, called for its side effects.
#' @export
#' @examples
#' \dontrun{
#' use_webex_vignette("vignette_with_quiz.Rmd", "Quiz people with webexercises")
#' }
use_webex_vignette <- function(name, title = NULL, type = c("vignette", "article")){
  type <- type[1]
  if(!type %in% c("vignette", "article")){
    cli_msg("i" = 'Argument {.code type} must be one of {.code c("vignette", "article")}, not {.val {type}}.')
    return(invisible())
  }
  f <- list.files(path = "vignettes/", pattern = "(rmd|qmd)", ignore.case = TRUE, full.names = TRUE)
  switch(type,
         "vignette" = usethis::use_vignette(name = name, title = title),
         "article" = usethis::use_article(name = name, title = title)
         )
  f_new <- list.files(path = "vignettes/", pattern = "(rmd|qmd)", ignore.case = TRUE, full.names = TRUE)
  fnam <- setdiff(f_new, f)
  linz <- readLines(fnam)
  linz[startsWith(linz, "output:")] <- "output: webexercises::webex_vignette"
  linz <- c(linz, "", "```{r eval=knitr::is_html_output(), results='asis', echo=FALSE}",
            "# This quiz is only shown in HTML output format",
            "webexercises::quiz(",
            "\"The answer to this question is true.\" = TRUE,",
            "\"This multiple choice question has three answers.\" =",
            "c(\"Correct\", \"Incorrect\", \"Not sure\"),",
            "\"Provide an exact floating point answer of 0.81\" = 0.81",
            "\"Or give some wiggle room\" = c(0.81, .1)",
            "\"How many words in this sentence\" = 6L",
            ")", "```")
  writeLines(linz, fnam)
  return(invisible())
}
