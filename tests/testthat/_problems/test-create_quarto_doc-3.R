# Extracted from test-create_quarto_doc.R:3

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "webexercises", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
skip_if_no_quarto()
