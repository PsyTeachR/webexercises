\name{Rdpack-package}
\alias{Rdpack-package}
\alias{Rdpack}
\docType{package}
\title{
  \Sexpr[stage=build,results=hide]{require(Rdpack)}
  \Sexpr[stage=build,results=hide]{pd <- utils::packageDescription("Rdpack")}
  \Sexpr[stage=build,results=hide]{lb <- library(help="Rdpack", character.only=TRUE)}
  \Sexpr[stage=build]{pd$Title}
}
\description{
  \Sexpr[stage=build]{pd$Description}
}
\details{
  \tabular{ll}{
    Package:  \tab \Sexpr[stage=build]{pd$Package}\cr
    Type:     \tab \Sexpr[stage=build]{pd$Type}\cr
    Version:  \tab \Sexpr[stage=build]{pd$Version} \cr
    Date:     \tab \Sexpr[stage=build]{pd$Date}\cr
    License:  \tab \Sexpr[stage=build]{pd$License}\cr
    LazyLoad: \tab \Sexpr[stage=build]{pd$LazyLoad}\cr
    Built:    \tab \Sexpr[stage=build]{pd$Built}
  }
%
% 2018-05-24 commenting out   
%    Index:
% 
%   \Sexpr[stage=build,results=rd]{paste("\\\\preformatted{", paste(if(!is.null(lb$info[[2]])) lb$info[[2]] else "No entries",collapse="\\n"), "}", sep="")}
%
%
  Package \code{Rdpack} provides a number of functions for maintenance
  of documentation in \R packages.  Although base \R and
  package \code{methods} have functions for creation of skeleton
  documentation, if a function gets a new argument or a generic gets a
  new method, then updating existing documentation is somewhat
  inconvenient. This package provides functions that update parts of the
  Rd documentation that can be dealt with automatically and leave manual
  changes untouched. For example, usage sections for functions are
  updated and if there are undescribed arguments, additional items are
  put in the `arguments' section. 
  
  A set of functions and macros support inclusion of references and
  citations from BibTeX files in \R documentation (Rd and
  roxygen2). These tools use only facilities provided by base \R and
  package \pkg{rbibutils} \insertCite{Rpackage:rbibutils}{Rdpack}.

  There are also convenience  macros for inclusion of evaluated examples
  and graphs, which hide some of the hassle of doing this directly with
  the underlying \verb{\Sexpr}'s.

  The subsections below give additional details, see also the vignettes.

  \subsection{Creating and updating Rd files}{
    
  The main function provided by this package is \code{\link{reprompt}}.
  There is also a function \code{\link{promptPackageSexpr}} for creating
  initial skeleton for overall package description such as this help
  page.

  \code{\link{reprompt}} produces a skeleton documentation for the
  requested object, similarly to functions like \code{prompt},
  \code{promptMethods}, and \code{promptClass}.  Unlike those functions,
  \code{\link{reprompt}} updates existing documentation (installed or in
  an Rd object or file) and produces a skeleton from scratch as a last
  resort only. If the documentation object describes more than one
  function, all descriptions are updated.  Basically,
  \code{\link{reprompt}} updates things that are generated
  automatically, leaving manual editing untouched.

  The typical use of \code{reprompt} is with one argument, as in
\preformatted{
    reprompt(infile = "./Rdpack/man/reprompt.Rd")
    reprompt(reprompt)
    reprompt("reprompt")
}
  \code{reprompt} updates the documentation of all objects described in
  the Rd object or file, and writes the updated Rd file in the current
  working directory, see \code{\link{reprompt}} for details. To describe
  a new function in an existing Rd file, just add something like
  \code{myfun()} and run reprompt to insert the correct signature,
  alias, etc. This works also for replacement functions, see
  \code{\link{reprompt}} for details.

  \code{\link{ereprompt}} updates the Rd documentation in a file,
  overwrites it and opens it in an editor. It calls \code{reprompt} to
  do the actual job but has different defaults. Which editor is opened,
  is system dependent, see the \code{\link[utils]{edit}} and
  \code{\link{ereprompt}} for futher details. 
  
  Users who work on Rd files in RStudio can use add-in \dQuote{Reprompt}
  to invoke \code{reprompt} conveniently on an Rd file or on a selected
  object in an \R source code file, see
  \code{\link{RStudio_reprompt}}. This add-in was contributed by Duncan
  Murdoch.

  Users of Emacs/ESS have various options, depending on their workflow.
  One approach is to define a key to call \code{\link{ereprompt}} on the
  file being edited, see
  \href{https://github.com/GeoBosh/georgisemacs}{georgisemacs} for an
  example setup. 

  

  \code{\link{promptPackageSexpr}} creates a skeleton for a
  package overview in file \verb{name-package.Rd}. Then the file can be
  edited as needed. This function needs to be called only once for a
  package since automatic generation of information in
  \verb{name-package.Rd} is achieved with Sexpr's at build time, not
  with verbatim strings (\code{promptPackage} used to insert verbatim
  strings but in recent versions of \R it also uses macros.).

  For example, the source of this help page is file
  `Rdpack-package.Rd'. It was initially produced using
\preformatted{
    promptPackageSexpr("Rdpack")
}
  The factual information at the beginning of this help topic (the index
  above, the version and other stuff that can be determined
  automatically) is kept automatically up to date.
}

\subsection{References and Citations}{
  
  Another set of functions is for management of bibliographic references
  in Rd files.  The old approach based on function \code{\link{rebib}}
  is fully functional, see below, but the recommended way to insert
  references and citations is based on Rd macros.

  The provided Rd macros are fully portable and, in particular, work in
  Rd files and roxygen2 comments, see \code{\link{insertRef}} and
  vignette \code{vignette("Inserting_bibtex_references", "Rdpack")}
  for details and examples.

  The Bibtex source for the references and citations produced by the Rd
  macros is file "REFERENCES.bib", which should be located in the root
  of the package installation directory. \pkg{Rdpack} needs also to be
  mentioned in two places in file `DESCRIPTION'. These one-off
  preparation steps are enumerated below:

  \enumerate{
    \item{
      Put  the following line in file `DESCRIPTION': \cr

      \verb{RdMacros: Rdpack} \cr
      
      (If there is already a line starting with 'RdMacros:', add
      \pkg{Rdpack} to the list on that line.)
    }

    \item{
      Add \pkg{Rdpack} to the list of imports (\verb{Imports:}
      field) in file `DESCRIPTION'.
    }

    \item{
      Add the following line to file `NAMESPACE':
\preformatted{  
    importFrom(Rdpack,reprompt)
}
      Alternatively, if \pkg{devtools} is managing your NAMESPACE file,
      the equivalent \pkg{roxygen2} line is:
\preformatted{  
    #' @importFrom Rdpack reprompt}
}

    \item{
      Create file \code{"REFERENCES.bib"} in subdirectory
      \code{"inst/"} of the package and put the BibTeX references in
      that file.
    }
  }

  The Rd macro \code{\\insertRef} takes two arguments: a BibTeX key and
  the name of a package. Thus, \code{\\insertRef{key}{package}} inserts
  the reference whose key is \code{key} from "REFERENCES.bib" of the
  specified package (almost always the one being documented).

  % With \pkg{Rdpack (>= 0.6-1)},
  Citations can be done with Rd
  macro \code{\\insertCite}, which inserts citation(s) for one or more
  BibTeX keys and records the keys.  \code{\\insertCiteOnly} is similar
  to \code{\\insertCite} but does not record the
  keys. \code{\\insertNoCite} records the keys but does not produce
  citations.

  \code{\\insertAllCited} creates a bibliography including
  all references recorded by \code{\\insertCite} and
  \code{\\insertNoCite}. It is usually put in section
  \dQuote{References}, something like:
\preformatted{  
    \references{
      \insertAllCited{}
    }
}
    in an Rd file. Don't align the backslash with the second 'e' of
    \code{@references}, since roxygen2 may interpret it as verbatim text, 
    not macro.


    The analogous documentation chunk in roxygen2 might look like this:
\preformatted{  
    #' @references
    #'     \insertAllCited{}
}  

  Bibliography styles for lists of references are supported as
  well. Currently the only alternative offered is to use long names
  (Georgi N. Boshnakov) in place of the default style (Boshnakov
  GN). More comprehensive alternatives can be included if needed or
  requested.

  Convenience functions \code{\link{makeVignetteReference}} and
  \code{\link{vigbib}} generate Bibtex entries for vignettes.

}

\subsection{Previewing documentation pages}{

  It is convenient during development to be able to view the
  rendered version of the document page being edited. 
  The function \code{\link{viewRd}} renders a documentation file in a
  source package and displays it as text or in a browser. It renders
  references properly in any workflow, including \pkg{devtools} development
  mode \insertCite{Rdevtools}{Rdpack} in Emacs/ESS, Rstudio, Rgui.
  This function is a good candidate to be assigned to a key in editors
  which support this.
  
  I created this function (in 2017) since the functions provided by
  \pkg{devtools} and Emacs/ESS are giving errors when processing pages
  containing Rd macros.
  
}

\subsection{Static Management of References}{
  
  In the alternative approach, the function \code{\link{rebib}} updates
  the bibliographic references in an Rd file. Rdpack uses a simple
  scheme for inclusion of bibliographic references. The key for each
  reference is in a TeX comment line, as in:
\preformatted{
    \references{
      ...
      \% bibentry: key1
      \% bibentry: key2
      ...
    }
}
  \code{rebib} puts each reference after the line containing its
  key. It does nothing if the reference has been put by a previous call
  of \code{rebib}. If the Bibtex entry for some references changes, it
  may be necessary to update them in the Rd file, as well. Call
  \code{rebib} with \code{force = TRUE} to get this effect. There is
  also a facility to include all references from the Bibtex file, see
  the documentation of \code{\link{rebib}} for details.
  
}

\subsection{Inserting evaluated examples}{

Sometimes the documentation of an object becomes more clear if accompanied by snippets of R
code and their results. 
The standard Rd macro \verb{\Sexpr} caters for a number of possibilities to evaluate \R code and
insert the results and the code in the documentation. 
The Rd macro \verb{\printExample} provided by package
\pkg{Rdpack} builds on it to print a snippet of \R code and the results of its evaluation, similarly to
console output but the code is not prefixed and the results are prefixed with comment
symbols.
For example, \verb{\printExample{2+2; a <- 2*3; a}} produces the
following in the rendered documentation:

\printExample{2+2; a <- 2*3; a}

The help page of \code{\link{promptUsage}} contains a number of examples created with
\code{\\printExample}. The corresponding Rd file can be obtained from the package tarball or from
\url{https://github.com/GeoBosh/Rdpack/blob/master/man/promptUsage.Rd}.

The argument of \verb{\printExample} must be on a single line with versions of R before
R 3.6.0.


\verb{\printExample} is typically placed in section Details of an
object's documentation, see section Details of \code{\link{get_usage}}
for anumber of examples produced mostly with \verb{\printExample}.

The macro \verb{\runExamples} can be used as a replacement
of section \verb{Examples}.
For example, if the following code is put at the top level in an Rd file (i.e. not in a
section):
\preformatted{
    \runExamples{2+2; a <- 2*3; a}
}
then it will be evaluated and replaced by a normal section examples:
\preformatted{
    \examples{
    2 + 2
    ##: 4
    a <- 2 * 3
    a
    ##: 6
    }
}
This generated examples section is processed by the standard \R tools (almost) as if it was
there from the outset. In particular, the examples are run by the R's quality control tools
and tangled along with examples in other documentation files.

In \R versions before 3.6.0 \verb{R CMD check} used to give a warning about
unknown \verb{\Sexpr} section at top level.

% According to the specification of the Rd format, \insertCite{@see @parseRd,
% p. 4;textual}{Rdpack} \verb{\Sexpr} at top level is legal but I need to check with the CRAN
% team or R devel if such expressions produced by user macros are excluded on purpose.
}

\subsection{Creating and including graphs}{

Figures can be inserted with the help of the standard Rd markup command
\verb{\figure}.  The Rd macro \verb{\insertFig} provided by package
\pkg{Rdpack} takes a snipped of \R code, evaluates it and inserts the
plot produced by it (using \verb{\figure}).  \verb{\insertFig} takes
three arguments: a filename, the package name and the code to evaluate
to produce the figure.  For example,
\preformatted{
    \insertFig{cars.png}{mypackage}{x <- cars$speed; y <- cars$dist; plot(x,y)}
}
will evaluate the code, save the graph in file \code{"man/figures/cars.png"} subdirectory of
package \code{"mypackage"}, and include the figure using \verb{\figure}. 
Subdirectory \code{"figures"} is created if it doesn't exist. 
Currently the graphs are saved in \code{"png"} format only.
In older versions of \R the code should be on a single line for the reasons explained in the
discussion of \verb{\printExample}. 

The sister macro \verb{\makeFig} creates the graph in exactly the same
way as \verb{\insertFig} but does not insert it. This can be done with a
separate \verb{\figure} command. This can be used if additional options are
desired for different output formats, see the description of \verb{\figure}
in "Writing R extensions".

}

  Other functions that may be useful are \code{Rdo2Rdf}, \code{Rdapply}
  and \code{Rd_combo}. Here is also brief information about some more
  technical functions that may be helpful in certain circumstances.

  \code{\link{get_usage}} generates usage text for functions and
  methods. The functions can be located in environments or other
  objects. This may be useful for description of function elements of
  compound objects. 

  \code{\link{c_Rd}} concatenates Rd pieces, character strings and lists
  to create a larger Rd piece or a complete Rd object.
  \code{\link{list_Rd}} is similar to \code{\link{c_Rd}} but provides
  additional features for convenient assembling of Rd objects.

  \code{\link{parse_Rdpiece}} is a technical function for parsing pieces
  of Rd source text but it has an argument to return formatted help text
  which may be useful when one wishes to show it to the user.

  \code{Rdo_set_section} can be used to set a section, such as
  "\verb{\author}".

  The remaining functions in the package are for programming with Rd
  objects.

}
\author{
  \Sexpr[stage=build]{pd$Author}

Maintainer: \Sexpr[stage=build]{pd$Maintainer}
}
\note{
  All processing is done on the parsed Rd objects, i.e. objects of class
  "Rd" or pieces of such objects \insertCite{parseRd}{Rdpack}.

  The following terminology is used (todo: probably not yet
  consistently) throughout the documentation.

  "Rd object" - an object of class Rd, or part of such object.

  "Rd piece" - part of an object of class Rd. Fragment is also used but
  note that \code{parse_Rd} defines fragment more restrictively.

  "Rd text", "Rd source text", "Rd format" - these refer to the text of
  the Rd files.
}
\seealso{
%  \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
  \code{\link{ereprompt}},
  \code{\link{reprompt}},
  \code{\link{promptPackageSexpr}},
  \code{\link{rebib}},
  
  \code{\link{get_usage}},
  
  \code{\link{viewRd}},
  \code{\link{vigbib}},
  \code{\link{makeVignetteReference}},
  
  \code{vignette("Inserting_bibtex_references", package = "Rdpack")},

  \code{vignette("Inserting_figures_and_evaluated_examples", package = "Rdpack")}
  
}
\references{

  \strong{Note:} Reference \insertCite{dummyArticle;textual}{Rdpack}
  does not exist. It is a test that simple math in BibTeX entries works.

  ---
  
  \insertAllCited{}
}
\examples{
## The examples below show typical use but are not executable.
## For executable examples see the help pages of 
## reprompt, promptPackageSexpr, and rebib.

## To make the examples executable, replace "myfun" with a real
## function, and similarly for classes and paths to files.

\dontrun{
## update the doc. from the Rd source and save myfun.Rd
##     in the current directory (like prompt)
reprompt(infile="path/to/mypackage/man/myfun.Rd")

## update doc of myfun() from the installed doc (if any);
##     if none is found, create it like prompt
reprompt("myfun")
reprompt(myfun)      # same

## update doc. for S4 methods from Rd source
reprompt(infile="path/to/mypackage/man/myfun-methods.Rd")

## update doc. for S4 methods from installed doc (if any);
##     if none is found, create it like promptMethods
reprompt("myfun", type = "methods")
reprompt("myfun-methods")  # same


## update doc. for S4 class from Rd source
reprompt(infile="path/to/mypackage/man/myclass-class.Rd")

## update doc. of S4 class from installed doc.
##     if none is found, create it like promptClass
reprompt("myclass-class")
reprompt("myclass", type = "class")  # same


## create a skeleton "mypackage-package.Rd"
promptPackageSexpr("mypackage")

## update the references in "mypackage-package.Rd"
rebib(infile="path/to/mypackage/man/mypackage-package.Rd", force=TRUE)
}
}
\keyword{ package }
