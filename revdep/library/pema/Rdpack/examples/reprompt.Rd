\name{reprompt}
\alias{reprompt}
\title{Update the documentation of a topic}
\description{Examine the documentation of functions, methods or classes and
  update it with additional arguments, aliases, methods or slots, as
  appropriate. This is an extention of the promptXXX() family of functions.
}
\usage{
reprompt(object, infile = NULL, Rdtext = NULL, final = TRUE, 
         type = NULL, package = NULL, methods = NULL, verbose = TRUE, 
         filename = NULL, sec_copy = TRUE, edit = FALSE, \dots)
}
\arguments{
  \item{object}{the object whose documentation is to be updated, such as
    a string, a function, a help topic, a parsed Rd object, see
    `Details'.}
  \item{infile}{a file name containing Rd documentation, see `Details'.}
  \item{Rdtext}{a character string with Rd formatted text, see `Details'.}
  \item{final}{logical, if \code{TRUE} modifies the output of
    \code{prompt} so that the package can be built.}
  \item{type}{type of topic, such as \code{"methods"} or
    \code{"class"}, see `Details'.} 
  \item{package}{package name; document only objects defined in this
    package, especially useful for methods, see `Details'.} 
  \item{methods}{
    used for documentation of S4 methods only, rarely needed even for
    them.  This argument is passed on to
    \code{\link[methods]{promptMethods}}, see its documentation for
    details.
  }
  \item{verbose}{if \code{TRUE} print messages on the screen.}
  \item{filename}{name of the file for the generated Rd content; if
    \code{NULL}, a suitable file name is generated, if \code{TRUE} it
    will be set to \code{infile},   
    if \code{FALSE} the Rd text is returned, see `Details'.}
  \item{\dots}{currently not used.}
  \item{sec_copy}{if \code{TRUE} copy Rd contents of unchanged sections
    in the result, see Details.}
  \item{edit}{if \code{TRUE} call \code{file.edit} just before
    returning. This argument is ignored if \code{filename} is \code{FALSE}.}
}
\details{
  The typical use of \code{reprompt} is with one argument, as in
  \preformatted{
    reprompt(infile = "./Rdpack/man/reprompt.Rd")
    reprompt(reprompt)
    reprompt("reprompt")
  }
  \code{reprompt} updates the requested documentation and writes the new
  Rd file in the current working directory. When argument \code{infile}
  is used, the descriptions of all objects described in the input file
  are updated. When an object or its name is given, \code{reprompt}
  looks first for installed documentation and processes it in the same
  way as in the case of \code{infile}. If there is no documentation for
  the object, \code{reprompt} creates a skeleton Rd file similar to the
  one produced by the base R functions from the \code{prompt} family (if
  \code{final = TRUE}, the default, it modifies the output of
  \code{prompt()}, so that the package can be built).

  To document a function, say \code{myfun}, in an existing Rd file, just
  add \code{myfun()} to the usage section in the file and call
  \code{reprompt()} on that file. Put quotes around the function name if
  it is non-syntactic.  For replacement functions (functions with names
  ending in \code{<-}) \code{reprompt()} will insert the proper usage
  statement. For example, if the signature of \code{xxx<-} is \code{(x,
  ..., value)} then both, \code{"xxx<-"()} and \code{xxx() <- value}
  will be replaced by \code{xxx(x, ...) <- value}.
  
  For S4 methods and classes the argument "package" is often needed to
  restrict the output to methods defined in the package of interest.
  \preformatted{
    reprompt("myfun-methods")

    reprompt("[<--methods", package = "mypackage")             
    reprompt("[<-", type = "methods", package = "mypackage") # same

    reprompt("myclass", type = "class", package = "mypackage") 
    reprompt("myclass-class", package = "mypackage")         # same
  }
  Without the "package" argument the reprompt for \code{"[<-"} would give
  all methods defined by loaded packages at the time of the call. 

  
  Currently \code{reprompt} functionality is not implemented for topic
  "package" but if \code{object} has the form "name-package" (or the
  equivalent with argument \code{topic}) and there is no documentation
  for \code{package?name}, \code{reprompt} calls
  \code{\link{promptPackageSexpr}} to create the required shell.
  Note that the shell produced by \code{promptPackageSexpr} does not
  need `reprompting' since the automatically generated information is
  included by \verb{\Sexpr}'s, not literal strings.


  
  Below are the details.

  Typically, only one of \code{object}, \code{infile}, and \code{Rdtext}
  is supplied. Warning messages are issued if this is not the case.

  The object must have been made available by the time when
  \code{reprompt()} is issued. If the object is in a package this is
  typically achieved by a \code{library()} command.

  \code{object} may be a function or a name, as accepted by the \code{?}
  operator. If it has the form "name-class" and "name-methods" a
  documentation shell for class "name" or the methods for generic function
  "name" will be examined/created. Alternatively, argument \code{type}
  may be set to "class" or "methods" to achieve the same effect.
 
  \code{infile} specifies a documentation file to be updated. If it
  contains the documentation for one or more functions, \code{reprompt}
  examines their usage statements and updates them if they have
  changed. It also adds arguments to the "arguments" section if not all
  arguments in the usage statements have entries there. If \code{infile}
  describes the methods of a function or a class, the checks made are as
  appropriate for them. For example, new methods and/or slots are added
  to the corresponding sections.

  It is all too easy in interactive use to forget to name the
  \code{infile} argument, compare\cr
  \code{reprompt("./man/reprompt.Rd")} vs.
  \code{reprompt(infile = "./man/reprompt.Rd")}).\cr
  A convenience feature is that if \code{infile} is missing
  and \code{object} is a character string ending in ".Rd" and containing
  a forward slash (i.e. it looks like Rd file in a directory), then it
  is taken to be \code{infile}. 
  
  \code{Rdtext} is similar to \code{infile} but the Rd content is taken
  from a character vector.

  If Rd content is supplied by \code{infile} or \code{Rdtext},
  \code{reprompt} uses it as a basis for comparison. Otherwise it tries
  to find installed documentation for the object or topic requested.
  If that fails, it resorts to one of the \code{promptXXX} functions to
  generate a documentation shell. If that also fails, the requested
  object or topic does not exist.

  If the above succeeds, the function examines the current definition of
  the requested object(s), methods, or class and amends the
  documentation with any additional items it finds.

  For Rd objects describing one or more functions, the usage expressions
  are checked and replaced, if they have changed. Arguments appearing in
  one or more usage expressions and missing from section "Arguments" are
  amended to it with content "Describe ..."  and a message is
  printed. Arguments no longer in the usage statements are NOT removed
  but a message is issued to alert the user. Alias sections are inserted
  for any functions with "usage" but without "alias" section.


  If \code{filename} is a character string, it is used as is, so any
  path should be included in the string.  Argument \code{filename}
  usuallly is omitted since the automatically generated file name is
  suitable in most cases. Exceptions are functions with non-standard
  names (such as replacement functions whose names end in \code{"<-"})
  for which the generated file names may not be acceptable on some
  operating systems.
  
  If \code{filename} is missing or \code{NULL}, a suitable name is
  generated as follows. If \code{infile} is supplied, \code{filename} is
  set to a file with the same name in the current working directory
  (i.e. any path information in \code{infile} is dropped). Otherwise,
  \code{filename} is obtained by appending the name tag of the Rd object
  with \code{".Rd"}. 

  If \code{filename} is \code{TRUE}, it is set to \code{infile} or, if
  \code{infile} is missing or \code{NULL}, a suitable name is generated
  as above. This can be used to change \code{infile} in place.

  If \code{filename} is \code{FALSE}, the Rd text is returned as a
  character vector and not written to a file. 

  If \code{edit} is \code{TRUE}, the reprompted file is opened in an
  editor, see also \code{\link{ereprompt}} (`e' for `edit') which is
  like \code{reprompt} but has as default \code{edit = TRUE} and some
  other related settings.

  \code{file.edit()} is used to call the editor.  Which editor is opened
  depends on the OS and on the user configuration. RStudio users will
  probably prefer the 'Reprompt' add-in or the underlying function
  \code{\link{RStudio_reprompt}}.  Emacs users would normally have set
  up \code{emacsclient} as their editor and this is automatically done
  by EMACS/ESS (even on Windows).
  
  If argument \code{sec_copy} is \code{TRUE} (the default),
  \code{reprompt} will, effectively, copy the contents of (some)
  unchanged sections, thus ensuring that they are exactly the same as in
  the original.  This needs additional work, since parsing an Rd file
  and then exporting the created Rd object to an Rd file does not
  necessarilly produce an identical Rd file (some escape sequences may
  be changed in the process, for example).  Even though the new version
  should be functionally equivalent to the original, such changes are
  usually not desirable. For example, if such changes creep into the
  Details section (which \code{reprompt} never changes) the user may be
  annoyed or worried.
  
}
\value{
  if \code{filename} is a character string or \code{NULL}, the name of
  the file to which the updated shell was written.

  Otherwise, the Rd text is returned as a character vector.
}

\author{Georgi N. Boshnakov}
\note{

  The arguments of \code{reprompt} are similar to prompt, with some
  additions. As in \code{prompt}, \code{filename} specifies the output
  file. In \code{reprompt} a new argument, \code{infile}, specifies the
  input file containing the Rd source.

  When \code{reprompt} is used to update sources of Rd documentation for
  a package, it is best to supply the original Rd file in argument
  \code{infile}. Otherwise, if the original Rd file contains
  \verb{\Sexpr} commands, \code{reprompt} may not be able to recover the
  original Rd content from the installed documentation. Also, the fields
  (e.g. the keywords) in the installed documentation may not be were you
  expect them to be. (This may be addressed in a future revision.)


  While \code{reprompt} adds new items to the documentation, it never
  removes existing content. It only issues a suggestion to remove an
  item, if it does not seem necessary any more (e.g. a removed argument
  from a function definition).

  \code{reprompt} handles usage statements for S3 and S4 methods
  introduced with any of the macros \verb{\method}, \verb{\S3method} and
  \verb{\S4method}, as in
  \verb{\method{fun}{class}(args...)}. \code{reprompt} understands also
  subsetting ans subassignment operators.  For example, suppose that the
  \code{\\arguments} section of file "bracket.Rd" contains these
  directives (or any other wrong signatures):

\preformatted{
    \method{[}{ts}()
    \method{[[}{Date}()
}

Then \code{reprompt("./bracket.Rd")} will change them to

\preformatted{
    \method{[}{ts}(x, i, j, drop = TRUE)
    \method{[[}{Date}(x, \dots, drop = TRUE)
}
  
  This works for the assignment operators and functions, as well. For
  example, any of these

\preformatted{
    \method{`[<-`}{POSIXlt}()
    \method{[}{POSIXlt}(x, j) <- value
}

will be converted by \code{reprompt} to the standard form

\preformatted{
    \method{[}{POSIXlt}(x, i, j) <- value
}    

Note that the quotes in \code{`[<-`} above. 

  Usage statements for functions are split over two or more lines if
  necessary. The user may edit them afterwards if the automatic
  splitting is not appropriate, see below.

  The usage section of Rd objects describing functions is left intact if
  the usage has not changed. To force \code{reprompt} to recreate the
  usage section (e.g. to reformat long lines), invalidate the usage of
  one of the described functions by removing an argument from its usage
  expression.  Currently the usage section is recreated completely if
  the usage of any of the described functions has changed. Manual
  formatting may be lost in such cases.
}

%% ~Make other sections like Warning with \section{Warning }{....} ~
\seealso{
    \code{\link{ereprompt}} which by default calls the editor on the
    original file
}
\examples{
## note: usage of reprompt() is simple.  the examples below are bulky
##       because they simulate various usage scenarios with commands,
##       while in normal usage they would be due to editing.

## change to a temporary directory to avoid clogging up user's
cur_wd <- getwd()
tmpdir <- tempdir()
setwd(tmpdir)

## as for prompt() the default is to save in current dir as "seq.Rd".
## the argument here is a function, reprompt finds its doc and
## updates all objects described along with `seq'.
## (In this case there is nothing to update, we have not changed `seq'.)

fnseq <- reprompt(seq)

## let's parse the saved Rd file (the filename is returned by reprompt)
rdoseq <- tools::parse_Rd(fnseq)   # parse fnseq to see the result.
Rdo_show(rdoseq)

## we replace usage statements with wrong ones for illustration.
## (note there is an S3 method along with the functions)
dummy_usage <- char2Rdpiece(paste("seq()", "\\\\method{seq}{default}()",
                   "seq.int()", "seq_along()", "seq_len()", sep="\n"),
                   "usage")
rdoseq_dummy <- Rdo_replace_section(rdoseq, dummy_usage)
Rdo_show(rdoseq_dummy)  # usage statements are wrong

reprompt(rdoseq_dummy, file = "seqA.Rd")
Rdo_show(tools::parse_Rd("seqA.Rd"))  # usage ok after reprompt

## define function myseq() 
myseq <- function(from, to, x){
    if(to < 0) {
        seq(from = from, to = length(x) + to)
    } else seq(from, to)
}

## we wish to describe  myseq() along with seq();
##    it is sufficient to put myseq() in the usage section
##    and let reprompt() do the rest
rdo2 <- Rdo_modify_simple(rdoseq, "myseq()", "usage")
reprompt(rdo2, file = "seqB.Rd")  # updates usage of myseq

## show the rendered result:
Rdo_show(tools::parse_Rd("seqB.Rd"))

## Run this if you wish to see the Rd file:
##   file.show("seqB.Rd")

reprompt(infile = "seq.Rd", filename = "seq2.Rd")
reprompt(infile = "seq2.Rd", filename = "seq3.Rd")

## Rd objects for installed help may need some tidying for human editing.
#hseq_inst <- help("seq")
#rdo <- utils:::.getHelpFile(hseq_inst)
rdo <- Rdo_fetch("seq", "base")
rdo
rdo <- Rdpack:::.Rd_tidy(rdo)          # tidy up (e.g. insert new lines
                                       #          for human readers)
reprompt(rdo) # rdo and rdoseq are equivalent
all.equal(reprompt(rdo), reprompt(rdoseq)) # TRUE

## clean up 
unlink("seq.Rd")         # remove temporary files
unlink("seq2.Rd")
unlink("seq3.Rd")
unlink("seqA.Rd")
unlink("seqB.Rd")

setwd(cur_wd)            # restore user's working directory
unlink(tmpdir)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{Rd}
