#' Add webexercises helper files to quarto
#'
#' Adds the necessary helper files to an existing quarto project and
#' edits the _quarto.yml file accordingly. A demo file for webexercises
#' will be added and optionally rendered.
#'
#' @param quarto_dir The base directory for your quarto project
#' @param include_dir The directory where you want to put the css and
#'   js files (defaults to "include")
#' @param output_format The format you want to add
#'   webexercises to (only html for now)
#'
#' @return No return value, called for side effects.
#' @export
#'
add_to_quarto <- function(quarto_dir = ".",
                          include_dir = "include",
                          output_format = c("html")) {
  # check inputs
  if (quarto_dir == "") quarto_dir <- "."
  if (include_dir == "") include_dir <- "."
  output_format <- match.arg(output_format)

  # get helper files
  css <- system.file("reports/default/webex.css", package = "webexercises")
  js <- system.file("reports/default/webex.js", package = "webexercises")
  demo <- system.file("reports/default/webexercises.qmd", package = "webexercises")

  # make sure include and script directories exist
  incdir <- file.path(quarto_dir, include_dir)
  dir.create(path = incdir, showWarnings = FALSE, recursive = TRUE)

  # add or update helper files
  file.copy(css, incdir, overwrite = TRUE)
  file.copy(js, incdir, overwrite = TRUE)
  file.copy(demo, quarto_dir, overwrite = TRUE)
  message("webex.css, webex.js, and webexercises.qmd updated")

  # update or create _quarto.yml
  css_path <- file.path(include_dir, "webex.css")
  js_path <- file.path(include_dir, "webex.js")
  quarto_defaults <- list(
    "html" = list(
      "css" = css_path,
      "include-after-body" = js_path
    )
  )

  quarto_file <- file.path(quarto_dir, "_quarto.yml")
  if (!file.exists(quarto_file)) {
    # add new format with reasonable defaults
    yml <- list()
    yml[[output_format]] <- quarto_defaults[[output_format]]
  } else {
    # keep default yml
    yml <- yaml::read_yaml(quarto_file)
    if ( !is.list(yml$format) || !"format" %in% names(yml)) {
      yml$format <- list()
    }

    if (!output_format %in% names(yml$format)) {
      # append output_format
      yml$format[[output_format]] <- quarto_defaults[[output_format]]
    }
  }

  # get previous values
  old_css <- yml$format[[output_format]]$css
  old_js <- yml$format[[output_format]]$`include-after-body`

  # merge with new values
  yml$format[[output_format]]$css <- union(old_css, css_path)
  yml$format[[output_format]]$`include-after-body` <- union(old_js, js_path)

  # write to _quarto.yml
  # custom handler to stop converting boolean values to yes and no
  yaml::write_yaml(yml, quarto_file, handlers = list(
    logical = function(x) {
      result <- ifelse(x, "true", "false")
      class(result) <- "verbatim"
      return(result)
    }
  ))
  message(quarto_file, " updated")

  # update .Rprofile
  rprofile <- file.path(quarto_dir, ".Rprofile")

  load_txt <- "# load webexercises before each chapter
# needs to check namespace to not bork github actions
if (requireNamespace('webexercises', quietly = TRUE)) library(webexercises)"
  write(load_txt, rprofile, append = TRUE)

  invisible(NULL)
}
