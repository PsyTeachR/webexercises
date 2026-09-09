# Value conversion correctness, including the hoisted per-element dispatch and
# the NULL-cstring guards.

# Factor conversion goes through the isObject-gated inherits path
f <- factor(c("b", "a", "b"), levels = c("a", "b"))
expect_equal(to_json(f), '["b","a","b"]')

# NA handling in both directions
expect_equal(to_json(c(1, NA, 3)), "[1,null,3]")
expect_equal(from_json("[1,null,3]"), c(1, NA, 3))
expect_equal(to_json(c("a", NA)), '["a",null]')

# Nested structures
expect_equal(from_json('[{"a":1},{"a":2}]'), list(list(a = 1), list(a = 2)))

# Large numeric vector round-trip exercises the hot conversion loop
big <- as.numeric(1:10000)
expect_equal(from_json(to_json(big)), big)

# Arrays and undefined/null via eval
expect_equal(qjs_eval("['x','y']"), c("x", "y"))
expect_true(is.null(qjs_eval("undefined")))
expect_true(is.null(qjs_eval("null")))

# Zero-column data frame must not read past the columns
expect_equal(to_json(data.frame()), "[]")
