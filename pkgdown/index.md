# webexercises

<!-- rmarkdown v1 -->

<img src="logo.png" style="float:right; max-width:280px; width: 25%;" />




The goal of `{webexercises}` is to enable instructors to easily create interactive web pages that students can use in self-guided learning. Although `{webexercises}` has fewer features than RStudio's [learnr](https://rstudio.github.io/learnr/) package, it is more lightweight: whereas `{learnr}` tutorials must be either hosted on a shiny server or run locally, `{webexercises}` creates standalone HTML files that require only a JavaScript-enabled browser. It is also extremely simple to use.

## Installation

You can install `{webexercises}` from CRAN using:


```r
install.packages("webexercises")
```

You can install the development version from [GitHub](https://github.com/PsyTeachR/webexercises) with:


```r
devtools::install_github("psyteachr/webexercises")
```

## Setup

### RMarkdown

Examples are provided in templates. To create an RMarkdown file from the webexercises template in RStudio, click `File -> New File... -> RMarkdown` and in the dialog box that appears, select `From Template` and choose `Web Exercises`.

Alternatively (or if you're not using RStudio) use:


```r
rmarkdown::draft("exercises.Rmd", "webexercises", "webexercises")
```

Knit the file to HTML to see how it works. **Note: The widgets only function in a JavaScript-enabled browser.**

### Quarto

You can set up a single template quarto file with the function `create_quarto_doc()`, or add the necessary files and setup to include webexercises in a quarto project with `add_to_quarto()`.

### Bookdown

You can add webexercises to a bookdown project or start a new bookdown project using `add_to_bookdown()`.


```r
# create a new book
# use default includes and scripts directories (include and R)
# output_format can be bs4_book, gitbook, html_book or tufte_html_book
add_to_bookdown(bookdown_dir = "demo_bs4",
                output_format = "bs4_book",
                render = TRUE)

# update an existing book with custom include and script directories
add_to_bookdown(bookdown_dir = ".",
                include_dir = "www",
                script_dir = "scripts",
                output_format = "gitbook")
```


## Creating interactive widgets with inline code

The webexercises package provides functions that create HTML widgets using [inline R code](https://github.com/rstudio/cheatsheets/raw/master/rmarkdown-2.0.pdf).  These functions are:

| function                | widget         | description                    |
|:------------------------|:---------------|:-------------------------------|
| `fitb()`                | text box       | fill-in-the-blank question     |
| `mcq()`                 | pull-down menu | multiple choice question       |
| `torf()`                | pull-down menu | TRUE or FALSE question         |
| `longmcq()`             | radio buttons  | MCQs with long answers         |
| `hide()` and `unhide()` | button         | solution revealed when clicked |

The appearance of the text box and pull-down menu widgets changes when users enter the correct answer. Answers can be either static or dynamic (i.e., specified using R code). Widget styles can be changed using `style_widgets()`.

These functions are optimised to be used with inline r code, but you can also use them in code chunks by setting the chunk option `results = 'asis'` and using `cat()` to display the result of the widget. 


```r
# echo = FALSE, results = 'asis'
opts <- c("install.package", 
            "install.packages", 
            answer = "library", 
            "libraries")

q1 <- mcq(opts)

cat("What function loads a package that is already on your computer?", q1)
```

What function loads a package that is already on your computer? <select class='webex-select'><option value='blank'></option><option value=''>install.package</option><option value=''>install.packages</option><option value='answer'>library</option><option value=''>libraries</option></select>

### Fill-In-The-Blanks

Create fill-in-the-blank questions using `fitb()`, providing the answer as the first argument.


```r
fitb(4)
```

- 2 + 2 is <input class='webex-solveme nospaces' size='1' data-answer='["4"]'/>

You can also create these questions dynamically, using variables from your R session (e.g., in a hidden code chunk).


```r
x <- sample(2:8, 1)
```


```r
fitb(x)
```

- The square root of 64 is: <input class='webex-solveme nospaces' size='1' data-answer='["8"]'/>



The blanks are case-sensitive; if you don't care about case, use the argument `ignore_case = TRUE`.


```r
fitb("E", ignore_case = TRUE)
```

- What is the letter after D? <input class='webex-solveme nospaces ignorecase' size='1' data-answer='["E"]'/>



If you want to ignore differences in whitespace use, use the argument `ignore_ws = TRUE` (which is the default) and include spaces in your answer anywhere they could be acceptable.


```r
fitb(c("library( tidyverse )", "library( \"tidyverse\" )", "library( 'tidyverse' )"), ignore_ws = TRUE, width = "20")
```

- How do you load the tidyverse package? <input class='webex-solveme nospaces' size='20' data-answer='["library( tidyverse )","library( \"tidyverse\" )","library( &apos;tidyverse&apos; )"]'/>

You can set more than one possible correct answer by setting the answers as a vector.


```r
fitb(c("A", "E", "I", "O" , "U"), ignore_case = TRUE)
```

- Type a vowel: <input class='webex-solveme nospaces ignorecase' size='1' data-answer='["A","E","I","O","U"]'/>

You can use regular expressions to test answers against more complex rules.


```r
fitb("^[a-zA-Z]{3}$", width = 3, regex = TRUE)
```

- Type any 3 letters: <input class='webex-solveme nospaces regex' size='3' data-answer='["^[a-zA-Z]{3}$"]'/>

### Multiple Choice

Set up a multiple-choice drop-down menu using `mcq()`.


```r
mcq(c("tidyr", "dplyr", answer = "readr", "ggplot2"))
```

- What package helps you load CSV files? <select class='webex-select'><option value='blank'></option><option value=''>tidyr</option><option value=''>dplyr</option><option value='answer'>readr</option><option value=''>ggplot2</option></select>
- "Never gonna give you up, never gonna: <select class='webex-select'><option value='blank'></option><option value=''>let you go</option><option value=''>turn you down</option><option value=''>run away</option><option value='answer'>let you down</option></select>"
- "I <select class='webex-select'><option value='blank'></option><option value='answer'>bless the rains</option><option value=''>guess it rains</option><option value=''>sense the rain</option></select> down in Africa" -Toto

### True or False

Make quick true/false questions with `torf()`.


```r
torf(TRUE)
torf(FALSE)
```

- True or False? You can permute values in a vector using `sample()`. <select class='webex-select'><option value='blank'></option><option value='answer'>TRUE</option><option value=''>FALSE</option></select>

### Longer MCQs

When your answers are very long, sometimes a drop-down select box gets formatted oddly. You can use `longmcq()` to deal with this. Since the answers are long, It's probably best to set up the options inside an R chunk with `echo=FALSE`. 


```r
opts_p <- c(
   "the probability that the null hypothesis is true",
   answer = "the probability of the observed, or more extreme, data, under the assumption that the null-hypothesis is true",
   "the probability of making an error in your conclusion"
)
```


```r
longmcq(opts_p)
```

**What is a p-value?**

<div class='webex-radiogroup' id='radio_BXNUQHYFVH'><label><input type="radio" autocomplete="off" name="radio_BXNUQHYFVH" value=""></input> <span>the probability that the null hypothesis is true</span></label><label><input type="radio" autocomplete="off" name="radio_BXNUQHYFVH" value="answer"></input> <span>the probability of the observed, or more extreme, data, under the assumption that the null-hypothesis is true</span></label><label><input type="radio" autocomplete="off" name="radio_BXNUQHYFVH" value=""></input> <span>the probability of making an error in your conclusion</span></label></div>


**What is true about a 95% confidence interval of the mean?**



<div class='webex-radiogroup' id='radio_ZBJROQGGSC'><label><input type="radio" autocomplete="off" name="radio_ZBJROQGGSC" value=""></input> <span>there is a 95% probability that the true mean lies within this range</span></label><label><input type="radio" autocomplete="off" name="radio_ZBJROQGGSC" value="answer"></input> <span>if you repeated the process many times, 95% of intervals calculated in this way contain the true mean</span></label><label><input type="radio" autocomplete="off" name="radio_ZBJROQGGSC" value=""></input> <span>95% of the data fall within this range</span></label></div>



## Checked sections

Create sections with the class `webex-check` to add a button that hides feedback until it is pressed. Add the class `webex-box` to draw a box around the section (or use your own styles).



````default
::: {.webex-check .webex-box}

I am going to learn a lot: `r torf(TRUE)`

```{r, results='asis', echo = FALSE}
opts <- c(
   "the probability that the null hypothesis is true",
   answer = "the probability of the observed, or more extreme, data, under the assumption that the null-hypothesis is true",
   "the probability of making an error in your conclusion"
)

cat("What is a p-value?", longmcq(opts))
```

:::
````

::: {.webex-check .webex-box}

I am going to learn a lot: <select class='webex-select'><option value='blank'></option><option value='answer'>TRUE</option><option value=''>FALSE</option></select>

What is a p-value? <div class='webex-radiogroup' id='radio_WNZTIYKBKN'><label><input type="radio" autocomplete="off" name="radio_WNZTIYKBKN" value=""></input> <span>the probability that the null hypothesis is true</span></label><label><input type="radio" autocomplete="off" name="radio_WNZTIYKBKN" value="answer"></input> <span>the probability of the observed, or more extreme, data, under the assumption that the null-hypothesis is true</span></label><label><input type="radio" autocomplete="off" name="radio_WNZTIYKBKN" value=""></input> <span>the probability of making an error in your conclusion</span></label></div>

:::



## Hidden solutions and hints

You can fence off a solution area that will be hidden behind a button using `hide()` before the solution and `unhide()` after, each as inline R code.  Pass the text you want to appear on the button to the `hide()` function.


````default
`r hide("Click here to see the solution")`

```{r eval = FALSE}
library(tidyverse)
```

`r unhide()`
````

How do you load tidyverse?


<div class='webex-solution'><button>Click here to see the solution</button>



```r
library(tidyverse)
```


</div>


If the solution is an RMarkdown code chunk, instead of using `hide()` and `unhide()`, you can set the `webex.hide` chunk option to TRUE, or set it to the string you wish to display on the button.


````default
```{r, echo = TRUE, eval = FALSE, webex.hide = "See a hint"}
?plot
```
````


<div class='webex-solution'><button>See a hint</button>

```r
?plot
```


</div>


<a rel="license" href="https://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

<script>

/* update total correct if #webex-total_correct exists */
update_total_correct = function() {
  console.log("webex: update total_correct");

  var t = document.getElementsByClassName("webex-total_correct");
  for (var i = 0; i < t.length; i++) {
    p = t[i].parentElement;
    var correct = p.getElementsByClassName("webex-correct").length;
    var solvemes = p.getElementsByClassName("webex-solveme").length;
    var radiogroups = p.getElementsByClassName("webex-radiogroup").length;
    var selects = p.getElementsByClassName("webex-select").length;

    t[i].innerHTML = correct + " of " + (solvemes + radiogroups + selects) + " correct";
  }
}

/* webex-solution button toggling function */
b_func = function() {
  console.log("webex: toggle hide");

  var cl = this.parentElement.classList;
  if (cl.contains('open')) {
    cl.remove("open");
  } else {
    cl.add("open");
  }
}

/* check answers */
check_func = function() {
  console.log("webex: check answers");

  var cl = this.parentElement.classList;
  if (cl.contains('unchecked')) {
    cl.remove("unchecked");
    this.innerHTML = "Hide Answers";
  } else {
    cl.add("unchecked");
    this.innerHTML = "Show Answers";
  }
}

/* function for checking solveme answers */
solveme_func = function(e) {
  console.log("webex: check solveme");

  var real_answers = JSON.parse(this.dataset.answer);
  var my_answer = this.value;
  var cl = this.classList;
  if (cl.contains("ignorecase")) {
    my_answer = my_answer.toLowerCase();
  }
  if (cl.contains("nospaces")) {
    my_answer = my_answer.replace(/ /g, "")
  }

  if (my_answer == "") {
    cl.remove("webex-correct");
    cl.remove("webex-incorrect");
  } else if (real_answers.includes(my_answer)) {
    cl.add("webex-correct");
    cl.remove("webex-incorrect");
  } else {
    cl.add("webex-incorrect");
    cl.remove("webex-correct");
  }

  // match numeric answers within a specified tolerance
  if(this.dataset.tol > 0){
    var tol = JSON.parse(this.dataset.tol);
    var matches = real_answers.map(x => Math.abs(x - my_answer) < tol)
    if (matches.reduce((a, b) => a + b, 0) > 0) {
      cl.add("webex-correct");
    } else {
      cl.remove("webex-correct");
    }
  }

  // added regex bit
  if (cl.contains("regex")){
    answer_regex = RegExp(real_answers.join("|"))
    if (answer_regex.test(my_answer)) {
      cl.add("webex-correct");
    }
  }

  update_total_correct();
}

/* function for checking select answers */
select_func = function(e) {
  console.log("webex: check select");

  var cl = this.classList

  /* add style */
  cl.remove("webex-incorrect");
  cl.remove("webex-correct");
  if (this.value == "answer") {
    cl.add("webex-correct");
  } else if (this.value != "blank") {
    cl.add("webex-incorrect");
  }

  update_total_correct();
}

/* function for checking radiogroups answers */
radiogroups_func = function(e) {
  console.log("webex: check radiogroups");

  var checked_button = document.querySelector('input[name=' + this.id + ']:checked');
  var cl = checked_button.parentElement.classList;
  var labels = checked_button.parentElement.parentElement.children;

  /* get rid of styles */
  for (i = 0; i < labels.length; i++) {
    labels[i].classList.remove("webex-incorrect");
    labels[i].classList.remove("webex-correct");
  }

  /* add style */
  if (checked_button.value == "answer") {
    cl.add("webex-correct");
  } else {
    cl.add("webex-incorrect");
  }

  update_total_correct();
}

window.onload = function() {
  console.log("webex onload");
  /* set up solution buttons */
  var buttons = document.getElementsByTagName("button");

  for (var i = 0; i < buttons.length; i++) {
    if (buttons[i].parentElement.classList.contains('webex-solution')) {
      buttons[i].onclick = b_func;
    }
  }

  var check_sections = document.getElementsByClassName("webex-check");
  console.log("check:", check_sections.length);
  for (var i = 0; i < check_sections.length; i++) {
    check_sections[i].classList.add("unchecked");

    let btn = document.createElement("button");
    btn.innerHTML = "Show Answers";
    btn.classList.add("webex-check-button");
    btn.onclick = check_func;
    check_sections[i].appendChild(btn);

    let spn = document.createElement("span");
    spn.classList.add("webex-total_correct");
    check_sections[i].appendChild(spn);
  }

  /* set up webex-solveme inputs */
  var solveme = document.getElementsByClassName("webex-solveme");

  for (var i = 0; i < solveme.length; i++) {
    /* make sure input boxes don't auto-anything */
    solveme[i].setAttribute("autocomplete","off");
    solveme[i].setAttribute("autocorrect", "off");
    solveme[i].setAttribute("autocapitalize", "off");
    solveme[i].setAttribute("spellcheck", "false");
    solveme[i].value = "";

    /* adjust answer for ignorecase or nospaces */
    var cl = solveme[i].classList;
    var real_answer = solveme[i].dataset.answer;
    if (cl.contains("ignorecase")) {
      real_answer = real_answer.toLowerCase();
    }
    if (cl.contains("nospaces")) {
      real_answer = real_answer.replace(/ /g, "");
    }
    solveme[i].dataset.answer = real_answer;

    /* attach checking function */
    solveme[i].onkeyup = solveme_func;
    solveme[i].onchange = solveme_func;

    solveme[i].insertAdjacentHTML("afterend", " <span class='webex-icon'></span>")
  }

  /* set up radiogroups */
  var radiogroups = document.getElementsByClassName("webex-radiogroup");
  for (var i = 0; i < radiogroups.length; i++) {
    radiogroups[i].onchange = radiogroups_func;
  }

  /* set up selects */
  var selects = document.getElementsByClassName("webex-select");
  for (var i = 0; i < selects.length; i++) {
    selects[i].onchange = select_func;
    selects[i].insertAdjacentHTML("afterend", " <span class='webex-icon'></span>")
  }

  update_total_correct();
}

</script>

