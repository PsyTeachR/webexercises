
test_that("untitled doc", {
  skip_if_no_quarto()

  scoped_tempdir({
  path <- create_quarto_doc(open = FALSE)
  tmpdir = "."
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
})

test_that("titled doc", {
  skip_if_no_quarto()

  scoped_tempdir({
  tmpdir = "."
  path <- create_quarto_doc("MyBook", open = FALSE)
  on.exit(unlink("MyBook", recursive = TRUE)) # clean up

  expected <- file.path(normalizePath(tmpdir), "MyBook", "MyBook.qmd")

  expect_true(file.exists(expected))
  expect_true(file.exists(path))
  })
})

test_that("pdf", {
  skip_if_no_quarto()
  skip_if_not_pandoc("2.0")
  scoped_tempdir({

  path <- create_quarto_doc("MyBook", open = FALSE)

  quarto::quarto_render(input = path, output_format = "html")
  expect_true(file.exists("MyBook/MyBook.html"))
  add_to_quarto_file(path)
  quarto::quarto_render(input = path, output_format = "pdf")
  expect_true(file.exists("MyBook/MyBook.pdf")) # check format
  })
})
