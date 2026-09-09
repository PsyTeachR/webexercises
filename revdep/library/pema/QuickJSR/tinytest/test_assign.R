# Regression tests for qjs_assign_ over-release: assigning any heap-allocated
# JS value (string/array/object) previously double-freed the value and left a
# dangling global, segfaulting on read-back.
jsc <- JSContext$new()

# Scalars map to JS immediates and always worked
jsc$assign("n_int", 42L)
expect_equal(jsc$get("n_int"), 42L)
jsc$assign("n_dbl", 3.14)
expect_equal(jsc$get("n_dbl"), 3.14)
jsc$assign("b", TRUE)
expect_equal(jsc$get("b"), TRUE)

# Heap-allocated values: these segfaulted before the fix
jsc$assign("s", "hello")
expect_equal(jsc$get("s"), "hello")

jsc$assign("cv", c("a", "b", "c"))
expect_equal(jsc$get("cv"), c("a", "b", "c"))

jsc$assign("nv", c(1.5, 2.5, 3.5))
expect_equal(jsc$get("nv"), c(1.5, 2.5, 3.5))

jsc$assign("lst", list(a = 1, b = "two"))
expect_equal(jsc$get("lst"), list(a = 1, b = "two"))

# Repeated assignment to the same name
for (i in 1:50) {
  jsc$assign("loopvar", paste0("v", i))
}
expect_equal(jsc$get("loopvar"), "v50")

# Nested-name assignment uses the recursive setter, which also steals the value
jsc$source(code = "var obj = {};")
jsc$assign("obj.deep", "nested-value")
expect_equal(jsc$get("obj.deep"), "nested-value")

# Force a GC pass after assigning several heap values in a row: a double
# freed value's refcount reaches zero one decrement early, so the GC would
# be the point at which reusing/collecting that memory could corrupt or
# crash on the read-backs below.
jsc$assign("gc1", "one")
jsc$assign("gc2", c("two", "three"))
jsc$assign("gc3", list(a = 1))
gc()
gc()
expect_equal(jsc$get("gc1"), "one")
expect_equal(jsc$get("gc2"), c("two", "three"))
expect_equal(jsc$get("gc3"), list(a = 1))
