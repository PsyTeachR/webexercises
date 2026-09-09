library(reformulas)

varcor_us <- structure(
  list(
    Subject = structure(
      matrix(c(565.5, 11.1, 11.1, 32.7), 2, 2, 
             dimnames = list(c("(Intercept)", "Days"), c("(Intercept)", "Days"))),
      class = "vcmat_us",
      stddev = structure(c(23.78, 5.72), names = c("(Intercept)", "Days")),
      correlation = matrix(
        c(1, 0.0813, 0.0813, 1), 2, 2,
        dimnames = list(c("(Intercept)", "Days"), c("(Intercept)", "Days")))
    )
  ),
  sc = 25.6,
  useSc = TRUE,
  class = "VarCorr.merMod"
)

varcor_us_no_corr <- varcor_us
attr(varcor_us_no_corr$Subject, "correlation") = matrix(NaN)

glmmTMB.varcor_us <- varcor_us
class(glmmTMB.varcor_us) <- NULL
attr(glmmTMB.varcor_us$Subject, "blockCode") <- setNames(1, "us")

# varcor_cs
varcor_cs <- structure(
  list(
    Subject = structure(
      matrix(c(565.5, 11, 11, 32.7), 2, 2, 
             dimnames = list(
               c("(Intercept)", "Days"), c("(Intercept)", "Days"))),
      class = "vcmat_cs",
      stddev = structure(c(23.78, 5.72), names = c("(Intercept)", "Days")),
      correlation = matrix(
        c(1, 0.0813, 0.0813, 1), 2, 2,
        dimnames = list(c("(Intercept)", "Days"), c("(Intercept)", "Days")))
    )
  ),
  sc = 25.6,
  useSc = TRUE,
  class = "VarCorr.merMod"
)

varcor_cs_no_corr <- varcor_cs
attr(varcor_cs_no_corr$Subject, "correlation") = matrix(NaN)

glmmTMB.varcor_cs <- varcor_cs
class(glmmTMB.varcor_cs) <- NULL
attr(glmmTMB.varcor_cs$Subject, "blockCode") <- setNames(2, "cs")

# varcor_diag
varcor_diag <- structure(
  list(
    Subject = structure(
      matrix(c(584.3, 0, 0, 33.6), 2, 2, 
             dimnames = list(
               c("(Intercept)", "Days"), c("(Intercept)", "Days"))),
      class = "vcmat_diag",
      stddev = structure(c(24.2, 5.8), names = c("(Intercept)", "Days")),
      correlation = matrix(NaN)
    )
  ),
  sc = 25.6,
  useSc = TRUE,
  class = "VarCorr.merMod"
)

glmmTMB.varcor_diag <- varcor_diag
class(glmmTMB.varcor_diag) <- NULL
attr(glmmTMB.varcor_diag$Subject, "blockCode") <- setNames(0, "diag")

day_names <- paste0("Daysf", 0:2)
varcor_ar1 <- structure(
  list(
    Subject = structure(
      matrix(c(2127, 1872, 1648,
               1872, 2127, 1872,
               1648, 1872, 2127), 3, 3,
             dimnames = list(day_names, day_names)),
      class = "vcmat_ar1",
      stddev = structure(rep(46.1, 3), names = day_names),
      correlation = matrix(c(1.000, 0.880, 0.775,
                             0.880, 1.000, 0.880,
                             0.775, 0.880, 1.000), 3, 3,
                           dimnames = list(day_names, day_names))
    )
  ),
  sc = 14.6,
  useSc = TRUE,
  class = "VarCorr.merMod"
)

glmmTMB.varcor_ar1 <- varcor_ar1
class(glmmTMB.varcor_ar1) <- NULL
attr(glmmTMB.varcor_ar1$Subject, "blockCode") <- setNames(3, "ar1")


## test_that("formatVC printing works for lme4", {
  ## linear mixed models
  expected_summary_us <- matrix(
    c("Subject", "(Intercept)", "23.78", "", "",
      "", "Days", " 5.72", "0.081", "",
      "Residual", "", "25.60", "", ""),
    nrow = 3, byrow = TRUE,
    dimnames = list(c("", "", ""),
                    c("Groups", "Name", "Std.Dev.", "Corr", ""))
  )
  expected_summary_us_no_corr <- expected_summary_us[, 1:4]
  expected_summary_us_no_corr[2, "Corr"] <- ""
  expected_summary_us_no_corr[1, "Corr"] <- "(not stored)"
  
  expected_summary_cs <- matrix(
    c("Subject", "(Intercept)", "23.78", "0.081 (cs)",
      "", "Days", " 5.72", "",
      "Residual", "", "25.60", ""),
    nrow = 3, byrow = TRUE,
    dimnames = list(c("", "", ""),
                    c("Groups", "Name", "Std.Dev.", "Corr"))
  )
  expected_summary_cs_no_corr <- expected_summary_cs
  expected_summary_cs_no_corr[1, "Corr"] <- "(not stored) (cs)"
  
  expected_summary_diag <- matrix(
    c("Subject", "(Intercept)", "24.2",
      "", "Days", " 5.8",
      "Residual", "", "25.6"),
    nrow = 3, byrow = TRUE,
    dimnames = list(c("", "", ""),
                    c("Groups", "Name", "Std.Dev."))
  )
  
  expected_summary_ar1 <- matrix(
    c("Subject", "Daysf0", "46.1", "0.880 (ar1)",
      "Residual", "", "14.6", ""),
    nrow = 2, byrow = TRUE,
    dimnames = list(c("", ""),
                    c("Groups", "Name", "Std.Dev.", "Corr"))
  )
  
  ## running the standard printing tests
  expect_equal(formatVC(varcor_us), expected_summary_us)
  expect_equal(formatVC(varcor_cs), expected_summary_cs)
  expect_equal(formatVC(varcor_diag), expected_summary_diag)
  expect_equal(formatVC(varcor_ar1), expected_summary_ar1)
  ## running the tests where there's no covariance matrix (ensuring no bug)
  expect_equal(formatVC(varcor_us_no_corr), expected_summary_us_no_corr)
  expect_equal(formatVC(varcor_cs_no_corr), expected_summary_cs_no_corr)
  ## running tests for glmmTMB objects
  expect_equal(formatVC(glmmTMB.varcor_us), expected_summary_us)
  expect_equal(formatVC(glmmTMB.varcor_cs), expected_summary_cs)
  expect_equal(formatVC(glmmTMB.varcor_diag), expected_summary_diag)
  expect_equal(formatVC(glmmTMB.varcor_ar1), expected_summary_ar1)

# TODO: should add tests for glmms once we have an idea how we want to 
# print them
