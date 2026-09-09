library(reformulas)
library(tinytest)

## shouldn't find 'naked' specials
expect_false(anySpecial(y ~ s))
expect_true(anySpecial(y ~ s(1)))
expect_false(anySpecial(y ~ s[[1]]))
expect_false(anySpecial(y ~ diag))
expect_true(anySpecial(y ~ diag(1)))
expect_false(anySpecial(y ~ diag[[1]]))

anySpecial(y ~ poly, specials = "poly")
anySpecial(y ~ poly(1), specials = "poly")
