## -----------------------------------------------------------------------------
library(testthat)
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

# Pretend we're snapshotting
snapper <- local_snapshotter(fail_on_new = FALSE)
snapper$start_file("snapshotting.Rmd", "test")

# Pretend we're testing testthat so we can use mocking
Sys.setenv(TESTTHAT_PKG = "testthat")

## -----------------------------------------------------------------------------
check_installed <- function(pkg, min_version = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(sprintf("{%s} is not installed.", pkg))
  }
  if (!is.null(min_version)) {
    pkg_version <- packageVersion(pkg)
    if (pkg_version < min_version) {
      stop(sprintf(
        "{%s} version %s is installed, but %s is required.", 
        pkg, 
        pkg_version, 
        min_version
      ))
    }
  }

  invisible()
}

## -----------------------------------------------------------------------------
test_that("check_installed() checks package is installed", {
  expect_no_error(check_installed("testthat"))
  expect_snapshot(check_installed("doesntexist"), error = TRUE)
})

## -----------------------------------------------------------------------------
test_that("check_installed() checks minimum version", {
  expect_no_error(check_installed("testthat", "1.0.0"))
  expect_snapshot(check_installed("testthat", "99.99.999"), error = TRUE)
})

## -----------------------------------------------------------------------------
test_that("check_installed() checks minimum version", {
  expect_no_error(check_installed("testthat", "1.0.0"))
  expect_snapshot(
    check_installed("testthat", "99.99.999"), 
    error = TRUE, 
    transform = function(lines) gsub(packageVersion("testthat"), "<version>", lines)
  )
})

## -----------------------------------------------------------------------------
requireNamespace <- NULL
packageVersion <- NULL

## -----------------------------------------------------------------------------
test_that("check_installed() checks package is installed", {
  local_mocked_bindings(requireNamespace = function(...) TRUE)
  expect_no_error(check_installed("package-name"))

  local_mocked_bindings(requireNamespace = function(...) FALSE)
  expect_snapshot(check_installed("package-name"), error = TRUE)
})

## -----------------------------------------------------------------------------
test_that("check_installed() checks minimum version", {
  local_mocked_bindings(
    requireNamespace = function(...) TRUE,
    packageVersion = function(...) numeric_version("2.0.0")
  )
  
  expect_no_error(check_installed("package-name", "1.0.0"))
  expect_snapshot(check_installed("package-name", "3.4.5"), error = TRUE)
})

## -----------------------------------------------------------------------------
system_os <- NULL

## -----------------------------------------------------------------------------
# test_that("can skip on multiple oses", {
#   local_mocked_bindings(system_os = function() "windows")
# 
#   expect_skip(skip_on_os("windows"))
#   expect_skip(skip_on_os(c("windows", "linux")))
#   expect_no_skip(skip_on_os("linux"))
# })

## -----------------------------------------------------------------------------
# local_mocked_bindings(
#   get_revdeps = function() character(),
#   gh_milestone_number = function(...) NA
# )

## -----------------------------------------------------------------------------
unix_time <- function() unclass(Sys.time())
unix_time()

## -----------------------------------------------------------------------------
elapsed <- function() {
  start <- unix_time()
  function() {
    unix_time() - start
  }
}

timer <- elapsed()
Sys.sleep(0.5)
timer()

## -----------------------------------------------------------------------------
test_that("elapsed() measures elapsed time", {
  time <- 1
  local_mocked_bindings(unix_time = function() time)

  timer <- elapsed()
  expect_equal(timer(), 0)

  time <- 2
  expect_equal(timer(), 1)
})

## -----------------------------------------------------------------------------
# old <- getFromNamespace("my_function", "mypackage")
# assignInNamespace("my_function", new, "mypackage")
# 
# # run the test...
# 
# # restore the previous value
# assignInNamespace("my_function", old, "mypackage")

