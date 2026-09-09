## ----setup--------------------------------------------------------------------
library(testthat)
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

# Pretend we're snapshotting
snapper <- local_snapshotter(fail_on_new = FALSE)
snapper$start_file("snapshotting.Rmd", "test")

## -----------------------------------------------------------------------------
expect_df <- function(tbl) {
  expect_s3_class(tbl, "data.frame")
}

## -----------------------------------------------------------------------------
# from tidytext
expect_nrow <- function(tbl, n) {
  expect_s3_class(tbl, "data.frame")
  expect_equal(nrow(tbl), n)
}

## -----------------------------------------------------------------------------
try({
test_that("success", {
  expect_nrow(mtcars, 32)
})

test_that("failure 1", {
  expect_nrow(mtcars, 30)
})

test_that("failure 2", {
  expect_nrow(matrix(1:5), 2)
})
})

## -----------------------------------------------------------------------------
expect_length <- function(object, n) {  
  # 1. Capture object and label
  act <- quasi_label(rlang::enquo(object))
  
  act_n <- length(act$val)
  if (act_n != n) {
    # 2. Fail if expectations are violated
    fail(c(
      sprintf("Expected %s to have length %i.", act$lab, n),
      sprintf("Actual length: %i.", act_n)
    ))
  } else {
    # 3. Pass if expectations are met
    pass()
  }
  
  # 4. Invisibly return the input value
  invisible(act$val)
}

## -----------------------------------------------------------------------------
test_that("mtcars is a 13 row data frame", {
  mtcars |>
    expect_type("list") |>
    expect_s3_class("data.frame") |> 
    expect_length(11)
})

## -----------------------------------------------------------------------------
test_that("expect_length works as expected", {
  x <- 1:10
  expect_success(expect_length(x, 10))
  expect_failure(expect_length(x, 11))
})

test_that("expect_length gives useful feedback", {
  x <- 1:10
  expect_snapshot_failure(expect_length(x, 11))
})

## -----------------------------------------------------------------------------
expect_length(mean, 1)

## -----------------------------------------------------------------------------
expect_vector_length <- function(object, n) {  
  act <- quasi_label(rlang::enquo(object))

  # It's non-trivial to check if an object is a vector in base R so we
  # use an rlang helper
  if (!rlang::is_vector(act$val)) {
    fail(c(
      sprintf("Expected %s to be a vector", act$lab),
      sprintf("Actual type: %s", typeof(act$val))
    ))
  } else {
    act_n <- length(act$val)
    if (act_n != n) {
      fail(c(
        sprintf("Expected %s to have length %i.", act$lab, n),
        sprintf("Actual length: %i.", act_n)
      ))
    } else {
      pass()
    }
  }

  invisible(act$val)
}

## -----------------------------------------------------------------------------
try({
expect_vector_length(mean, 1)
expect_vector_length(mtcars, 15)
})

## -----------------------------------------------------------------------------
expect_s3_class <- function(object, class) {
  if (!rlang::is_string(class)) {
    rlang::abort("`class` must be a string.")
  }

  act <- quasi_label(rlang::enquo(object))

  if (!is.object(act$val)) {
    fail(sprintf("Expected %s to be an object.", act$lab))
  } else if (isS4(act$val)) {
    fail(c(
      sprintf("Expected %s to be an S3 object.", act$lab),
      "Actual OO type: S4"
    ))
  } else if (!inherits(act$val, class)) {
    fail(c(
      sprintf("Expected %s to inherit from %s.", act$lab, class),
      sprintf("Actual class: %s", class(act$val))
    ))
  } else {
    pass()
  }

  invisible(act$val)
}

## -----------------------------------------------------------------------------
try({
x1 <- 1:10
TestClass <- methods::setClass("Test", contains = "integer")
x2 <- TestClass()
x3 <- factor()

expect_s3_class(x1, "integer")
expect_s3_class(x2, "integer")
expect_s3_class(x3, "integer")
expect_s3_class(x3, "factor")
})

## -----------------------------------------------------------------------------
try({
expect_s3_class(x1, 1)
})

## -----------------------------------------------------------------------------
expect_s3_object <- function(object, class = NULL) {
  if (!rlang::is_string(class) && is.null(class)) {
    rlang::abort("`class` must be a string or NULL.")
  }

  act <- quasi_label(rlang::enquo(object))

  if (!is.object(act$val)) {
    fail(sprintf("Expected %s to be an object.", act$lab))
  } else if (isS4(act$val)) {
    fail(c(
      sprintf("Expected %s to be an S3 object.", act$lab),
      "Actual OO type: S4"
    ))
  } else if (!is.null(class) && !inherits(act$val, class)) {
    fail(c(
      sprintf("Expected %s to inherit from %s.", act$lab, class),
      sprintf("Actual class: %s", class(act$val))
    ))
  } else {
    pass()
  }

  invisible(act$val)
}

## -----------------------------------------------------------------------------
expect_length_ <- function(act, n, trace_env = caller_env()) {
  act_n <- length(act$val)
  if (act_n != n) {
    fail(
      sprintf("%s has length %i, not length %i.", act$lab, act_n, n), 
      trace_env = trace_env
    )
  } else {
    pass()
  }
}

expect_length <- function(object, n) {  
  act <- quasi_label(rlang::enquo(object))

  expect_length_(act, n)
  invisible(act$val)
}

