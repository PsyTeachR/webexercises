test_that("form_to_chunks correctly parses when none of the edges have formulae", {
  expect_error({
    theorytools::simulate_data(dagitty::dagitty("x -> y"))
  }, NA)
})
