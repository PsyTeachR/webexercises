\name{dummyfun}
\alias{a1}
\alias{a2}
\alias{a3}
#ifdef windows
\alias{onlywin}
#endif
#ifdef unix
\alias{onlyunix}
#endif
\title{Example in Rdpack}
\description{Dummy description.
  Second sentence.
}
\usage{dummyfun(x, y, type, flag = FALSE)}
\arguments{
  \item{x}{Description of \code{x}}
  \item{y}{Description of \code{y}}
  \item{type}{Description of \code{type}}
  \item{flag}{Description of \code{flag}}
}
\details{Dummy details.
  More dummy details.

#ifdef unix
  These are on unix.
#endif
#ifdef windows
  These are on windows.
#endif
}
\value{A list with the following components:
  \item{res}{result, a number}
  \item{convergence}{numeric code indicating convergence.}
}
\section{Further information}{
This is a user defined section.
}
\examples{
dummyfun(1)
#ifdef windows
    ## example on Windows
#endif
#ifdef unix
\dontrun{
## need to supply a suitable file path (if any) for your system
## example on unix
}
#endif
}
\keyword{kw1}
\keyword{kw2}


