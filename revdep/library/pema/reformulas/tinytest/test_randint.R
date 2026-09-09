library(reformulas)
f <- ~ 1 + a  + b + (a | f) + (1 + a | g) + (a + b | h ) + (1 + a + b | i)
expect_equal(randint(f),
             ~1 + a + b + (1 | f) + (1 | g) + (1 | h) + (1 | i))

