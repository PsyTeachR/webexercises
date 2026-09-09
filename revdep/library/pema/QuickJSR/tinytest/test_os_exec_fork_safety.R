# os.exec() forks, then the child _exit()s on setup/exec failure before ever
# calling execve(). _exit() is redirected to Rf_error() so a genuine top-level
# exit()/abort() call from QuickJS becomes a catchable R error rather than
# killing the session - but that redirect must not apply in the forked child:
# doing so would longjmp back into the (duplicated) R interpreter instead of
# terminating, leaving a rogue process that resumes running the rest of the
# caller's R script. Run in a subprocess: a regression here manifests as a
# duplicated log entry or a hang, not a crash of the test runner itself.

# os.exec()/waitpid() are fork()-based and excluded entirely from quickjs-ng
# on platforms without fork()
if (!identical(qjs_eval("typeof os.exec"), "undefined")) {
  log_file <- tempfile()
  script <- tempfile(fileext = ".R")
  writeLines(
    c(
      "library(QuickJSR)",
      sprintf("log_file <- %s", deparse(log_file)),
      "ret <- qjs_eval(\"os.exec(['/nonexistent_xyz_quickjsr_test'], {block:true})\")",
      "cat('MARK', ret, '\\n', file = log_file, append = TRUE)"
    ),
    script
  )

  status <- system2(
    R.home("bin/Rscript"),
    args = script,
    stdout = TRUE,
    stderr = TRUE,
    timeout = 20
  )
  unlink(script)
  log_lines <- if (file.exists(log_file)) readLines(log_file) else character(0)
  unlink(log_file)

  # Exactly one process must reach the log line: the fork()ed child must really
  # _exit(), not resurrect a second R process that re-runs the same script tail.
  expect_equal(length(log_lines), 1)

  # The exec failure must surface in the parent as a normal, prompt return
  # value, not an R error and not a hang. The forked child terminates via
  # hard_terminate() (libquickjs.c), which is platform-specific: Linux and
  # Windows can pass the real exit status through (127, matching a failed
  # exec/command-not-found), but other Unixes fall back to raise(SIGKILL),
  # which has no way to carry a status and always reports as killed-by-signal-9
  # (-9) instead.
  expected_status <- if (
    .Platform$OS.type == "windows" || Sys.info()[["sysname"]] == "Linux"
  ) {
    "127"
  } else {
    "-9"
  }
  expect_equal(trimws(sub("^MARK", "", log_lines[1])), expected_status)

  # The happy path (successful exec, no _exit() in the child at all) must be
  # completely unaffected.
  expect_equal(qjs_eval("os.exec(['true'], {block: true})"), 0)
  expect_equal(qjs_eval("os.exec(['false'], {block: true})"), 1)

  # A non-blocking exec of a valid command must still return a live pid, and
  # waiting on it must reap it with the expected exit status.
  pid <- qjs_eval("os.exec(['true'], {block: false})")
  expect_true(pid > 0)
  wait_res <- qjs_eval(sprintf("os.waitpid(%d, 0)", pid))
  expect_equal(wait_res[[2]], 0)
}

# Dummy test so the file is non-empty
expect_equal(1, 1)
