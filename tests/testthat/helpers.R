# Use to test quarto availability or version lower than
skip_if_no_quarto <- function(ver = NULL) {
  skip_if(is.null(quarto::quarto_path()), message = "Quarto is not available")
  skip_if_not(
    quarto::quarto_available(min = ver, error = FALSE),
    message = sprintf(
      "Version of quarto is lower than %s: %s.",
      ver,
      quarto::quarto_version()
    )
  )
}

# Use to test quarto greater than
skip_if_quarto <- function(ver = NULL) {
  # Skip if no quarto available
  skip_if_no_quarto()
  # Then skip if available or if version is greater than
  if (is.null(ver)) {
    skip_if(
      !is.null(quarto::quarto_path()),
      message = sprintf("Quarto is available: %s.", quarto_version())
    )
  } else {
    skip_if(
      quarto::quarto_version() >= ver,
      message = sprintf(
        "Version of quarto is greater than or equal %s: %s.",
        ver,
        quarto::quarto_version()
      )
    )
  }
}
