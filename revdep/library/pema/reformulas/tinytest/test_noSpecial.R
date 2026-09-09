library(reformulas)

expect_equal(noSpecials(y~1+us(1|f)), y ~ 1)
expect_equal(noSpecials(y~1+us(1|f),delete=FALSE), y ~ 1 + (1|f))
expect_equal(noSpecials(y~us(1|f)), y ~ 1)
expect_equal(noSpecials(y~us(1|f), delete=FALSE), y ~ (1|f))
expect_equal(noSpecials(y~us+1), y ~ us + 1)
expect_equal(noSpecials(~us(1|f)+1), ~1)
expect_equal(noSpecials(~s(stuff) + a + b, specials = "s"), ~a + b)
expect_equal(noSpecials(cbind(b1, 20-b1) ~ s(x, bs = "tp")), cbind(b1, 20 - b1) ~ 1)

expect_equal(no_specials(findbars_x(~ 1 + s(x) + (f|g) + diag(x|y))),
             list(quote( f | g) , quote( x | y)))
expect_equal(no_specials(~us(f|g, extra_arg)), quote( f | g))
