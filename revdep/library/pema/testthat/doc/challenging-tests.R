## -----------------------------------------------------------------------------
library(testthat)
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

# Pretend we're snapshotting
snapper <- local_snapshotter(fail_on_new = FALSE)
snapper$start_file("snapshotting.Rmd", "test")

# Pretend we're testing testthat so we can use mocking
Sys.setenv(TESTTHAT_PKG = "testthat")

## -----------------------------------------------------------------------------
dice <- function() {
  sample(6, 1)
}

test_that("dice returns different numbers", {
  withr::local_seed(1234)

  expect_equal(dice(), 4)
  expect_equal(dice(), 2)
  expect_equal(dice(), 6)
})

## -----------------------------------------------------------------------------
roll_three <- function() {
  sum(dice(), dice(), dice())
}

test_that("three dice adds values of individual calls", {
  local_mocked_bindings(dice = mock_output_sequence(1, 2, 3))
  expect_equal(roll_three(), 6)
})

## -----------------------------------------------------------------------------
continue <- function(prompt) {
  cat(prompt, "\n", sep = "")

  repeat {
    val <- readline("Do you want to continue? (y/n) ")
    if (val %in% c("y", "n")) {
      return(val == "y")
    }
    cat("! You must enter y or n\n")
  }  
}

readline <- NULL

## -----------------------------------------------------------------------------
test_that("user must respond y or n", {
  mock_readline <- local({
    i <- 0
    function(prompt) {
      i <<- i + 1
      cat(prompt)
      val <- if (i == 1) "x" else "y"
      cat(val, "\n", sep = "")
      val
    }
  })

  local_mocked_bindings(readline = mock_readline)
  expect_snapshot(val <- continue("This is dangerous"))
  expect_true(val)
})

## -----------------------------------------------------------------------------
f <- mock_output_sequence(1, 12, 123)
f()
f()
f()

## -----------------------------------------------------------------------------
test_that("user must respond y or n", {
  local_mocked_bindings(readline = mock_output_sequence("x", "y"))
  expect_true(continue("This is dangerous"))
})

## -----------------------------------------------------------------------------
save_file <- function(path, data) {
  if (file.exists(path)) {
    if (!continue("`path` already exists")) {
      stop("Failed to continue")
    }
  }
  writeLines(data, path)
}

test_that("save_file() requires confirmation to overwrite file", {
  path <- withr::local_tempfile(lines = letters)

  local_mocked_bindings(continue = function(...) TRUE)
  save_file(path, "a")
  expect_equal(readLines(path), "a")

  local_mocked_bindings(continue = function(...) FALSE)
  expect_snapshot(save_file(path, "a"), error = TRUE)
})

