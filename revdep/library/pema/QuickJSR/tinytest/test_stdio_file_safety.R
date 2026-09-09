# std.out/std.err are backed by sentinel FILE* values (not real FILE*s),
# since real output is redirected through Rprintf/REprintf. fileno, ftell,
# fseek, feof, ferror, clearerr and read used to call straight through to
# libc on those sentinels and segfault R. Run in a subprocess so a
# regression fails the test instead of taking down the whole test run.

run_subprocess <- function(lines) {
  script <- tempfile(fileext = ".R")
  writeLines(c("library(QuickJSR)", lines, "cat('__DONE__\\n')"), script)
  out <- suppressWarnings(system2(
    R.home("bin/Rscript"),
    args = script,
    stdout = TRUE,
    stderr = TRUE
  ))
  unlink(script)
  out
}

get_val <- function(out, name) {
  line <- grep(paste0("^", name, "="), out, value = TRUE)
  if (length(line) == 0) {
    NA_character_
  } else {
    sub(paste0("^", name, "="), "", line[1])
  }
}

out <- run_subprocess(c(
  "cat('fileno_out=', qjs_eval('std.out.fileno()'), '\\n', sep='')",
  "cat('fileno_err=', qjs_eval('std.err.fileno()'), '\\n', sep='')",
  "cat('tell_out=', qjs_eval('std.out.tell()'), '\\n', sep='')",
  "cat('tell_err=', qjs_eval('std.err.tell()'), '\\n', sep='')",
  "cat('seek_out=', qjs_eval('std.out.seek(0, 0)'), '\\n', sep='')",
  "cat('eof_out=', qjs_eval('std.out.eof()'), '\\n', sep='')",
  "cat('error_out=', qjs_eval('std.out.error()'), '\\n', sep='')",
  "cat('clearerr_out=', is.null(qjs_eval('std.out.clearerr()')), '\\n', sep='')",
  "cat('read_out=', qjs_eval('std.out.read(new ArrayBuffer(1))'), '\\n', sep='')",
  "cat('read_err=', qjs_eval('std.err.read(new ArrayBuffer(1))'), '\\n', sep='')"
))

# The subprocess must run to completion: if any call above segfaults, this
# marker is never printed and the assertions below catch the difference.
expect_true(any(grepl("__DONE__", out)))

expect_equal(get_val(out, "fileno_out"), "1")
expect_equal(get_val(out, "fileno_err"), "2")
expect_equal(get_val(out, "tell_out"), "-1")
expect_equal(get_val(out, "tell_err"), "-1")
expect_true(as.numeric(get_val(out, "seek_out")) < 0)
expect_equal(get_val(out, "eof_out"), "FALSE")
expect_equal(get_val(out, "error_out"), "FALSE")
expect_equal(get_val(out, "clearerr_out"), "TRUE")
expect_equal(get_val(out, "read_out"), "0")
expect_equal(get_val(out, "read_err"), "0")

# std.out/std.err must still refuse to be closed (pre-existing guard, must
# still work now that other FILE* methods are also intercepted)
expect_error(qjs_eval("std.out.close()"), "cannot close stdio")
expect_error(qjs_eval("std.err.close()"), "cannot close stdio")

# A real, non-sentinel file must be completely unaffected by the sentinel
# checks (fileno/tell/seek/read/eof/error/clearerr all operate normally)
tmp <- tempfile()
jsc <- JSContext$new()
jsc$assign("tmp_path", tmp)
jsc$source(
  code = paste(
    "var f = std.open(tmp_path, 'w+');",
    "f.puts('hello');",
    "f.flush();",
    "function fTell() { return f.tell(); }",
    "function fSeek() { return f.seek(0, 0); }",
    "function fFileno() { return f.fileno(); }",
    "function fEof() { return f.eof(); }",
    "function fClose() { return f.close(); }",
    sep = "\n"
  )
)
expect_equal(jsc$call("fTell"), 5)
expect_equal(jsc$call("fSeek"), 0)
expect_true(jsc$call("fFileno") > 2)
expect_false(jsc$call("fEof"))
jsc$call("fClose")
unlink(tmp)
