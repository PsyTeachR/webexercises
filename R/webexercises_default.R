#' Create default webexercises document
#'
#' This function wraps \code{rmarkdown::html_document} to configure
#' compilation to embed the default webexercises CSS and JavaScript files in
#' the resulting HTML.
#'
#' @details Call this function as the \code{output_format} argument
#'   for the \code{\link[rmarkdown]{render}} function when compiling
#'   HTML documents from RMarkdown source.
#'
#' @param ... Additional function arguments to pass to
#'   \code{\link[rmarkdown]{html_document}}.
#'
#' @return R Markdown output format to pass to 'render'.
#'
#' @seealso \code{\link[rmarkdown]{render}}, \code{\link[rmarkdown]{html_document}}
#'
#' @examples
#' # copy the webexercises 'R Markdown' template to a temporary file
#' \dontrun{
#' my_rmd <- tempfile(fileext = ".Rmd")
#' rmarkdown::draft(my_rmd, "webexercises", "webexercises")
#'
#' # compile it
#' rmarkdown::render(my_rmd, webexercises::webexercises_default())
#'
#' # view the result
#' browseURL(sub("\\.Rmd$", ".html", my_rmd))
#' }
#' @export
webexercises_default <- function(...) {
  css <- system.file("reports/default/webex.css", package = "webexercises")
  js <- system.file("reports/default/webex.js", package = "webexercises")

  setup_hide_knithook()

  # smart quotes changed in rmarkdown 2.2 / pandoc 2.0.6
  rmarkdown::pandoc_available(version = "2.0.6", error = TRUE)

  rmarkdown::html_document(css = css,
                           includes = rmarkdown::includes(after_body = js),
                           md_extensions = "-smart",
                           ...)
}


setup_hide_knithook <- function() {
  knitr::knit_hooks$set(webex.hide = function(before, options, envir) {
    if (before) {
      if (is.character(options$webex.hide)) {
        hide(options$webex.hide)
      } else {
        hide()
      }
    } else {
      unhide()
    }
  })

  invisible()
}
