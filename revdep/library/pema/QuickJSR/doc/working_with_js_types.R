## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(QuickJSR)

## -----------------------------------------------------------------------------
m <- matrix(1:6, nrow = 2)
cat(to_json(m))

## -----------------------------------------------------------------------------
df <- data.frame(a = 1:3, b = c("x", "y", "z"))
cat(to_json(df))

## -----------------------------------------------------------------------------
ctx <- JSContext$new()
ctx$source(code = "function callRFunction(f, x, y) { return f(x, y); }")

ctx$call("callRFunction", function(x, y) x + y, 1, 2)
ctx$call("callRFunction", function(x, y) paste0(x, ",", y), "a", "b")

## -----------------------------------------------------------------------------
ctx$source(code = 'function env_test(env) { return env.a + env["b"]; }')
env <- new.env()
env$a <- 1
env$b <- 2
ctx$call("env_test", env)

## -----------------------------------------------------------------------------
ctx$source(code = "function env_update(env) { env.a = 10; env.b = 20; }")
ctx$call("env_update", env)
env$a
env$b

## -----------------------------------------------------------------------------
qjs_eval('R.package("base").getwd()')

