test_that("special characters properly escaped", {
  skip_if_not_pandoc("2.0")
  skip_if_no_quarto()

  scoped_tempdir({
    # new <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = "")
    # dir.create(new)
    # oldwd <- setwd(new)
    #the_path <- "."
    create_quarto_doc("untitled", open = FALSE)
    f <- "untitled/untitled.qmd"
    add_to_quarto_file(f)
    lnz <- readLines(f)
    lnz <- c(lnz[1:(grep('library(webexercises)', lnz, fixed = TRUE)+2L)], c('', '', '`r quiz("Testing # $ % _ { and }" = c(answer = "# $ % _ { and }", "something else"))`'))
    writeLines(lnz, f)
    quarto::quarto_render(f)
    lnz_html <- readLines("untitled/untitled.html")
    lnz_html <- grep("# $ % _ { and }", lnz_html, fixed = TRUE, value = TRUE)
    expect_true(length(unlist(regmatches(lnz_html, gregexpr("# $ % _ { and }", lnz_html, fixed = TRUE)))) == 2)
    if(requireNamespace("pdftools", quietly = TRUE)){
      lnz_pdf <- pdftools::pdf_text("untitled/untitled.pdf")
      lnz_pdf <- grep("# $ % _ { and }", lnz_pdf, fixed = TRUE, value = TRUE)
      expect_true(length(unlist(regmatches(lnz_pdf, gregexpr("# $ % _ { and }", lnz_pdf, fixed = TRUE)))) == 3)
    }
  })

})
