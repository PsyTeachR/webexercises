tmpdir <- tempdir()
setwd(tmpdir)

test_that("untitled doc", {
  path <- create_quarto_doc(open = FALSE)
  on.exit(unlink("Untitled", recursive = TRUE)) # clean up

  expected <- file.path(normalizePath(tmpdir), "Untitled", "Untitled.qmd")
  css <- file.path(normalizePath(tmpdir), "Untitled", "webex.css")
  js <- file.path(normalizePath(tmpdir), "Untitled", "webex.js")

  #expect_equal(path, expected)
  expect_true(file.exists(expected))
  expect_true(file.exists(path))
  expect_true(file.exists(css))
  expect_true(file.exists(js))

  skip_on_cran() # not all CRAN installations have pandoc
  if (requireNamespace("quarto", quietly = TRUE)) {
    # render
    quarto::quarto_render(path, quiet = TRUE)
    html <- file.path(normalizePath(tmpdir), "Untitled", "Untitled.html")
    expect_true(file.exists(html))
  }
})

test_that("titled doc", {
  path <- create_quarto_doc("MyBook", open = FALSE)
  on.exit(unlink("MyBook", recursive = TRUE)) # clean up

  expected <- file.path(normalizePath(tmpdir), "MyBook", "MyBook.qmd")

  expect_true(file.exists(expected))
  expect_true(file.exists(path))
})

test_that("pdf", {
  skip("requires pandoc and human inspection")
  path <- create_quarto_doc("MyBook", open = FALSE)
  on.exit(unlink("MyBook", recursive = TRUE)) # clean up

  quarto::quarto_render(input = path, output_format = "html")
  browseURL("MyBook/MyBook.html") # check format

  quarto::quarto_render(input = path, output_format = "pdf")
  browseURL("MyBook/MyBook.pdf") # check format
})
