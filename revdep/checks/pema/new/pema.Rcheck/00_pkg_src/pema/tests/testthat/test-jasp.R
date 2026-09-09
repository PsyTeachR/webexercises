library(pema)
df <- pema::bonapersona
df$ageWeek[is.na(df$ageWeek)] <- median(df$ageWeek, na.rm = TRUE)

datsel <- df[, c("yi", "vi", "author", "mTimeLength", "year", "model", "ageWeek", "strainGrouped", "bias", "species", "domain", "sex")]

dat2l <- datsel
dat2l[["author"]] <- NULL

new_data <- data.frame(
  yi   = as.numeric(dat2l$yi),
  year = as.numeric(dat2l$year),
  vi   = as.numeric(dat2l$vi)
)

test_that("brma works with one moderator", {
  expect_error({suppressWarnings(brma(yi ~ .,
                     data = new_data,
                     vi = "vi",
                     method = "lasso",
                     prior = c(df = 1, scale = 1),
                     mute_stan = FALSE, iter = 10))}, NA)
})

test_that("brma errors with no moderators", {
  expect_error({suppressWarnings(brma(yi ~ 1,
                                      data = new_data,
                                      vi = "vi",
                                      method = "lasso",
                                      prior = c(df = 1, scale = 1),
                                      mute_stan = FALSE, iter = 50))})
})
