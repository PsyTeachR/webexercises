# Fails on 3.6 CI, but can't be replicated locally
exit_if_not(R.version$major > "3")

object <- as.Date("1985-06-18")

expect_equal(to_json(object), "[\"1985-06-18T00:00:00.000Z\"]")
expect_equal(to_json(list(object)), "[[\"1985-06-18T00:00:00.000Z\"]]")
expect_equal(
  to_json(data.frame(foo = object)),
  "[{\"foo\":\"1985-06-18T00:00:00.000Z\"}]"
)
expect_equal(
  to_json(list(foo = data.frame(bar = object))),
  "{\"foo\":[{\"bar\":\"1985-06-18T00:00:00.000Z\"}]}"
)

object <- as.POSIXct("1985-06-18 12:34:56", tz = "UTC")
expect_equal(to_json(object), "[\"1985-06-18T12:34:56.000Z\"]")
