expect_equal(to_json(1), "[1]")
expect_equal(to_json(c(NA, 1:3, NA)), "[null,1,2,3,null]")
expect_equal(to_json(c(NA, 1.5, NA, 2.5)), "[null,1.5,null,2.5]")

expect_equal(to_json("a"), "[\"a\"]")
expect_equal(to_json(c("a", "b", NA, "c")), "[\"a\",\"b\",null,\"c\"]")

expect_equal(to_json(TRUE), "[true]")
expect_equal(to_json(FALSE), "[false]")
expect_equal(to_json(c(TRUE, NA, FALSE)), "[true,null,false]")

expect_equal(to_json(list(1, 2, 3, NA)), "[[1],[2],[3],[null]]")
expect_equal(
  to_json(list(a = 1, b = 2, c = NA, d = 3)),
  "{\"a\":[1],\"b\":[2],\"c\":[null],\"d\":[3]}"
)
expect_equal(
  to_json(list(a = "d", b = "e", c = "f")),
  "{\"a\":[\"d\"],\"b\":[\"e\"],\"c\":[\"f\"]}"
)

expect_equal(to_json(list(c(1, 2), c(3, 4))), "[[1,2],[3,4]]")
expect_equal(to_json(list(list(1, 2), list(3, 4))), "[[[1],[2]],[[3],[4]]]")
expect_equal(
  to_json(list(list(a = 1, b = 2), list(c = 3, d = 4))),
  "[{\"a\":[1],\"b\":[2]},{\"c\":[3],\"d\":[4]}]"
)

expect_equal(
  to_json(list(c("e", "f"), c("g", "h"))),
  "[[\"e\",\"f\"],[\"g\",\"h\"]]"
)
expect_equal(
  to_json(list(list("e", "f"), list("g", "h"))),
  "[[[\"e\"],[\"f\"]],[[\"g\"],[\"h\"]]]"
)
expect_equal(
  to_json(list(list(a = "e", b = "f"), list(c = "g", d = "h"))),
  "[{\"a\":[\"e\"],\"b\":[\"f\"]},{\"c\":[\"g\"],\"d\":[\"h\"]}]"
)

expect_equal(1, from_json("[1]"))
expect_equal(1:3, from_json("[1,2,3]"))
expect_equal(c(1.5, 2.5), from_json("[1.5,2.5]"))

expect_equal("a", from_json("[\"a\"]"))
expect_equal(c("a", "b", "c"), from_json("[\"a\",\"b\",\"c\"]"))

expect_equal(TRUE, from_json("[true]"))
expect_equal(FALSE, from_json("[false]"))
expect_equal(c(TRUE, FALSE), from_json("[true,false]"))

# Mixed-Type Conversions
expect_equal(c(1, 1), from_json("[1,true]"))
expect_equal(c(1.5, 1.0), from_json("[1.5,true]"))
expect_equal(c(1, "a"), from_json("[1,\"a\"]"))
expect_equal(c(1.2, 1.0), from_json("[1.2,1]"))
expect_equal(c("1", "a", "TRUE"), from_json("[1,\"a\",true]"))
expect_equal(c("1.5", "TRUE", "a", "1"), from_json("[1.5,true,\"a\",1]"))

expect_equal(matrix(1:3, ncol = 1), from_json("[[1],[2],[3]]"))
expect_equal(matrix(1:6, ncol = 2), from_json("[[1,4],[2,5],[3,6]]"))
expect_equal(list(1, c(2, 3)), from_json("[[1],[2,3]]"))
expect_equal(
  list(1, c(2, 3), list(3, c(4, 5))),
  from_json("[[1],[2,3],[3,[4,5]]]")
)

expect_equal(
  list(a = 1, b = 2, c = 3),
  from_json("{\"a\":[1],\"b\":[2],\"c\":[3]}")
)
expect_equal(
  list(a = "d", b = "e", c = "f"),
  from_json("{\"a\":[\"d\"],\"b\":[\"e\"],\"c\":[\"f\"]}")
)

expect_equal(
  list(list(a = 1, b = 2), list(c = 3, d = 4)),
  from_json("[{\"a\":[1],\"b\":[2]},{\"c\":[3],\"d\":[4]}]")
)

expect_equal(
  list(c("e", "f"), c("g", "h")),
  from_json("[[\"e\",\"f\"],[\"g\",\"h\"]]")
)
expect_equal(
  list(list("e", "f"), list("g", "h")),
  from_json("[[[\"e\"],[\"f\"]],[[\"g\"],[\"h\"]]]")
)
expect_equal(
  list(list(a = "e", b = "f"), list(c = "g", d = "h")),
  from_json("[{\"a\":[\"e\"],\"b\":[\"f\"]},{\"c\":[\"g\"],\"d\":[\"h\"]}]")
)

# NULL conversions
expect_equal(NULL, from_json("null"))
expect_equal(NA, from_json("[null]"))
expect_equal(c(NA, 1), from_json("[null, 1]"))
expect_equal(c(1, NA, 1), from_json("[1, null, 1]"))

expect_equal("[null]", to_json(NULL))
expect_equal("null", to_json(NULL, auto_unbox = TRUE))
expect_equal("[null]", to_json(NA))
expect_equal("null", to_json(NA, auto_unbox = TRUE))
