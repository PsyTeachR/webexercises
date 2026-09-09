\name{NEWS}
\title{News for Package \sQuote{sn}}
\encoding{UTF-8}
%--------------------------------------------
\section{Changes in sn version 2.1.3 (2026-02-24)}{
\itemize{
  \item In \code{msn.mle} and its auxiliary functions, exact symmetry of 
    the estimated \code{Omega} matrix is being forced, to avoid a numerical 
    issue arising in particular instances. 
  \item Working of the \code{show} method for \code{selm} and \code{mselm} 
    classes has been reinstated. This had effectively been inhibited in a
    previous version of \pkg{sn} by unfortunate re-definitions of the methods. 
  \item In function \code{st.prelimFit}, the call to \code{quantreg::rq.wfit} 
    now has \code{method="fn"} to reduce the chance of warning messages 
    \dQuote{Solution may be nonunique}.
  \item Fixed a minor bug in \code{convolutionSUNdistr}.
  \item Various scattered improvements in the documentation.  
  }
}


\section{Changes in sn version 2.1.2 (2026-01-24)}{
\itemize{
  \item Fixed a bug which affected usage of \code{...} in \code{pst} 
        and \code{qst}, and improved documentation of these functions.
  \item Improved documentation in \code{"SUNdistr-base"}.
  }
}

\section{Changes in sn version 2.1.1 (2023-04-04)}{
  \itemize{
  \item Coding of \code{pst} is improved for extreme \code{x} arguments
    by employing asymptotic expressions of tail probabilites. 
    As an implication, this change improves the working of \code{qst}.
    Also, new arguments \code{lower.tail} and \code{log.p} are added.
  \item 
    Checking on the dimensionality \code{(d,m)} of calls to \code{{d,p}sun, 
    sunMean, sunVcov, sunMardia} takes place before a call to a function of 
    \pkg{mnormt} is issued. If the maximal dimensionality is exceeded, either 
    a \code{stop} is generated, or \code{NA}s are returned, 
    depending on the value of the \code{silent} argument.
  \item
    Fixed bugs affecting calls to \code{psn, pst} when \code{length(x)} was
    shorter than the length of the parameters (among \code{xi, omega, alpha}).
  }
}

\section{Changes in sn version 2.1.0 (2022-07-30)}{
  \itemize{
    \item New function \code{fitdistr.grouped}, with pertaining class and methods.
    \item More informative messages are issued when \code{trace=TRUE}, at several places.
    \item An experimental way for initializing the parameters of \code{sn.mple} 
          fitting is introduced; it only takes effect when it improves over 
	  the existing scheme. 
    \item Some adjustments in the documenation on request of the CRAN group.
    \item Fixed a bug affecting \code{st.prelimFit} when the argument \code{w}
          was used.
    \item The NEWS file is now in Rd format. 
  }
}
\section{Changes in sn version 2.0.2 (2022-03-07)}{
  \itemize{
    \item Calling \code{rmsn, rmst, rmsc} with parameters for distributions 
      with dimension \code{1} now works. 
    \item The same feature applies to \code{mst.prelimFit} with one column 
       matrix \code{y}.
    \item In \code{psn}, improved handling of non-finite \code{x} values 
      \code{(NA, NaN, Inf)}, which led to crashes; 
      also, streamlined coding of \code{qsn}. 
    \item Minor fixes in the documentation of zeta and qsn; improved wording elsewhere.
  }
}
\section{Changes in sn version 2.0.1 (2021-11-26)}{
  \itemize{
    \item Change of the tuning arguments when \code{numDeriv::hessian} is called, 
      to improve computation of the information matrix following a ST model fitting. 
    \item Fixed bug which in some cases prevented the use of the 'start' argument. 
    \item Re-organization of some internal functions computing SUN summary quantities.
    \item Improved documentation for \code{selm, selm.fit} and \code{SUNdistr-base}.
  }
}
\section{Changes in sn version 2.0.0 (2021-03-28)}{
  \itemize{
    \item Support for the SUN family is introduced, as for probability distribution
      operations. Two modes of working are envisaged: 
      (i) using classic-style functions for probability distributions, 
         plus some functions of similar style;
      (ii) using S4 objects of the new class \code{SUNdistr}. 
      For mode (i), the functions \code{{d,p,r}sun, sun{Mean,Vcov,Mardia}} are provided. 
      For mode (ii), there are \code{{make, marginal, conditional, affineTrans, join, 
      convolution, summary}SUNdistr}, and related S4 methods. 
    \item Additional facilities include 
      \code{convertSN2SUNdistr}, \code{convertCSN2SUNpar} and 
      two matrix operations (\code{tr} and \code{blockDiag}).  
    \item Fixed a bug in \code{plot.SECdistr} affecting the plot of a subset 
      of the variables.
  }
}
\section{Changes in sn version 1.6-2 (2020-05-26)}{
  \itemize{
    \item Fixed wrong computation of standard errors when a multivariate ST model was
      fitted with the constraint alpha=0; similar fix of function confint.
    \item Change of the algorithm used in rsn: the additive representation is now used
      both fo r 0 and for non-0 values of tau.
    \item Use of the vignette builder R.rsp.
  }
}
\section{Changes in sn version 1.6-1 (2020-04-01)}{
  \itemize{
    \item Some minor changes in the selm function documentation.
  }
}
\section{Changes in sn version 1.6-0 (2020-03-28)}{
  \itemize{
    \item New intialization technique for numerical MLE search when function selm is 
      called with family="ST". This is performed by the new functions st.prelimFit 
      and mst.prelimFit, with the aid of galton_moors2alpha_nu.
    \item In st.prelimFit, the package quantreg is employed for preliminary linear 
      predictor estimation.
    \item Related new functions of more general interest are: fournum, pprodn2, 
      pprodt2, qprodt2. 
    \item Additional facts: an improved version of function profile.selm.
    \item Improved coding of some internal functions.
  }
}
\section{Changes in sn version 1.5-5 (2020-01-30)}{
  \itemize{
    \item In sn.infoMv, new argument at.MLE is introduced. 
    \item Arguments of selm are updated to match changes in R. 
    \item Fix a bug in dsn when called with a non-scalar argument alpha. 
    \item Changed internal checks on 'try' output, to accomplish R changes.
  }
}
\section{Changes in sn version 1.5-4 (2019-05-09)}{
  \itemize{
    \item On request from the CRAN group, a modification is inserted to get around
      numerical problems arising in connection with use of OpenBLAS (version 0.3.5).
    \item For plotting of a multivariate SECdistr when 'range' is not supplied and 
      'data' is non-NULL, calculation of the plotting range has been modified. 
    \item Proper handling of the 'name' argument of marginalSECdistr when the result 
      is a univariate distribution.
  }
}
\section{Changes in sn version 1.5-3 (2018-11-08)}{
  \itemize{
    \item In pst, improved implementation of Method 2; slight modification of the
      automatic selection method when 'method=0'. 
    \item Internal function qst_bounds introduced for better initial bracketing of 
      ST quantiles; improved qst coding.
    \item In profile.selm the selected parameter area does no longer need to include
      the MLE/MPLE point. 
    \item In sn.infoMv removed bugs in the stage of parameter parsing, which prevented 
      computing the expected information matrix. 
    \item In internal functions st.pdev.gh and mst.pdev.grad, improved computation of 
      'nu' component of logLik gradient, yielding faster fitting of ST models. 
    \item Improved handling of arguments of sn.infoMv. 
    \item Improved documentation of modeSECdistr and coding of modeSECdistrMv.
  }
}
\section{Changes in sn version 1.5-2 (2018-04-24)}{
  \itemize{
    \item Improved checking of input arguments to lower level fitting procedures 
      (those below selm) and improved handling for those of pst. 
    \item Fixed improper handling  when not positive-definite information in 
      st.infoUv occurs, pointed out by the CRAN group.
  }
}
\section{Changes in sn version 1.5-1 (2017-11-22)}{
  \itemize{
    \item More extensive documentation: 
      - addition of 'overview' entry in standard documentation;
      - in directory 'doc', inclusion of a PDF file providing a tutorial 
        introduction to the package;
      -  additions and improvements at various places in Rd files. 
    \item Fix a minor bug in sn.infoUv causing crash when the DP information matrix 
      is not invertible. 
    \item Improved numerical inversion of st.cp2dp in extreme situations.
  }
}
\section{Changes in sn version 1.5-0 (2017-02-09)}{
  \itemize{
    \item Tools for user-defined symmetry-modulated (AKA skew-symmetric) distributions
      are introduced: \{d,r\}[m]SymmModulated and its bivariate density plotting. 
    \item Fixed a bug in dsn affecting the cases (a) x=Inf, alpha=0, and (b) omega<=0. 
  }
}
\section{Changes in sn version 1.4-0 (2016-06-30)}{
  \itemize{
    \item Introduce methods confint and predict for selm-class objects. 
    \item Fix bug in rmst causing some dependence among subsequent samples.
    \item Fix bug of modeSECdistrMv  affecting certain ST cases.
    \item Now plot.SECdistrBv allows to overlap plots.
    \item Improved naming of output.
    \item profile.selm can now be called with vector(s) param.values of length 1.
  }
}
\section{Changes in sn version 1.3-0 (2015-11-11)}{
  \itemize{
    \item Method profile.selm is introduced. 
    \item The object returned by plot.SECdistrMv now includes the coordinates of the 
      contour curves. 
    \item Fixed a bug affecting rmsn when called using dp=, also dp[[1]] is named beta 
      instead of xi.
  }
}
\section{Changes in sn version 1.2-5 (2015-09-25)}{
  \itemize{
    \item Not released
  }
}
\section{Changes in sn version 1.2-4 (2015-08-25)}{
  \itemize{
    \item Output of plot.SECdistr is better structured and documented. 
    \item In pmst, handling of case nu=Inf required a fix. 
    \item Corrected a bug of internal function msn.dp2dp when called with aux=TRUE 
      and d=1; this affected rmsn and rmst if d=1.
  }
}
\section{Changes in sn version 1.2-3 (2015-07-14)}{
  \itemize{
    \item Fixed a bug in evaluation of the feasible CP parameter space of univariate ST.
    \item Fixed a bug which crashed pmst when called with fractional degrees of freedom.
    \item Functions dmsn, pmsn and dmst now expand a single value supplied as 'xi' into
      a vector or matrix of suitable dimension.
  }
}
\section{Changes in sn version 1.2-2 (2015-06-05)}{
  \itemize{
    \item Fixed a bug in extractSECdistr from mselm-class objects. 
    \item Fixed a bug that  prevented calling low level fitting functions with non-null
      'penalty' argument.
    \item Improved documentation of selm.fit and related functions.
  }
}
\section{Changes in sn version 1.2-1 (2015-04-28)}{
  \itemize{
    \item Optimization parameters are now passed from selm to sn.mple and st.mple as
      indicated in the documentation. 
    \item Plotting of selm-class and mselm-class objects avoids clash of par('cex') 
      parameters. 
    \item Computation of sn.infoMv now takes into account whether method="MPLE" was 
      used at the estimation stage. 
  }
}
\section{Changes in sn version 1.2-0 (2015-03-24)}{
  \itemize{
    \item Created new functions extractSECdistr and modeSECdistr.
    \item New methods mean and sd for class SECdistrUv, and new methods mean and vcov 
      for class SECdistrMv.
    \item Computation of qst switches to qsn if nu>1e4, instead of nu=Inf as before.
    \item Fixed a bug in st.pdev.hessian (correction in args sequence). 
    \item Improved detection of singular distributions in selm output.  
    \item Improved handling of component names of SECdistr.
  }
}
\section{Changes in sn version 1.1-2 (2014-11-30)}{
  \itemize{
    \item Fixed a bug affecting plotting of mselm objects under certain circumstances. 
    \item Fixed a bug affecting function selm when the weights argument contained 0's. 
    \item Improved coding in some functions. 
    \item More functions are exported and their documentation is added.
  }
}
\section{Changes in sn version 1.1-1 (2014-10-30)}{
  \itemize{
    \item Function qsn has an additional argument 'solver'. 
    \item Functions pmsn and pmst can  now be called with argument 'xi' of matrix type. 
    \item More functions are now exported in NAMESPACE. 
    \item Fixed a bug about selm.control argument of selm.fit. 
    \item Improved documentation of various functions.
  }
}
\section{Changes in sn version 1.1-0 (2014-08-06)}{
  \itemize{
    \item Main few feature is the possibility to set the constraint alpha=0 in function 
      selm and in lower level fitting functions. 
    \item Other additions or changes are: 
       introduction of OP parameterization;
       fix a bug in qst; more efficient coding  of dmsn and dmst; 
       pmsn can now be called with argument 'x' of matrix type; 
       in pst and qst, new argument method allows to select the algorithm employed.
    \item More detailed documentation of pst and other functions and methods.
  }
}
\section{Changes in sn version 1.0-0 (2014-01-06)}{
  \itemize{
    \item This is a major upgrade of the package, with much of the code completely new 
      or largely re-written, leading to changes in the syntax and the user interface.
    \item The key new functions are selm and makeSECdistr, with various related functions  
      and methods. 
    \item S4 methods are adopted. 
    \item Many existing functions are updated,  a few are dropped.
    \item See help(SN) for more information.
    \item (Development of "version 1" was started in June 2007.)
  }
}
\section{Changes in sn version 0.4-18 (2013-05-01)}{
  \itemize{
    \item Various minor adjustments, many of them to fulfill CRAN programming standards.
  }
}
\section{Changes in sn version 0.4-0 (2006-04-11)}{
 Several changes and additions are included:
  \itemize{
    \item  many routines allow use of composite parameter 'dp';
    \item  multivariate normal and t probabilities are now computed by 'mnormt';
    \item  use of NAMESPACE introduced;
    \item some more routines introduced, eg. st.cumulants.inversion;
    \item  various fixes/improvements in documentation.
  }
}
\section{Changes in sn version 0.3-5 (2006-01-16)}{
  \itemize{
    \item Added some new functions (these include msn.affine, sn.mmle, sn.Einfo, 
      sn.mle.grouped), fix various errors, and other improvements (eg. improved pst).
  }
}
\section{Changes in sn version 0.3-0 (2002-06-15)}{
  \itemize{
    \item The main change is the addition of routines for (multivariate) skew-t 
      distribution; also some other routines, e.g. mle for grouped data
  }
}
\section{Changes in sn version 0.2-2 (2002-01-05)}{
  \itemize{
    \item Fix error in sn.dev.gh, improved qsn
  }
}
\section{Changes in sn version 0.2-0 (1998-10-31)}{
  \itemize{
    \item This is the first public release and distribution, originally 
    from \url{http://azzalini.stat.unipd.it} in October 1998, 
    shortly afterwards from \acronym{CRAN}.
  }
}
