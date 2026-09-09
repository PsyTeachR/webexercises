test_that("simfun correctly generated", {

  g <- dagitty::dagitty('dag {
  X [distribution="rnorm()"]
  Y [distribution="rbinom(size = 1, prob = .5)"]
  Z [distribution="runif()"]
  X -> Y [form = ".5+I(X^2)"]
  Z -> X
  Z -> Y [form="Z*X"]
  A -> X [form="-.2+3*A"]
}')

  test_env <- environment()
  assign("A", 1:4, envir = test_env)
  assign("Z", -2:1, envir = test_env)
  assign("X", seq(from = -.1, to = .2, by = .1), envir = test_env)
  assign("Y", 8:11, envir = test_env)

  edg <- tidySEM::get_edges(g)
  edg_x <- edg[edg$to == "X", ]


  set.seed(1)
  tmp <- theorytools:::edges_to_simfun(edg_x, beta_default = round(runif(1, -1, 1), 1))

  expect_equal(
    eval(parse(text = tmp), envir = test_env),
    eval(parse(text = "3 * A - (0.2 + 0.5 * Z)"), envir = test_env))

  set.seed(1)
  edg_y <- edg[edg$to == "Y", ]
  tmp <- theorytools:::edges_to_simfun(edg_y, beta_default = round(runif(1, -1, 1), 1))

  expect_equal(
    eval(parse(text = tmp), envir = test_env),
    eval(parse(text = "0.5 - (0.5 * (X * Z) + 0.5 * I(X^2))"), envir = test_env))

  edg <- data.frame(form = c("X*Y", "X*Y"))
  expect_equal(
    theorytools:::edges_to_simfun(edg, beta_default = 1),
    "X * Y")
  expect_equal(
    theorytools:::edges_to_simfun(edg, beta_default = 1, duplicated = "add"),
    "2 * (X * Y)")

})
