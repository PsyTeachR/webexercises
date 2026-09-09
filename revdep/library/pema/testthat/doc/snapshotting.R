## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
set.seed(1014)

## ----setup--------------------------------------------------------------------
library(testthat)

## ----include = FALSE----------------------------------------------------------
snapper <- local_snapshotter(fail_on_new = FALSE)
snapper$start_file("snapshotting.Rmd", "test")

## -----------------------------------------------------------------------------
bullets <- function(text, id = NULL) {
  paste0(
    "<ul", if (!is.null(id)) paste0(" id=\"", id, "\""), ">\n", 
    paste0("  <li>", text, "</li>\n", collapse = ""),
    "</ul>\n"
  )
}
cat(bullets("a", id = "x"))

## -----------------------------------------------------------------------------
test_that("bullets", {
  expect_equal(bullets("a"), "<ul>\n  <li>a</li>\n</ul>\n")
  expect_equal(bullets("a", id = "x"), "<ul id=\"x\">\n  <li>a</li>\n</ul>\n")
})

## -----------------------------------------------------------------------------
test_that("bullets", {
  expect_snapshot(cat(bullets("a")))
  expect_snapshot(cat(bullets("a", "b")))
})

## ----include = FALSE----------------------------------------------------------
# Reset snapshot test
snapper$end_file()
snapper$start_file("snapshotting.Rmd", "test")

## -----------------------------------------------------------------------------
test_that("bullets", {
  expect_snapshot(cat(bullets("a")))
  expect_snapshot(cat(bullets("a", "b")))
})

## -----------------------------------------------------------------------------
# finalise snapshot to in order to get an error
snapper$end_file()
snapper$start_file("snapshotting.Rmd", "test")

## ----error = TRUE-------------------------------------------------------------
try({
bullets <- function(text, id = NULL) {
  paste0(
    "<ul", if (!is.null(id)) paste0(" id=\"", id, "\""), ">\n", 
    paste0("<li>", text, "</li>\n", collapse = ""),
    "</ul>\n"
  )
}
test_that("bullets", {
  expect_snapshot(cat(bullets("a")))
  expect_snapshot(cat(bullets("a", "b")))
})
})

## -----------------------------------------------------------------------------
try({
test_that("you can't add a number and a letter", {
  expect_snapshot(1 + "a")
})
})

## -----------------------------------------------------------------------------
test_that("you can't add a number and a letter", {
  expect_snapshot(1 + "a", error = TRUE)
})

## -----------------------------------------------------------------------------
test_that("you can't add weird things", {
  expect_snapshot(error = TRUE, {
    1 + "a"
    mtcars + iris
    Sys.Date() + factor()
  })
})

## -----------------------------------------------------------------------------
check_unnamed <- function(..., call = parent.frame()) {
  names <- ...names()
  has_name <- names != ""
  if (!any(has_name)) {
    return(invisible())
  }

  named <- names[has_name]
  cli::cli_abort(
    c(
      "All elements of {.arg ...} must be unnamed.",
      i = "You supplied argument{?s} {.arg {named}}."
    ), 
    call = call
  )
}

test_that("no errors if all arguments unnamed", {
  expect_no_error(check_unnamed())
  expect_no_error(check_unnamed(1, 2, 3))
})

test_that("actionable feedback if some or all arguments named", {
  expect_snapshot(error = TRUE, {
    check_unnamed(x = 1, 2)
    check_unnamed(x = 1, y = 2)
  })
})

## -----------------------------------------------------------------------------
safe_write_lines <- function(lines, path, overwrite = FALSE) {
  if (file.exists(path) && !overwrite) {
    cli::cli_abort(c(
      "{.path {path}} already exists.", 
      i = "Set {.code overwrite = TRUE} to overwrite"
    ))
  }

  writeLines(lines, path)
}

## -----------------------------------------------------------------------------
snapper$end_file()
snapper$start_file("snapshotting.Rmd", "safe-write-lines")

## -----------------------------------------------------------------------------
test_that("generates actionable error message", {
  path <- withr::local_tempfile(lines = "")
  expect_snapshot(safe_write_lines(letters, path), error = TRUE)
})

## -----------------------------------------------------------------------------
snapper$end_file()
snapper$start_file("snapshotting.Rmd", "safe-write-lines")

## -----------------------------------------------------------------------------
try({
test_that("generates actionable error message", {
  path <- withr::local_tempfile(lines = "")
  expect_snapshot(safe_write_lines(letters, path), error = TRUE)
})
})

## -----------------------------------------------------------------------------
snapper$end_file()
snapper$start_file("snapshotting.Rmd", "test-2")

## -----------------------------------------------------------------------------
test_that("generates actionable error message", {
  path <- withr::local_tempfile(lines = "")
  expect_snapshot(
    safe_write_lines(letters, path), 
    error = TRUE,
    transform = \(lines) gsub(path, "<path>", lines, fixed = TRUE)
  )
})

## -----------------------------------------------------------------------------
test_that("can snapshot a simple list", {
  x <- list(a = list(1, 5, 10), b = list("elephant", "banana"))
  expect_snapshot_value(x)
})

## -----------------------------------------------------------------------------
knitr::include_graphics("review-image.png")

## -----------------------------------------------------------------------------
knitr::include_graphics("review-text.png")

