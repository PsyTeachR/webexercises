# Extracted from test-mcq.R:8

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "webexercises", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
html <- mcq(c(answer="will", "won't", "might"))
expect_equal(grep("<option value=''>won't</option>", html, fixed = TRUE), 1L)
