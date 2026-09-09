test_that("create_fair_theory() creates github repo", {
  ownr <- try(gh::gh_whoami()$login)
  testthat::skip_if_not(condition = isTRUE(ownr == "cjvanlissa"), message = "Skipped test that requires GitHub")
  # Create a theory with no remote repository (for safe testing)

  theorytools:::scoped_tempdir({
    the_path = "."
    theorytools:::with_cli_try("Initialize 'Git' repository", {
      gert::git_init(path = the_path)
    })
    remote_repo <- basename(getwd())
    # Connect remote repo -----------------------------------------------------
    repo_properties <- worcs:::git_connect_or_create(the_path, remote_repo)
    repo_url <- repo_properties$repo_url
    repo_exists <- repo_properties$repo_exists
    prior_commits <- repo_properties$prior_commits
    # Push local repo to remote -----------------------------------------------

    if(repo_exists & isFALSE(prior_commits)){
      writeLines("some text", "readme.md")
      worcs::git_update(message = "Initial commit", repo = the_path, files = ".")
    }

    expect_true(repo_exists)
    expect_true(startsWith(repo_url, "https://"))
    out <- gert::git_remote_ls(repo_url)
    expect_true(nrow(out) > 0)
    worcs:::git_remote_delete(remote_repo)
    out <- try(gert::git_remote_ls(repo_url), silent = TRUE)
    expect_true(any(grepl("404", out))) # Test to make sure the github repo is cleanly deleted
  })

})


test_that("create_fair_theory() works", {

  the_path <- fs::file_temp(pattern = "license")
  scoped_temporary_project(dir = the_path)

  theoryfile <- file.path(the_path, "testtheory.txt")
  writeLines("bla", theoryfile)
  out <- create_fair_theory(path = the_path,
                            title = "My Theory",
                            theory_file = theoryfile,
                            remote_repo = NULL,
                            add_license = "ccby")
  expect_true(out)
})

test_that("create_fair_theory() passes license arguments", {
  the_path <- fs::file_temp(pattern = "license_arguments")
  scoped_temporary_project(dir = the_path)

  out <- create_fair_theory(path = the_path,
                            title = NULL,
                            theory_file = NULL,
                            remote_repo = NULL,
                            add_license = "proprietary",
                            copyright_holder = "bla")
  expect_true(out)

})
