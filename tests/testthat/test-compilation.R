test_that("minimal compile", {
  skip_on_cran()
  
  ## make a temporary file
  tf <- tempfile(fileext=".Rmd")
  cat("---",
      "title: \"Web Exercises\"",
      "output: webexercises::webexercises_default",
      "---", "",
      "\"no smart quotes\"", "", 
      "```{r test, webex.hide=\"click me\"}",
      "rnorm(10)",
      "```",
      file=tf,
      sep = "\n")


  ## compile it
  outfile <- rmarkdown::render(tf, quiet=TRUE)
  expect_equal(basename(outfile),
               sub("\\.Rmd$", ".html", basename(tf)))
  
  # check for no smart quotes (&quot; not &ldquo; or &rdquo;)
  rendered_text <- readLines(outfile)
  smart_quotes <- grep("no smart quotes", rendered_text)
  expect_equal(rendered_text[smart_quotes], "<p>&quot;no smart quotes&quot;</p>")
  
  # check for hide button
  click_me <- grep("click me", rendered_text)
  expect_equal(rendered_text[click_me-1], "<button>")
  expect_equal(rendered_text[click_me-2], "<div class=\"webex-solution\">")
  
  ## cleanup
  if (file.exists(tf)) file.remove(tf)
  if (file.exists(outfile)) file.remove(outfile)
})
