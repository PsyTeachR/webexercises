# Extracted from test-longmcq.R:7

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "webexercises", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
html <- longmcq(c(answer="will", "won't", "might"))
expect_equal(grep("<span>won&apos;t</span>", html, fixed = TRUE), 1L)
