#' Add webexercises helper files to quarto
#'
#' Adds the necessary helper files to an existing quarto project and
#' edits the _quarto.yml file accordingly. A demo file for webexercises
#' will be added and optionally rendered.
#'
#' @param quarto_dir The base directory for your quarto project
#' @param include_dir The directory where you want to put the css and
#'   js files (defaults to "include")
#' @param script_dir The directory where you want to put the .R script
#'   (defaults to "R")
#' @param output_format The format you want to add
#'   webexercises to (only html for now)
#' @param render Whether to render the book after updating (defaults to FALSE).
#'
#' @return No return value, called for side effects.
#' @export
#'
add_to_quarto <- function(quarto_dir = ".",
                          include_dir = "include",
                          script_dir = "R",
                          output_format = c("html"),
                          render = FALSE) {
  # check inputs
  if (quarto_dir == "") bookdown_dir <- "."
  if (include_dir == "") include_dir <- "."
  if (script_dir == "") script_dir <- "."
  output_format <- match.arg(output_format)

  # get helper files
  css <- system.file("reports/default/webex.css", package = "webexercises")
  js <- system.file("reports/default/webex.js", package = "webexercises")
  script <- system.file("reports/default/webex.R", package = "webexercises")
  index <- system.file("reports/default/index.qmd", package = "webexercises")

  # make sure include and script directories exist
  incdir <- file.path(quarto_dir, include_dir)
  dir.create(path = incdir, showWarnings = FALSE, recursive = TRUE)

  rdir <- file.path(quarto_dir, script_dir)
  dir.create(path = rdir, showWarnings = FALSE, recursive = TRUE)

  # add or update helper files
  file.copy(css, incdir, overwrite = TRUE)
  file.copy(js, incdir, overwrite = TRUE)
  file.copy(script, rdir, overwrite = TRUE)
  message("webex.css, webex.js, and webex.R updated")

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
  yaml::write_yaml(yml, quarto_file)
  message(quarto_file, " updated")

  # add setup script to .Rprofile
  rprofile <- file.path(quarto_dir, ".Rprofile")
  source <- paste0('source("', script_dir, '/webex.R")')
  write(source, rprofile, append = TRUE)

  # add webexercises file
  webex_path <- file.path(quarto_dir, "webexercises.qmd")
  file.copy(index, webex_path, overwrite = FALSE)
  webex_file <- readLines(webex_path)
  webex_file <- sapply(webex_file, gsub,
                       pattern = "webex.R",
                       replacement = file.path(script_dir, "webex.R"),
                       fixed = TRUE, USE.NAMES = FALSE)
  webex_file <- sapply(webex_file, gsub,
                       pattern = "webex.css",
                       replacement = css_path,
                       fixed = TRUE, USE.NAMES = FALSE)
  webex_file <- sapply(webex_file, gsub,
                       pattern = "webex.js",
                       replacement = js_path,
                       fixed = TRUE, USE.NAMES = FALSE)
  write(webex_file, webex_path)

  # render and open site
  if (isTRUE(render)) {
    if (!requireNamespace("quarto", quietly = TRUE)) {
      stop("Package \"quarto\" needed for this function to work. Please install it.",
           call. = FALSE)
    }
    if (!requireNamespace("xfun", quietly = TRUE)) {
      stop("Package \"xfun\" needed for this function to work. Please install it.",
           call. = FALSE)
    }

    xfun::in_dir(quarto_dir, quarto::quarto_render(
      input = "webexercises.qmd",
      output_format = output_format
    ))

    utils::browseURL(file.path(quarto_dir, "webexercises.html"))
  }

  invisible(NULL)
}
