tmpdir <- tempdir()
setwd(tmpdir)

test_that("defaults", {
  dir.create("quarto_test")
  on.exit(unlink("quarto_test", recursive = TRUE))

  write("project:\n  title: quarto_test\n", "quarto_test/_quarto.yml")

  add_to_quarto("quarto_test", render = FALSE)

  quarto <- file.path("quarto_test", "_quarto.yml")
  css <- file.path("quarto_test", "include", "webex.css")
  js <- file.path("quarto_test", "include", "webex.js")
  script <- file.path("quarto_test", "R", "webex.R")
  rprofile <- file.path("quarto_test", ".Rprofile")
  webex <- file.path("quarto_test", "webexercises.qmd")

  expect_true(file.exists(css))
  expect_true(file.exists(js))
  expect_true(file.exists(script))
  expect_true(file.exists(rprofile))
  expect_true(file.exists(webex))

  yml <- yaml::read_yaml(quarto)
  expect_equal(yml$format$html$css, "include/webex.css")
  expect_equal(yml$format$html$`include-after-body`, "include/webex.js")
})


test_that("names dirs", {
  dir.create("quarto_test")
  on.exit(unlink("quarto_test", recursive = TRUE))

  write("project:\n  title: quarto_test\n", "quarto_test/_quarto.yml")

  add_to_quarto(quarto_dir = "quarto_test",
                include_dir = "",
                script_dir = "",
                render = FALSE)

  quarto <- file.path("quarto_test", "_quarto.yml")
  css <- file.path("quarto_test", "webex.css")
  js <- file.path("quarto_test", "webex.js")
  script <- file.path("quarto_test", "webex.R")
  rprofile <- file.path("quarto_test", ".Rprofile")
  webex <- file.path("quarto_test", "webexercises.qmd")

  expect_true(file.exists(css))
  expect_true(file.exists(js))
  expect_true(file.exists(script))
  expect_true(file.exists(rprofile))
  expect_true(file.exists(webex))

  yml <- yaml::read_yaml(quarto)
  expect_equal(yml$format$html$css, "./webex.css")
  expect_equal(yml$format$html$`include-after-body`, "./webex.js")
})
