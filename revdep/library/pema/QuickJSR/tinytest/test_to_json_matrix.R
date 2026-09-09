empty_matrix <- matrix(nrow = 0, ncol = 0)
expect_equal(to_json(empty_matrix), "[]")

numeric_matrix <- matrix(1:6, nrow = 2, ncol = 3)
expect_equal(to_json(numeric_matrix), "[[1,3,5],[2,4,6]]")

character_matrix <- matrix(letters[1:6], nrow = 2, ncol = 3)
expect_equal(
  to_json(character_matrix),
  "[[\"a\",\"c\",\"e\"],[\"b\",\"d\",\"f\"]]"
)

logical_matrix <- matrix(c(TRUE, FALSE), nrow = 2, ncol = 1)
expect_equal(to_json(logical_matrix), "[[true],[false]]")
