test_that("formulas expand correctly", {
  expect_equal(theorytools:::expand_formula(f = "a*b"), "a + b + a:b")
  expect_equal(theorytools:::expand_formula(f = "(a+b+c)^2"), theorytools:::expand_formula(f = "(a+b+c)*(a+b+c)"))
  expect_equal(theorytools:::expand_formula("a + b %in% a"), "a + a:b")
  expect_equal(theorytools:::expand_formula("a / b"), theorytools:::expand_formula("a + b %in% a"))
  expect_equal(theorytools:::expand_formula("(a+b+c)^2 - a:b"), theorytools:::expand_formula("a + b + c + a:c + b:c"))
  expect_equal(theorytools:::expand_formula("log(a)"), "log(a)")
  expect_equal(theorytools:::expand_formula("I(log(a))"), "I(log(a))")
  expect_equal(theorytools:::expand_formula("a + I(b+c)"), "a + I(b + c)")

})
