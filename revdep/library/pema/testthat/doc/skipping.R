## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(testthat)

## -----------------------------------------------------------------------------
# # Only run test if a token file is available
# skip_if_not(file.exists("secure-token.json"))
# 
# # Only run test if R has memory profiling capabilities
# skip_if_not(capabilities("profmem"))
# 
# # Only run if we've opted-in to slow tests with an env var
# skip_if(Sys.getenv("RUN_SLOW_TESTS") == "true")

## -----------------------------------------------------------------------------
skip_if_dangerous <- function() {
  if (!identical(Sys.getenv("DANGER"), "")) {
    skip("Not run in dangerous environments.")
  } else {
    invisible()
  }
}

## ----eval = FALSE-------------------------------------------------------------
# convert_markdown_to_html <- function(in_path, out_path, ...) {
#   if (rmarkdown::pandoc_available("2.0")) {
#     from <- "markdown+gfm_auto_identifiers-citations+emoji+autolink_bare_uris"
#   } else if (rmarkdown::pandoc_available("1.12.3")) {
#     from <- "markdown_github-hard_line_breaks+tex_math_dollars+tex_math_single_backslash+header_attributes"
#   } else {
#     if (is_testing()) {
#       testthat::skip("Pandoc not available")
#     } else {
#       abort("Pandoc not available")
#     }
#   }
# 
#   ...
# }

## -----------------------------------------------------------------------------
is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

