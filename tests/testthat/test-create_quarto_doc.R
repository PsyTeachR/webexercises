tmpdir <- tempdir()
setwd(tmpdir)

test_that("untitled doc", {
  path <- create_quarto_doc(open = FALSE)
  expected <- file.path(normalizePath(tmpdir), "Untitled", "Untitled.qmd")
  css <- file.path(normalizePath(tmpdir), "Untitled", "webex.css")
  js <- file.path(normalizePath(tmpdir), "Untitled", "webex.js")
  script <- file.path(normalizePath(tmpdir), "Untitled", "webex.R")

  expect_equal(path, expected)
  expect_true(file.exists(css))
  expect_true(file.exists(js))
  expect_true(file.exists(script))

  if (requireNamespace("quarto", quietly = TRUE)) {
    # render
    quarto::quarto_render(path)
    html <- file.path(normalizePath(tmpdir), "Untitled", "Untitled.html")
    expect_true(file.exists(html))
  }

  unlink("Untitled", recursive = TRUE) # clean up
})

test_that("titled doc", {
  path <- create_quarto_doc("MyBook", open = FALSE)
  expected <- file.path(normalizePath(tmpdir), "MyBook", "MyBook.qmd")

  expect_equal(path, expected)

  unlink("MyBook", recursive = TRUE) # clean up
})
