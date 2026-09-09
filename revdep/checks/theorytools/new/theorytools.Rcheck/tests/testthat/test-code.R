test_that("code returns correct data.frame", {
  x <- c("aa1", "aa2", "ba1", "bb1", "bb2")
  coded <- code(x)
  coded <- code(coded, "aa", 1:2)
  coded <- code(coded, "ba", 1)
  coded <- code(coded, "bb", 1:2)
  coded <- theorytools:::add_level(coded)
  coded <- code(coded, "a", 1)
  coded <- code(coded, "b", 1:2)
  tmp <- as.data.frame(coded)
  expect_all_true(substr(tmp$input, 1, 2) == tmp$label)
  expect_all_true(substr(tmp$input, 1, 1) == tmp$label1)
})

test_that("similarity works", {
  skip_if_not(requireNamespace("reticulate", quietly = TRUE))

  skip_on_cran()
  #skip_on_ci()

  skip_if_not(theorytools:::check_python(c("transformers", "numpy", "torch")))
  if(dir.exists("../../dev/minilm")){
    res <- get_embeddings(c("a", "b"), "../../dev/minilm")
  } else {
    theorytools:::scoped_tempdir({
      theorytools::download_huggingface("sentence-transformers/all-MiniLM-L6-v2", "minilm")
      res <- get_embeddings(c("a", "b"), "minilm")
    })
  }
  expect_true(is.matrix(res))
  expect_equal(dim(res), c(2,384), ignore_attr = TRUE)
})

test_that("code returns items in correct order", {
x <- c("cat", "dog", "kitty", "cute cats", "doggy", "hyacinth")
coded <- code(x)
# coded <- tmp
coded <- code(coded, "cat", 1, 3, 4)
coded <- code(coded, "dog", 1, 2)
coded <- code(coded, "hyacinth", 1)
coded <- theorytools:::add_level(coded)
coded <- code(coded, "animal", 1, 2)
coded <- code(coded, "plant", 1)
tmp <- as.data.frame(coded)
expect_all_true(tmp$input == x)
})
