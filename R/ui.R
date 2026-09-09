#' Wraps cli for a beautiful command line user interface which indicates if
#' `code` passes or fails.
#' @keywords internal
with_cli_try <- function(msg, code, ...){
  tryCatch({
    if(!is_quiet()) cli::cli_process_start(msg, ..., .envir = parent.frame(1))
    eval(code, envir = parent.frame())
    cli::cli_process_done()
    return(invisible(TRUE))
  }, error = function(err) {
    cli::cli_process_failed()
    return(invisible(FALSE))
  })
}

#' Wraps cli messages for a beautiful command line user interface;
#' Use argument names:
#' "!" = "This is a warning"
#' "v" = "This is a green checkmark"
#' "x" = "This is a red cross"
#' @keywords internal
cli_msg <- function(...){
if(!is_quiet()) do.call(cli::cli_bullets, list(text = as.vector(list(...))), envir = parent.frame(n = 1))
}

#' Checks if usethis option is quite, with default
#' @keywords internal
is_quiet <- function() {
  isTRUE(getOption("usethis.quiet", default = !interactive()))
}
