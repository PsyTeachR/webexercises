#' Create a quarto document with webexercise
#'
#' Creates a new directory with the file name and copies in a demo qmd file and the necessary helper files.
#'
#' @param name Name of the new document
#' @param open Whether to open the document in RStudio
#'
#' @return The file path to the document
#' @export
#'
create_quarto_doc <- function(name = "Untitled", open = interactive()) {
  if (!file.exists(name)) dir.create(name, FALSE, TRUE)
  path <- normalizePath(name)
  filepath <- file.path(path, paste0(basename(name), ".qmd"))

  # get helper files
  css <- system.file("reports/default/webex.css", package = "webexercises")
  js <- system.file("reports/default/webex.js", package = "webexercises")
  index <- system.file("reports/default/index.qmd", package = "webexercises")

  file.copy(css, path)
  file.copy(js, path)
  file.copy(index, filepath)

  if (open) rstudioapi::documentOpen(filepath)

  invisible(filepath)
}
