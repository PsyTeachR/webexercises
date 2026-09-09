factor_var <- iris$Species
factor_var_json <- paste0(
  "[\"",
  paste0(as.character(factor_var), collapse = "\",\""),
  "\"]"
)

expect_equal(to_json(factor_var), factor_var_json)
expect_equal(to_json(factor_var[1], auto_unbox = TRUE), "\"setosa\"")
