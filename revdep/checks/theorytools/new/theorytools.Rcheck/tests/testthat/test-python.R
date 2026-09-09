test_that("similarity works", {
  skip_if_not(requireNamespace("reticulate", quietly = TRUE))

  skip_on_cran()
  #skip_on_ci()

  skip_if_not(theorytools:::check_python(c("transformers", "numpy", "torch")))
  if(dir.exists("../../dev/minilm")){
    res <- get_embeddings(c("a", "b"), "../../dev/minilm")
    x <- c("cat", "dog", "kitty", "cute cats", "doggy", "hyacinth")
    coded <- code(x, similarity = "embeddings", model_path = "../../dev/minilm")
  } else {
    theorytools:::scoped_tempdir({
      theorytools::download_huggingface("sentence-transformers/all-MiniLM-L6-v2", "minilm")
      res <- get_embeddings(c("a", "b"), "minilm")
      x <- c("cat", "dog", "kitty", "cute cats", "doggy", "hyacinth")
      coded <- code(x, similarity = "embeddings", model_path = "minilm")
    })
  }
  expect_true(is.matrix(res))
  expect_equal(dim(res), c(2,384), ignore_attr = TRUE)


  coded <- code(coded, "cat", 1, 3, 4)
  coded <- code(coded, "dog", 1, 2)
  coded <- code(coded, "hyacinth", 1)
  coded <- theorytools:::add_level(coded)
  coded <- code(coded, "animal", 1, 2)
  coded <- code(coded, "plant", 1)
  tmp <- as.data.frame(coded)
  expect_all_true(tmp$input == x)

})
