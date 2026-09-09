data("curry")
df <- curry[c(1:5, 50:55), c("d", "vi", "sex", "age", "donorcode")]
test_that("brma runs fine", {
  expect_error(suppressWarnings({res <- brma(d~., data = df, iter = 10)}), NA)
})

if(requireNamespace("mice", quietly = TRUE)){
  library(mice)
  nhanes$vi <- runif(nrow(nhanes))
  imp <- mice(nhanes, m = 5, print = FALSE)

  test_that("brma runs fine with mice", {
    expect_error(suppressWarnings({tmp <- brma(bmi~., vi ="vi", data = imp, iter = 10)}), NA)
  })
}
