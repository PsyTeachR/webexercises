library(pema)
df <- bonapersona
df <- df[, c("species", "origin", "sex", "ageWeek", "model", "yi", "vi")]
df <- na.omit(df)

suppressWarnings({res <- brma(yi~., method = "lasso", data = df, iter = 100)})
sms <- summary(res)

test_that("summary method works", {
  expect_true(all(c("coefficients", "tau2", "R2", "k", "method", "algorithm") %in% names(sms)))
})

test_that("print method works", {
  tmp <- capture.output(print(sms))
  expect_true(any(startsWith(tmp, "BRMA")))
  expect_true(any(startsWith(tmp, "Intercept")))
})

test_that("predict method works", {
  preds <- predict(res)
  expect_true(inherits(preds, "numeric"))
  expect_true(length(preds) == nrow(df))
})

test_that("predict method works with samples", {
  preds <- predict(res, type = "samples")
  expect_true(inherits(preds, "matrix"))
  expect_true(nrow(preds) == nrow(df))
  expect_true(ncol(preds) == 200)
})

test_that("predict method works with newdata", {
  nd <- df[1:10, ]
  preds <- predict(res, newdata = nd)
  expect_true(inherits(preds, "numeric"))
  expect_true(length(preds) == nrow(nd))
})

test_that("predict method works with samples", {
  nd <- df[1:10, ]
  preds <- predict(res, newdata = nd, type = "samples")
  expect_true(inherits(preds, "matrix"))
  expect_true(nrow(preds) == nrow(nd))
  expect_true(ncol(preds) == 200)
})
