if (requireNamespace("lme4") && requireNamespace("glmmTMB")) {
    ## don't need both these pkgs everywhere but will usually be
    ## available ... no harm in skipping on weird systems
    
    dd <- expand.grid(f = factor(1:101), rep1 = factor(1:2), rep2 = 1:2)
    dd$y <- glmmTMB::simulate_new(~1 + (rep1|f),
                                  seed = 101,
                                  newdata = dd,
                                  newparams = list(beta = 1,
                                                   theta = c(0,0,1),
                                                   betadisp = 0),
                                  family = gaussian)[[1]]
    m1 <- lme4::lmer( y ~ 1 + (1|f), data = dd)
    p1 <- predict(m1)
    p2 <- predict(m1, newdata = dd)

    ## make sure we don't break/revert changes that corrected https://github.com/lme4/lme4/issues/631
    ## (sparse contrasts etc.)
    dd <- read.csv(system.file("testdata","lme4_GH631.csv", package = "reformulas"))
    form <- response ~ condition_bystanders + (condition_bystanders|ID)
    model <- lme4::lmer(form, data = dd)
    d0 <- unique(dd[c("condition_bystanders", "ID")])
    dp <- with(d0, expand.grid(condition_bystanders, ID)) |>
        setNames(c("condition_bystanders", "ID"))
    pp <- predict(model, newdata = dp)

    ## results are the same once we go through Khatri-Rao;
    ## only difference is whether interim J matrix (model effects)
    ## is sparse or dense
    fb <- findbars(form)
    mf <- model.frame(subbars(form), data = dd)
    expect_equal(
        mkReTrms(fb, mf),
        mkReTrms(fb, mf, sparse = TRUE)
    )

    ngroup <- 5
    ntime <- 500000
    n <- ngroup * ntime
    d <- data.frame(group=gl(ngroup, ntime), times=glmmTMB::numFactor(1:ntime), y=rnorm(n))
    form <- y ~ (times+0|group)  ## have already run noSpecials/sub_specials
    mf <- model.frame(subbars(form), data = d)
    ## makes a 400 Mb object ...
    tt <- mkReTrms(findbars(form), mf, calc.lambdat = FALSE, sparse = TRUE)
    rm(tt)
}

dd$y <- 1
dd <- expand.grid(a = 1:7, b = 1:3, c = 1:5, d = 1:9)
form2 <- y ~ 1 + (1|a) + (1|b) + (1|c) + (1|d)
rterms_ord <- mkReTrms(findbars(form2), dd, reorder.terms = TRUE)
rterms_noord <- mkReTrms(findbars(form2), dd, reorder.terms = FALSE)
## reorder elements into original formula order
expect_equal(rterms_noord$cnms, with(rterms_ord, cnms[order(ord)]))
