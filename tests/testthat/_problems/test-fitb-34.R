# Extracted from test-fitb.R:34

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
expect_equal(
    fitb("x", width = 5), 
    "<input class='webex-solveme nospaces' size='5' data-answer='[\"x\"]'/>"
  )
expect_equal(
    fitb(0.5), 
    "<input class='webex-solveme nospaces' size='3' data-answer='[\"0.5\",\".5\"]'/>"
  )
expect_equal(
    fitb(0.5, num = FALSE), 
    "<input class='webex-solveme nospaces' size='3' data-answer='[\"0.5\"]'/>"
  )
