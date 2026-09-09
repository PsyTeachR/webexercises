# R functions passed into JS: reference handling, GC preservation, and error
# propagation across the C boundary.
jsc <- JSContext$new()

# Regression for js_fun_static: invoking one R callback several times within a
# single JS call previously released a borrowed reference and segfaulted once
# the callback was called more than twice.
jsc$source(
  code = "function applyN(f, n) { var s = 0; for (var i = 0; i < n; i++) s += f(i); return s; }"
)
expect_equal(jsc$call("applyN", function(x) x, 5L), sum(0:4))
expect_equal(jsc$call("applyN", function(x) x * 2, 20L), sum((0:19) * 2))

# Closures/captures still resolve
mult <- 10
expect_equal(jsc$call("applyN", function(x) x * mult, 4L), sum((0:3) * 10))

# Regression for the missing R_PreserveObject: an R function stored in a JS
# global with no remaining R reference must survive garbage collection.
jsc$source(code = "function useStored() { return storedFn(7); }")
jsc$assign("storedFn", function(x) x + 1)
gc()
gc()
expect_equal(jsc$call("useStored"), 8)

# Many distinct stored callbacks, each capturing its own value, survive gc
for (k in 1:20) {
  local({
    kk <- k
    jsc$assign(paste0("fn", kk), function() kk * 100)
  })
}
gc()
gc()
jsc$source(code = "function callFn(name) { return globalThis[name](); }")
expect_equal(jsc$call("callFn", "fn7"), 700)
expect_equal(jsc$call("callFn", "fn20"), 2000)

# An error raised inside an R callback must surface as an R error rather than
# unwinding through the QuickJS C stack.
jsc$source(code = "function callf(f) { return f(); }")
expect_error(jsc$call("callf", function() stop("boom")))

# The engine remains usable after a trapped callback error
expect_equal(jsc$call("applyN", function(x) x, 3L), 3)
