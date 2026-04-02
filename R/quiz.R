#' @title Create a Quiz
#' @description Convenience function for creating a basic quiz in HTML format
#' from the arguments captured by `...`, where the type of each question
#' is determined automatically from the class of the arguments.
#' @param ... Each argument should be a named vector, see Details.
#' @param title Atomic character, default: 'Quiz'
#' @param show_box Logical, whether or not to draw a box around the quiz.
#' Default: `TRUE`
#' @param show_check Logical, whether or not to show a button to check answers.
#' Default: `TRUE`
#' @return `NULL`, this function is called for its side effect of printing HTML
#' code using `cat()`.
#' @details The function renders questions captured by the arguments in `...`.
#' The name of each argument is the text of the question. The value of each
#' argument determined the question type and its correct answer. The following
#' types of questions are supported:
#'
#' \describe{
#'  \item{"`torf()`"}{The argument should be a single value of type `logical`,
#'  e.g.: `"The answer to this question is true." = TRUE`}
#'  \item{"`mcq()`"}{The argument should be a vector of type `character`. The
#'  first element is taken as the correct answer; the order of answers is
#'  randomized. E.g.: `"This multiple choice question has three answers." =
#'  c("Correct", "Incorrect", "Not sure")`}
#'  \item{"`fitb()`"}{The argument should be of type `numeric`. If the vector is
#'  atomic, the first element is taken as the correct answer, e.g.:
#'  `"Provide an exact floating point answer of 0.81" = 0.81`. If the vector has
#'  two elements, the second element is taken as the tolerance `tol`,
#'  e.g.: `"Here, 0.8 will be correct." = c(0.81, 0.01)`. If the
#'  vector is of type `integer`, the tolerance is set to zero, e.g.:
#'  `"The answer is 4." = 4L`}
#' }
#'
#' Alternatively, `...` may contain a single atomic character referring to a
#' text file that contains the questions, see examples.
#' @examples
#' # Quiz from arguments:
#' invisible(capture.output(
#' quiz(
#' "The answer to this question is true." = TRUE,
#' "This multiple choice question has three answers." = c("Correct", "Incorrect", "Not sure"),
#' "Provide an exact floating point answer of 0.81" = 0.81
#' )
#' ))
#' # From a file:
#' quiz_file <- tempfile()
#' writeLines(
#' c("The answer is true. = TRUE",
#' "The answer is correct = c(answer = \"Correct\", \"Incorrect\", \"Not sure\")",
#' "The answer is exactly .81 = 0.81",
#' "But here, .8 is also fine = c(0.81, .01)",
#' "Here, answer exactly 4. = 4L")
#' , quiz_file)
#' invisible(capture.output(quiz(quiz_file)))
#' @rdname quiz
#' @export
#' @importFrom knitr is_html_output is_latex_output
quiz <- function(..., title = "Quiz", show_box = TRUE, show_check = TRUE){
  # Parse input -------------------------------------------------------------

  if (isTRUE(knitr::is_html_output() & !requireNamespace("webexercises", quietly = TRUE))) {
    return("")
  }

  dots <- list(...)
  # Check if a file is provided instead of multiple questions
  if (length(dots) == 1) {
    if (file.exists(dots[[1]])) {
      txt <- readLines(dots[[1]])
      questionz <- lapply(txt, function(q) {
        spl <- regexpr("=", q)
        trimws(substring(q, c(1, spl + 1), c(spl - 1, nchar(q))))
      })
      dots <- lapply(questionz, function(q) {
        eval(parse(text = q[2]))
      })
      names(dots) <- trimws(sapply(questionz, `[`, 1))
    }
  }

  # In case of HTML output --------------------------------------------------
  output_format <- determine_output_format()
  if (output_format == "html") {
    if (requireNamespace("webexercises", quietly = TRUE)) {
      # Now, prepare the HTML code
      txt <- tryCatch({
        if (show_box | show_check) {
          classes <- paste0(' class = "', trimws(paste0(c(
            c("", "webex-check")[show_check + 1L], c("", "webex-box")[show_box + 1L]
          ), collapse = " ")), '"')
        }
        intro <- paste0(
          '<div class="webex-check webex-box">\n<span>\n<p style="margin-top:1em; text-align:center">\n<b>',
          title,
          '</b></p>\n<p style="margin-left:1em;">\n'
        )
        outro <- '\n</p>\n</span>\n</div>'

        questions <- sapply(dots, function(q) {
          switch(
            class(q)[1],
            "character" = {
              opts <- q
              if (any(names(opts) == "answer")) {
                mcq(sample(opts))
              } else {
                fitb(answer = opts, num = FALSE)
              }
            },
            "logical" = {
              torf(answer = q)
            },
            "numeric" = {
              if (length(q) == 1) {
                fitb(answer = q)
              } else {
                fitb(answer = q[1], tol = q[2])
              }

            },
            "integer" = {
              fitb(answer = q[1], tol = 0)
            }
          )
        })

        paste0(intro, paste(paste(names(dots), questions), collapse = "\n\n"), outro)
      }, error = function(e){ "" })
      return(cat(txt, sep = "\n"))
    }
  }


  # In case of PDF output ---------------------------------------------------

  if (output_format == "latex") {
    txt <- tryCatch({

      questions <- unlist(lapply(seq_along(dots), function(i) {
        n <- names(dots)[i]
        q <- dots[[n]]
        c(paste0("\\textbf{ Q", i, ": ", n, "}", collapse = ""), "",
          tryCatch({
            switch(class(q)[1],
                   "character" = {
                     if (any(names(q) == "answer")) {
                       c("\\begin{enumerate}",
                         "\\def\\labelenumi{\\Alph{enumi}.}",
                         "\\tightlist",
                         as.character(t(expand.grid("\\item", paste0("  ", sample(q)), stringsAsFactors = FALSE)))
                         , "\\end{enumerate}")
                     } else {
                       stop()
                     }
                   },
                   "logical" = {
                     c("\\begin{enumerate}", "\\tightlist", "\\item[$\\square$]", "  True", "\\item[$\\square$]",
                       "  False", "\\end{enumerate}")
                   },
                   "\\hspace{\\parindent}\\ignorespaces\\ldots{}"
            )}, error = function(e){ "\\hspace{\\parindent}\\ignorespaces\\ldots{}"}),
          "")
      }))

      ansrs <- unname(as.character(dots))
      is_mc <- !is.na(sapply(dots, `[`, "answer"))
      if(any(is_mc)){
        ansrs[which(is_mc)] <- sapply(dots[which(is_mc)], `[`, "answer")
      }
      ansrs <- c("\\begin{itemize}", "\\tightlist",
                 paste0("\\item[Q", seq_along(ansrs), ":]  ", ansrs),
                 "\\end{itemize}")
      if(show_box){
        txt <- c(paste0("\\begin{tcolorbox}[breakable, enhanced jigsaw,colback=blue!5!white,colframe=blue!75!black,rounded corners, parbox=false,title=", title, "]"),
        "",
        questions,
        "",
        "\\tcblower",
        "\\textbf{Answers}",
        "",
        ansrs,
        "",
        "\\end{tcolorbox}")

      } else {
        txt <- c(paste0("\\textbf{", title, "}"),
                 "\\",
                 questions,
                 "\\textbf{Answers}",
                 "\\",
                 ansrs)
      }
      txt
    }, error = function(e){ "" })
    return(knitr::raw_latex(txt))
  }

  ""
}
