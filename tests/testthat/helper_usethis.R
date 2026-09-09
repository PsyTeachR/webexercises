skip_if_not_pandoc <- function(ver = NULL) {
  if (!rmarkdown::pandoc_available(ver)) {
    msg <- if (is.null(ver)) {
      "Pandoc is not available"
    } else {
      sprintf("Version of Pandoc is lower than %s.", ver)
    }
    skip(msg)
  }
}

scoped_tempdir <- function (code){

  new <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = "")
  dir.create(new)
  on.exit(unlink(new, recursive = TRUE), add = TRUE)
  old <- setwd(dir = new)
  on.exit(setwd(old))
  force(code)
}
