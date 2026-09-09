%% Build and check from R:
%% news(db = tools:::.build_news_db_from_package_NEWS_Rd("<Matrix>/inst/NEWS.Rd"))
\name{NEWS}
\title{News for \R{} Package \pkg{Matrix}}
\encoding{UTF-8}
\newcommand{\MPR}{\pkg{Matrix} \href{https://R-forge.R-project.org/tracker/index.php?func=detail&aid=#1&group_id=61&atid=294}{PR##1}}

\section{Changes in version 1.7-6 (2026-07-24)}{
  \subsection{Description}{
    \itemize{
      \item \file{DESCRIPTION} fields \code{URL} and \code{BugReports}
      are updated to reflect a migration of the \pkg{Matrix} package
      sources from a Subversion repository hosted by R-Forge to a Git
      repository hosted by Codeberg.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item Warnings newly reported by \command{rchk} are squashed.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \pkg{Matrix} version 1.7-3 renamed four macros defined in
      \file{inst/include/Matrix/version.h}, stripping the \samp{R_}
      prefix of the original names \samp{R_MATRIX_PACKAGE_*}.  This
      change was accidental and is reverted.
      \item Ported typo fix in \file{Intro2Matrix.Rnw} from trunk.
    }
  }
}

\section{Changes in version 1.7-5 (2026-03-20, svn r5198)}{
  \subsection{Misc}{
    \itemize{
      \item Non-API entry point \code{Rf_findVarInFrame} is no longer
      used.
    }
  }
}

\section{Changes in version 1.7-4 (2025-08-27, svn r5172)}{
  \subsection{Installation}{
    \itemize{
      \item Warnings surfaced by \option{-Wtautological-overlap-compare}
      are squashed.  These revealed two typos in \file{src/matmult.c}
      causing optimizations for \code{crossprod(\var{.sRMatrix}, y)} and
      \code{tcrossprod(x, \var{.sRMatrix})} to be skipped.  Thanks to
      Brian Ripley and Michael Chirico for the reports.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Methods for \code{band}, \code{triu}, and \code{tril} with
      signature \code{x="matrix"} returned a formally invalid
      \code{.geMatrix} (with \code{x} slot of class \code{"matrix"}) in
      some no-op cases, where no bands are set to zero.
    }
  }
}

\section{Changes in version 1.7-3 (2025-03-05, svn r5126)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{<matrix>} \code{o} \code{<sparseVector>} binary
      \code{"Ops"} work again, returning a matrix (of \code{"Matrix"}).

      \item \code{- new("lgeMatrix")} and more \code{ - <Matrix>} now work.

      \item Use \code{int} instead of \code{Rboolean} in 2x2 cases in \file{utils-R.c}.
    }
  }
}

\section{Changes in version 1.7-2 (2025-01-20, svn r5115)}{
  \subsection{Installation}{
    \itemize{
      \item \pkg{Matrix} can be installed with parallel \command{bmake}.
      Thanks to Sebastian Meyer for the report and patch in \MPR{6861}.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item Test in \file{tests/matprod.R} comparing
      \code{t(x) \%*\% x} and \code{crossprod(x)} is amended to tolerate
      small numerical differences seen under \samp{aarch64} Linux.
    }
  }
}

\section{Changes in version 1.7-1 (2024-10-17, svn r4948)}{
  \subsection{Installation}{
    \itemize{
      \item Installation under architecture-specific builds of \R{}
      works again.  It was broken in \pkg{Matrix} version 1.7-0,
      where changes to \file{src/Makevars} resulted in \env{CPPFLAGS}
      not including \option{-I"${R_INCLUDE_DIR}${R_ARCH}"}.
    }
  }
  \subsection{SuiteSparse}{
    \itemize{
      \item Internal SuiteSparse and METIS library sources are patched
      to avoid possible use of illegal entry points.
    }
  }
  \subsection{C-Level API}{
    \itemize{
      \item Registered routine \code{sexp_as_cholmod_factor} no longer
      calls \code{cholmod_check_factor} before returning, leaving the
      decision to check to the caller.  Accordingly, most
      \code{cholmod_check_*} are registered; packages wanting to use
      them need \code{LinkingTo: Matrix (>= 1.7-1)}.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item Non-API entry points \code{OBJECT}, \code{IS_S4_OBJECT},
      \code{SET_OBJECT}, \code{ATTRIB}, and \code{SET_ATTRIB} are no
      longer used.
    }
  }
}

\section{Changes in version 1.7-0 (2024-03-16, svn r4662)}{
  \subsection{Installation}{
    \itemize{
      \item \pkg{Matrix} \eqn{\ge}{>=} 1.7-0 depends on \R{}
      \eqn{\ge}{>=} 4.4.
    }
  }
  \subsection{Linking}{
    \itemize{
      \item The \pkg{Matrix} ABI version is incremented from 1 to 2.

      \item Reverse \code{LinkingTo} built under earlier versions of
      \pkg{Matrix} should be rebuilt from sources by users and
      maintainers of binary repositories.
    }
  }
  \subsection{SuiteSparse}{
    \itemize{
      \item The internal SuiteSparse library sources are updated from
      version 5.10.1 to version 7.6.0.  We have so far identified one
      backwards incompatible change: since SuiteSparse version 7.3.0,
      \code{cholmod_sort(A)} sorts but \emph{does not pack} the matrix
      \code{A}.  It seems that now \code{cholmod_sort} and
      \code{cholmod_copy} must be used in conjuction if a sorted
      \emph{and packed} result is desired.  This change affects only
      reverse \code{LinkingTo} relying on the old behaviour.  It seems
      that currently there are no such packages on CRAN or Bioconductor.

      \item CHOLMOD component Partition is compiled along with its
      dependencies (METIS, CAMD, CCOLAMD).

      \item CXSparse is compiled instead of CSparse, which did not
      support complex matrices.

      \item The internal SuiteSparse and METIS library sources are
      patched to squash a significant number of warnings surfaced by
      \option{-Wall}.
    }
  }
  \subsection{Significant User-Visible Changes}{
    \itemize{
      \item The diagonal elements of the \code{R} factor computed by
      \code{qr(<sparseMatrix>)} are no longer constrained to be
      non-negative, due to differences in the implementation of function
      \code{cs_house} between SuiteSparse libraries CSparse and
      CXSparse.
    }
  }
  \subsection{Classes}{
    \itemize{
      \item \code{indMatrix} no longer extends virtual class
      \code{compMatrix} and so no longer inherits a (never used)
      \code{factors} slot.  Objects serialized under \pkg{Matrix}
      \eqn{<} 1.7-0 and unserialized under \pkg{Matrix} \eqn{\ge}{>=}
      1.7-0 remain valid, retaining a harmless \code{factors}
      \emph{attribute}.

      \item Unexported class union \code{replValueSp} is effectively
      removed, now having zero members.  Actual removal is delayed until
      package binaries caching the old definition are rebuilt under
      \pkg{Matrix} version 1.7-0.

      \item The validity method for class \code{sparseQR} no longer
      requires non-negative \code{diag(R)}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item The unary subscript \code{x[i]} is correct again for
      \code{x} of class \code{.s[CT]Matrix} and logical \code{i}
      indexing entries outside of the stored triangle.
    }
  }
}

\section{Changes in version 1.6-5 (2024-01-06, svn r4560)}{
  \subsection{C-Level API}{
    \itemize{
      \item Registered routine \code{cholmod_triplet_as_sexp} transposes
      entries \dQuote{opposite} the \code{stype} when that is nonzero,
      following CHOLMOD.

      \item \code{cholmod_defaults} is registered so that calls to
      API function \code{M_cholmod_defaults} actually work.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{x[]} works for \code{x} inheriting from virtual class
      \code{sparseVector}.

      \item \code{length(x)} is always an integer for \code{x}
      inheriting from virtual class \code{sparseVector}.  Truncation did
      not occur for \code{x@length} of type \code{"double"} equal to or
      greater than \code{.Machine[["integer.max"]] + 1}.

      \item \code{tril(<n-by-n>, -n)} now works again.

      \item \code{tri[ul](<indMatrix>, k)} now works correctly for
      \code{k != 0}.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item \code{\%||\%} is defined in the \pkg{Matrix} namespace only
      for \R{} \eqn{<} 4.4.0.
    }
  }
}

\section{Changes in version 1.6-4 (2023-11-29, svn r4523)}{
  \subsection{Installation}{
    \itemize{
      \item Warnings surfaced by \option{-Wformat} are squashed.
    }
  }
  \subsection{C-Level API}{
    \itemize{
      \item API function \code{M_chm_triplet_to_SEXP}, removed in
      \pkg{Matrix} version 1.6-2, is restored (as a macro).  It was
      \dQuote{covertly} used by package \pkg{Rmosek}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item better deprecation message for \code{..2dge()}.
    }
  }
}

\section{Changes in version 1.6-3 (2023-11-13, svn r4513)}{
  \subsection{Misc}{
    \itemize{
      \item With an \R{} built with \command{configure} option
      \option{--disable-long-double}, \code{prod(M)} now very slightly
      differs for two differently classed versions of \code{M}.

      \item \code{checkMatrix()} from \file{test-tools-Matrix.R} gets
      optional \code{MSG} argument for suppressing \code{prod()}
      differences.
    }
  }
}

\section{Changes in version 1.6-2 (2023-11-05, svn r4503)}{
  \subsection{Compatibility}{
    \itemize{
      \item \pkg{Matrix} did not pass its checks under \R{} version
      3.5.0, implicitly violating \code{Depends: R (>= 3.5)}.  This
      release restores compatibility.
    }
  }
  \subsection{Linking}{
    \itemize{
      \item Support is added for an ABI version relevant to packages
      that link against \pkg{Matrix}.  The ABI version is 1 in this
      release and will be incremented by 1 in each future release that
      changes the ABI.  It is implicitly 0 in previous releases.
      Versions and their components are defined in a header for use by
      packages with \code{LinkingTo: Matrix (>= 1.6-2)} in their
      \file{DESCRIPTION}.  See \file{inst/include/Matrix/version.h} and
      (below) \code{Matrix.Version}.

      \item Reverse \code{LinkingTo} built under earlier versions of
      \pkg{Matrix} should be rebuilt from sources by users and
      maintainers of binary repositories.
    }
  }
  \subsection{C-Level API}{
    \itemize{
      \item API headers are organized under \file{inst/include/Matrix/}
      for easier namespacing.  Packages should start using
      \code{LinkingTo: Matrix (>= 1.6-2)} and include the API headers
      with, e.g., \code{#include <Matrix/Matrix.h>}.

      \item Packages including API headers can define macro
      \code{R_MATRIX_INLINE}, typically with
      \code{#define R_MATRIX_INLINE inline}, in order to allow the
      compiler to inline stubs for registered routines.

      \item Some API function prototypes and macros not used by any
      reverse \code{LinkingTo} are removed or remapped.

      \item Several API function prototypes used \code{const} qualifiers
      where the registered routines do not.

      \item The prototype of API function \code{M_cholmod_band_inplace}
      did not match that of registered routine
      \code{cholmod_band_inplace}.  The prototype of \code{cholmod_band}
      was copied by mistake.
    }
  }
  \subsection{Significant User-Visible Changes}{
    \itemize{
      \item Methods for generic functions \code{rbind2}, \code{cbind2},
      \code{\%*\%}, \code{\%&\%}, \code{crossprod}, and
      \code{tcrossprod} determine the class of the result using more
      strict rules, designed to avoid \dQuote{surprising} coercions
      where possible.  Notably, operations involving
      \code{RsparseMatrix} now return an \code{RsparseMatrix} in more
      cases.  \code{TsparseMatrix} and \code{diagonalMatrix} may be
      handled as \code{CsparseMatrix} or as \code{RsparseMatrix},
      depending on context.
    }
  }
  \subsection{Classes}{
    \itemize{
      \item New nonvirtual class \code{ndiMatrix} representing diagonal
      nonzero pattern matrices.  It extends virtual classes
      \code{diagonalMatrix} and \code{nMatrix}.  \code{ndiMatrix} are
      typically obtained as the result of \code{is.na}, \code{is.nan},
      or \code{is.infinite} applied to a \code{diagonalMatrix} or as the
      result of coercing a \code{diagonalMatrix} to \code{nMatrix}.
      (The result of that coercion used to be an \code{ntCMatrix}.  It
      is still possible to obtain an \code{ntCMatrix} by coercion to
      \code{nsparseMatrix}.)

      \item The validity method for class \code{sparseVector} requires
      \code{length} not exceeding \code{2^53}, which on most platforms
      is the minimum positive integer \eqn{k} such that \eqn{k + 1} is
      not exactly representable in double precision.

      \item A \code{dsparseVector} with \code{x} slot of type
      \code{"integer"} is formally invalid, as always intended.

      \item Certain never or seldom used class unions are removed.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item \code{mean(<sparseVector>, trim=)} now works efficiently for
      nonzero values of \code{trim}.

      \item \code{rep(<sparseVector>, each=)} now works efficiently,
      avoiding \code{rep(., times = rep(each, times = length(.)))}.

      \item \code{.m2dense} and \code{.m2sparse} gain an argument
      \code{trans} indicating if vectors that are not matrices should be
      coerced to 1-row matrices rather than 1-column matrices.

      \item \code{.m2dense} and \code{.m2sparse} can be called with one
      argument.  Their \code{class} arguments admit new default values
      \code{".ge"} and \code{".gC"}.

      \item \code{.diag2dense} and \code{.diag2sparse} gain an argument
      \code{kind} indicating the \dQuote{kind} of the result.

      \item New exports \code{.M2V} and \code{.m2V}, for coercing
      \code{Matrix} and \code{matrix} (and in fact \code{vector}) to
      \code{sparseVector}.

      \item New exports \code{isUniqueT} and \code{asUniqueT}, with
      optional argument \code{byrow} allowing for row-major ordering of
      entries.  \code{asUniqueT} supercedes \code{uniqTsparse}, which is
      no longer documented.

      \item New export \code{aggregateT}, for aggregating
      \code{TsparseMatrix} \emph{without} sorting.

      \item Methods for \code{all.equal} now report the packages where
      S4 classes are defined.

      \item \code{sum(x)} and \code{prod(x)} no longer require a
      coercion from \code{symmetricMatrix} to \code{generalMatrix}.
      Results where coercions are now avoided may differ numerically due
      to reordering of adds and multiplies, most commonly on systems
      where \code{sizeof(long double) == sizeof(double)}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Methods for \code{cbind2} and \code{rbind2} did not in all
      cases handle vectors as 1-column and 1-row matrices, respectively.

      \item Methods for \code{cbind2} and \code{rbind2} did not handle
      0-length vectors (including \code{NULL}) correctly where the
      result would have 0 rows and columns, respectively.

      \item Methods for \code{cbind2} and \code{rbind2} did not handle
      \code{NA} in the \code{x} slot of \code{ndenseMatrix} correctly
      (i.e., as \code{TRUE}).

      \item \code{cbind2(<ndenseMatrix>, <ldenseMatrix>)} gave
      \code{ngeMatrix} instead of \code{lgeMatrix}.
      \code{cbind2(<lsparseMatrix>, <lsparseMatrix>)} gave
      \code{dgCMatrix} instead of \code{lgCMatrix}.  Methods for
      \code{rbind2} had similar problems.

      \item \code{rcond(<0-by-0>)} now returns \code{Inf}; see
      \PR{18543}.

      \item \code{round(<dp[op]Matrix>)} and
      \code{signif(<dp[op]Matrix>)} now return \code{ds[yp]Matrix}
      rather than \code{dp[op]Matrix} and now discard \code{factors}.

      \item Methods for \code{length} now return \code{integer} rather
      than \code{double} if the result does not exceed \code{INT_MAX}.

      \item Methods for subscripting \code{sparseVector} did not behave
      compatibly with \pkg{base} when supplied with fractional,
      \code{NA}, or out-of-bounds subscripts.

      \item \code{symmpart(x)}, \code{skewpart(x)}, \code{band(x, k1,
      k2)}, \code{triu(x, k)}, and \code{tril(x, k)} now always return a
      \code{.diMatrix} for \code{x} inheriting from
      \code{diagonalMatrix}.

      \item \code{colSums(<(n|l|ind)Matrix>)} and
      \code{rowSums(<(n|l|ind)Matrix>)} now always give a result of type
      \code{"integer"}.  Methods differed previously, some giving
      \code{"double"} (as \pkg{base} does, suboptimally, traditional
      matrices of type \code{"logical"}).

      \item Some methods for generic function \code{lu} did not transmit
      \code{Dimnames} to the result.

      \item Some methods for group generic function \code{Summary}
      ignored arguments matching \code{\dots}.  Other methods did not
      ignore the \dQuote{garbage} elements of the \code{x} slot of
      dense, triangular matrices.

      \item \code{kronecker(<n.TMatrix>, <diagonalMatrix>)} threw an
      error for attempting to access the nonexistent \code{x} slot of
      its first argument.

      \item Matrix products now behave exactly as \pkg{base} when
      testing for conformable arguments.

      \item Numeric products (\code{\%*\%}) did not always return a
      \code{dMatrix}.

      \item Methods for \code{all.equal} now \dQuote{see} attributes of
      S4 objects that are not slots.  This can be disabled by setting
      argument \code{check.attributes} to \code{NA}, which is otherwise
      equivalent to \code{TRUE}.

      \item \code{prod(x)} is computed more diligently for \code{x}
      inheriting from \code{sparseMatrix}, \code{sparseVector}, or
      \code{.t[rp]Matrix}, i.e., those \code{x} that can be understood
      to have \dQuote{structural} zeros.  Now, multiplication by zero
      occurs at the position of the first structural zero in the matrix
      or vector (when traversed by row in the case of
      \code{RsparseMatrix}).  An exception is \code{TsparseMatrix}, for
      which multiplication by zero occurs before multiplication by any
      stored entry, regardless of the position of the first structural
      zero in the corresponding sorted matrix (to avoid the cost of
      sorting).

      \item \code{tri[ul](<.t[rp]Matrix>, k)} was often wrong for
      nonzero \code{k}, setting too many bands to zero.

      \item C-level \code{tCsparse_diag} (formerly \code{diag_tC}) now
      handles structural zeros and \code{NaN} on the main diagonal
      correctly.  Option \code{"diagBack"} now works correctly.

      \item \code{expm(x)} failed for \code{x} of class \code{dtpMatrix}
      or \code{dspMatrix}, since \pkg{Matrix} version 1.6-1.

      \item \code{.m2dense(x, ".ge")} allocated unnecessarily for
      \code{x} without attributes.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item \proglang{C} code now refers to the symbol \code{factors} as
      \code{Matrix_factorsSym}, rather than \code{Matrix_factorSym}.

      \item The content of \file{src/Mutils.[ch]} has been migrated to
      more transparently named files: \file{src/attrib.[ch]},
      \file{src/objects.[ch]}, etc.  Similarly, much of
      \file{src/factorizations.[ch]} have been migrated to
      \file{src/solve.[ch]} and \file{src/determinant.[ch]}.

      \item All matrix product code has been migrated to
      \file{products.[Rch]}.

      \item Files in \file{po/} and \file{inst/po/} have been updated
      due to more frequent use of \code{gettextf} in \file{R/*.R}.

      \item \proglang{C} code is prepared to handle complex matrices and
      their factorizations.  Notably, new machinery in
      \file{src/cs-etc.[ch]} will enable linking the CXSparse library
      instead of the CSparse library, the latter supporting numeric
      types but not complex ones.
    }
  }
}

\section{Changes in version 1.6-1.1 (2023-09-08, hotfix)}{
  \subsection{Misc}{
    \itemize{
      \item Export the generics \code{crossprod()} and
      \code{tcrossprod()} explicitly, needed for R-devel when they
      become primitive internal generics.
    }
  }
}

\section{Changes in version 1.6-1 (2023-08-11, svn r4228)}{
  \subsection{C-Level API}{
    \itemize{
      \item Registered routine \code{chm_sparse_to_SEXP} sorts and packs
      its first argument \emph{before} assigning any struct members to
      variables, preventing use-after-free.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item Four Valgrind-detected memory bugs are fixed.
    }
  }
  \subsection{Classes}{
    \itemize{
      \item Validity methods for classes \code{Cholesky} and
      \code{pCholesky} test for a valid \code{perm} slot.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item Several new coercion utilities, exported and documented in
      \code{help("fastMisc")}.  Some of these supercede ones made
      available (experimentally) in \pkg{Matrix} 1.5-4; for example,
      \code{.M2m} makes both \code{.dense2m} and \code{.sparse2m}
      redundant.  The superceded ones are not yet formally deprecated,
      but are no longer documented.

      \item \code{drop0} is now implemented independently of
      \code{CHOLMOD}, becoming more efficient notably for logical
      arguments, no longer requiring a coercion to double.

      \item \code{drop0} gains an argument \code{give.Csparse} to
      complement \code{is.Csparse}.  \code{FALSE} indicates that
      \code{RsparseMatrix}, \code{TsparseMatrix}, and \code{indMatrix}
      arguments should be handled directly, without a coercion to
      \code{CsparseMatrix}.  The default value is \code{TRUE}, for
      backwards compatibility.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{<diagonalMatrix> \%*\% <RsparseMatrix>} works again.

      \item \code{diag(<non-square RsparseMatrix>) <- value} works
      again, no longer giving a \code{p} slot of length \code{Dim[2]}
      rather than \code{Dim[1]}.

      \item \code{as(<diagonalMatrix>, "symmetricMatrix")} now checks
      for symmetric \code{Dimnames}, for consistency.

      \item as(<indMatrix>, "[nld](sparse)?Matrix") now returns a
      \code{.gRMatrix} or a \code{.gCMatrix} depending on the
      \code{margin} slot.

      \item \code{as(<[CR]sparseMatrix>, "generalMatrix")} now checks if
      the number of nonzero entries in the result would exceed
      \code{INT_MAX} and throws an error in that case.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item Run speed-measuring tests only \code{if(doExtras)}: these
      were too slow when run under Valgrind.

      \item Most coercion code has been migrated to \file{coerce.[Rch]}
      from elsewhere.

      \item The number of methods for generic functions \code{coerce}
      and \code{as.*} has been reduced substantially, from 306 to 194
      (not counting deprecated ones), partly as a result of efforts to
      do more fine-grained dispatch in \proglang{C} code.

      \item Files in \file{po/} and \file{inst/po/} have been updated
      (again), as many more \proglang{C} level messages now use format
      strings as a result of \code{vsnprintf} usage in
      \file{src/validity.c}.
    }
  }
}

\section{Changes in version 1.6-0 (2023-06-30, svn r4125)}{
  \subsection{Dependencies}{
    \itemize{
      \item The following \dQuote{weak} dependencies, needed only for a
      small number of Rd cross references, are removed:
      \pkg{MatrixModels}, \pkg{expm}, \pkg{igraph}, \pkg{maptools},
      \pkg{sp}, \pkg{spdep}.  Links to CRAN or Bioconductor in Rd files
      are preserved.

      \item \pkg{sfsmisc} is moved from \code{Enhances} to
      \code{Suggests}, as \pkg{Matrix} does not formally enhance it with
      methods or links to documentation.

      \item \pkg{grDevices} and \pkg{datasets} are added to
      \code{Imports} and \code{Suggests}, respectively, as \pkg{Matrix}
      does import from \pkg{grDevices} and (in vignettes) does load data
      from \pkg{datasets}.

      \item Example, test, and vignette code no longer fails when
      \env{R_DEFAULT_PACKAGES} is set to \code{NULL}.

      \item Example code uses \code{requireNamespace} instead of
      \code{require} to preserve the user's search path.
    }
  }
  \subsection{Significant User-Visible Changes}{
    \itemize{
      \item Methods for generic function \code{chol} that previously
      returned an object of class \code{p?Cholesky} now return an
      equivalent object of class \code{dtrMatrix} or \code{dtpMatrix}.
      Existing code that relied (correctly) on \code{chol} to return the
      upper triangular Cholesky factor as a \code{Matrix} can be
      expected to work as before.
    }
  }
  \subsection{Classes}{
    \itemize{
      \item Class \code{indMatrix} gains a \code{margin} slot with value
      \code{1L} or \code{2L} (\code{1L} being the prototype and
      previously implicit value), indicating that the object represents
      a row or column index matrix, with ones at \code{[i, perm[i]]} or
      \code{[perm[j], j]}, respectively.\cr
      \cr
      Methods with \code{indMatrix} or its subclass \code{pMatrix} in
      the signature have been adjusted to account for the new slot.
      Notably, multiplication on the right by an \code{indMatrix} with
      \code{margin = 2} is now implemented as a column subscript, and
      the transpose of an \code{indMatrix} is now the same object but
      with \dQuote{opposite} \code{margin}.

      \item Virtual class \code{MatrixFactorization} gains a
      \code{Dimnames} slot.  Now all factorizations preserve the
      \code{Dimnames} of the original, factorized \code{Matrix}, whereas
      previously classes \code{Schur}, \code{sparseLU}, \code{sparseQR},
      \code{dCHMsimpl}, and \code{dCHMsuper} did \emph{not}.  Users can
      get the value of the new \code{Dimnames} slot with
      \code{dimnames(.)} and set it with \code{dimnames(.) <- value}.

      \item Classes \code{p?BunchKaufman} and \code{p?Cholesky} no
      longer extend \code{dtrMatrix} or \code{dtpMatrix} and in turn no
      longer extend \code{Matrix}.  They retain slots \code{Dim},
      \code{Dimnames}, \code{uplo}, and \code{x}, but not \code{diag}.
      This change implies that virtual classes \code{Matrix} and
      \code{MatrixFactorization} no longer intersect.

      \item Classes \code{p?Cholesky} gain a \code{perm} slot with
      prototype \code{integer(0L)} to support representation of pivoted
      factorizations, as typically computed by LAPACK routine
      \code{dpstrf}.  \code{perm} of length 0 is valid and equivalent to
      the identity permutation.

      \item New nonvirtual class \code{pcorMatrix} extending
      \code{dppMatrix}.  It is the counterpart of \code{corMatrix} using
      packed storage, supporting more efficient storage of dense
      correlation matrices.  Now \code{pack(<corMatrix>)} gives a
      \code{pcorMatrix} preserving the \code{sd} slot, rather than a
      \code{dppMatrix} without an \code{sd} slot.

      \item New virtual classes \code{BunchKaufmanFactorization},
      \code{SchurFactorization}, and \code{QR}, extended by existing
      nonvirtual classes \code{p?BunchKaufman}, \code{Schur}, and
      \code{sparseQR}, respectively.  These are parallel to the existing
      virtual classes \code{CholeskyFactorization} and \code{LU}.
      Packages defining new factorization classes may extend these.

      \item Virtual class \code{CHMfactor} and its subclasses gain
      formal validity methods.

      \item The validity method for class \code{sparseQR} now tests that
      the \code{V} slot is lower trapezoidal and that the \code{R} slot
      has non-negative diagonal elements.

      \item The validity method for class \code{corMatrix} now tolerates
      nonfinite elements in the \code{sd} slot.  It no longer tolerates
      nonunit diagonal elements in the \code{x} slot.

      \item The prototype of the \code{Dim} slot of virtual class
      \code{MatrixFactorization} is now \code{integer(2L)}.  It was
      previously \code{integer(0L)}, with the result that
      \code{validObject(new(<nonvirtual>))} was always an error.

      \item The prototype of the \code{L} slot of class \code{sparseLU}
      is now formally lower triangular, so that
      \code{validObject(new("sparseLU"))} is not an error.

      \item The prototypes of the \code{Q} and \code{T} slots of class
      \code{Schur} are now 0-by-0 \code{dgeMatrix}, so that
      \code{validObject(new("Schur"))} is not an error.
    }
  }
  \subsection{Generic Functions}{
    \itemize{
      \item New generic functions \code{expand1} and \code{expand2},
      intended to replace \code{expand} and coercions from (subclasses
      of) \code{MatrixFactorization} to (subclasses of) \code{Matrix}.
      \code{expand1} is used as
      \code{expand1(<MatrixFactorization>, <character string>)} and
      constructs by name factors appearing in the factorization.
      \code{expand2} is used as \code{expand2(<MatrixFactorization>)}
      and returns a named list of \emph{all} factors appearing in the
      factorization, in order and with row names on the first factor
      and column names on the last factor.  The result can be used to
      reconstruct the factorized \code{Matrix} as the product of the
      elements of the list, namely
      \code{Reduce(`\%*\%`, expand2(.))}.\cr
      \cr
      \code{expand} and its methods are retained for backwards
      compatibility.  They may be formally deprecated in the future,
      hence new code should use \code{expand1} and \code{expand2}.
      Notably, \code{expand1} and \code{expand2} have methods for all
      factorizations in \pkg{Matrix}, whereas \code{expand} continues to
      have methods only for \code{denseLU}, \code{sparseLU}, and
      \code{CHMfactor}.  See \code{help("expand-methods")} for a list of
      methods, including useful optional arguments.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item Methods for subscripting \code{Matrix} now use the more
      systematic code in \file{R/subscript.R} and
      \file{src/subscript.c}, becoming more efficient for all
      \code{lsparseMatrix}
      (no longer coercing to \code{dsparseMatrix} and back),
      sparse \code{symmetricMatrix}
      (no longer coercing to \code{generalMatrix} and back when \code{i}
      in \code{x[i, i]} is monotone),
      \code{unpackedMatrix}
      (no longer coercing to \code{matrix} and back), and
      \code{RsparseMatrix}
      (no longer coercing to \code{TsparseMatrix}, then to
      \code{CsparseMatrix}, then back to \code{TsparseMatrix} [!]).\cr
      \cr
      \code{x[i, j, drop = FALSE]} preserves the class of \code{x} in
      more cases where \code{x} is a \code{triangularMatrix},
      \code{diagonalMatrix}, or \code{pMatrix}, doing more complete
      checks on \code{i} and \code{j}.\cr
      \cr
      Notably, for \code{x} inheriting from \code{RsparseMatrix}, the
      result is now always an \code{RsparseMatrix}, rather than always a
      \code{TsparseMatrix}.

      \item \code{NULL} subscripts, as in \code{x[NULL]}, \code{x[NULL,
      j]}, and \code{x[i, NULL]}, are now supported for \code{x}
      inheriting from \code{Matrix}.  They are handled as
      \code{integer(0)}, consistent with \pkg{base}.

      \item Generic function \code{Cholesky} gains methods for
      \code{denseMatrix} returning an object of class \code{p?Cholesky}.
      The method for subclass \code{dsyMatrix} admits an argument
      \code{perm} indicating if the pivoted factorization should be
      computed.  The corresponding \code{chol} method gains an argument
      \code{pivot} indicating the same.  By default, \code{Cholesky}
      pivots and \code{chol} does not.

      \item Many subclasses of \code{MatrixFactorization} can now be
      coerced to \dQuote{nearby} subclasses of \code{Matrix}.  The
      resulting \code{Matrix} reflects the internal representation of
      the factorization and not necessarily a particular matrix factor.
      The new coercions are:
      \code{as(<denseLU>, "dgeMatrix")},
      \code{as(<BunchKaufman>, "dtrMatrix")},
      \code{as(<pBunchKaufman>, "dtpMatrix")},
      \code{as(<Cholesky>, "dtrMatrix")},
      \code{as(<pCholesky>, "dtpMatrix")},
      \code{as(<CHMsimpl>, "dtCMatrix")}, and
      \code{as(<CHMsuper>, "dgCMatrix")}.
      See \code{help("denseLU-class")} (and similar) for details.

      \item \code{determinant(x, \dots)} and \code{solve(a, b, \dots)}
      now work for \code{x} and \code{a} inheriting from
      \code{MatrixFactorization}, behaving as if \code{x} and \code{a}
      were replaced by the factorized \code{Matrix}.  The exception is
      \code{x} inheriting from \code{CHMfactor}, where for backwards
      compatibility the default behaviour is still to compute the
      determinant of the Cholesky factor.  This exception should be
      considered \emph{temporary}, hence defensive code will call
      \code{determinant} with (new) optional argument \code{sqrt} set to
      \code{TRUE} or \code{FALSE} explicitly, to not rely on the current
      default value.  See \code{help("CHMfactor-class")} for details.

      \item Generic function \code{diag} gains methods for
      \code{p?Cholesky} and \code{CHMfactor}.  The result is a numeric
      vector containing the diagonal entries of the diagonal matrix
      \eqn{D}, as defined in \code{help("Cholesky-class")} and
      \code{help("CHMfactor-class")}.

      \item The \code{lu} and \code{qr} methods for class
      \code{dgCMatrix} now admit an \code{order} argument with value in
      \code{0:3}, allowing the expert user to choose among all ordering
      methods made available by the CSparse library.

      \item \code{solve(<dgCMatrix>, b, sparse = TRUE)} is now handled
      entirely in \proglang{C} code via \code{cs_spsolve} from the
      CSparse library.

      \item New utilities \code{invertPerm}, \code{signPerm},
      \code{isPerm}, and \code{asPerm} for computing the inverse and
      sign of a permutation vector, testing if an integer vector is a
      permutation vector, and coercing a transposition vector to a
      permutation vector.  \code{invertPerm} is a more general version
      of the already exported function \code{invPerm}, which is retained
      as a wrapper around \code{invertPerm} for backwards compatibility.

      \item The \code{qr.R} method for class \code{sparseQR} gains a
      \code{backPermute} argument with default \code{FALSE}, for
      compatibility with \pkg{base}.  Function \code{qrR}, which existed
      primarily to provide a back-permuting option, is retained for
      backwards compatibility.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{x[integer(0), ]} and \code{x[, integer(0)]} now give a
      \code{generalMatrix} result when \code{x} is a 0-by-0
      \code{diagonalMatrix}, for consistency with all other cases of
      \code{x[seq_len(n), ]} and \code{x[, seq_len(n)]}, where \code{x}
      is an \code{n}-by-\code{n} triangular, symmetric, or diagonal
      matrix.

      \item For \code{x} inheriting from \code{RsparseMatrix},
      subassignment of the form \code{x[i, ] <- value} is now correctly
      distinguished from \code{x[i] <- value}.

      \item \code{rownames(x[integer(0), , drop = FALSE])} and
      \code{colnames(x[, integer(0), drop = FALSE])} are now always
      \code{NULL} and never \code{character(0)}, consistent with the
      implementation in \pkg{base}.

      \item Subscript operations on \code{Matrix} now correctly error
      whenever the formal argument \dots{} is matched, as in \code{x[i,
      j, drop]}, where \code{x[i, j, drop = drop]} is almost always
      intended.

      \item \code{x[i, ]} now correctly drops dimensions when \code{x}
      is a 1-by-\code{n} \code{Matrix} and \code{i} is \code{TRUE}.

      \item Methods for \code{solve} now obey the following rules much
      more strictly:
      \itemize{
        \item \code{solve(a=<Matrix>, b=<vector>)}
        must return a vector.
        \item \code{solve(a=<denseMatrix>, b=<Matrix>)}
        must return a \code{denseMatrix}.
        \item \code{solve(a=<sparseMatrix>, b=<Matrix>, sparse=FALSE)}
        must return a \code{denseMatrix}.
        \item \code{solve(a=<sparseMatrix>, b=<Matrix>, sparse=TRUE)}
        must return a \code{sparseMatrix}.
      }
      resolving some longstanding incompatibilities with \pkg{base}.\cr
      \cr
      Note that methods for sparse \code{a} and missing or sparse
      \code{b} have default \code{sparse = TRUE}, while methods for
      sparse \code{a} and dense \code{b} have default
      \code{sparse = FALSE}.

      \item \code{solve(<symmetricMatrix>)} now always gives a
      \code{symmetricMatrix} result.  \code{solve(<dpoMatrix>)} and
      \code{solve(<dppMatrix>)} preserve formal positive definiteness,
      giving a \code{dpoMatrix} and \code{dppMatrix}, respectively.

      \item \code{BunchKaufman(<matrix>)} now works when argument
      \code{uplo} (documented to be optional) is missing.

      \item Coercions to \code{corMatrix} now set the diagonal elements
      of the result to 1, consistent with \code{cov2cor}.

      \item \code{dimnames(x) <- value} now validates \code{x@Dim}
      before \code{value} to avoid undefined behaviour in C-level check.

      \item \code{chol2inv(x)} now ignores the lower triangular part of
      \code{x} not inheriting from \code{triangularMatrix}.

      \item \code{chol2inv(x)} now computes \code{crossprod(solve(x))}
      instead of \code{tcrossprod(solve(x))} for all formally lower
      triangular \code{x}.  Previously, \code{crossprod} was used only
      for dense \code{x}.

      \item \code{rcond(x, norm)} throws a nicer error for \code{x} of
      length 0.

      \item Error messages due to invalid \code{norm} in \code{rcond(x,
      norm)} now refer to the argument as \code{norm} rather than
      \code{type}.

      \item \code{rcond(x, norm)} now validates \code{norm} also for
      \code{x} of class \code{d(sy|sp|po|pp)Matrix}, even if for such
      \code{x} all valid \code{norm} give the same result.

      \item \code{which(<[RT]sparseMatrix>, ...)} now gives indices in
      column-major order in all cases, to be consistent with
      \code{help("which")}.

      \item Factorizations inheriting from virtual class \code{LU} are
      now cached under the name \code{denseLU} or \code{sparseLU},
      depending on the nonvirtual class, rather than always under the
      name \code{LU}.  Note that user code should \emph{not} rely on the
      details of the cache and should instead rely on functions such as
      \code{lu} to retrieve cached factorizations.

      \item Errors signaled by \code{as(<dsyMatrix>, "dpoMatrix")} and
      \code{as(<dspMatrix>, "dppMatrix")} now clarify that the coercions
      do not attempt to test for positive semidefiniteness when the
      matrix is not positive definite.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item \code{invPerm(p)} no longer segfaults for \code{p} that are
      not valid permutation vectors.  \code{invPerm(NA)} was enough to
      trigger a segfault.

      \item \proglang{C} code interfacing the CSparse library tests in
      more places for failed allocations inside of \code{cs_*}.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item Help pages for matrix factorization classes and methods have
      been broadly expanded and updated to use consistent notation.

      \item The length of the \pkg{Matrix} namespace has been reduced by
      ~15\%.  More than 100 unused symbols have been removed.

      \item Updates to \file{po/*.\{po,pot\}} and \file{inst/po/*} for
      translators.
    }
  }
}

\section{Changes in version 1.5-4.1 (2023-05-16, hotfix)}{
  \subsection{Installation}{
    \itemize{
      \item \file{src/Lapack-etc.h} uses \code{#ifdef PR18534fixed},
      adapting to \PR{18534} without breaking installation under \R{}
      \eqn{<} 4.3.1.
    }
  }
}

\section{Changes in version 1.5-4 (2023-04-02, svn r3837)}{
  \subsection{Compatibility}{
    \itemize{
      \item \code{sequence.default} is defined for \R{} \eqn{<} 4.0.0.
    }
  }
  \subsection{C-Level API}{
    \itemize{
      \item \file{Rinternals.h} is included in
      \file{inst/include/Matrix.h} instead of deprecated
      \file{Rdefines.h}.  The inclusion is done outside of
      \code{extern "C"}.
    }
  }
  \subsection{Deprecated and Defunct}{
    \itemize{
      \item The following low level coercion utilities, which were
      previously exported but always \dQuote{hidden} and undocumented,
      are now deprecated: \code{..2dge}, \code{.C2nC}, \code{.T2Cmat},
      \code{.asmatrix}, \code{.dense2sy}, \code{.diag2mat},
      \code{.diag2sT}, \code{.diag2tT}, \code{.dsy2dsp},
      \code{.dsy2mat}, \code{.dxC2mat}, \code{.m2dgC}, \code{.m2lgC},
      \code{.m2ngC}, \code{.m2ngCn}, \code{.m2ngTn}, \code{.n2dgT},
      \code{.nC2d}, \code{.nC2l}.\cr
      \cr
      The deprecations follow efforts to define more general and more
      systematic (but still fast) coercion utilities, to allow expert
      users to bypass S4 dispatch in more cases.  The subset of these
      currently exported is documented under \code{help("fastMisc")}.
      Deprecation warnings will suggest an appropriate replacement,
      mostly from that list.\cr
      \cr
      It is not always the case that the replacement can be
      \dQuote{dropped in}, hence users should consult the relevant
      documentation when changing their code.

      \item Warnings signaled by coercion methods deprecated in
      \pkg{Matrix} 1.5-0 now correctly inherit from class
      \code{deprecatedWarning}.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item Calls to \code{sprintf} are replaced by equivalent calls
      \code{snprintf} to avoid potential buffer overflow.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item C-level utilities \code{Matrix_memset()} and
      \code{Matrix_memcpy()}, both new, are now used in many places
      instead of API macros \code{Memzero()} and \code{Memcpy()} which
      never check for overflow.  C-level macro \code{AZERO()} is no
      longer defined.

      \item C-level macro \code{Calloc_or_Alloca_TO()} now
      zero-initializes also in the \code{alloca}-using case.
    }
  }
}

\section{Changes in version 1.5-3 (2022-11-10, svn r3772)}{
  \subsection{Dependencies}{
    \itemize{
      \item \pkg{methods} is moved from \code{Imports} to \code{Depends}
      as suggested in the WRE manual.  Now \code{as} and other basic S4
      machinery are available whenever \pkg{Matrix} is attached.  This
      change affects \R{} processes started with environment variable
      \env{R_DEFAULT_PACKAGES} set to \code{NULL} (or any list not
      containing \pkg{methods}).
    }
  }
  \subsection{Compatibility}{
    \itemize{
      \item Test involving sparse \code{POSIXlt} in
      \file{tests/Simple.R} is adapted to possible (unconditional since
      \R{} version 4.3.0) existence of character component \code{zone}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{dimScale(x)} with argument \code{d1} missing is no
      longer an error.  (The default value had \code{diag(x, FALSE)}
      instead of \code{diag(x, names = FALSE)}.)

      \item \code{(dim|row|col)Scale(x)} is no longer an error for
      traditional matrices \code{x} without a \code{dimnames} attribute.

      \item Our \code{cov2cor()} methods now again preserve
      (symmetrized!)  \code{dimnames}, fixing \MPR{6783} reported by
      Ben Bolker.

      \item \code{colSums()} and friends now always give a \emph{named}
      result when the marginal \code{Dimnames} are non-\code{NULL}.
      (Names were \dQuote{forgotten} for \code{diagonalMatrix} and
      \code{indMatrix} arguments.)

      \item \code{colSums()} and friends now respect \code{na.rm} when
      handling \code{diagonalMatrix} with \code{NA} diagonal entries.

      \item \code{expand(<denseLU>)} now \dQuote{copies-on-modify}, no
      longer duplicating the \code{m*n}-length \code{x} slot in the
      \code{m == n} case, when it can be used directly.

      \item \code{lu(<m-by-0>)}, \code{lu(<0-by-n>)}, and
      \code{BunchKaufman(<0-by-0>)} now give sensible (0-extent)
      results, rather than a LAPACK error, for \code{denseMatrix}.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item \code{Diagonal()} gets a new optional \code{names} argument.

      \item \code{diag(x) <- value} is now done in \proglang{C} also for
      \code{[CRT]sparseMatrix}.

      \item \code{.diagU2N()} gets fast counterpart \code{.diagN2U()}.

      \item \code{colSums()} and friends are now implemented more
      efficiently for \code{denseMatrix} and \code{[CRT]sparseMatrix}.
      Notably, methods for triangular and symmetric matrices no longer
      go via \code{generalMatrix}, and methods for
      \code{[CRT]sparseMatrix} now handle nonzero pattern and logical
      matrices directly (no longer coercing to double, a constraint of
      the earlier implementation using CHOLMOD).

      \item \code{determinant(<ds[yp]Matrix>)} is now computed via the
      Bunch-Kaufman factorization.  Factorizations are cached in the
      \code{factors} slot for future reuse.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item C-level wrappers for LAPACK \code{d..trf} routines gain an
      argument \code{warn} indicating how to handle \code{info > 0}:
      \code{warn <= 0} is silent, \code{warn = 1} is a warning, and
      \code{warn > 1} is an error.  In the case of \code{dp[op]trf}, for
      which \code{info > 0} implies an incomplete factorization,
      \code{info} is now returned as a length-1 integer.
    }
  }
}

\section{Changes in version 1.5-2 (2022-10-21, svn r3702)}{
  \subsection{Classes}{
    \itemize{
      \item The validity methods for classes \code{l[st]CMatrix} now
      correctly test for structurally nonzero entries on the wrong side
      of the main diagonal, and fail in that case.  Previously, this
      test was performed only for \code{d[st]Matrix}.

      \item The validity method for virtual class \code{sparseVector} is
      more diligent, catching more edge cases such as \code{NA} in the
      \code{length} or \code{i} slot.

      \item New validity methods for \code{n[st][CRT]Matrix},
      \code{Schur}, \code{denseLU}, \code{p?BunchKaufman},
      \code{p?Cholesky}, \code{sparseLU}, and \code{sparseQR}.  Notably,
      the following properties of factorizations are now checked: the
      dimensions of each factor, the orientation of each triangular (or
      trapezoidal) factor, and the validity of each permutation vector.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{lu(x)@L@uplo} is now \code{"L"}, not \code{"U"}, for
      0-by-0 and 1-by-1 \code{dgCMatrix} \code{x}.

      \item The validity method for \code{corMatrix} now throws a better
      error when the \code{sd} slot is of type \code{"integer"} rather
      than \code{"double"}.

      \item \code{.sparseDiagonal()} now agrees with \code{Diagonal()}
      when called with no arguments, returning a 0-by-0 (rather than
      1-by-1) diagonal \code{Matrix}.

      \item \code{sparseMatrix(i, j)} with 0-length \code{i} and
      \code{j} now returns a 0-by-0 matrix rather than throwing a
      perplexing error.

      \item \code{sparseMatrix(dims = <list>)} and
      \code{sparseMatrix(x = <dMatrix>)} now produce errors.

      \item \code{diag(x) <- value} now coerces \code{diagonalMatrix}
      \code{x} if \code{typeof(value)} is \dQuote{higher} than
      \code{typeof(x@x)} in the usual hierarchy, for consistency with
      methods for \code{denseMatrix} and with \code{base::`diag<-`}.

      \item Methods for \code{kronecker()} no longer ignore the
      \code{make.dimnames} argument.

      \item Printing a \code{sparseMatrix} with \code{NA} row or column
      names is no longer an error.

      \item Products of two \code{pMatrix} objects \code{x} and \code{y}
      are now computed correctly.  Previously, \code{y \%*\% x} was
      returned instead of \code{x \%*\% y}!

      \item Products \code{x \%*\% y} with \code{x} a
      \code{diagonalMatrix} or \code{indMatrix} and \code{y} a
      traditional matrix or vector, or with \code{x} a traditional
      matrix or vector and \code{y} a \code{diagonalMatrix} or
      \code{pMatrix}, now treat the unclassed argument as a
      \code{.geMatrix} and return a \code{.geMatrix}, for greater
      consistency with other products involving one \code{Matrix} and
      one non-\code{Matrix}.

      \item Similarly, \code{kronecker(x, y)} with one of \code{x} and
      \code{y} a \code{Matrix} and the other a traditional matrix or
      vector now treats the unclassed argument as a \code{.geMatrix}.

      \item \code{dimnames(solve(x))} is now \code{rev(dimnames(x))} for
      \code{denseMatrix} \code{x}, consistent with the handling of
      \code{dimnames} by \code{solve.default}.  Methods for
      \code{sparseMatrix} \code{x} have not been addressed (yet).
    }
  }
  \subsection{Memory}{
    \itemize{
      \item In many more (but not yet all) places, \proglang{C}
      functions protect the values of \code{R_do_slot},
      \code{Rf_getAttrib}, \code{Rf_mkString}, etc. from garbage
      collections, squashing many new and some old \command{rchk}
      warnings.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item \code{is.nan(x)} is now implemented for all \code{x}
      inheriting from virtual class \code{Matrix} or
      \code{sparseVector}.

      \item \code{Diagonal(n=, x=)} now recycles \code{x} of any
      positive length to length \code{n}.  Previously, recycling was
      supported only for \code{x} of length 1.

      \item Products involving \code{diagonalMatrix} or \code{indMatrix}
      have been broadly improved as follows:
      \itemize{
        \item \code{dimnames(A \%*\% B)} is now always
        \code{c(dimnames(A)[1], dimnames(B)[2])}.

        \item \code{t?crossprod()} methods involving \code{indMatrix} or
        its subclass \code{pMatrix} gain a \code{boolArith} argument.

        \item Numeric and boolean products are always returned as
        \code{dMatrix} and \code{nMatrix}, respectively, except in a few
        special cases where the product can be represented as an
        \code{indMatrix}.  (Previously, coercions were skipped when one
        of the operands was unit diagonal.)

        \item Products of \code{diagonalMatrix} with dense
        \code{triangularMatrix} now correctly give a
        \code{triangularMatrix} result (and without unpacking).

        \item Products of \code{diagonalMatrix} with
        \code{[RT]sparseMatrix} now preserve storage, no longer coercing
        to \code{CsparseMatrix}.

        \item \code{crossprod(x, y)} no longer requires the product of
        \code{ncol(x)} and \code{ncol(y)} to be less than \code{2^31}
        when both \code{x} and \code{y} are \code{indMatrix}.  (The new
        implementation now always gives a \code{dgTMatrix} result,
        whereas previously the result would typically but not always be
        a \code{dgCMatrix}.)
      }

      \item \code{kronecker(<Matrix>, <Matrix>)} now gives the correct
      \dQuote{shape} (general, [unit] triangular, symmetric, diagonal)
      in all cases where it can be known without checking.

      \item \code{kronecker(<[CR]sparseMatrix>, <Matrix>)} now retains
      the storage of the first argument, no longer coercing to
      \code{TsparseMatrix}.

      \item New exported functions \code{dimScale}, \code{rowScale}, and
      \code{colScale}, for scaling rows and columns of a
      \code{[mM]atrix} without losing \code{dimnames} and where
      appropriate without losing symmetry.
    }
  }
}

\section{Changes in version 1.5-1 (2022-09-12, svn r3642)}{
  \subsection{Memory}{
    \itemize{
      \item ASan-detected memory bugs are fixed in \proglang{C}
      functions \code{Tsparse_as_CRsparse} and \code{pMatrix_validate}.
      The former was triggered by \code{.T2C(<0-by-0>)} and the latter
      was triggered by \code{as(<length-10000 integer>, "pMatrix")}.
    }
  }
}

\section{Changes in version 1.5-0 (2022-09-09, svn r3636)}{
  \subsection{Deprecated and Defunct}{
    \itemize{
      \item With a few exceptions, direct coercions to non-virtual
      subclasses of \code{Matrix} (e.g., \code{dsCMatrix}) have been
      formally deprecated.  For now, these will continue to work as
      before, but with a warning indicating how to accomplish the
      desired coercion via virtual classes (e.g.,
      \code{symmetricMatrix}) alone.  How such warnings are signaled is
      controlled by the global option
      \code{Matrix.warnDeprecatedCoerce}.
      \describe{
        \item{\code{0} or less}{is to be silent.}
        \item{\code{1}}{is to signal a warning with each deprecated
          coercion.}
        \item{\code{2} or greater}{is to signal an error with each
          deprecated coercion.}
        \item{\code{NA}}{is to signal a message or warning (see below)
          with the next deprecated coercion and be silent after that.}
      }
      If unset or invalid, then the value of the environment variable
      \env{R_MATRIX_WARN_DEPRECATED_COERCE} (\code{NA} if unset) is
      used.  This is cached when the \pkg{Matrix} namespace is
      loaded.\cr
      \cr
      Option values are coerced to integer before use.\cr
      \cr
      To reduce disruption to existing code, the \code{NA} case signals
      messages rather than warnings with coercions to the most-used
      non-virtual subclasses of \code{Matrix}, namely \code{dg.Matrix}
      and \code{d.CMatrix}.  This may change in the future.
    }
  }
  \subsection{Classes}{
    \itemize{
      \item New virtual class \code{unpackedMatrix} representing dense
      matrices in unpacked format.  It extends \code{denseMatrix} and is
      extended by \code{[nld](ge|sy|tr)Matrix}, i.e., the subclasses of
      \code{denseMatrix} not extending \code{packedMatrix}.

      \item The validity method for \code{dppMatrix} requires
      non-negative diagonal elements, matching the validity method for
      \code{dpoMatrix}.

      \item The validity method for \code{Matrix} tolerates vector types
      other than \code{"character"} for \code{Dimnames[[i]]}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Symmetrization of \code{<Matrix>@Dimnames} and
      \code{dimnames(<matrix>)} now goes through \proglang{C} utility
      \code{symmDN()} in most places, resolving some earlier
      inconsistencies.

      \item Many more validity methods now correctly operate under the
      assumption that methods for superclasses have already been called,
      eliminating many redundant checks.

      \item Validation of \code{<Matrix>@Dim} now looks at type
      \emph{before} length, avoiding a misleading error message.

      \item Validation of \code{<Matrix>@Dimnames} now avoids
      \code{isNewList}, which had allowed an error message suggesting
      that \code{NULL} is a list.

      \item Setting a factor on a \code{compMatrix} is now to install
      the factor itself, not a copy, for efficiency and consistency with
      the semantics of \code{<compMatrix>@factors[[name]] <- value}.

      \item Long vector support in methods for packing and unpacking
      \code{denseMatrix}, and others.

      \item \code{diag<-} incorrectly preserved the class of dense
      matrices, so that, e.g., \code{`diag<-`(x=<dpoMatrix>, value=-1)}
      was still a \code{dpoMatrix}.  Now the result is always one of the
      more general \code{.(ge|tr|sy|tp|sp)Matrix}.

      \item \code{t(<corMatrix>)} no longer clears the \code{sd} slot.
      \code{t(<p?BunchKaufman>)} now returns one of the more general
      \code{dt[rp]Matrix}, rather than preserving class and clearing the
      \code{perm} slot.

      \item \code{t(<symmetricMatrix>)} no longer reverses the
      \code{Dimnames} slot.  Symmetrization of \code{dn <- x@Dimnames}
      and \code{t(x)@Dimnames} had given different results when
      \code{dn[[1]]} and \code{dn[[2]]} were non-\code{NULL} and
      asymmetric.

      \item \code{isTriangular(x, upper)} had incorrectly returned
      \code{FALSE} for \code{x} of class \code{triangularMatrix} when
      \code{upper = TRUE} and \code{x@uplo = "L"} or when \code{upper =
      FALSE} and \code{x@uplo = "U"}.  \code{isTriangular} is now
      equivalent to \code{isDiagonal} in those cases.

      \item \code{isSymmetric()} was equivalent to \code{isDiagonal()}
      for triangular matrices, \emph{not} allowing numerical fuzz via an
      argument \code{tol}.  A \code{tol} argument is now implemented for
      all subclasses of \code{dMatrix} except for those inheriting from
      \code{symmetricMatrix} or \code{diagonalMatrix}.

      \item Methods for \code{isSymmetric} now also look at
      \code{Dimnames} and \code{names(Dimnames)}, following
      \code{isSymmetric.matrix} from \pkg{base}.  See also New Features.

      \item \code{band(x, -k, k)} for sparse \code{x} used
      \code{isSymmetric(x)} (which tolerates numerical fuzz) to test for
      symmetry, resulting in loss of information in some cases.  Now it
      tests that \code{x} inherits from \code{symmetricMatrix}, and so
      returns \code{symmetricMatrix} in fewer cases.

      \item \code{triu(x, k)} and \code{tril(x, k)} incorrectly required
      \code{k <= m} (instead of \code{k <= n}), for \code{m}-by-\code{n}
      sparse \code{x}.  They now accept all \code{k} from \code{-m} to
      \code{n}, with fewer errors in the \code{m < n} case.

      \item \code{crossprod(<Rsparse>, <Tsparse>)} and similar now work
      again (optional \code{boolArith} was not passed on), fixing
      \MPR{6766} by David Cortes.  Ditto for \code{tcrossprod()}, where
      the old result was even wrong when it had \dQuote{worked}, before
      \pkg{Matrix} 1.2-0.

      \item \code{as(<matrix>, "nMatrix")} can now be sparse \emph{or}
      dense, going via \code{Matrix()}, for greater consistency with
      coercions to \code{dMatrix} and \code{lMatrix}.  (Previously, the
      result was always an \code{ngTMatrix}.)

      \item \code{forceSymmetric(<[RT]sparseMatrix>)} are now more
      efficient, returning symmetric \code{[RT]sparseMatrix} without
      intermediate coercions to \code{CsparseMatrix}.

      \item \code{tcrossprod(a, b)} for unit triangular sparse matrices
      now works correctly.

      \item \code{!<ltrMatrix>} is no longer an error in the 0-by-0 unit
      diagonal case.

      \item Coercions among \code{[CRT]sparseMatrix} preserve the
      \code{factors} slot in more cases.

      \item Coercions of overallocated \code{l.TMatrix} to
      \code{denseMatrix} or \code{CsparseMatrix} now give \code{TRUE}
      instead of \code{NA} in the \code{NA || TRUE} case, following
      conventional logic.

      \item Methods for unpacking and indexing \code{packedMatrix} and
      for coercing from \code{[CRT]sparseMatrix} to \code{denseMatrix}
      now check more consistently for overflow of \code{R_XLEN_T_MAX}.

      \item \code{solve(<ddenseMatrix>, <ANY>)} is removed from the
      method list.  It had allowed infinite recursion, e.g., with
      \code{solve(new("dgeMatrix"), NULL)}.

      \item \code{is.na(<ndenseMatrix>)} gave \code{TRUE} where the
      \code{x} slot had \code{NA}.  Now the result is always a zero
      matrix.

      \item \code{is.na(<.t[rp]Matrix>)} and
      \code{is.infinite(<.t[rp]Matrix>)} ignored the \code{diag} slot,
      behaving always as though \code{diag == "N"}.  They now give
      \code{FALSE} on the diagonal in the \code{diag != "N"} case.

      \item Now only \dQuote{nontrivial} matrix elements determine
      whether \code{is.na(<denseMatrix>)} is an \code{ndenseMatrix} or
      an \code{nsparseMatrix}.

      \item \code{is.na(<ddenseMatrix>)} coerced to \code{lMatrix}.
      This unnecessary step is avoided now, saving a potentially
      nontrivial allocation.

      \item \code{solve(<ddenseMatrix>, b)} coerced the first argument
      to \code{dgeMatrix} when \code{b} was not a \code{ddenseMatrix} or
      traditional \code{matrix}.  This unnecessary step is avoided now,
      so that specialized methods for \code{d(tr|sy|po|tp|sp|pp)Matrix}
      are used where possible (including for \code{b} inheriting from
      \code{[ln]denseMatrix}, \code{sparseMatrix}, or \code{numLike}).

      \item \code{`dim<-`(x, -x@Dim)} is now an error, no longer
      yielding an invalid \code{Matrix} object.

      \item \code{`dim<-`(x, x@Dim)} is now faster, returning \code{x}
      without allocation in all cases.

      \item \code{`dim<-`(x, value)} gives a better error when
      \code{value} contains \code{NA} or elements exceeding
      \code{INT_MAX}.

      \item \code{`dim<-`(<RsparseMatrix>, value)} is now an
      \code{RsparseMatrix}, rather than a \code{TsparseMatrix}.

      \item For consistency with other methods,
      \code{symmpart(<diagonalMatrix>)} now always inherits from both
      \code{dMatrix} and \code{symmetricMatrix}, and
      \code{skewpart(<diagonalMatrix>)} now always has symmetric
      \code{Dimnames}.

      \item Zeros on the diagonal of
      \code{skewpart(<[CRT]sparseMatrix>)} are now \emph{structural}.

      \item \code{as(<ndenseMatrix>, "(vector|matrix|[dl]Matrix)")} and
      \code{nnzero(<ndenseMatrix>)} now correctly treat \code{NA} in the
      \code{x} slot as \code{TRUE}.

      \item \code{as(<[nl].TMatrix>, "dMatrix")} now correctly handles
      the overallocated case: data for each unique \code{[i,j]} pair are
      aggregated logically (\code{x1 || ... || xn}) rather than
      arithmetically (\code{x1 + ... + xn}), so that elements of the
      result are restricted to the set \code{c(0, 1, NA)}.  This bug had
      also affected the result of \code{sum(<[nl].TMatrix>)}.

      \item \code{dimnames(as(x, "matrix"))} is now \code{NULL} for
      \emph{all} \code{x} inheriting from \code{Matrix}, when
      \code{x@Dimnames} is the trivial \code{list(NULL, NULL)}.

      \item \code{.bdiag(<named list>)} no longer propagates names to
      the \code{Dim} slot of the result.

      \item \code{as(<named vector>, "denseMatrix")} now correctly
      propagates \code{names} to the result.

      \item \code{as(<d.[CR]Matrix>, "lMatrix")} no longer drops
      non-structural zeros, for greater consistency with analogous
      coercions.

      \item \code{Matrix(x, doDiag)} now behaves as documented for
      diagonal matrices \code{x} with asymmetric \code{dimnames},
      returning a \code{diagonalMatrix} when \code{doDiag = TRUE},
      rather than a \code{triangularMatrix}.

      \item Matrix(<n-dimensional table>) now works for \code{n != 2}.

      \item \code{Matrix(<sparseVector>)} now works for vector lengths
      other than 1, no longer giving an error about length mismatch when
      neither of \code{nrow} and \code{ncol} are supplied.

      \item \code{Matrix(<diagonalMatrix>, doDiag = FALSE)} is now a
      \code{symmetricMatrix}, not a \code{diagonalMatrix}, matching the
      documentation of \code{doDiag}.

      \item \code{Matrix(<.geMatrix>, sparse = TRUE, forceCheck)} and
      \code{Matrix(<.g[CRT]Matrix>, sparse = FALSE, forceCheck)} now
      respect \code{forceCheck = FALSE} by always returning
      \code{generalMatrix}, i.e., \emph{not} testing for symmetric or
      triangular structure.

      \item \code{Matrix(0, nrow, )}, \code{Matrix(0, , ncol)} now throw
      (correct) errors for \code{nrow}, \code{ncol} in the interval
      \eqn{[0,1)}, consistent with \code{base::matrix()}.

      \item \code{sparseDefault(<sparseMatrix>)} now counts zeros
      without coercing to \code{matrix}, making
      \code{Matrix(<sparseMatrix>, sparse = NULL)} much more efficient.

      \item Methods for group generic \code{Math} no longer preserve
      \code{x@diag == "U"} or lose \code{x@Dimnames} when \code{f(0) ==
      0} and \code{f(1) != 1}.  (The former happened for
      \code{triangularMatrix} \code{x} and the latter for
      \code{diagonalMatrix} \code{x}.)

      \item \code{image(Z)} for a completely \dQuote{empty} (all 0)
      \code{sparseMatrix} works again (?!).

      \item \code{x[i, ] <- value} and \code{y[, j] <- value} is now an
      error in more cases for \code{m}-by-0 \code{CsparseMatrix}
      \code{x} and 0-by-\code{n} \code{CsparseMatrix} \code{y}.  In
      these cases, subassignment gave a (formally) invalid result.

      \item \code{chol(<ds[yp]Matrix>)} now calls the underlying C-level
      routine exactly once.  Previously, it was called an extra time in
      order to test for positive definiteness, with the result thrown
      away (!).  Hence these methods should become approximately two
      times faster.

      \item \code{dimnames(chol(x))} is identical to \code{dimnames(x)}
      in all cases, now even when \code{chol(x)} is constructed from a
      cached \code{MatrixFactorization}, for greater consistency with
      \code{base::chol.default()}.

      \item \code{chol(<generalMatrix>)} no longer looks at
      \code{Dimnames} when testing for symmetry.

      \item \code{lu(<dtCMatrix>)} no longer returns an invalid
      \code{sparseLU} object in the lower triangular case.

      \item \code{lu(x)} had sometimes incorrectly cached its return
      value as element \code{"lu"} (rather than \code{"LU"}) of
      \code{x@factors}.  Now it is always \code{"LU"}.

      \item \code{Compare} operators, e.g., \code{a > b}, \code{x !=
      y}, now work correctly in more dense unitriangular and sparse
      0-extent cases.

      \item \code{!<nMatrix>} is now always an \code{nMatrix}, never an
      \code{lMatrix}.

      \item \code{!<ndenseMatrix>} and \code{which(<ndenseMatrix>)} now
      correctly handle \code{NA} as \code{TRUE}.

      \item \code{anyNA(<denseMatrix>)} had incorrectly returned
      \code{anyNA(.@x)} in many cases, giving false positives for some
      \code{.(tr|sy)Matrix} and \code{ndenseMatrix}.  Now methods
      respect the \dQuote{rules} of these classes.

      \item The boolean arithmetic product \code{A \%&\% B} and e.g.,
      \code{crossprod(A, B, boolArith=TRUE)} now should behave as if
      \code{drop0(A)} and \code{drop0(B)} were used, i.e., for formally
      sparse matrices, the boolean product results should be stable with
      respect to non-structural vs structural zeros.

      \item \code{t(<symmetricMatrix>)} now retains the \code{factors}
      slot, avoiding recomputation.

      \item Fixed the (quite \emph{long standing}) \MPR{6777}, reported
      by Manuel Koller: \code{tcrossprod(<matrix>, <[dln]sCMatrix>)} has
      been wrong in some cases.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item \code{qr(<big sparse>)} could segfault due to integer
      overflow inside of \code{cs_multiply}.  Now an error is signaled
      indicating \dQuote{out of memory}.  Reported by Benjamin Tyner
      as \MPR{6610}.

      \item Valgrind warning originating in \code{cholmod_sdmult}
      is squashed.  Reported by David Cortes as \MPR{6726}.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item \code{KhatriRao()} gets new \code{sparseY = TRUE} option and
      also works for more \code{Matrix} classes.

      \item Virtual class \code{packedMatrix} gains methods for
      \code{pack}, \code{unpack}, \code{isSymmetric},
      \code{isTriangular}, and \code{isDiagonal} implemented in C,
      replacing those defined for many subclasses individually.

      \item Virtual class \code{unpackedMatrix} gains methods for
      \code{pack}, \code{unpack}, \code{isSymmetric},
      \code{isTriangular}, \code{isDiagonal}, \code{t}, \code{diag}, and
      \code{diag<-} implemented in C, replacing those defined for many
      subclasses individually.

      \item \code{isTriangular} and \code{isDiagonal} are now
      implemented in \proglang{C} also for \code{[CRT]sparseMatrix} and
      standard \code{matrix}.  \code{isSymmetric} is now implemented in
      \proglang{C} for all \code{denseMatrix} and all
      \code{[CRT]sparseMatrix}, though these \proglang{C} routines are
      currently only called when testing for \emph{exact} symmetry
      (always for \code{[ln]Matrix}, only when \code{tol = 0} for
      \code{dMatrix}).

      \item Methods for \code{isSymmetric} gain an argument
      \code{checkDN = TRUE} indicating whether symmetry of
      \code{Dimnames} should be checked.  For backwards compatibility
      and consistency with \code{isSymmetric.matrix} from \pkg{base},
      the actual condition is \code{checkDN && check.attributes}.

      \item \code{isTriangular(x, upper)} now has a \code{kind}
      attribute \emph{if and only if} \code{x} is triangular and
      \code{upper} is \code{NA}.

      \item \code{diag(<unpackedMatrix>) <- value} now behaves like
      \code{diag(<packedMatrix>) <- value}, supporting coercions
      depending on \code{typeof(value)}, consistent with \code{diag<-}
      from \pkg{base}.

      \item \code{pack} and \code{unpack} are now identity functions for
      \code{packedMatrix} and \code{unpackedMatrix} arguments,
      respectively (previously an error).  \code{pack(<.geMatrix>)}
      (previously an error) now behaves as \code{pack(<matrix>)}, i.e.,
      by checking for symmetry or triangularity before packing.
      \code{unpack(<matrix>)} now works and is equivalent to
      \code{as(<matrix>, "unpackedMatrix")}, with result inheriting from
      \code{.(ge|tr|sy)Matrix}, as appropriate.

      \item Many more validity methods implemented in C, for efficiency,
      including methods for \code{Matrix}, \code{compMatrix},
      \code{diagonalMatrix}, \code{indMatrix}, \code{pMatrix},
      \code{corMatrix}, \code{[liz]Matrix}, and \code{ndenseMatrix}.

      \item \code{band(x, k1, k2)} is optimized further for both dense
      and sparse \code{x}, returning \code{triangularMatrix},
      \code{symmetricMatrix}, and \code{packedMatrix} in more cases.

      \item \code{band()} is now implemented also for
      \code{diagonalMatrix} (only \code{tri[ul]()} worked before).

      \item Coercions \code{.ge<->.g[CRT]}, \code{.t[rp]<->.t[CRT]},
      \code{.s[yp]<->.s[CRT]}, and \code{..[CRT]<->matrix} are now fully
      implemented and optimized, with minimal intermediate allocations.
      These (and others) no longer rely on CHOLMOD, which had handled
      integer types as double and required preprocessing in many cases
      (with \code{diagU2N()}, etc.).

      \item Fixes in group methods (e.g., \code{>}, \code{&}, \code{|}),
      notably for matrices inheriting from class \code{symmetricMatrix},
      \code{triangularMatrix}, \code{lMatrix}, or \code{nMatrix}.

      \item \code{as.vector}, \code{as.numeric}, and \code{as.logical}
      are now implemented for all \code{Matrix}.

      \item Subassignment to \code{indMatrix} is no longer prohibited,
      now going via \code{TsparseMatrix}.

      \item \code{indMatrix} gains methods for \code{isTriangular},
      \code{isDiagonal}, \code{diag}, \code{diag<-}, \code{band},
      \code{tri[ul]}, and \code{forceSymmetric}.  It also gains
      coercions to more virtual classes (notably \code{denseMatrix}) and
      a coercion to \code{pMatrix}.

      \item \code{solve(<ddenseMatrix>, <numLike>)} now works in all
      cases.

      \item \code{determinant(<ds[yp]Matrix>)} is now much faster in the
      positive definite case, no longer going via \code{dgeMatrix}.

      \item \code{diag(<[CRT]sparseMatrix>)} is now done in \proglang{C}
      and is highly optimized in the \code{.[ts][CR]Matrix} case.

      \item \code{symmpart} and \code{skewpart} are now done in
      \proglang{C} for all \code{denseMatrix} and all
      \code{[CRT]sparseMatrix}.  Both now more faithfully preserve the
      \dQuote{storage} of their argument.  (Previously,
      \code{symmpart(<packedMatrix>)} was an \code{unpackedMatrix}, and
      \code{(symm|skew)part(<[RT]sparseMatrix>)} was a
      \code{CsparseMatrix}.)

      \item \code{as(<vector|matrix>,
      "([dln]?dense|[dlnCRT]?sparse)Matrix")} are now fully and more
      consistently implemented.  In the vector case, the result is now
      always a \code{length}-by-1 \code{generalMatrix}.  In the matrix
      case, structure is now always examined, hence the result is a
      \code{symmetricMatrix} or \code{triangularMatrix} in more cases.

      \item \code{Matrix(<classed matrix>)} now works for classes
      other than \code{table}.

      \item \code{lu(<dt[rpCRT]Matrix>)} and \code{lu(<ddiMatrix>)} now
      behave more consistently.  In the diagonal, upper triangular, and
      unit lower triangular cases, the result is obtained
      \dQuote{directly}, i.e., without pivoting.  In the non-unit lower
      triangular case, it is obtained with pivoting.  (Previously,
      pivoting was never done for \code{dtCMatrix} and always done for
      \code{dt[rpRT]Matrix} and \code{ddiMatrix}.)

      \item \code{lu(x)} now caches its return value also for all
      \code{ds.Matrix} \code{x} (by default).

      \item \code{readMM()} now warns if the number of entries found is
      less than number reported in the header.

      \item \code{x[i]} now works for \code{nMatrix} \code{i}, just as
      for \code{lMatrix} \code{i}.  This supports constructions such as
      \code{x[is.na(x)]}, where the logical operation produces an
      \code{nMatrix} because it is never \code{NA}.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item \code{AZERO()} and friends gain an argument specifying a
      zero constant (0 for \code{int} arrays, 0.0 for \code{double}
      arrays).

      \item C-level utilities \code{(R_)?[gs]et_factors()} have been
      renamed \code{(R_)?[gs]et_factor()}, as they only ever get and set
      \emph{one} factor.

      \item The signature of \code{set_factor()} has been changed to
      match other \code{set*()} functions: to \code{(object,name,value)}
      from \code{(object,value,name)}.

      \item For clarity, \code{set_factor()} now returns \code{void} and
      is used like other \code{set*()} functions (i.e., for its side
      effect).  The \R{} interface is unchanged: \code{R_set_factor()}
      continues to return the value being set.

      \item C-level utilities
      \code{make_[di]_matrix_(triangular|symmetric)()},
      \code{packed_to_full_(double|int)()},
      \code{full_to_packed_(double|int)()}, and
      \code{install_diagonal(_int)?()} are replaced by safer, more
      consistently named ones.  Previous versions allowed integer
      overflow.

      \item C-level utilities \code{dup_mMatrix_as_d?geMatrix()} are
      replaced by the more general \code{dense_as_general()}, which
      takes arguments controlling memory allocation and the
      \dQuote{kind} of the \code{.geMatrix} result.

      \item New C-level utility \code{DimNames_is_symmetric()} with \R{}
      interface \code{isSymmetricDN()}, which should be used
      consistently to test for symmetry of \code{[dD]imnames}.  Note
      that these are intended to behave consistently with
      \code{symmetricMatrix_validate()}, by allowing, e.g.,
      \code{list(NULL, nms)}, but not, e.g.,
      \code{list(A = NULL, B = nms)}.

      \item Coercions to \code{triangularMatrix} and
      \code{symmetricMatrix} are now almost all inherited from
      \code{Matrix}, whose methods simply call \code{tri[ul]()} and
      \code{forceSymmetric()} if \code{isTriangular()} and
      \code{isSymmetric()}, respectively, return \code{TRUE}.

      \item Many of the exported \code{.*2*} utilities have been
      redefined as aliases or wrappers of new, more general functions
      (see below).  These not-yet-deprecated functions have been
      centralized in \file{R/denseMatrix.R} and \file{R/sparseMatrix.R}.

      \item New C-level utilities
      \code{R_(dense|sparse)_as_kind()}
      for coercion from one \dQuote{kind} to another;
      \code{R_(dense|sparse)_as_general()}
      for coercion from triangular and symmetric to general;
      \code{R_(dense|sparse)_band()}
      for coercion to triangular (and other banded);
      \code{R_(unpacked*|packed*|sparse)_force_symmetric()}
      for coercion to symmetric;
      \code{R_(dense|sparse)_as_(sparse|dense)()}
      for coercion between dense and sparse of the same \dQuote{kind}
      and \dQuote{structure};
      \code{R_diagonal_as_sparse()}
      for coercion from \code{diagonalMatrix} to any
      \code{[CRT]sparseMatrix};
      \code{R_(dense|sparse|geMatrix)_as_(matrix|vector)()}
      for coercion to base matrix and vector; and
      \code{tCRsparse_as_RCsparse()} for the idioms
      \code{as(t(<[CR]sparseMatrix>), "[RC]sparseMatrix")}.
      These all have not-yet-exported \R{} wrappers.

      \item \code{indTri()} and \code{indDiag()} now in C, with a new
      argument \code{packed} for efficiently indexing
      \code{packedMatrix}.  \code{indDiag()} now behaves sensibly in the
      \code{n = 0} case.

      \item \code{.M.kind()}, \code{.M.shape()}, and (new)
      \code{.M.repr()} are now done in \proglang{C} via
      \code{R_check_class_etc()}, requiring a class definition only in
      \dQuote{rare} cases.
    }
  }
}

\section{Changes in version 1.4-1 (2022-03-21, svn r3446)}{
  \subsection{Installation}{
    \itemize{
      \item Some warnings surfaced by \option{-Wconversion} are
      squashed.
    }
  }
  \subsection{Compatibility}{
    \itemize{
      \item \code{tryInvokeRestart} is defined for \R{} \eqn{<} 4.0.0.
      Thanks to Michael Chirico for the report.
    }
  }
  \subsection{SuiteSparse}{
    \itemize{
      \item The patch for header
      \file{SuiteSparse_config/SuiteSparse_config.h}
      is improved for Windows.
    }
  }
  \subsection{Classes}{
    \itemize{
      \item New virtual class \code{packedMatrix} representing dense
      matrices in packed format.  It extends \code{denseMatrix} and is
      extended by \code{[nld](sp|tp)Matrix}.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item Protection stack imbalances detected by \command{rchk} are
      fixed.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{diag(x)} methods now mostly also keep \code{names}
      from \code{dimnames(x)} by default and obey \code{names=*} more
      generally.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item Methods for subscripting \code{packedMatrix}, including
      \code{diag()}, notably keeping names by default and for \code{t()}
      which are memory efficient, i.e., do not work via unpacking,
      thanks to Mikael Jagan.

      \item New \code{dmperm()} implementing a Dulmage-Mendelsohn
      decomposition, thanks to the persistency of Mauricio Vargas
      (@uc.cl).

      \item Export more low-level conversion utilities: \code{.n2dgT},
      \code{.m2ngCn}, \code{.m2ngTn}.

      \item Provide some matrix multiplication methods for
      \code{RsparseMatrix}.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item Our \proglang{C} sources now use \code{R_Calloc()},
      \code{R_Free()} etc, instead of the shorter versions without
      'R_'. Consequently, we get closer to \code{STRICT_R_HEADERS}.
      Also, include \code{<float.h>} for \code{DBL_EPSILON}.

      \item Modified \code{AZERO()} to work with \code{R_xlen_t} and new
      \code{AZEROs()} for \code{size_t}.
    }
  }
}

\section{Changes in version 1.4-0 (2021-12-08, svn r3419)}{
  \subsection{Compatibility}{
    \itemize{
      \item \file{inst/test-tools-1.R}: \code{Sys.memGB} returns
      \code{NA.value = 2.10201} on Windows, no longer calling
      \code{memory.limit} which is a stub since \R{} version 4.2.0.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item Several low level functions are adjusted to avoid integer
      overflow in \code{i+j*m} or similar.  Reported by Dario Strbenac
      on the R-devel mailing list (\dQuote{dgTMatrix Segmentation
        Fault}, June 10, 2021).

      \item Leak in \code{as(<dtCMatrix>, "denseMatrix")} when the
      argument is unit triangular is fixed.  Thanks to Bill Dunlap for
      the report and patch in \PR{18204}.

      \item Leak in \code{crossprod(<dsCMatrix>)} is fixed.  Thanks to
      Bill Dunlap for the report and patch in \PR{18205}.

      \item Leaks in \code{solve(<dgCMatrix>, <ddenseMatrix>)} and
      \code{lu(<dgCMatrix>)} and when the argument is near-singular (or
      when memory is exhausted) are fixed.  Thanks to Bill Dunlap for
      the report and patch in \PR{18206}.

      \item Leaks in \code{[cr]bind2(x, y)} when both arguments are
      sparse and exactly one is nonzero pattern are fixed.  Thanks to
      Bill Dunlap for the report and patch in \PR{18210}.

      \item \code{solve(<dsCMatrix>, \dots)} restarts after catching
      warnings signaled from \code{dsCMatrix_*_solve} so that memory is
      freed rather than leaked.  Thanks to Bill Dunlap for the report
      and patch in \PR{18214}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{sparse.model.matrix(.., contrasts.arg = <.. ddiMatrix
      ..>)} now works correctly, fixing \MPR{6673} by Davor Josipovic.

      \item \code{sparse.model.matrix(..)} now also works in cases the
      contrast matrix has become a \code{denseMatrix}; e.g., in a case
      using \code{poly(.)} in the formula; now works correctly, fixing
      \MPR{6657} and useful suggestions by Nick Hanewinckel.

      \item Fixed the internal \code{attr.all_Mat()} auxiliary for
      \code{all.equal()}, notably for the case when exactly one of the
      matrices is a base \code{matrix}.

      \item Fixed long-standing bug in the \code{rbind2()} method for
      logical dense matrices, specifically \code{lgeMatrix}, thanks to
      the notice by Aaron Lun.

      \item \code{band(M, k1, k2)} now also works when \code{k1 * k2} is
      larger than 2^31-1, the maximal integer, fixing \MPR{6743} by
      Ariel Paulson.  Further, it works when \code{M} is a sparse
      \code{symmetricMatrix} but the band is not symmetric,
      \code{k1 != -k2}.

      \item \code{sparseVector(i=integer(), length=2^33)} now does
      show/print, after fixing a bug in the \code{head()} method for
      \emph{empty} sparseVectors.  Reported by David Cortes as
      \MPR{6745}.

      \item \code{ss <- <sparseVector>[i]} gave an invalid sparseVector
      \code{ss} as \code{ss@i} was not necessarily sorted; thanks to a
      report by Quran Wu.

      \item \code{as(<dsyMatrix>, "generalMatrix")} and similar,
      sometimes did \emph{not} use (C-level) \code{symmetric_Dimnames()}
      etc; report (to \R{}'s \PR{18250} by Mikael Jagan); fixed all on C
      level.  As a consequence, you will now see \emph{more} preserved
      dimnames after matrix transformations or operations which involved
      symmetric matrices.

      \item \code{as(<ddiMatrix>, "matrix")} no longer loses dimnames,
      thanks to Mikael Jagan's report as \MPR{6751}.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item No longer include \file{Rdefines.h} as it is somewhat
      deprecated.
    }
  }
}

\section{Changes in version 1.3-4 (2021-05-24, svn r3392)}{
  \subsection{Compatibility}{
    \itemize{
      \item Tests are further revised for length mismatch warning in
      \code{matrix(data, nrow, ncol)} under \R{} \eqn{\ge}{>=} 4.2.0.
    }
  }
}

\section{Changes in version 1.3-3 (2021-05-01, svn r3390)}{
  \subsection{Installation}{
    \itemize{
      \item \pkg{Matrix} \eqn{\ge}{>=} 1.3-3 depends on \R{}
      \eqn{\ge}{>=} 3.5, relaxing the dependency on \R{} \eqn{\ge}{>=}
      3.6 introduced in \pkg{Matrix} version 1.3-0.
    }
  }
  \subsection{Compatibility}{
    \itemize{
      \item Tests are revised for length mismatch warning in
      \code{matrix(data, nrow, ncol)} under \R{} \eqn{\ge}{>=} 4.2.0.
    }
  }
  \subsection{C-Level API}{
    \itemize{
      \item \file{inst/include/cholmod.h} and
      \file{inst/include/Matrix_stubs.c} needed adjustment after the
      SparseSuite update in \pkg{Matrix} version 1.3-0.  \MPR{6714}
      reported by Kasper Kristensen, who maintains \CRANpkg{TMB}.
    }
  }
  \subsection{Deprecated and Defunct}{
    \itemize{
      \item \code{cBind()} and \code{rBind()} are now defunct: simply
      use \code{cbind()} and \code{rbind()} instead.
    }
  }
  \subsection{Classes}{
    \itemize{
      \item Class unions \code{Mnumeric} and \code{numericVectors} are
      removed.  These were unexported and unused but nonetheless
      visible to users, appearing as superclasses of many basic classes.
      Notably, a proposed change to the validity method for
      \code{Mnumeric} would have broken class \code{factor}, which
      extended \code{Mnumeric} but would not have been valid under the
      proposal.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Fixed a thinko (in 1.3-2): Now direct coercion from
      \code{ddiMatrix} to \code{dgCMatrix}, and hence, e.g.,
      \code{as(Matrix(1, sparse=TRUE), "dgCMatrix") now works.}

      \item Fixed error message in <dtrMatrix> multiplication.

      \item Fixed long-standing bug in \code{R[,j] <- v} when \code{R}
      is an \code{RsparseMatrix}, \MPR{6709} by David Cortes.

      \item \code{as.matrix()} and \code{as.array()} now work for
      \code{sparseVector} as expected; see \MPR{6708}.

      \item \code{M[,]} (and similar) now work as in base \R{};
      \MPR{6720} by David Cortes.

      \item \code{-S} now works also when \code{S} has no \code{factors}
      slot.  It signalled an error, e.g., for sparse triangular matrices
      \code{S}; \MPR{6656}, reported by Chun Fung (Jackson) Kwok.

      \item \code{M*2} and similar no longer keep cached factorizations
      (in `factors` slot), but drop them via internal new
      \code{.empty.factors()}.  \MPR{6606}, reported by Thomas Lumley.

      \item removed a few duplicated \code{.alias{.}} from
      \file{man/*.Rd}.
    }
  }
  \subsection{Misc}{
    \itemize{
      \item translation updates (of outlines only); finally added
      Italian (by Daniele Medri) to svn; updated French (by Philippe
      Grosjean), forgotten (\R{} part of) Korean.  New Lithuanian
      translations by Gabriele Stupuriene & Rimantas Zakauskas.

      \item In internal \code{diagOdiag()} method, no longer use
      \code{matrix(x, n,n)} when \code{x} is longer than n*n.

      \item Eliminating the need for \file{ftp://*}, add the very small
      \code{jgl009} MatrixMarket example to our \file{external/} files.
    }
  }
}

\section{Changes in version 1.3-2 (2021-01-05, svn r3362)}{
  \subsection{Installation}{
    \itemize{
      \item \code{USE_FC_LEN_T} is defined before \file{Rconfig.h} is
      included.  Under \R{} \eqn{\ge}{>=} 3.6.2, the effect is that
      \code{FC_LEN_T} is defined when \file{R_ext/BLAS.h} is included,
      and the result is that \file{R_ext/BLAS.h} defines \code{FCONE}
      as a nonempty value suitable for passing character lengths from
      \proglang{C} to Fortran.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item \code{matrix_trf} protects two more objects from garbage
      collection, squashing two \command{rchk} warnings.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{rankMatrix()} tweaks for the singular values based
      methods, notably \code{method = "maybeGrad"}.

      \item \code{as(new("dtCMatrix", diag="U"), "matrix")} now works,
      as C-level \code{diagU2N()} now also works for 0-dimensional
      triangular matrices; this also fixes a subsetting
      (\dQuote{indexing}) bug of such 0-dimensional matrices, thanks to
      a report by Aaron Lun.

      \item logical subsetting of 0-dim. (diagonal/triangular) matrices
      fixes.

      \item \code{chol(<diagonal dt[CRT]Matrix>)} now works.
    }
  }
}

\section{Changes in version 1.3-1 (2020-12-23, svn r3352)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{rankMatrix(<dense>, method="qr.R")} no longer assumes
      non-negative diagonal entries of the \eqn{R} matrix.
    }
  }
}

\section{Changes in version 1.3-0 (2020-12-15, svn r3351)}{
  \subsection{Installation}{
    \itemize{
      \item \pkg{Matrix} \eqn{\ge}{>=} 1.3-0 depends on \R{}
      \eqn{\ge}{>=} 3.6.

      \item Macro \code{FCONE} is defined and used to pass character
      lengths from \proglang{C} to Fortran under \R{} \eqn{\ge}{>=}
      3.6.2 (without breaking installation under older \R{}).  Thanks
      to Brian Ripley.
    }
  }
  \subsection{SuiteSparse}{
    \itemize{
      \item The internal SuiteSparse library sources are updated from
      version 4.2.1 to version 5.7.1.  The change is visible in
      \code{.SuiteSparse_version()}.
    }
  }
  \subsection{Significant User-Visible Changes}{
    \itemize{
      \item \code{Matrix(*, doDiag=TRUE)} where \code{doDiag=TRUE} has
      always been the default is now obeyed also in the sparse case, as
      all \code{diagonalMatrix} are also \code{sparseMatrix}.\cr
      \cr
      \code{Matrix(0, 3,3)} returns a \code{ddiMatrix} instead of a
      \code{dsCMatrix} previously.  The latter is still returned from
      \code{Matrix(0, 3,3, doDiag=FALSE)}, and e.g.,
      \code{.symDiagonal(3,pi)}.\cr
      \cr
      Also a triangular matrix, e.g., \code{dtrMatrix} is detected now
      in cases with \code{NA}s.\cr
      \cr
      This is both a bug fix \emph{and} an API change which breaks code
      that assumes \code{Matrix(.)} to return a \code{CsparseMatrix}
      in cases where it now returns a \code{diagonalMatrix} (which
      does extend \code{sparseMatrix}).
    }
  }
  \subsection{New Features}{
    \itemize{
      \item Subassignment to \code{diagonalMatrix} now returns sparse
      \code{triangularMatrix} more often; also (sparse)
      \code{symmetricMatrix}.

      \item \code{nearPD()} gets new option: If \code{base.matrix =
      TRUE}, the resulting \code{mat} component is a \pkg{base}
      \code{matrix}, as often used desired when \code{nearPD()} is used
      outside the \pkg{Matrix} package context.

      \item Factored out new \code{qr2rankMatrix()} utility from
      \code{rankMatrix()}.

      \item New \code{BunchKaufman(<matrix>)} method.

      \item Added \code{wrld_1deg} sparse matrix example to
      \emph{distributed} version of \pkg{Matrix} (no longer excluding it
      via \file{.Rbuildignore}).

      \item New (simple) \code{mat2triplet()} function to be used
      instead of \code{summary(<sparseMatrix>)} in code.

      \item Internal \code{.diag2tT()} gains new option \code{drop0 =
      TRUE} and hence now by default drops zero diagonal entries.
      Consequently, e.g., \code{as(<diagonalMatrix>, "CsparseMatrix")}
      now drops such zeros, too.

      \item \code{sparseMatrix()} gets new argument \code{repr = "C"},
      superseding the (now deprecated) \code{giveCsparse = TRUE}.
      Allows to return \code{RsparseMatrix}.

      Similarly, \code{rsparsematrix()}, \code{fac2sparse()} and
      \code{fac2Sparse()} get the new \code{repr} argument and their
      \code{giveCsparse} is deprecated, sometimes only informally for
      now.% no deprecation warning yet

      \item \code{sparse.model.matrix()} gets option \code{sep = ""},
      with, e.g., \code{sep = ":"} allowing to get easier column names;
      from \MPR{6581}, by Vitalie Spinu.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item The second argument in calls to \code{cholmod_factorize_p}
      from \code{internal_chm_factor} was a pointer to 1 \code{double}
      instead of a \code{double} array of length 2, resulting in buffer
      overflow there.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{rankMatrix(<sparse>, method="qr")} now returns
      \code{NA} (or \code{NaN}) instead of signalling an error in the
      case the sparse \eqn{Q R} decomposition gave \code{NA}s in
      \code{diag(R)}.

      \item Coercion (\code{as(., .)}) from e.g., \code{lsyMatrix} to
      \code{CsparseMatrix} silently made asymmetric dimnames
      symmetric, as did the \emph{internal} \code{forceCspSymmetric(*,
      dimNames)} which may be called from \code{forceSymmetric()}.

      \item \MPR{6659}, reported by Georg Kindermann:
      \code{<sparseVector>[i] <- val} bug is fixed.

      \item \MPR{6666}, reported by Ezra Tucker:
      \code{which(<ldiMatrix>, array.ind=TRUE)} thinko is fixed.

      \item For R-devel Dec 4, 2020: adapt all.equal() check of sparse
      matrix images (which contain panel functions with environments).
    }
  }
}

\section{Changes in version 1.2-18 (2019-11-26, svn r3300)}{
  \subsection{Compatibility}{
    \itemize{
      \item \file{inst/test-tools-1.R}: a bug-fixed \code{canCoerce}
      is used under \R{} \eqn{<} 3.6.2.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item \code{ddense_skewpart} protects another object from garbage
      collection, squashing a remaining \command{rchk} warning.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{as(m, "dgTMatrix")} does not lose \code{dimnames}
      anymore when \code{m} is a (traditional) \code{matrix}.

      \item \code{M[logical(0), ]} now has dimension \eqn{0 x k} for
      sparse \code{M} as for base matrices.

      \item \code{log(M, base)} (the 2-argument version of \code{log()})
      wrongly gave the result for \code{base = exp(1)}, i.e., the
      1-argument default.

      \item \file{test-tools-Matrix.R}: \code{Qidentical()} no longer
      assumes \code{class(<matrix>)} to be of length 1.
    }
  }
}

\section{Changes in version 1.2-17 (2019-03-20, svn r3294)}{
  \subsection{Compatibility}{
    \itemize{
      \item \code{isFALSE} is defined for \R{} \eqn{<} 3.5.0.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item \proglang{C} functions protect more objects from garbage
      collection, squashing several \command{rchk} warnings.
    }
  }
}

\section{Changes in version 1.2-16 (2019-03-04, svn r3291)}{
  \subsection{New Features}{
    \itemize{
      \item regression tests depending on \code{sample()} now are future
      proof reproducible, via \code{RNGversion(.)}.

      \item give information about #\{rows\} and #\{columns\} that are
      suppressed in print()ing if the matrix is larger than
      \code{max.print}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{data(<Matrix-data>)} no longer attaches \pkg{Matrix}
      to the search path.

      \item \code{Ops} group methods, i.e., \code{Arith},
      \code{Compare}, \code{Logic}, now should all work with 0-extent
      matrices as well, thanks to bug reports by Aaron Lun, University
      of Cambridge.

      \item when printing and formatting sparse matrices, see
      \code{formatSpMatrix()}, the \code{maxp} option, e.g., from
      \code{getOption("max.print")}, is \dQuote{rounded up} to 100, as
      very small values are very rarely appropriate.
    }
  }
}

\section{Changes in version 1.2-15 (2018-08-20, svn r3283)}{
  \subsection{New Features}{
    \itemize{
      \item \code{image()} gets new optional argument
      \code{border.color}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{image(Matrix(0, n,m))} now works.
    }
  }
}


\section{Changes in version 1.2-14 (2018-04-08, svn r3278)}{
  \subsection{New Features}{
    \itemize{
      \item German translation updates.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item \code{dgCMatrix_cholsol} protects one more object from
      garbage collection, squashing an \command{rchk} warning.
    }
  }
}

\section{Changes in version 1.2-13 (2018-03-25, svn r3275)}{
  \subsection{New Features}{
    \itemize{
      \item Faster \code{as(<matrix>, "sparseMatrix")} and coercion to
      \code{dgCMatrix}, \code{ngCMatrix}, etc, via new direct
      \proglang{C} \code{matrix_to_Csparse()} which does \emph{not} go
      via \code{dgeMatrix}.  This also works for large matrices
      \code{m}, i.e., when \code{length(m) >= .Machine$integer.max}.

      Also provide low-level \R{} functions \code{.m2dgC()},
      \code{.m2lgC()}, and \code{.m2ngC()} for these.
    }
  }
  \subsection{Memory}{
    \itemize{
      \item \proglang{C} functions protect more objects from garbage
      collection, to be \dQuote{rather safe than sorry}.  Thanks to
      Tomas Kalibera's \command{rchk} tools.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{cbind(NULL,<Matrix>)} no longer return \code{NULL};
      analogously for \code{rbind()}, \code{rbind2()}, \code{cbind2()},
      fixing very long standing typo in the corresponsing
      \code{cbind2()} and \code{rbind2()} methods.

      \item The deprecation warning (once per session) for
      \code{cBind()} and \code{rBind()} finally works (fixing a simple
      thinko).

      \item \code{cbind()} and \code{rbind()} for largish sparse
      matrices no longer gives an error because of integer overflow (in
      the default case where \code{sparse} is not been specified hence
      is chosen by a \code{nnzero()} based heuristic).

      \item \code{.symDiagonal(5, 5:1)} and \code{.trDiagonal(x = 4:1)}
      now work as expected.

      \item \code{Sp[i]} now is much more efficient for large sparse
      matrices \code{Sp}, notably when the result is short.

      \item \code{<sparseVector>[ <negative integer> ]} now also gives
      the correct answer when the result is \dQuote{empty}, i.e., all
      zero or false.

      \item large \code{dspMatrix} and \code{dtpMatrix} objects can
      now be constructed via \code{new(*, Dim = *, x = *)} also when
      \code{length(x)} is larger than 2^31 (as the \proglang{C} internal
      validation method no longer suffers from integer overflow).
    }
  }
}

\section{Changes in version 1.2-12 (2017-11-10, svn r3239)}{
  \subsection{New Features}{
    \itemize{
      \item \code{crossprod(x,y)} and \code{kronecker(x,y)} have become
      considerably more efficient for large \code{indMatrix} objects
      \code{x, y}, thanks to private nudging by Boris Vaillant.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \MPR{6185}: \code{c < 0} now also works for derived sparse
      Matrices (which only \emph{contain} Matrix classes); via improving
      hidden \code{MatrixClass()}.  Part of such derived matrices only
      work in \R{} \eqn{\ge}{>=} 3.5.0.

      \item using \code{Authors@R} in \file{../DESCRIPTION} to list all
      contributors.

      \item \code{solve(-m)} no longer should use a cached Cholesky
      factorization (of \code{m}).
    }
  }
}

\section{Changes in version 1.2-11 (2017-08-10, svn r3225)}{
  \subsection{Compatibility}{
    \itemize{
      \item \code{length(<NULL>) <- value} is avoided as it is
      deprecated in \R{} \eqn{\ge}{>=} 3.5.0.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item S4 method dispatch no longer emits ambiguity notes (by
      default) for everybody, apart from the package maintainer.  You
      can reactivate them by \code{options(Matrix.ambiguityNotes =
      TRUE)}
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{rankMatrix(<matrix of all 0>)} now gives zero for all
      methods, as it should be.

      \item \code{qr.coef(<sparseQR>, y)} now finally has correct (row)
      names (from pivot back permutation).

      \item \code{.trDiagonal()} utility is now exported.
    }
  }
}

\section{Changes in version 1.2-10 (2017-04-19, svn r3216)}{
  \subsection{Memory}{
    \itemize{
      \item \proglang{C} functions protect more objects from garbage
      collection.  Thanks to Tomas Kalibera's \command{rchk} tools.
    }
  }
}

\section{Changes in version 1.2-9 (2017-03-08, svn r3211)}{
  \subsection{New Features}{
    \itemize{
      \item \code{Ops} between \code{table}, \code{xtabs}, and our
      matrices now work.

      \item \code{as(matrix(diag(3), 3, dimnames=rep(list(c("A","b","c")),2)), "diagonalMatrix")@x}
      is no longer named.

      \item \code{norm(x, "2")} now works as well (and equivalently to
      \code{base::norm}).

      \item \code{sparseVector()} now also works without \code{x}
      argument.

      \item \code{c.sparseVector()} method for \code{c()} of
      sparseVectors (and available as regular function on purpose).
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{as(Diagonal(3), "denseMatrix")} no longer returns a
      non-dense \code{ddiMatrix}.

      \item \code{S[sel,] <- value} and similar no longer segfault, but
      give a \code{"not (yet?) supported"} error for sparse matrices
      \code{S} and logical \code{sel} when \code{sel} contains
      \code{NA}s.

      The same error (instead of a low-level one) is signalled for
      \emph{indexing} (with NA-containing logical \code{sel}), i.e.,
      \code{S[sel,]}.
      %% from in ../TODO : \item \code{S[sel,]}, \code{S[,sel] <- value}
      %% and similar now also work for sparse matrices \code{S} and
      %% logical \code{sel} when \code{sel} contains \code{NA}s.

      \item \code{which(x, arr.ind=TRUE, *)} (when \code{x} is a
      \code{lMatrix} or \code{nMatrix}) now works the same as
      \code{base::which}, obeying an optional \code{useNames} argument
      which defaults to \code{TRUE}.  Previously, the resulting
      two-column matrix typically had empty \code{dimnames}.
    }
  }
}

\section{Changes in version 1.2-8 (2017-01-16, svn r3201)}{
  \subsection{Compatibility}{
    \itemize{
      \item Methods for \code{Ops} handle 0-length operands more
      consistently, matching changes planned for \R{} version 3.4.0.
    }
  }
  \subsection{SuiteSparse}{
    \itemize{
      \item \code{SuiteSparse_long} is defined as \code{int64_t} on all
      platforms.  Hence we now include C99 header \file{inttypes.h}.

      \item The internal CSparse library sources are patched to avoid
      buffer overflow in \code{cs_usolve} and \code{cs_utsolve} when
      \code{U} is singular.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{x[.] <- value} now also works for
      \code{sparseVector}, both as \code{x} and as \code{value}.
      \item \code{x[FALSE] <- value} now also works for
      \code{sparseVector}.

      \item \code{rep(x, *)} now works for \code{sparseVector} and
      sparse and dense \code{Matrix}-classed matrices \code{x}.
    }
  }
}

\section{Changes in version 1.2-7.1 (2016-08-29, svn r3187)}{
  \subsection{Installation}{
    \itemize{
      \item \code{_POSIX_C_SOURCE} is defined \emph{conditionally} with
      \code{#ifdef __GLIBC__}.
    }
  }
}

\section{Changes in version 1.2-7 (2016-08-27, svn r3185)}{
  \subsection{New Features}{
    \itemize{
      \item \code{cBind()} and \code{rBind()} have been almost silently
      deprecated in \R{} \eqn{\ge}{>=} 3.2.0 and now give a warning,
      \dQuote{once per session} only.

      \item \code{bandSparse(*, k=k, *)} now returns matrices inheriting
      from \code{triangularMatrix} when obvious from the diagonal
      indices \code{k}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{KhatriRao(X,Y)} now also works when \code{X} or
      \code{Y} is completely zero.
    }
  }
}

\section{Changes in version 1.2-6 (2016-04-27, svn r3175)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item The 0-dim. Matrix multiplication fix in 1.2-5 did trigger
      wrong warnings in other diagonal matrix multiplications.
    }
  }
}

\section{Changes in version 1.2-5 (2016-04-14, svn r3170)}{
  \subsection{New Features}{
    \itemize{
      \item \code{isSymmetric(m)} now also works for \code{indMatrix}
      \code{m}.

      \item \code{isSymmetric(m)} is faster for large dense asymmetric
      matrices.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Matrix multiplications (\code{A \%*\% B}) now work correctly
      when one of the matrices is diagonal and the other has a zero
      dimension.
    }
  }
}

\section{Changes in version 1.2-4 (2016-02-29, svn r3162)}{
  \subsection{New Features}{
    \itemize{
      \item \code{sparseMatrix()} gets new argument \code{triangular}
      and a smarter default for \code{dims} when \code{symmetric} or
      \code{triangular} is true.

      \item \code{as(<sparse>, "denseMatrix")} now works in more cases
      when \code{prod(dim(.))} is larger than \eqn{2^{31} - 1}.  Hence,
      e.g., \code{!S} now works for much larger sparse matrices
      \code{S}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item creating very large dense matrices, e.g., by
      \code{as(<sparseM.>, "matrix")} would segfault (in case it could
      allocate enough storage).
    }
  }
}

\section{Changes in version 1.2-3 (2015-11-19, svn r3155)}{
  \subsection{C-Level API}{
    \itemize{
      \item \file{inst/include/Matrix.h} tries harder to define
      \samp{alloca} correctly for compilers that do not define
      \code{__GNUC__}.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item \code{MatrixClass()} is exported now.

      \item More exports of semi-internal functions (for speed, named
      \code{.<foo>}, i.e., inofficial API), such as
      \code{.solve.dgC.lu()}.

      \item more Korean translations
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item extended \code{n?CMatrix} classes (e.g., from
      \code{setClass(., contains="ngCMatrix")}) now can be coerced via
      \code{as(.)} to \code{d.CMatrix}.

      \item The printing of largish sparse matrices is improved, notably
      in the case where columns are suppressed, via new
      \code{fitWidth = TRUE} option in \code{printSpMatrix2()}.
      %%% FIXME __ EXAMPLES __

      \item \code{cbind2()} and \code{rbind2()} no longer fail to
      determine \code{sparse} when it is unspecified and hence
      \code{NA}, fixing \MPR{6259}.
    }
  }
}

\section{Changes in version 1.2-2 (2015-07-03, svn r3131)}{
  \subsection{Dependencies}{
    \itemize{
      \item Objects are more systematically imported from \dQuote{base}
      packages like \pkg{stats}.  It is no longer assumed that those
      packages are attached.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Our \code{colSums(x)}, \code{rowMeans(y)}, \dots, methods
      now \dQuote{keep names}, i.e., if the result is a numeric vector,
      and the matrix \code{x} has column or row names, these become the
      \code{names(.)} of the result, fixing \MPR{6018}.
    }
  }
}

\section{Changes in version 1.2-1 (2015-05-30, svn r3127)}{
  \subsection{New Features}{
    \itemize{
      \item \code{Matrix} now has an \code{initialization()} method
      coercing 0-length dimnames components to \code{NULL} and other
      non-\code{NULL} dimnames to \code{character}.  Before, e.g.,
      numeric dimnames components partially worked, even though it has
      always been documented that non-\code{NULL} dimnames should be
      \code{character}.

      \item \code{as.vector(<sparseVector>)} etc, now work, too.

      \item \code{lu(<sparseMatrix>)} now keeps \code{dimnames}.

      \item better \file{NEWS.Rd} (which pleases Kurt and
      \command{tidy};-)
    }
  }
  \subsection{Memory}{
    \itemize{
      \item Using \code{alloca} to perform large allocations could
      overflow the stack, leading in some cases to a segfault.  Now
      \code{alloca} is used only for small allocations.  Thanks to a
      report on the R-help mailing list (\dQuote{does segfault mean
        (always) a bug?}, May 5, 2015).
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{S[] <- T} and \code{S[] <- spV} now work (in more
      cases) for sparse matrices S, T and sparseVector \code{spV}.

      \item Optional arguments in \code{image()}, e.g.,
      \code{main=<..>)} now also work for \code{lgCMatrix},
      \code{nMatrix} etc; thanks to a 4.5 years old report by Mstislav
      Elagin.

      \item \code{dimnames(A) <- val} now resets the \code{factors} slot
      to empty, as the factorizations now keep dimnames more often.

      \item \code{crossprod(<matrix>, Diagonal(<n>))} works again (and
      these are tested more systematically).

      \item Matrix products (\code{\%*\%}, \code{crossprod}, and
      \code{tcrossprod}) for \code{dtrMatrix} are correct in all
      cases, including keeping dimnames.

      \item \code{Matrix(d)} (and other coercions to \code{Matrix})
      now correctly keeps \code{dimnames} also when \code{d} is a
      traditional \emph{diagonal} matrix.
    }
  }
}

\section{Changes in version 1.2-0 (2015-04-03, svn r3096)}{
  \subsection{Generic Functions}{
    \itemize{
      \item New generic function \code{\%&\%} for boolean matrix
      multiplication: that is, matrix multiplication using boolean
      arithmetic.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item New argument \code{boolArith = NA} in \code{crossprod()} and
      \code{tcrossprod()}.  \code{boolArith = TRUE} now forces boolean
      arithmetic, where \code{boolArith = FALSE} forces numeric one.
      Several of these products are more efficient thanks to new C
      functionality based on our new \code{chm_transpose_dense()}, and
      others based on \code{geMatrix_crossprod},
      \code{geMatrix_matrix_mm}, etc.

      \item Most dense matrix products, also for non-\code{dgeMatrix},
      including \code{l..Matrix} and \code{n..Matrix} ones are now
      directly handled by new \code{.Call()}s.

      \item \code{dMatrix} (numeric) and \code{lMatrix} (logical)
      matrices can now be coerced to \code{nMatrix} (non-zero pattern
      or \dQuote{boolean}) even when they contain \code{NA}s, which then
      become \code{TRUE}s.

      \item More thorough checking of \code{cbind2()} and
      \code{rbind2()} methods, notably as they are called from
      \code{cbind()} and \code{rbind()} from \R{} \eqn{\ge}{>=} 3.2.0.

      \code{rbind2(<dense>, <dense>)} is faster, being based on new C
      code.

      \item symmetric Matrices (i.e., inheriting from
      \code{symmetricMatrix}) are allowed to have \code{dimnames} of
      the form \code{list(NULL, <names>)} \emph{and} now print correctly
      and get correctly coerced to general matrices.

      \item \code{indMatrix} object (\dQuote{index matrices}) no longer
      need to be \dQuote{skinny}.

      \item \code{rsparseMatrix()} now accepts \code{rand.x = NULL} and
      then creates a random \emph{patter\bold{n}} matrix
      (\code{nsparseMatrix}).

      \item \code{anyDuplicatedT()} and \code{uniqTsparse()} low level
      utilities are exported now.

      \item Partial Korean translations of messages.
    }
  }
  \subsection{Deprecated and Defunct}{
    \itemize{
      \item For \R{} \eqn{\ge}{>=} 3.2.0, \code{cBind()} and
      \code{rBind()} are deprecated, as they are no longer needed since
      \code{cbind()} and \code{rbind()} do work automatically.
    }
  }

  \subsection{Bug Fixes}{
    \itemize{
      \item Fix some \code{rbind2()} methods.

      \item \code{t()} now transposes the dimnames even for symmetric
      matrices.

      \item \code{diag(M) <- val} did not always recycle \code{val} to
      full length, e.g., when \code{M} was a \code{dtrMatrix}.

      \item \code{crossprod(<indMatrix>)} was wrong in cases where the
      matrix had all-zero columns.

      \item Matrix products (\code{\%*\%}, \code{crossprod}, and
      \code{tcrossprod}) with one sparse and one dense argument now
      return \emph{numeric} (a \code{dMatrix}) when they should, i.e.,
      unless the new setting \code{boolArith = TRUE} is applied.
    }
  }
}

\section{Changes in version 1.1-5 (2015-01-18, svn r3037)}{
  \subsection{Compatibility}{
    \itemize{
      \item Methods for matrix multiplication (\code{\%*\%},
      \code{crossprod}, \code{tcrossprod}) are revised to match the
      behaviour of \R{} \eqn{\ge}{>=} 3.2.0, which better tolerates
      matrix-vector products.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item More use of \code{anyNA()} (for speedup).

      \item \code{isTriangular()} gets new optional argument
      \code{upper  = NA}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{crossprod()} and \code{tcrossprod()} fixes for several
      <diagonal> o <sparse> combinations.

      \item \code{rowMeans(<dgeMatrix>, na.rm=TRUE)} was wrong
      sometimes.

      \item fix and speedup of coercions (\code{as(., .)}) from and to
      symmetric or triangular matrices.

      \item \code{invPerm()} coercion to integer

      \item \code{dimnames( solve(.,.) )} fix [r3036]

      \item \code{tril()} and \code{triu()} now return correct
      \code{uplo}.

      \item \code{names(dimnames(.))} now preserved, e.g. in
      \code{symmpart()} or subsetting (\code{A[i,j]}).
    }
  }
}

\section{Changes in version 1.1-4 (2014-06-14, svn r2994)}{
  \subsection{New Features}{
    \itemize{
      \item new \code{rsparsematrix()} for random sparse Matrices.

      \item improved warnings, notably for unused arguments previously
      swallowed into \code{...}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{crossprod(<vec>, <dsyMatrix>)} fixed.

      \item \code{crossprod()} and \code{kronecker()} fixes for some
      <indMatrix> cases.
    }
  }
}

\section{Changes in version 1.1-3 (2014-03-30, svn r2982)}{
  \subsection{New Features}{
    \itemize{
      \item \code{\%*\%} and \code{crossprod()} now also work with
      \code{sparseVector}s.

      \item speedup of \code{crossprod(v, <sparseM>)}, thanks to nudge
      by Niels Richard Hansen.

      \item new help page for all such matrix products
      (\file{../man/matrix-products.Rd}).
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{image()} now gets correct \code{ylim} again.

      \item More consistent matrix products.
    }
  }
}

\section{Changes in version 1.1-2-2 (2014-03-04, svn r2966)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item correct adaption to \R{} 3.1.0

      \item using \code{tolerance} (and not \sQuote{tol}) in
      \code{all.equal()}
    }
  }
}

\section{Changes in version 1.1-2 (2014-01-28, svn r2962)}{
  \subsection{New Features}{
    \itemize{
      \item export fast power-user coercion utilities \code{.dsy2mat()},
      \code{.dxC2mat()}, \code{.T2Cmat()}, \code{..2dge()}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item matrix products now (mostly) work with \code{sparseVector}s;
      and correctly in some more cases.
    }
  }
}

\section{Changes in version 1.1-1.1 (2013-12-30, svn r2957)}{
  \subsection{Installation}{
    \itemize{
      \item \pkg{Matrix} \eqn{\ge}{>=} 1.1-1.1 depends on \R{}
      \eqn{\ge}{>=} 2.15.2 to ease checking.
    }
  }
  \subsection{Compatibility}{
    \itemize{
      \item \file{inst/test-tools-1.R}: \code{assertCondition} is
      defined for \R{} \eqn{<} 3.0.2 and used by \code{assertWarning}
      there.
    }
  }
}

\section{Changes in version 1.1-1 (2013-12-28, svn r2933)}{
  \subsection{New Features}{
    \itemize{
      \item \code{image(.., xlim, ylim)}: nicer defaults for the axis
      limits, and \code{ylim} is sorted decreasingly; not strictly
      back-compatible but should never harm.
      %% ../R/dgTMatrix.R

      \item \code{rankMatrix(*, method="qr")} now using \code{tol}

      \item \code{T2graph()} and \code{graph2T()} export old
      functionality explicitly.  Tweaks in conversions between
      \code{graph} and \code{sparseMatrix} objects.  Notably,
      \code{as(<graph>, <Matrix>)} now more often returns a (0/1
      pattern) n..Matrix.

      \item \code{sparseMatrix()}: new \code{use.last.ij} argument.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{KhatriRao()}: fix rownames (X <-> Y)

      \item \code{qr.coef()}, \code{qr.fitted}, and \code{qr.resid} now
      also work with \emph{sparse} RHS \code{y}.

      \item sparse matrix \dQuote{sub assignments}, e.g.,
      \code{M[ii] <- v}, speedup and fixes.

      \item bug fixes also in \code{M[negative indices] <- value} and
      \code{<sparseMatrix>[cbind(i,j)]}.
    }
  }
}

\section{Changes in version 1.1-0 (2013-10-21, svn r2930)}{
  \subsection{Dependencies}{
    \itemize{
      \item \pkg{methods}, \pkg{stats}, \pkg{utils}, and \pkg{lattice}
      are moved from \code{Depends} to \code{Imports}.
    }
  }
  \subsection{SuiteSparse}{
    \itemize{
      \item The internal SuiteSparse library sources are updated to the
      latest version.  Use new function \code{.SuiteSparse_version} to
      get the version in use.
    }
  }
  \subsection{C-Level API}{
    \itemize{
      \item \file{inst/include/cholmod.h} is updated to reflect changes
      in SuiteSparse.  Notably, there were changes in the layout of the
      various \code{cholmod_*_struct}.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item \code{fac2sparse} and \code{fac2Sparse} now exported, with a
      new \code{giveCsparse} option.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item fixed long lasting undetected \code{solve(<dsCMatrix>, *)}
      bug.

      \item Our \code{all.equal()} methods no longer sometimes return
      \code{c("TRUE", "....difference..")}.

      \item \code{rankMatrix(<matrix>)}: fix the internal \code{x.dense}
      definition.
    }
  }
}

\section{Changes in version 1.0-14 (2013-09-12, svn r2907)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item Revert some wrong changes to \code{solve(<sparse>, *)} from
      1.0-13 (\dQuote{stop gap fix} for \R{} 3.0.2).
    }
  }
}

\section{Changes in version 1.0-13 (2013-09-10, svn r2904)}{
  \subsection{Classes}{
    \itemize{
      \item New nonvirtual class \code{indMatrix} representing row index
      matrices, i.e., matrices whose rows are standard unit vectors.  It
      extends \code{sparseMatrix} and is extended by \code{pMatrix}, the
      class of permutation matrices.
    }
  }
  \subsection{Generic Functions}{
    \itemize{
      \item New generic functions \code{isTriangular} and
      \code{isDiagonal} for testing if the argument is (upper or lower)
      triangular or diagonal.  These were defined previously but never
      exported or documented.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item Many methods for \code{pMatrix} are generalized to support
      \code{indMatrix}.  All (initial) functionality was contributed by
      Fabian Scheibl, Univ.\sspace{} Munich.

      \item New (efficient) \code{KhatriRao()} function by Michael
      Cysouw

      \item \code{rankMatrix(M, method="qr")} no longer needs
      \code{sval} which makes it considerably more useful for large
      sparse \code{M}.

      \item Start providing \code{anyNA} methods for \R{} \eqn{\ge}{>=}
      3.1.0.

      \item \code{solve(<sparse> a, <sparse> b)}: if \code{a} is
      symmetric, now compute \emph{sparse} result.

      \item \code{nearPD()} gets new option \code{conv.norm.type = "I"}.

      \item \code{determinant(<dpoMatrix>)} now uses \code{chol()}, and
      hence also an existing (\sQuote{cached}) Cholesky factor.

      \item 3 new \code{C -> R} utilities (including hidden \R{}
      function \code{.set.factors()} for caching also from \R{}, not
      just in C).
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{M[] <- v} for unitriangular \code{M} now correct.

      \item \code{lu(.)} no longer sometimes returns unsorted columns.
    }
  }
}

%% TODO: fill in from here <<<<<<<<<<<<<<<<<<<
%% ----  using ../ChangeLog and notably my ../svn-log-from.all

\section{Changes in version 1.0-12 (2013-03-26, svn r2872)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}


\section{Changes in version 1.0-11 (2013-02-02)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{as(<csr>, "dgCMatrix")} (from package
      \CRANpkg{SparseM}) now works again.

      \item .
    }
  }
}

\section{Changes in version 1.0-10 (2012-10-22)}{
  \subsection{New Features}{
    \itemize{
      \item \code{.sparseDiagonal()}: new \code{unitri} argument, and
      more flexibility;

      \item new \code{solve(<dsCMatrix>, <missing>)} via efficient C
      code.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 1.0-9 (2012-09-05)}{
  \subsection{New Features}{
    \itemize{
      \item new \code{sparseVector()} constructor function.

      \item \code{is.finite()} \code{is.infinite()} now work for our
      matrices and \code{sparseVector} objects.

      \item \code{diag(.) <- V} now preserves symmetricity,
      triangularity and even uni-triangularity sometimes.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Quite a few fixes for \code{Ops} (arithmetic, logic, etc)
      group methods.

      \item Ditto for \code{diagonalMatrix} methods.
    }
  }
}

\section{Changes in version 1.0-6 (2012-03-16)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 1.0-5 (2012-03-15)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 1.0-4 (2012-02-21)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 1.0-3 (2012-01-13)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 1.0-2 (2011-11-19)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 1.0-1 (2011-10-18)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 1.0-0 (2011-10-04)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 0.9996875-3 (2011-08-13)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 0.9996875-2 (2011-08-09)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 0.9996875-1 (2011-08-08)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }

  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 0.999375-50 (2011-04-08)}{
  \subsection{New Features}{
    \itemize{
      \item .
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

%% ---------------- Start of DB+MM history -----------------------------

\section{Changes in version 0.95-1 (2005-02-18, svn r561)}{
  \subsection{Authorship}{
    \itemize{
      \item During Douglas Bates' sabbatical in Zurich, Martin Maechler
      becomes co-author of \pkg{Matrix}.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item Beginning of class reorganization with a more systematic
      naming scheme.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item More (correct) coercions \code{as(<from>, <to>)}.
    }
  }
}

\section{Changes in version 0.9-1 (2005-01-24, svn r451)}{
  \subsection{New Features}{
    \itemize{
      \item lme4 / lmer specific \R{} code moved out to \CRANpkg{lme4}
      package.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item .
    }
  }
}

\section{Changes in version 0.8-2 (2004-04-05, svn r51)}{
  \subsection{Description}{
    \itemize{
      \item \pkg{Matrix} version 0.8-2 is a full refactor.  Classes,
      generic functions, and methods are newly implemented in S4.
      S3 machinery is removed.  The remaining items in this section
      describe the state of things in version 0.8-2 rather than changes
      since version 0.3-26.

      \item \pkg{Matrix} \eqn{\ge}{>=} 0.8-2 depends on \R{}
      \eqn{\ge}{>=} 1.9.0.

      \item \code{Depends: methods} is added to \file{DESCRIPTION}.

      \item Douglas Bates becomes the sole author of \pkg{Matrix}.

      \item The package is retitled \dQuote{Classes and Methods for
        Numerical Linear Algebra using LAPACK, LDL, TAUCS, METIS, and
        UMFPACK}.

      \item The package sources are now maintained in a Subversion
      repository.
    }
  }
}

%% ---------------- Start of S4 history --------------------------------

\section{Changes in version 0.3-26 (2003-11-03)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item The default expressions of formal arguments \code{transpose}
      and \code{left} of generic function \code{facmul} are changed from
      \code{F} and \code{T} to \code{FALSE} and \code{TRUE}, as only the
      latter are reserved words.
    }
  }
}

\section{Changes in version 0.3-25 (2003-10-30)}{
  \subsection{Deprecated and Defunct}{
    \itemize{
      \item S3 generic function \code{determinant} is removed as it was
      ported to \R{} \eqn{\ge}{>=} 1.8.0.
    }
  }
  \subsection{Significant User-Visible Changes}{
    \itemize{
      \item A namespace for \pkg{Matrix} is defined using directives in
      \file{NAMESPACE}.

      \item S3 generic functions \code{eigen}, \code{expand},
      \code{facmul}, \code{lu}, \code{norm}, \code{rcond}, \code{schur},
      and \code{unpack} are exported.

      \item S3 methods are registered and not exported, hence they
      continue to be available but only through calls to exported S3
      generic functions.

      \item Functions \code{Matrix}, \code{SVD}, \code{as.Matrix},
      \code{diagDet}, and \code{hilbert} are exported.

      \item Functions \code{Matrix.class}, \code{*.test}, and
      \code{is.*} are exported but intended only for internal use.

      \item Functions \code{asObject} and \code{prependClass} are not
      exported.

      \item Load hook \code{.First.lib} is removed and replaced by a
      \code{useDynLib} directive in \file{NAMESPACE}.
    }
  }
}

\section{Changes in version 0.3-24 (2003-04-20)}{
  \subsection{Significant User-Visible Changes}{
    \itemize{
      \item S3 generic function \code{det} is renamed
      \code{determinant}.
    }
  }
  \subsection{Methods}{
    \itemize{
      \item \code{determinant.Matrix} (formerly \code{det.Matrix})
      computes the \eqn{LU} factorization of its argument instead of the
      \eqn{QR} factorization.
    }
  }
}

\section{Changes in version 0.3-23 (2003-03-30)}{
  \subsection{Description}{
    \itemize{
      \item \pkg{Matrix} \eqn{\ge}{>=} 0.3-23 depends on \R{}
      \eqn{\ge}{>=} 1.7.0.
    }
  }
  \subsection{Installation}{
    \itemize{
      \item \file{configure}, \file{configure.in}, \file{configure.win},
      \file{cleanup}, \file{src/Makevars.in}, and
      \file{src/Makevars.win} are removed and replaced by a simple
      \file{src/Makevars} arranging for \pkg{Matrix} to use \R{}'s
      \code{LAPACK_LIBS} and \code{BLAS_LIBS}.  The simplification is
      made possible by \R{} version 1.7-0, which is configured by
      default to build, link against, and install a shared LAPACK.
    }
  }
}

\section{Changes in version 0.3-22 (2003-02-03)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item Empty directory \file{data} is removed.
    }
  }
}

\section{Changes in version 0.3-21 (2002-10-25)}{
  \subsection{Description}{
    \itemize{
      \item The package is retitled \dQuote{Classes and Methods for
        Numerical Linear Algebra using LAPACK}.
    }
  }
  \subsection{Installation}{
    \itemize{
      \item \file{configure.win} and \file{src/Makevars.win} are added
      to support installation under Windows, thanks to Brian Ripley.

      \item More \code{#undef} in the \proglang{C++} sources to support
      installation under Windows, thanks to Brian Ripley.
    }
  }
}

\section{Changes in version 0.3-20 (2002-10-08)}{
  \subsection{Installation}{
    \itemize{
      \item \file{configure.ac} sets \code{CFLAGS} before expanding
      \code{AC_PROG_CC} and sets \code{FLIBS} before expanding
      \code{ACX_BLAS} and \code{ACX_LAPACK}.

      \item Autoconf macro \code{OCTAVE_BLAS_LIBS}, which is no longer
      used, is removed from \file{aclocal.m4}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Unwanted Autoconf output is removed from \file{aclocal.m4}.
    }
  }
}

\section{Changes in version 0.3-19 (2002-07-22)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{PACKAGE = "Matrix"} is passed to \code{.Call} to
      restrict name lookup to \pkg{Matrix}.

      \item The \proglang{C++} sources use qualified name lookup (as in
      \code{std::<name>}) in more places.

      \item The \proglang{C++} sources get pointers to matrix data
      without taking the address of the first element, which is wrong for
      a matrix of length 0.
    }
  }
}

\section{Changes in version 0.3-18 (2002-05-03)}{
  \subsection{Compatibility}{
    \itemize{
      \item \code{*_ELT} macros are no longer defined for \R{} \eqn{<}
      1.2.0 as \pkg{Matrix} depends on \R{} \eqn{\ge}{>=} 1.5.0.
    }
  }
}

\section{Changes in version 0.3-17 (2002-04-30)}{
  \subsection{Description}{
    \itemize{
      \item \pkg{Matrix} \eqn{\ge}{>=} 0.3-17 depends on \R{}
      \eqn{\ge}{>=} 1.5.0.
    }
  }
  \subsection{Installation}{
    \itemize{
      \item \file{configure.in} is replaced by \file{configure.ac}
      contributed by Kurt Hornik.  \file{configure.ac} makes use of
      \command{R CMD config}, a utility added in \R{} version 1.5-0.

      \item Autoconf macros \code{ACX_BLAS} and \code{ACX_LAPACK},
      written by Steven G. Johnson, are added to \file{aclocal.m4} and
      expanded in \file{configure.ac}.

      \item The configured value of \code{LAPACK_LIBS} is prepended to
      \code{PKG_LIBS} in \file{src/Makevars.in}.
    }
  }
}

\section{Changes in version 0.3-16 (2001-12-10)}{
  \subsection{Documentation}{
    \itemize{
      \item A preliminary \file{ChangeLog}.
    }
  }
  \subsection{Compatibility}{
    \itemize{
      \item Rd files are adapted to use \code{\\method{}{}} markup
      introduced in \R{} version 1.2.2.

      \item One usage of \code{.Alias}, deprecated in \R{} version
      1.4.1, is removed.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item S3 methods gain formal argument \code{\dots} where needed to
      match the generic function.

      \item The name of a class member function in \file{src/tgmd.h} was
      was spuriously qualified.
    }
  }
}

\section{Changes in version 0.3-15 (2001-05-15)}{
  \subsection{Installation}{
    \itemize{
      \item The configured value of \code{BLAS_LIBS} is prepended to
      \code{PKG_LIBS} in \file{src/Makevars.in}.
    }
  }
}

\section{Changes in version 0.3-13 (2001-05-10)}{
  \subsection{Installation}{
    \itemize{
      \item The \proglang{C++} sources undefine macros \code{length} and
      \code{append} in many places to allow for class member functions
      with those names.
    }
  }
}

\section{Changes in version 0.3-10 (2001-05-04)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item The \proglang{C++} sources use qualified name lookup (as in
      \code{std::<name>}) in more places.
    }
  }
}

\section{Changes in version 0.3-9 (2001-03-09)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item The \proglang{C++} sources no longer write to \code{stderr}
      and (in most places) \code{stdout}, no longer use the
      \code{assert} macro, and no longer call \code{exit}.
    }
  }
}

\section{Changes in version 0.3-8 (2001-01-10)}{
  \subsection{Description}{
    \itemize{
      \item \file{DESCRIPTION} gets a \code{Maintainer} field and
      Douglas Bates is named there.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Removes around 100 non-source files wrongly bundled in
      \pkg{Matrix} version 0.3-7.
    }
  }
}

\section{Changes in version 0.3-7 (2000-12-03)}{
  \subsection{Installation}{
    \itemize{
      \item \code{FLIBS} is appended to \code{PKG_LIBS} in
      \file{src/Makevars.in}.
    }
  }
  \subsection{Documentation}{
    \itemize{
      \item A basic \file{README}.
    }
  }
}

\section{Changes in version 0.3-6 (2000-10-30)}{
  \subsection{Description}{
    \itemize{
      \item \pkg{Matrix} \eqn{\ge}{>=} 0.3-6 depends on \R{}
      \eqn{\ge}{>=} 1.1.1.
    }
  }
  \subsection{Installation}{
    \itemize{
      \item \file{configure} makes use of \code{HAVE_F77_UNDERSCORE} in
      \file{Rconfig.h}.

      \item \code{PKG_LIBS} and \code{PKG_LDFLAGS} to the configured
      values of \code{LIBS} and \code{LDFLAGS} in \file{src/Makevars.in}.
    }
  }
}

\section{Changes in version 0.3-5 (2000-08-20)}{
  \subsection{Deprecated and Defunct}{
    \itemize{
      \item \code{eigen.Matrix} argument \code{schur}, which was unused,
      is removed.
    }
  }
  \subsection{Methods}{
    \itemize{
      \item An S3 method \code{schur.Matrix} interfacing LAPACK routine
      \code{dgeesx}.  It returns \code{list(values, schur, vectors)}.

      \item For arguments not inheriting from \code{Matrix} subclass
      \code{Hermitian}, \code{eigen.Matrix} is now an interface to
      LAPACK routine \code{dgeevx}, and its optional arguments
      \code{balance} and \code{rcond}, which were unused, can now be
      used to request balancing and the reciprocal condition numbers of
      the eigenvalues and right eigenvectors.  The return value is now
      \code{list(values, vectors, rcond)} with
      \code{vectors = list(left, right)} and
      \code{rcond = list(values, vectors)}.
    }
  }
}

\section{Changes in version 0.3-3 (2000-08-11)}{
  \subsection{Installation}{
    \itemize{
      \item \file{configure} skips the check for BLAS in the Sun
      Performance Library if the \proglang{C} compiler is \command{gcc}.
    }
  }
  \subsection{Compatibility}{
    \itemize{
      \item \code{STRING_ELT}, \code{SET_STRING_ELT}, \code{VECTOR_ELT},
      and \code{SET_VECTOR_ELT} are used in place of \code{STRING} and
      \code{VECTOR}.  \code{*_ELT} macros are defined for \R{} \eqn{<}
      1.2.0 to not break compatibility.
    }
  }
  \subsection{Significant User-Visible Changes}{
    \itemize{
      \item \code{SVD(x, nu = 0, nv)$u} and \code{SVD(x, nu, nv = 0)$vt}
      are \code{NULL} rather than empty matrices.
    }
  }
  \subsection{Methods}{
    \itemize{
      \item An S3 method \code{lu.Matrix} interfacing LAPACK routine
      \code{dgetrf}.  It returns \code{list(l, u, permutation)}, with
      attribute \code{norms = list(one, infinity)} containing the one
      and infinity norms.  An optional argument is provided to disable
      computation of \code{one} and \code{infinity}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{SVD(x, nu, nv)} allocated for the right singular
      values a matrix with dimensions \code{c(ncol(x), nv)} instead of
      \code{c(nv, ncol(x))}.  Buffer overflow could occur in LAPACK
      routine \code{dgesvd} if \code{nv < ncol(x)}.
    }
  }
}

\section{Changes in version 0.3-1 (2000-07-24)}{
  \subsection{Generic Functions}{
    \itemize{
      \item S3 generic function \code{eigen}.
    }
  }
  \subsection{Methods}{
    \itemize{
      \item An S3 method \code{eigen.Matrix} interfacing LAPACK routines
      \code{dgeev} and \code{dsyev}, the latter only for arguments
      inheriting from \code{Matrix} subclass \code{Hermitian}.  It
      returns \code{list(values, vectors)}, where \code{vectors} is
      \code{list(left, right)} for non-\code{Hermitian} arguments and a
      numeric matrix for \code{Hermitian} arguments.  An optional
      argument is provided to disable computation of \code{vectors}.

      \item S3 methods \code{det.Matrix}, \code{det.UpperTriangular},
      \code{det.UnitUpperTriangular}, \code{det.LowerTriangular}, and
      \code{det.UnitLowerTriangular} computing the modulus of the
      determinant or its logarithm.  These return
      \code{list(modulus, sign)}.  Component \code{modulus} has a
      logical attribute \code{logarithm} indicating if the determinant
      is \code{sign * exp(modulus)} or \code{sign * modulus}.
      \code{det.Matrix} computes the \eqn{QR} factorization of its
      argument using LAPACK routine \code{dgeqrf}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item \code{Matrix.class(x)} could be incomplete or contain bad
      elements for orthogonal \code{x}.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item A function \code{as.Matrix} for coercing an object to
      class \code{Matrix}, parallel to \code{as.matrix}.  The return
      value inherits from subclasses of \code{Matrix} if tests for
      structure are satisfied.

      \item Functions \code{asObject} and \code{prependClass} for
      setting and prepending to the \code{class} attribute of the
      argument.

      \item A function \code{diagDet} for computing the determinant of a
      triangular matrix given the diagonal entries.
    }
  }
}

\section{Changes in version 0.2-4 (2000-07-18)}{
  \subsection{Installation}{
    \itemize{
      \item A \file{configure} script detecting options for linking BLAS
      and LAPACK.  It is generated from \file{configure.in} which makes
      use of an Autoconf macro \code{OCTAVE_BLAS_LIBS} defined in
      \file{aclocal.m4}.

      \item \file{src/Makevars} is now generated from
      \file{src/Makevars.in}.

      \item A \file{cleanup} script removing generated files.
    }
  }
  \subsection{Documentation}{
    \itemize{
      \item A Texinfo manual \file{R-Matrix.texi} containing
      implementation details and describing how LAPACK++ was modified
      for \pkg{Matrix}.
    }
  }
  \subsection{Methods}{
    \itemize{
      \item An S3 method \code{rcond.Matrix} interfacing LAPACK routines
      \code{d*con}.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Exceptions thrown by LAPACK++ are caught and handled as \R{}
      errors.

      \item \code{UpperTriangular.test} and \code{LowerTriangular.test}
      returned a maximum rather than a maximum modulus for real
      arguments.
    }
  }
}

\section{Changes in version 0.2-1 (2000-07-15)}{
  \subsection{Description}{
    \itemize{
      \item \pkg{Matrix} version 0.2-1 is the first one to be
      distributed by CRAN.

      \item The package is titled \dQuote{A Matrix Library for \R{}}.

      \item Douglas Bates is the maintainer and principal author.
      Saikat DebRoy is a co-author.

      \item \pkg{Matrix} \eqn{\ge}{>=} 0.2-1 depends on \R{}
      \eqn{\ge}{>=} 1.1.0.
    }
  }
  \subsection{Installation}{
    \itemize{
      \item A modified LAPACK++ (Linear Algebra PACKage in C++, version
      1.1a) is compiled alongside the \pkg{Matrix} sources.  LAPACK++ is
      a \proglang{C++} interface to LAPACK originally developed by
      Roldan Pozo.
    }
  }
  \subsection{Classes}{
    \itemize{
      \item S3 class \code{Matrix} with subclasses \code{Hermitian},
      \code{UpperTriangular} (recursively, \code{UnitUpperTriangular}),
      and \code{LowerTriangular} (recursively,
      \code{UnitLowerTriangular}).  Objects are traditional numeric
      matrices with a \code{class} attribute indicating their
      structural properties.  Objects are interfaced in \proglang{C++}
      using the parallel class hierarchy defined by LAPACK++.
    }
  }
  \subsection{Generic Functions}{
    \itemize{
      \item S3 generic functions \code{det}, \code{expand},
      \code{facmul}, \code{lu}, \code{norm}, \code{rcond}, \code{schur},
      and \code{unpack}.
    }
  }
  \subsection{Methods}{
    \itemize{
      \item An S3 method \code{norm.Matrix} interfacing LAPACK routines
      \code{dlan*}.

      \item An S3 method \code{solve.Matrix} interfacing LAPACK routines
      \code{d*trf} and \code{d*trs}.

      \item An S3 method \code{as.matrix.Matrix} just dropping the class
      attribute.

      \item An S3 method \code{print.Matrix} just printing the
      \code{as.matrix} result.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item A function \code{Matrix} constructing objects of class
      \code{Matrix} from numeric vectors and matrices, parallel to
      \pkg{base} function \code{matrix}.

      \item A function \code{Matrix.class} returning a character vector
      containing the subclasses of \code{Matrix} that would be valid for
      the argument.

      \item Functions \code{Hermitian.test},
      \code{UpperTriangular.test}, \code{LowerTriangular.test},
      \code{Orthogonal.test}, and \code{Orthonormal.test} returning a
      maximum modulus distance useful for testing the respective
      property.

      \item Functions \code{is.Hermitian}, \code{is.UpperTriangular},
      \code{is.LowerTriangular}, and \code{is.Orthonormal} testing if
      the \code{*.test} value does not exceed a tolerance.

      \item Function \code{SVD} interfacing LAPACK routine
      \code{dgesvd}.  \code{SVD(x, nu, nv)} returns
      \code{list(d, u, vt)} containing the singular values (sorted
      non-increasingly), first \code{nu} left singular vectors (stored
      column-wise), and first \code{nv} right singular vectors (stored
      row-wise).

      \item Function \code{hilbert} constructing the \eqn{n}-by-\eqn{n}
      Hilbert matrix.
    }
  }
}

%% ---------------- Start of CRAN history ------------------------------
