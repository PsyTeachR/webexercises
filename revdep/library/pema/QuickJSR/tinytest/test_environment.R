# R environments and R.package access, including the use-after-free fixes on the
# property-name / package-name C strings and safe error propagation.
jsc <- JSContext$new()

# Read and write environment members via the exotic get/set handlers
jsc$source(code = "function envget(e) { return e.x; }")
jsc$source(code = "function envset(e) { e.y = 42; e.z = 'hi'; }")
e <- new.env()
e$x <- 10
expect_equal(jsc$call("envget", e), 10)

jsc$call("envset", e)
expect_equal(e$y, 42)
expect_equal(e$z, "hi")

# Repeated access is stable
for (i in 1:10) {
  expect_equal(jsc$call("envget", e), 10)
}

# R.package retrieves a base closure and calls it (js_r_package path)
jsc$source(
  code = 'function useId() { return R.package("base")["identity"](99); }'
)
expect_equal(jsc$call("useId"), 99)

# A non-existent package must error cleanly rather than crash
jsc$source(
  code = 'function badpkg() { return R.package("no_such_pkg_xyz_123"); }'
)
expect_error(jsc$call("badpkg"))

# The engine remains usable afterwards
expect_equal(jsc$call("useId"), 99)
