library(reformulas)
if (requireNamespace("Formula")) {
  form <- lwage ~ ns(exp, df = 3) | blk
  attr(form, "lhs") <- quote(lwage)
  attr(form, "rhs") <- list(quote(ns(exp, df = 3)), quote(blk))
  form <- Formula::as.Formula(form)
  expect_null(findbars_x(form, target = "||", default.special = NULL))
}
