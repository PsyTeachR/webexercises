# Tests for the C I/O wrapper functions in libquickjs.c. These exercise the
# fwrite, fprintf, fputs, puts, printf, putchar, fputc, fflush, and exit
# wrappers that redirect QuickJS output to R's console/error streams.

# Helper to capture stderr by running code in a subprocess
capture_stderr <- function(code) {
  script <- tempfile(fileext = ".R")
  writeLines(
    c(
      "library(QuickJSR)",
      paste0("qjs_eval(", shQuote(code), ")")
    ),
    script
  )
  result <- suppressWarnings(system2(
    R.home("bin/Rscript"),
    args = script,
    stderr = TRUE
  ))
  unlink(script)
  trimws(result)
}

# --- stdout capture via fwrite/fprintf wrappers ---

# Basic console.log goes to stdout
expect_equal(
  capture.output(qjs_eval("console.log('hello')")),
  "hello"
)

# Multiple arguments are joined with spaces
expect_equal(
  capture.output(qjs_eval("console.log('a', 'b', 'c')")),
  "a b c"
)

# Empty string output
expect_equal(
  capture.output(qjs_eval("console.log('')")),
  ""
)

# Multiline output exercises fwrite with embedded newlines
expect_equal(
  capture.output(qjs_eval("console.log('line1\\nline2\\nline3')")),
  c("line1", "line2", "line3")
)

# Special characters in output
expect_equal(
  capture.output(qjs_eval("console.log('tab\\there')")),
  "tab\there"
)

# Numeric output exercises the dtoa path through fwrite
expect_equal(
  capture.output(qjs_eval("console.log(42)")),
  "42"
)

expect_equal(
  capture.output(qjs_eval("console.log(3.14159)")),
  "3.14159"
)

# Long string output exercises chunked fwrite (buffer is 4096 bytes)
long_str <- paste(rep("x", 5000), collapse = "")
expect_equal(
  capture.output(qjs_eval(paste0("console.log('", long_str, "')"))),
  long_str
)

# --- stderr capture via fprintf wrapper ---

# console.error goes to stderr
expect_equal(
  capture_stderr("console.error('err')"),
  "err"
)

# Multiple arguments to console.error
expect_equal(
  capture_stderr("console.error('a', 'b')"),
  "a b"
)

# --- putchar/fputc wrappers ---

# print() writes to stdout via putchar/fputc
expect_equal(
  capture.output(qjs_eval("print('x')")),
  "x"
)

# --- exit_wrapper ---

# std.exit() calls the C exit() function, wrapped to call Rf_error
expect_error(
  qjs_eval("std.exit(0)"),
  "exit\\(0\\) called from QuickJS"
)

expect_error(
  qjs_eval("std.exit(42)"),
  "exit\\(42\\) called from QuickJS"
)

# Context remains usable after exit error
jsc <- JSContext$new()
tryCatch(jsc$source(code = "std.exit(1)"), error = function(e) NULL)
jsc$source(code = "var _testResult = 1 + 1")
expect_equal(jsc$get("_testResult"), 2)

# --- fflush_wrapper ---

# fflush on stdout/stderr should be a no-op (return 0)
expect_equal(
  capture.output(qjs_eval("console.log('before'); console.log('after')")),
  c("before", "after")
)

# --- Edge cases ---

# Unicode output
expect_equal(
  capture.output(qjs_eval("console.log('\\u00e9\\u00e8\\u00ea')")),
  "\u00e9\u00e8\u00ea"
)

# Mixed types in console.log
expect_equal(
  capture.output(qjs_eval("console.log(1, 'two', true, null)")),
  "1 two true null"
)

# Very large output exercises fwrite chunking boundary
big_output <- paste(rep("A", 8000), collapse = "")
expect_equal(
  nchar(capture.output(qjs_eval(paste0("console.log('", big_output, "')")))[1]),
  8000
)

# --- puts/fputs wrappers ---

# print() internally uses puts/fputs for simple string output
expect_equal(
  capture.output(qjs_eval("print('puts test')")),
  "puts test"
)

# --- console.error availability ---

# console.error should be registered on the console object
expect_true("error" %in% qjs_eval("Object.keys(console)"))
