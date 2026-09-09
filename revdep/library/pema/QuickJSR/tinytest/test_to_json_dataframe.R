test <- data.frame(foo = 1:2)
expect_equal(to_json(test), '[{"foo":1},{"foo":2}]')

test <- data.frame(foo = 1:2)
expect_equal(to_json(test), '[{"foo":1},{"foo":2}]')

test <- data.frame(foo = 1:2, bar = data.frame(x = 123:123))

test <- data.frame(foo = 1:2, bar = 123:124)
rownames(test) <- c("a", "b")
expect_equal(
  to_json(test),
  '[{"foo":1,"bar":123,"_row":"a"},{"foo":2,"bar":124,"_row":"b"}]'
)

test <- data.frame(foo = 1:2)
test$bar <- list(x = 123, y = 123)
test$baz <- data.frame(z = 456:457)
expect_equal(
  to_json(test),
  '[{"foo":1,"bar":[123],"baz":{"z":456}},{"foo":2,"bar":[123],"baz":{"z":457}}]'
)
