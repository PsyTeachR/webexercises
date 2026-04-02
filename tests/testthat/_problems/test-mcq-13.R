# Extracted from test-mcq.R:13

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "webexercises", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
html <- mcq(c(answer="library(\"dplyr\")", "library(tidyr)"))
expect_equal(grep("<option value='answer'>library(\"dplyr\")</option>", html, fixed = TRUE), 1L)
