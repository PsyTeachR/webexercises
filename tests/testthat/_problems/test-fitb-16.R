# Extracted from test-fitb.R:16

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "webexercises", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
expect_equal(
    fitb("x"), 
    "<input class='webex-solveme nospaces' size='1' data-answer='[\"x\"]'/>"
  )
expect_equal(
    fitb(c("x", "y")), 
    "<input class='webex-solveme nospaces' size='1' data-answer='[\"x\",\"y\"]'/>"
  )
