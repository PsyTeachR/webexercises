pkgname <- "pema"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('pema')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("I2")
### * I2

flush(stderr()); flush(stdout())

### Name: I2
### Title: Compute I2
### Aliases: I2

### ** Examples

I2(matrix(1:20, ncol = 1))



cleanEx()
nameEx("as.stan")
### * as.stan

flush(stderr()); flush(stdout())

### Name: as.stan
### Title: Convert an object to stanfit
### Aliases: as.stan

### ** Examples

stanfit <- "a"
class(stanfit) <- "stanfit"
converted <- as.stan(stanfit)



cleanEx()
nameEx("brma")
### * brma

flush(stderr()); flush(stdout())

### Name: brma
### Title: Conduct Bayesian Regularized Meta-Analysis
### Aliases: brma brma.formula brma.default

### ** Examples

data("curry")
df <- curry[c(1:5, 50:55), c("d", "vi", "sex", "age", "donorcode")]
suppressWarnings({res <- brma(d~., data = df, iter = 10)})



cleanEx()
nameEx("check_workshop_data")
### * check_workshop_data

flush(stderr()); flush(stdout())

### Name: check_workshop_data
### Title: Check Data for BRMA Workshop
### Aliases: check_workshop_data

### ** Examples

check_workshop_data(bonapersona)



cleanEx()
nameEx("maxap")
### * maxap

flush(stderr()); flush(stdout())

### Name: maxap
### Title: Maximum a posteriori parameter estimate
### Aliases: maxap

### ** Examples

maxap(c(1,2,3,4,5))



cleanEx()
nameEx("plot_sensitivity")
### * plot_sensitivity

flush(stderr()); flush(stdout())

### Name: plot_sensitivity
### Title: Plot posterior distributions for BRMA models
### Aliases: plot_sensitivity

### ** Examples

plot_sensitivity(samples = list(
data.frame(Parameter = "b",
Value = rnorm(10),
Model = "M1"),
data.frame(Parameter = "b",
Value = rnorm(10, mean = 2),
Model = "M2")),
parameters = "b")



cleanEx()
nameEx("sample_prior")
### * sample_prior

flush(stderr()); flush(stdout())

### Name: sample_prior
### Title: Sample from the Prior Distribution
### Aliases: sample_prior

### ** Examples

sample_prior("lasso", iter = 10)



cleanEx()
nameEx("shiny_prior")
### * shiny_prior

flush(stderr()); flush(stdout())

### Name: shiny_prior
### Title: Interactively Sample from the Prior Distribution
### Aliases: shiny_prior

### ** Examples

## Not run: 
##D shiny_prior()
## End(Not run)



cleanEx()
nameEx("simulate_smd")
### * simulate_smd

flush(stderr()); flush(stdout())

### Name: simulate_smd
### Title: Simulates a meta-analytic dataset
### Aliases: simulate_smd

### ** Examples

set.seed(8)
simulate_smd()
simulate_smd(k_train = 50, distribution = "bernoulli")
simulate_smd(distribution = "bernoulli", model = "es * x[ ,1] * x[ ,2]")



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
