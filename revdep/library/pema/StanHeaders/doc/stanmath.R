## ----setup, include = FALSE-----------------------------------------------------------------------
options(width = 100)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
local({
  hook_output <- knitr::knit_hooks$get('output')
  knitr::knit_hooks$set(output = function(x, options) {
    if (!is.null(options$max.height)) options$attr.output <- c(
      options$attr.output,
      sprintf('style="max-height: %s;"', options$max.height)
    )
    hook_output(x, options)
  })
})
Sys.setenv(USE_CXX17 = "1")
set.seed(12345)

## -------------------------------------------------------------------------------------------------
example(stanFunction, package = "StanHeaders", run.dontrun = TRUE)

## ----echo = FALSE, warning = FALSE, class.output="scroll-100"-------------------------------------
if (length(functions) %% 2 == 1) {
  functions <- c(functions, "")
}
functions <- matrix(functions, ncol = 2, byrow = TRUE)
print(functions)

## -------------------------------------------------------------------------------------------------
Sys.setenv(PKG_CXXFLAGS = StanHeaders:::CxxFlags(as_character = TRUE))
SH <- system.file(ifelse(.Platform$OS.type == "windows", "libs", "lib"), .Platform$r_arch,
                  package = "StanHeaders", mustWork = TRUE)
Sys.setenv(PKG_LIBS = paste0(StanHeaders:::LdFlags(as_character = TRUE),
                             " -L", shQuote(SH), " -lStanHeaders"))
                            

## -------------------------------------------------------------------------------------------------
x <- optim(rnorm(3), fn = f, gr = g, a = 1:3, method = "BFGS", hessian = TRUE)
x$par
x$hessian
H(x$par, a = 1:3)
J(x$par, a = 1:3)
solution(a = 1:3, guess = rnorm(3))

## -------------------------------------------------------------------------------------------------
all.equal(1, Cauchy(rexp(1)), tol = 1e-15)

## -------------------------------------------------------------------------------------------------
A <- matrix(c(0, -1, 1, -runif(1)), nrow = 2, ncol = 2)
y0 <- rexp(2)
all.equal(nonstiff(A, y0), c(0, 0), tol = 1e-5)
all.equal(   stiff(A, y0), c(0, 0), tol = 1e-8)

## -------------------------------------------------------------------------------------------------
Sys.setenv(STAN_NUM_THREADS = 2) # specify -1 to use all available cores

## -------------------------------------------------------------------------------------------------
odd <- seq.int(from = 2^25 - 1, to = 2^26 - 1, by = 2)
tail(psapply(n = as.list(odd))) == 1 # check your process manager while this is running

## -------------------------------------------------------------------------------------------------
stopifnot(all.equal(1, check_logarithmic_PMF(p = 1 / sqrt(2))))

## ----echo = FALSE, comment = ""-------------------------------------------------------------------
cat(readLines("sparselm_stan.hpp"), sep = "\n")

## ----message = FALSE------------------------------------------------------------------------------
library(Rcpp)
tf <- tempfile(fileext = "Module.cpp")
exposeClass("sparselm_stan",
      constructors = list(c("Eigen::Map<Eigen::SparseMatrix<double> >", 
                            "Eigen::VectorXd")),
      fields = c("X", "y"),
      methods = c("log_prob<>", "gradient<>"),
      rename = c(log_prob = "log_prob<>", gradient = "gradient<>"),
      header = c("// [[Rcpp::depends(BH)]]",
                 "// [[Rcpp::depends(RcppEigen)]]",
                 "// [[Rcpp::depends(RcppParallel)]",
                 "// [[Rcpp::depends(StanHeaders)]]",
                 "// [[Rcpp::plugins(cpp17)]]",
                 paste0("#include <", file.path(getwd(), "sparselm_stan.hpp"), ">")),
      file = tf,
      Rfile = FALSE)
Sys.setenv(PKG_CXXFLAGS = paste0(Sys.getenv("PKG_CXXFLAGS"), " -I",
                                 system.file("include", "src", 
                                             package = "StanHeaders", mustWork = TRUE)))
sourceCpp(tf)
sparselm_stan

## -------------------------------------------------------------------------------------------------
dd <- data.frame(a = gl(3, 4), b = gl(4, 1, 12))
X <- Matrix::sparse.model.matrix(~ a + b, data = dd)
X

## -------------------------------------------------------------------------------------------------
sm <- new(sparselm_stan, X = X, y = rnorm(nrow(X)))
sm$log_prob(c(beta = rnorm(ncol(X)), log_sigma = log(pi)))
round(sm$gradient(c(beta = rnorm(ncol(X)), log_sigma = log(pi))), digits = 4)

