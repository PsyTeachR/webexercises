# rbibutils 2.4.1

## EDIT BEFORE RELEASE!

- now '\slash' is handled by `toRd.bibentryExtra` (previously was in Rdpack).

- don't interpret '\slash' if the leading slash is escaped.

- export `bibstyle_JSSextra` - not exported in v2.4.

- modified the `bibentryExtra` method for `toRd` to process `\slash`.

- improved handling of latex accents and  Unicode combining characters.

- removed the deprecated `register_JSSextra`.


# rbibutils 2.4

## Advance warning about a future potentially incompatible change

- A change of the default for argument `direct` of `readBib()` is planned for
  rbibutils v3.0 (from `FALSE` to `TRUE`). For most users `direct = TRUE` is
  superior (better handling of maths, additional capabilities). If you really
  want `direct = FALSE`, please state that explicitly in the call to
  `readBib()`.

## New and improved features

- now rbibutils gives warnings when it encounters undefined bibtex names (see
  `@string` bibtex macro), fixes issue#10. Such strings are used for consistent
  naming of journals, for example. The name is inserted in the output when
  undefined (previously this was done silently).

- consolidated `append_type` between the bibtex related formats.
  Internal, but fixed a bug causing technical reports to be converted to MISC
  when converting from isi and biblatex to bibtex.

- added completion for `bibentryExtra` objects. Useful for interactive use. For
  example in an R session if `be` is a `bibentryExtra` object, typing `be$bi`
  then the 'Tab' key will be completed to `be$bibtype`. Also, `be$` then 'Tab'
  will provide a choice from the available completions. This should work also in
  RStudio, whereever it provides completion.

- corrected some typo's in the draft vignette.

- now using `bibentrydirectout_write` also in 'bibentryout.c'.
  `bibentryout_write` was not in sync with changes in `bibentrydirectout_write`.

- refactored `bibstyle_JSSextra`; new function `bibstyle_JSSextraLongNames` in
  preparation of removing bibstyles 'JSSRd' and 'JSSRdLongNames' from Rdpack.

  
## Bug fixes

- now bibstyle 'JSSextra' doesn't change the 'JSS' style (the fix in v2.3 didn't
  resolve this completely).

- some long standing unnoticed bugs or shortcomings of the processing
  in `readBib()` and `convert()` in the case `direct = FALSE` have
  been fixed. 


# rbibutils 2.3

## New and improved features

- the class of the object returned by `readBibentry()`, `readBib()`, and
  `bibtexImport()` is now always `c("bibentryExtra", "bibentry")` (unless
  argument `fbibentry` is supplied). Previously `"bibentryExtra"` was added only
  when there were bib items with non-standard type and `extra = TRUE`. An option
  to return just `"bibentry"` may be considered.
  
- non-standard bibtypes are lowercased.

- consolidated the subsetting operators for 'bibentryExtra' objects and the
  documentation for them.
  
- new function `bibentryExtra()` creates 'bibentryExtra' objects. It accepts
  arbitrary Bibtex entry types and takes the same arguments as `bibentry()`.

- the default bib style for the `bibentryExtra` method for `format()` is now 
  "JSSextra".

- refactored and streamlined `writeBibentry()` (the original version didn't use
  the `format` method).

- new generic function `as.bibentryExtra`.

- new 'bibentryExtra' method for `c()`.

- bib style "JSSextra" now knows how to render 'online' bibtype. It is a
  biblatex (not bibtex) field but very useful these days.

- bib style "JSSextra" now knows how to render a few more non-standard bib
  types.

- `print(be, style = "R")`, where `be` is an object from class "bibentryExtra"
  no longer includes the, effectively, internal for `rbibutils` field
  `truebibtype`.

- first draft of a vignette.

## Bug fixes

- now bibstyle 'JSSextra' creates a new environment for its stuff. Previously it
  was accidentally adding its objects directly in the 'JSS' style's environment,
  causing the two to be equivalent.

- fixed a bug in `format.bibentryExtra()` which caused `writeBibentry()` to
  misbehave when `style = "Rstyle"`.

- fixed `[<-` sub-assignment to 'bibentryExtra' objects.

- when `style = "latex"`, style "JSSextra" was failing to print bibentries with
  types InBook and InCollection, due to a typo (redundant comma) in the code.

- a number of minor bugs were fixed.

  
# rbibutils 2.2.16

- fixed processing of the Polish suppressed-l `\l`. Previously the character
  following it was enclosed in braces, which was harmless in most cases but the
  superfluous braces could cause trouble in special circumstances. Did the same
  for the uppercase version, `\L`, which was missing from the code.


# rbibutils 2.2.15

- adapted some tests to a change in R-devel circa r84986.


# rbibutils 2.2.14

- fixed a couple of tests in 'test-convert.R' which started failing (ca. R svn
  rev 84760) due to an R-devel change in `person()`.


# rbibutils 2.2.13

- Bugfix: the declaration of the return value of a C function was accidentally
  changed from `const char *` to `char *` in v2.2.12, causing CRAN warnings on
  some platforms.


# rbibutils 2.2.12

- Bugfix: `readBib` with `texChars = "Rdpack"` which converts `\'i` to `\'\i`
   was wrapping `\'\i` in braces in 'author' and related fields only. Failure to
   do so in other fields was making the output invalid when `\'i` was followed
   by alphabetical character(s). Fixes issue#7 reopened by @EricMarcon.

   Note that option `"Rdpack"` for argument `texChars` is mainly for internal
   use which compensates for R not recognising `\'i` as an accented character,
   see the news items for v2.2.5 and v2.2.4 and the bug report about
   `tools:::latexToUtf8` at [R bugs](https://bugs.r-project.org/show_bug.cgi?id=18208).

- partial internal refactoring of C code to avoid duplication.


# rbibutils 2.2.11

- in `C` code, changed `sprintf` calls to use `snprintf` to fix CRAN warnings.


# rbibutils 2.2.10

- fixed warnings about deprecated function declarations without prototypes in
  `C` code.


# rbibutils 2.2.9

- fixed wrong markup of an item in this file (for v2.2.4) causing bad rendering
  and a NOTE from CRAN.
  

# rbibutils 2.2.8

- new argument `fbibentry` for `readBib` and `readBibentry` for specification of
  a function for generation of bib objects. It should have the same arguments as
  the default `utils::bibentry()` but doesn't need to be vectorised, since
  `readBibentry()` generates one `bibentry` call for each reference.

- `readBib` now parses correctly LaTeX accents like `\a'o`. These are officially
  defined only for LaTeX's `tabbing` environment as replacements for `\'o`,
  etc., but seem accepted by LaTeX outside these environments. Also, `Bibtex`
  converts them to the standard ones when writing `.bbl` files and R's bib
  processing functions know about them.

- a bug in `ads` export was causing a test to fail on platforms with `char`
  equivalent to `unsigned char`. Reported by @nileshpatra, who also identified
  the cause. Fixes issue#8 on github.


# rbibutils 2.2.7

- fixed bug in isi output occuring in v2.2.5 and 2.2.6 and revealed by gss/ASAN
  check.


# rbibutils 2.2.6 (not on CRAN)

- fixed memory leaks in nbib output in biblatex input occuring in v2.2.5.


# rbibutils 2.2.5

- `readBibentry` with `extra = TRUE` now parses (almost) any syntactically
  correct bib entries. In particular, it accepts arbitrary bib types and doesn't
  throw errors for bibentries missing fields required by bibtex for the standard
  bibtex types. For example, biblatex entries typically have `date`, not `year`.

- `readBib` with `direct = TRUE` and `texChars` set to `"convert"` or `"export"`
  was not processing mathematical expressions properly. Now fixed.
  
- argument `texChars` of `readBib` gets new possible value, "Rdpack". This is
  like the default, "keep", but in addition it converts `\'i` to `\'\i`. This
  is related to issue #7, see below the fix in v2.2.4 for details. This is
  mainly for internal use.

- improved the messages from error handling when creating bibentry
  objects. The fix is in `readBibentry` but users typically see them when
  calling `readBib`.

- fixed an error which caused `bibConvert` to segfault when importing `nbib`
  files.

- `readBibentry` (and hence `readBib`) were printing some error messages that
  were actually handled.
  

# rbibutils 2.2.4

- stopped converting `\'\i'` to `\'i`. They are equivalent but there is no
  reason to do this. Also, at the time of writing R's `tools::latexToUtf8`
  converts the former but not the latter, while Biber seems to convert the
  latter but not the former, see
  https://bugs.r-project.org/show_bug.cgi?id=18208 . So, users of the bib file
  may have specific reasons to use one or the other.

- names consisting of just one part, family, were missing processing of escaped
  characters (issue #5).
    

# rbibutils 2.2.3

- fixed memory issues from valgrind in v2.2.2 thanks to patch supplied by Bill
  Dunlap.


# rbibutils 2.2.2

- import of `Pubmed XML` was sometimes giving a handful of references for files
  with tens or hundreds of them. Now fixed, see issue #4, reported by Rafael
  Santamaría.  (The function reading the file was implicitly assuming that the
  end of each reference is on a line by itself and was silently ignoring text on
  the same line after the end of reference tag. Reference files from online
  databases often have no new lines at all, except for the XML header.)


# rbibutils 2.2.1

- fixed problems revealed by valgrind.


# rbibutils 2.2

- new convenience function `charToBib` takes input from a character vector
  rather than a file. By default it assumes that the input is in `bibtex` format
  and dispatches to `readBib`. If an input format is specified it calls
  `bibConvert`.

- new S3 class `bibentryExtra`, inheriting from `bibentry`, provides support for
  non-standard types (potentially arbitrary) of bibtex entries. Suitable methods
  are defined for printing, converting and manipulating (e.g., subsetting and
  assignment) `bibentryExtra` objects. The initial implementation is incomplete
  and under development.

- `readBib()` gets a new argument `extra`. If it is set to `TRUE` and
  non-standard types of entries are encountered in the input bibtex file, then
  the class of the result is set to `bibentryExtra`. See also the note about
  `bibentryExtra`.

- `readBib` gets new argument, `macros`, for specification of file(s) containing
  Bibtex macros (such as abbreviations for names of journals). These files are
  read in before file(s) specified by `file`.

- `readBib` with `direct = TRUE` now accepts non-syntactic field names,
  e.g. containing `-`. (This is irrelevant when `direct = FALSE` since in that
  case nonstandard fields are ignored and standard fields do not contain unusual
  characters.)

- internal structures for bibtex macros, such as `@string` were not cleared at
  the end of calls and were accumulating from multiple invocations of
  conversions from bibtex and biblatex. Now fixed.

- now references with missing cite keys in bibtex input are accepted (previously
  such references were dropped). Dummy cite keys are inserted.

- now `@preamble` entry in bibtex is ignored silently. Previously it was also
  dropped but with a message about unrecognised type, which was confusing.

- export arXiv:XXX and similar as `https` (some were still exported as `http`).
  Fixes GeoBosh/Rdpack#21, reported by Kisung You.

- unsuported conversions for some formats were accepted with unpredictable
  results. Informative messages are printed now.

- improved handling of byte order marks (BOM) for utf8 output. This was causing
  problems to tests of this package on Windows since on Linux BOMs are not
  emitted (I haven't figured what causes the difference - the code is not OS
  dependent).

- improved handling of corner cases in bibtex input, especially for `readBib`
  with `direct = TRUE`.


# rbibutils 2.1.1

- now a warning (rather than error) is issued if package 'testthat' is not
  available for tests.

- `readBib` now has a default for the encoding, so it would usually be called
   just with one argument (the filename).


# rbibutils 2.1

- `readBib` can now convert bibtex files directly (i.e., without first
  converting to XML intermediate) to bibentry R objects. This can be requested
  by setting the new argument `direct` to `TRUE`.

- `readBib` gets argument `texChars` to control whether or not to convert TeX
  sequences representing characters (such as accented Latin characters) to
  normal characters in the output encoding. There is an option also to convert
  charaters to the corresponding TeX sequences.

- `readBib` now accepts encodings as for `bibConvert`.

- `readBib` now processes field `key` in bibtex files. (This field is optional,
  used by some bibtex styles for sorting.)

- bug fixes and improvements.

- removed field `LazyData` from DESCRIPTION as there is no data directory
  (and R-devel now flags it with a NOTE).
  

# rbibutils 2.0

- there is no longer (unintended) dependence on R >= 3.4. This was because of
  the use of `R_unif_index`. Report and fix due to Henrik Sloot (#1).

- completely reimplemented the conversion to `bibentry` - now this is done
  entirely in `C` and it now has the same speed as the conversions to other
  bibliograthy formats.

- removed `xml2` from the imports - it is no longer needed now that the
  conversion to bibentry is done in `C`.

- new functions `readBibentry` and `writeBibentry` for reading from and writing
  bibentries to R source files.

- now errors when reading bibentry files are turned into warnings with suitable
  messages.


# rbibutils 1.4

- new function `writeBib` for writing bibtex files.

- fixed erroneous processing of PhD thesis bib entries with some values of field
  `type`.  (reported by Kisung You for GeoBosh/Rdpack#17)

- fixed a compiler warning about a pointer differing in
  signedness from the expected type (reported by Patrice Kiener).

- somehow `README.md` went missing in v1.3, now reinstated.


# rbibutils 1.3

- reverted a change in v1.2 which caused trouble with some latex characters.

- trimmed white space in cite keys and some others to avoid getting cite keys
  containing the newline character (possible if the comma after the key is on a
  new line).

- new function `readBib` for importing bibtex files.


# rbibutils 1.2.1 (not on CRAN)

- improved processing of URL field when converting to bibentry.


# rbibutils 1.2 (not on CRAN)

- fixed inBook processing.

- fixed encoding bug introduced in v1.1.

- fixed misterous loss of `$`s and curly braces in certain circumstances.


# rbibutils 1.1.0

- fixed processing of multiple person names in bibtex import.

- mathematical formulas were wrongly exported without dollars in some cases.

- stopped printing some messages causing problems to Rdpack.


# rbibutils 1.0.3

- fixed warnings from `clang` compilers on CRAN. (These were about tautology
  `if` clauses in `src/adsout.c` and default argument promotion of the second
  argument in a couple of invocations of `va_start` in `src/modsout.c`).

- fixed typo's in the documentation.

- updated the website.


# rbibutils 1.0.2

- completed the copyright credits in DESCRIPTION (there were contributors not
  mentioned anywhere except in the C source files they contributed).


# rbibutils 1.0.1 (not on CRAN)

- clarified the copyright holders in DESCRIPTION.


# rbibutils 1.0.0 (not on CRAN)

Features of this version:

- includes an R port of `bibutils` libraries (currently `bibutils_6.10`).

- supports all character encodings available in `bibutils` (defaults are UTF-8).

- supports all input/output bibliography formats available in `bibutils`,
  including Bibtex, Biblatex, and XML mods intermediate.

- in addition, supports conversions of the above formats from/to `bibentry` R
  source files or `rds` objects.
