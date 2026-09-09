# These functions come from worcs:
#' @importFrom cli cli_process_start cli_process_done cli_process_failed cli_bullets
with_cli_try <- function (msg, code, ...)
{
  tryCatch({
    if (!is_quiet())
      cli::cli_process_start(msg, ..., .envir = parent.frame(1))
    eval(code, envir = parent.frame())
    cli::cli_process_done()
    return(invisible(TRUE))
  }, error = function(err) {
    cli::cli_process_failed()
    return(invisible(FALSE))
  })
}

cli_msg <- function (...)
{
  if (!is_quiet())
    do.call(cli::cli_bullets, list(text = as.vector(list(...))),
            envir = parent.frame(n = 1))
}

is_quiet <- function ()
{
  isTRUE(getOption("usethis.quiet", default = !interactive()))
}
