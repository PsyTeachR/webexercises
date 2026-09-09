expect_equal(to_json(list(1), auto_unbox = TRUE), "[1]")
expect_equal(to_json(list(I(1)), auto_unbox = TRUE), "[[1]]")
expect_equal(to_json(I(list(1)), auto_unbox = TRUE), "[1]")

expect_equal(to_json(list(x = 1)), "{\"x\":[1]}")
expect_equal(to_json(list(x = 1), auto_unbox = TRUE), "{\"x\":1}")
expect_equal(to_json(list(x = I(1)), auto_unbox = TRUE), "{\"x\":[1]}")

expect_equal(to_json(list(x = I(list(1))), auto_unbox = TRUE), "{\"x\":[1]}")
expect_equal(to_json(list(x = list(I(1))), auto_unbox = TRUE), "{\"x\":[[1]]}")
