## test_that("'||' works with nested,  multiple, or interaction terms" , {

##works with nested
expect_equivalent(findbars(y ~ (x || id / id2)),
                  findbars(y ~ (1 | id  / id2) + (0 + x | id / id2)))
	
##works with multiple
	expect_equivalent(findbars(y ~ (x1 + x2  || id / id2) + (x3 | id3) + (x4 || id4)),
                          findbars(y ~ (1 | id / id2) + (0 + x1 | id / id2) +
                                   (0 + x2 | id / id2) + (x3 | id3) + (1 | id4) +
                                   (0 + x4| id4)))
##interactions:
	expect_equivalent(findbars(y ~ (x1*x2 || id)),
                          findbars(y ~ (1 | id) + (0+x1 | id) + (0 + x2 | id) +
                                   (0 + x1:x2 | id)))

	
## "quoted terms work"
	## used to fail in test-oldRZXFailure.R
	f <- quote(crab.speciesS + crab.sizeS +
                   crab.speciesS:crab.sizeS + (snail.size | plot))
	expect_equivalent(findbars(f)[[1]], (~(snail.size|plot))[[2]][[2]] )

 ## leaves superfluous '||' alone"
	expect_equivalent(findbars(y ~ z + (0 + x || id)),
                          findbars(y ~ z + (0 + x  | id)))
	

## "plays nice with parens in fixed or random formulas"
expect_equivalent(findbars(y ~ (z + x)^2 + (x || id)),
                  findbars(y ~ (z + x)^2 + (1 | id) + (0 + x | id)))
	
expect_equivalent(findbars(y ~ ((x || id)) + (x2|id)),
                  findbars(y ~ (1 | id) + (0 + x | id) + (x2|id)))

## test_that("long formulas work",{
    form <- log.corti~z.n.fert.females*z.n.males+
        is.alpha2*(z.infanticide.susceptibility+z.min.co.res+
                   z.co.res+z.log.tenure)+
        z.xtime+z.age.at.sample+sin.season+cos.season+
        (1  +z.n.fert.females
            +z.n.males
            +is.alpha2.subordinate
            +z.infanticide.susceptibility
            +z.min.co.res
            +z.log.tenure
            +z.co.res
            +z.xtime
            +z.age.at.sample
            +sin.season
            +cos.season
            +I(z.n.fert.females*z.n.males)
            +I(is.alpha2.subordinate*z.min.co.res)
            +I(z.co.res*is.alpha2.subordinate)
            +I(is.alpha2.subordinate*z.co.res)
            +int.is.a.log.ten
            ||monkeyid)
    expStr <- paste(deparse(reformulas::expandDoubleVerts(form),width=500),collapse="")
    ## check: no spurious ~ induced
    expect_equal(1,sum(grepl("~",strsplit(expStr,"")[[1]])))
## })

## test_that("nobar", {
rr <- function(form) {
  form[[length(form)]]
}


## rr <- lme4:::RHSForm
    expect_equal(nobars(y~1+(1|g)),                      y~1)
    expect_equal(nobars(y~1|g),                          y~1)
    expect_equal(nobars(y~1+(1||g)),                     y~1)
    expect_equal(nobars(y~1||g),                         y~1)
    expect_equal(nobars(y~1+(x:z|g)),                    y~1)
    expect_equal(nobars(y~1+(x*z|g/h)),                  y~1)
    expect_equal(nobars(y~(1|g)+x+(x|h)),                y~x)
    expect_equal(nobars(y~(1|g)+x+(x+z|h)),              y~x)
    expect_equal(nobars(~1+(1|g)),                        ~1)
    expect_equal(nobars(~(1|g)),                          ~1)
    expect_equal(nobars(rr(y~1+(1|g))),                    1)
    expect_equal(nobars(rr(y~(1|g))),                      1)
## })


