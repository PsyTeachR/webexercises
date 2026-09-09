test_that("add_theory_file() creates new file", {
  the_path <- fs::file_temp(pattern = "add_theory")
  scoped_temporary_project(dir = the_path)
  theorytools::add_theory_file(path = the_path)
  expect_true(file.exists(file.path(the_path, "theory.txt")))

  file.remove(file.path(the_path, "theory.txt"))
})

test_that("add_theory_file() copies file", {
  the_path <- fs::file_temp(pattern = "copy_theory")
  scoped_temporary_project(dir = the_path)

  flpth <- file.path(the_path, "copyme.txt")
  file.create(flpth)
  dirnm <- file.path(the_path, "theory")
  dir.create(dirnm)

  add_theory_file(path = dirnm, theory_file = flpth)
  expect_true(file.exists(file.path(the_path, "copyme.txt")))
})
