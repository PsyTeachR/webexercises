library(reformulas)
## need quote() stuff to prevent unwanted evaluation ...
expect_identical(extractForm(~a+offset(b),quote(offset)), list(quote(offset(b))))
expect_identical(extractForm(~c,quote(offset)), NULL)
expect_identical(extractForm(~a+offset(b)+offset(c),quote(offset)), list(quote(offset(b)), quote(offset(c))))
expect_identical(extractForm(~offset(x),quote(offset)),  list(quote(offset(x))))

## check that we don't break behaviour of existing head():
## https://github.com/bbolker/reformulas/issues/6
expect_identical(head(quote(x(1,2,3)), -1), quote(x(1,2)))
