# --- Environment get/set property handlers survive repeated use ---
jsc <- JSContext$new()
jsc$source(code = "function envget(e) { return e.x; }")
jsc$source(code = "function envset(e) { e.y = 42; }")
e <- new.env()
e$x <- 7
expect_equal(jsc$call("envget", e), 7)
jsc$call("envset", e)
expect_equal(e$y, 42)
# Repeated access must not crash or return garbage
for (i in 1:100) {
  expect_equal(jsc$call("envget", e), 7)
}

# --- Environment SEXP survives R's GC while held by JS ---
jsc$source(code = "function envget2(e) { return e.v; }")
env2 <- new.env()
env2$v <- 123
# Force GC between passing the env and reading it back
expect_equal(jsc$call("envget2", env2), 123)
gc()
expect_equal(jsc$call("envget2", env2), 123)
rm(env2)
gc()
# The JS object still holds a preserved reference; a fresh env works too
env3 <- new.env()
env3$v <- 456
expect_equal(jsc$call("envget2", env3), 456)

# --- R.package use-after-free guard ---
jsc$source(code = 'function useMean() { return R.package("base")["mean"]([1,2,3]); }')
expect_equal(jsc$call("useMean"), 2)
# Non-string argument must not crash
jsc$source(code = 'function badpkg2() { return R.package(123); }')
expect_error(jsc$call("badpkg2"))

# --- std/os modules initialised exactly once ---
jsc$source(code = "function useStd() { return typeof std; }")
expect_equal(jsc$call("useStd"), "object")
jsc$source(code = "function useOs() { return typeof os; }")
expect_equal(jsc$call("useOs"), "object")

# --- stack_size input validation ---
expect_error(JSContext$new(stack_size = "not_a_number"))
expect_error(JSContext$new(stack_size = TRUE))
expect_error(JSContext$new(stack_size = list(1)))
# Valid integer and numeric values still work
expect_true(inherits(JSContext$new(stack_size = -1), "JSContext"))
expect_true(inherits(JSContext$new(stack_size = 1000000), "JSContext"))
expect_true(inherits(JSContext$new(stack_size = 1000000.0), "JSContext"))

# --- is_file input validation ---
ctx <- JSContext$new()
expect_error(QuickJSR:::qjs_source(ctx$context, "1 + 1", is_file = "yes"))
expect_error(QuickJSR:::qjs_source(ctx$context, "1 + 1", is_file = 1))
# Valid logical still works
expect_true(QuickJSR:::qjs_source(ctx$context, "1 + 1", is_file = FALSE))

# --- C-level date formatting (POSIXct and Date) ---
expect_equal(to_json(as.POSIXct("1985-06-18 12:34:56", tz = "UTC")),
             "[\"1985-06-18T12:34:56.000Z\"]")
expect_equal(to_json(as.Date("1985-06-18")),
             "[\"1985-06-18T00:00:00.000Z\"]")
# Fractional seconds are preserved
expect_equal(to_json(as.POSIXct("1985-06-18 12:34:56.5", tz = "UTC")),
             "[\"1985-06-18T12:34:56.500Z\"]")
# NA dates become null
expect_equal(to_json(as.POSIXct(c("1985-06-18 12:34:56", NA), tz = "UTC")),
             "[\"1985-06-18T12:34:56.000Z\",null]")
# Pre-epoch (negative) timestamps format correctly
expect_equal(to_json(as.POSIXct("1969-12-31 23:59:59", tz = "UTC")),
             "[\"1969-12-31T23:59:59.000Z\"]")

# --- direct date SEXP construction from JS Date ---
expect_equal(as.numeric(qjs_eval("new Date('1985-06-18T12:34:56.000Z')")),
             as.numeric(as.POSIXct("1985-06-18 12:34:56", tz = "UTC")))
expect_equal(as.numeric(qjs_eval("new Date('1985-06-18T12:34:56.500Z')")),
             as.numeric(as.POSIXct("1985-06-18 12:34:56.5", tz = "UTC")))
# Round-trip through a JS Date object
jsc$source(code = "function mkdate() { return new Date('1985-06-18T12:34:56.000Z'); }")
expect_equal(as.numeric(jsc$call("mkdate")),
             as.numeric(as.POSIXct("1985-06-18 12:34:56", tz = "UTC")))

# --- string conversion (UTF-8 preserved, no intermediate std::string) ---
expect_equal(from_json("[\"héllo\"]"), "héllo")
expect_equal(from_json("[\"a\\\"b\"]"), "a\"b")
expect_equal(qjs_eval("'café'"), "café")
# Empty string
expect_equal(from_json("[\"\"]"), "")

# --- cached do.call for R function calls with arguments ---
jsc$source(code = "function callfun(f, a, b) { return f(a, b); }")
expect_equal(jsc$call("callfun", function(x, y) x * y, 6, 7), 42)
# Repeated calls exercise the cached lookup
for (i in 1:50) {
  expect_equal(jsc$call("callfun", function(x, y) x + y, i, 1), i + 1)
}
rm(list=ls())
