test_that("formulas merged correctly", {
  expect_equal(theorytools:::merge_formulas("a:b+c:d+e:f", "a:b", "c:d", "e*f"), theorytools:::merge_formulas("a:b+c:d+e:f", "a:b", "c:d", "e+f+e:f"))
  expect_equal(theorytools:::merge_formulas("a*b", "a:b"), theorytools:::merge_formulas("a*b", "a"))
  expect_equal(theorytools:::merge_formulas("a+b+a:b", "a:b"), theorytools:::merge_formulas("a*b", "a"))
})

# f1 <- "x"
# f2 <- "x+y"
# Deriv::Simplify(paste0(f1, "+", f2))
# paste0(Deriv::Simplify(paste0(f2, "-", f1)), "+", Deriv::Simplify(paste0(f1, "-", f2)))
