# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(theorytools)
skip_if_no_python <- function() {
  if (!reticulate::py_module_available("transformers") |
      !reticulate::py_module_available("numpy") |
      !reticulate::py_module_available("torch")){
    skip("Python dependencies not available for testing")
  }
}
test_check("theorytools")
