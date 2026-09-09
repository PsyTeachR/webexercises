test_that("intercept and beta are parsed out", {
  expect_equal(as.character(theorytools:::edges_to_analysisfun(
    data.frame(form =
    "0.5+2*X+Y"))[2]),
    "X + Y")
  expect_equal(as.character(theorytools:::edges_to_analysisfun(
    data.frame(form =
                 "-5-0.2*X+Y"))[2]),
    "X + Y")
  expect_equal(as.character(theorytools:::edges_to_analysisfun(
    data.frame(form =
                 "-0.5+0.2*X+Y"))[2]),
    "X + Y")
  expect_equal(as.character(theorytools:::edges_to_analysisfun(
    data.frame(form =
                 "-0.5+-0.2*X+Y"))[2]),
    "X + Y")
  expect_equal(as.character(theorytools:::edges_to_analysisfun(
    data.frame(form =
                 "+0.5+-0.2*X+Y"))[2]),
    "X + Y")
})


test_that("intercept of -1 is retained in formula", {
  f1 <- terms(theorytools:::edges_to_analysisfun(
    data.frame(form =
                 "-1+2*X+Y")))
  f2 <- terms(as.formula("~-1+X+Y"))
  expect_equal(attr(f1,"term.labels"), attr(f2,"term.labels"))
  expect_equal(attr(f1,"intercept"), attr(f2,"intercept"))


  f1 <- terms(theorytools:::edges_to_analysisfun(
    data.frame(form =
                 "-.5+0.3*X*Y")))
  f2 <- terms(as.formula("~X+Y+X:Y"))
  expect_equal(attr(f1,"term.labels"), attr(f2,"term.labels"))
  expect_equal(attr(f1,"intercept"), attr(f2,"intercept"))

  f1 <- terms(theorytools:::edges_to_analysisfun(
    data.frame(form =
                 "-0.3*X*Y")))
  f2 <- terms(as.formula("~X+Y+X:Y"))
  expect_equal(attr(f1,"term.labels"), attr(f2,"term.labels"))
  expect_equal(attr(f1,"intercept"), attr(f2,"intercept"))

})

test_that("betas from complex formulas are parsed correctly", {

f1 <- terms(theorytools:::edges_to_analysisfun(
  data.frame(form =
               ".5 * I(A^2)")))
f2 <- terms(as.formula("~I(A^2)"))
expect_equal(attr(f1,"term.labels"), attr(f2,"term.labels"))
expect_equal(attr(f1,"intercept"), attr(f2,"intercept"))

})
