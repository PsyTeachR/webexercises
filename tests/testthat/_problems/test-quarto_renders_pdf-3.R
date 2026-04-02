# Extracted from test-quarto_renders_pdf.R:3

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "webexercises", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
skip_if_not_pandoc("2.0")
skip_if_no_quarto()
