library(reformulas)

## "basic intercept + slope '||' works"
expect_equivalent(
    findbars(Reaction ~ Days + (Days||Subject)),
    findbars(Reaction ~ Days + (1|Subject) + (0 + Days|Subject))
)

## '||' works with nested,  multiple, or interaction terms" 
## works with nested
expect_equivalent(findbars(y ~ (x || id / id2)),
                  findbars(y ~ (1 | id  / id2) + (0 + x | id / id2)))
	
## works with multiple
expect_equivalent(findbars(y ~ (x1 + x2  || id / id2) + (x3 | id3) + (x4 || id4)),
                  findbars(y ~ (1 | id / id2) + (0 + x1 | id / id2) +
                               (0 + x2 | id / id2) + (x3 | id3) + (1 | id4) +
                               (0 + x4| id4)))
## interactions:
expect_equivalent(findbars(y ~ (x1*x2 || id)),
                  findbars(y ~ (1 | id) + (0+x1 | id) + (0 + x2 | id) +
                               (0 + x1:x2 | id)))
	
## "quoted terms work"
## used to fail in test-oldRZXFailure.R
f <- quote(crab.speciesS + crab.sizeS +
           crab.speciesS:crab.sizeS + (snail.size | plot))
expect_equivalent(findbars(f)[[1]], (~(snail.size|plot))[[2]][[2]] )

 ## "leaves superfluous '||' alone"
expect_equivalent(findbars(y ~ z + (0 + x || id)),
                          findbars(y ~ z + (0 + x  | id)))
	

## "plays nice with parens in fixed or random formulas"
expect_equivalent(findbars(y ~ (z + x)^2 + (x || id)),
                  findbars(y ~ (z + x)^2 + (1 | id) + (0 + x | id)))

expect_equivalent(findbars(y ~ ((x || id)) + (x2|id)),
                  findbars(y ~ (1 | id) + (0 + x | id) + (x2|id)))

## at("update works as expected", {
## 	m <- lmer(Reaction ~ Days + (Days || Subject), sleepstudy)
## 	expect_equivalent(fitted(update(m, .~.-(0 + Days | Subject))), 
##                           fitted(lmer(Reaction ~ Days + (1|Subject), sleepstudy)))
## })

## "long formulas work"
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
expStr <- paste(deparse(expandDoubleVerts(form),width=500),collapse="")
## check: no spurious ~ induced
expect_equal(1,sum(grepl("~",strsplit(expStr,"")[[1]])))

