## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = (requireNamespace("metafor", quietly = TRUE) & requireNamespace("mice", quietly = TRUE) & requireNamespace("metaforest", quietly = TRUE) & requireNamespace("bain", quietly = TRUE) & requireNamespace("metafor", quietly = TRUE) & knitr::is_html_output()),
  comment = "#>"
)

## -----------------------------------------------------------------------------
# library(pema)
# check_workshop_data(df = curry)

## ----eval = FALSE, warning=FALSE,message=FALSE--------------------------------
# library(metaforest)

## ----echo=FALSE,warning=FALSE,message=FALSE, include=FALSE--------------------
# library(knitr)

## ----eval = FALSE, echo = FALSE-----------------------------------------------
# message("✔ Looks like you're all set to do the workshop!")

## ----eval = FALSE, echo= TRUE-------------------------------------------------
# df <- curry
# check_workshop_data(df)

## ----echo= FALSE--------------------------------------------------------------
# if(!requireNamespace("metaforest", quietly = TRUE)){
#   df <- structure(list(study_id = structure(c(1L, 1L, 2L, 3L, 4L, 5L,
# 5L, 6L, 7L, 7L, 7L, 7L, 8L, 8L, 9L, 9L, 10L, 10L, 10L, 10L, 11L,
# 11L, 12L, 13L, 14L, 15L, 16L, 16L, 16L, 17L, 17L, 18L, 19L, 19L,
# 19L, 20L, 20L, 21L, 21L, 22L, 22L, 22L, 22L, 23L, 23L, 23L, 23L,
# 23L, 23L, 24L, 24L, 25L, 25L, 26L, 26L, 27L), levels = c("Aknin, Barrington-Leigh, et al. (2013) Study 3",
# "Aknin, Broesch, et al. (2015) Study 1", "Aknin, Broesch, et al. (2015) Study 2",
# "Aknin, Dunn, et al. (2013) Study 3", "Aknin, Fleerackers, et al. (2014) ",
# "Aknin, Hamlin, et al. (2012) ", "Alden, & Trew (2013) ", "Anik, Aknin, et al. (2013) Study 1",
# "Buchanan, & Bardi (2010) ", "Chancellor, Margolis, et al. (2017)  ",
# "Donnelly, Grant, et al. (2017)  Study 1", "Donnelly, Grant, et al. (2017) Study 2b",
# "Dunn, Aknin, et al. (2008) Study 3", "Geenen, Hoheluchter, et al. (2014) ",
# "Hanniball & Aknin (2016, unpublished) ", "Layous, Kurtz, J, et al. (under review) Study 1",
# "Layous, Kurtz, J, et al. (under review) Study 2", "Layous, Lee, et al. (2013) ",
# "Layous, Nelson, et al. (2012) ", "Martela, & Ryan (2016) ",
# "Mongrain, Chin, et al. (2011) ", "Nelson, Della Porta, et al. (2015) ",
# "Nelson, Layous, et al. (2016) ", "O'Connell, O'Shea, et al. (2016) ",
# "Ouweneel, Le Blanc, et al. (2014) Study 2", "Trew, & Alden (2015) ",
# "Whillans, Dunn, et al. (2016) Study 2"), class = "factor"),
#     effect_id = 1:56, d = c(0.46, 0.13, 0.93, 0.3, 0.24, 0.38,
#     0.44, 0.46, 0.59, 0.16, 0.54, -0.42, -0.15, 0.49, 0.41, 0.62,
#     0, 0, 0, 0, 0.77, 0.85, 1.25, 0.67, 0.7, -0.46, 0.08, 0.2,
#     0.26, 0.3, 0.12, 0.18, -0.05, -0.12, 0.07, 0.55, 0.42, 0.08,
#     0.15, 0.23, 0.27, 0.09, 0.06, 0.3, 0.36, 0.15, 0.2, 0.16,
#     0.19, 0.02, 0.12, 0.27, 0.27, -0.05, -0.33, 0.19), vi = c(0.020529,
#     0.02004225, 0.170478846153846, 0.101125, 0.080576, 0.0342225418981152,
#     0.0344292645871908, 0.102645, 0.0503528019052956, 0.0484100308209583,
#     0.048206976744186, 0.0475372093023256, 0.0453499817301544,
#     0.0448654973649539, 0.0729294642857143, 0.0748607142857143,
#     0.0919117647058824, 0.0919117647058824, 0.0928030303030303,
#     0.0928030303030303, 0.0373841214864723, 0.0369597457627119,
#     0.0222387745820152, 0.0918358695652174, 0.0624264705882353,
#     0.0384537710411267, 0.0288014894916365, 0.028922352800989,
#     0.0290216333765286, 0.0181374017141807, 0.0179914557682348,
#     0.0143613243970822, 0.00961838942307692, 0.00963269230769231,
#     0.00962127403846154, 0.0552114200943535, 0.0543818148311956,
#     0.00844556962025316, 0.00846255274261603, 0.0369399082568807,
#     0.0370316513761468, 0.0364004545454545, 0.03638, 0.0129494889715091,
#     0.0130054211748989, 0.0128541499884583, 0.0128788675025826,
#     0.0128585285195317, 0.0128733590280063, 0.119052619047619,
#     0.0680943841287198, 0.0824105442176871, 0.0824105442176871,
#     0.0507218561609334, 0.0528751645373597, 0.0550520650787774
#     ), n1i = c(100, 100, 13, 20, 25, 60, 60, 20, 43, 43, 43,
#     43, 41, 44, 28, 28, 16, 16, 16, 16, 59, 59, 107, 23, 34,
#     51, 70, 70, 70, 178, 178, 213, 208, 208, 208, 34, 34, 237,
#     237, 54.5, 54.5, 55, 55, 238, 238, 238, 238, 238, 238, 28,
#     28, 25, 25, 38, 36, 36), n2c = c(100, 100, 13, 20, 25, 59,
#     59, 20, 40, 40, 43, 43, 48, 48, 28, 28, 34, 34, 33, 33, 56,
#     59, 108, 23, 34, 56, 69, 69, 69, 81, 81, 104, 208, 208, 208,
#     42, 42, 237, 237, 54.5, 54.5, 55, 55, 116, 116, 116, 116,
#     116, 116, 12, 31, 24, 24, 41, 41, 37), sex = c(38L, 38L,
#     42L, 70L, 34L, 41L, 41L, 55L, 28L, 28L, 28L, 28L, 41L, 41L,
#     26L, 26L, 27L, 27L, 27L, 27L, 52L, 52L, 50L, 26L, 21L, 43L,
#     16L, 16L, 16L, 19L, 19L, 38L, 38L, 38L, 38L, 36L, 36L, 16L,
#     16L, 53L, 53L, 53L, 53L, 40L, 40L, 40L, 40L, 40L, 40L, 43L,
#     43L, 16L, 16L, 26L, 26L, 50L), age = c(21, 21, 45, 3, 21,
#     19.9, 19.9, 1.9, 19.56, 19.56, 19.56, 19.56, 37.28, 37.28,
#     38, 38, 35.6, 35.6, 35.6, 35.6, 22.57, 22.57, 37.77, 20,
#     20, 19.37, 18.55, 18.55, 18.55, 18.93, 18.93, 20, 10.6, 10.6,
#     10.6, 20.4, 20.4, 33.63, 33.63, 19.98, 19.98, 19.98, 19.98,
#     29.95, 29.95, 29.95, 29.95, 29.95, 29.95, 34.17, 34.17, 20.88,
#     20.88, 20.47, 20.47, 72.02), location = structure(c(3L, 3L,
#     10L, 10L, 2L, 8L, 8L, 2L, 2L, 2L, 2L, 2L, 1L, 1L, 7L, 7L,
#     6L, 6L, 6L, 6L, 8L, 8L, 8L, 2L, 4L, 2L, 8L, 8L, 8L, 8L, 8L,
#     9L, 2L, 2L, 2L, 8L, 8L, 2L, 2L, 9L, 9L, 9L, 9L, 8L, 8L, 8L,
#     8L, 8L, 8L, 8L, 8L, 5L, 5L, 2L, 2L, 8L), levels = c("Australia",
#     "Canada", "Canada / South Africa", "Germany", "Netherlands",
#     "Spain", "UK?", "USA", "USA/Korea", "Vanuatu"), class = "factor"),
#     donor = structure(c(3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 2L, 2L,
#     2L, 2L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L,
#     3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L,
#     3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 2L, 2L,
#     1L), levels = c("Hypertense", "Socially Anxious", "Typical"
#     ), class = "factor"), donorcode = structure(c(2L, 2L, 2L,
#     2L, 2L, 2L, 2L, 2L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L, 2L,
#     2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,
#     2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,
#     2L, 2L, 2L, 2L, 2L, 1L, 1L, 2L), levels = c("Anxious", "Typical"
#     ), class = "factor"), interventioniv = structure(c(5L, 5L,
#     5L, 3L, 5L, 5L, 5L, 3L, 1L, 1L, 1L, 1L, 6L, 7L, 1L, 1L, 1L,
#     1L, 1L, 1L, 8L, 8L, 8L, 5L, 5L, 4L, 1L, 1L, 1L, 1L, 1L, 1L,
#     1L, 1L, 1L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
#     1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 5L), levels = c("AK", "Benevolence",
#     "Donate own sweets", "Helping behavior: mapping out course schedule",
#     "Prosocial Purchase", "Prosocial Purchase ($25)", "Prosocial Purchase ($50)",
#     "Social recycling"), class = "factor"), interventioncode = structure(c(3L,
#     3L, 3L, 2L, 3L, 3L, 3L, 2L, 1L, 1L, 1L, 1L, 3L, 3L, 1L, 1L,
#     1L, 1L, 1L, 1L, 2L, 2L, 2L, 3L, 3L, 2L, 1L, 1L, 1L, 1L, 1L,
#     1L, 1L, 1L, 1L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,
#     1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 3L), levels = c("Acts of Kindness",
#     "Other", "Prosocial Spending"), class = "factor"), control = structure(c(12L,
#     12L, 12L, 2L, 12L, 12L, 12L, 2L, 1L, 1L, 4L, 4L, 11L, 11L,
#     9L, 10L, 13L, 13L, 11L, 11L, 22L, 17L, 21L, 12L, 12L, 3L,
#     20L, 20L, 20L, 6L, 6L, 18L, 23L, 23L, 23L, 8L, 8L, 7L, 7L,
#     24L, 24L, 24L, 24L, 19L, 19L, 19L, 14L, 15L, 14L, 5L, 14L,
#     8L, 8L, 16L, 5L, 12L), levels = c("BE", "Donate other sweets",
#     "Helping self", "LD", "List activities", "Make self happier",
#     "Memory", "Neutral Activity", "New Acts", "No Acts", "None",
#     "Personal Purchase", "Receiver", "Self", "Self ", "Social Exposure",
#     "Take item", "Track Locations", "Track activities", "Track daily activity",
#     "Trash", "Trash/Recycling", "Whereabouts", "Work Activity"
#     ), class = "factor"), controlcode = structure(c(3L, 3L, 3L,
#     1L, 3L, 3L, 3L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 1L, 2L, 3L, 3L,
#     2L, 2L, 1L, 3L, 1L, 3L, 3L, 3L, 1L, 1L, 1L, 3L, 3L, 1L, 1L,
#     1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 3L, 3L,
#     3L, 1L, 3L, 1L, 1L, 1L, 1L, 3L), levels = c("Neutral Activity",
#     "Nothing", "Self Help"), class = "factor"), recipients = structure(c(1L,
#     1L, 7L, 11L, 13L, 1L, 1L, 11L, 2L, 2L, 2L, 2L, 4L, 4L, 2L,
#     2L, 5L, 5L, 5L, 5L, 15L, 15L, 15L, 3L, 8L, 6L, 14L, 14L,
#     14L, 9L, 9L, 2L, 2L, 2L, 2L, 4L, 4L, 2L, 2L, 2L, 2L, 2L,
#     2L, 10L, 10L, 10L, 10L, 10L, 10L, 12L, 12L, 2L, 2L, 2L, 2L,
#     2L), levels = c("Anonymous Sick Children", "Anyone", "Anyone / Charity",
#     "Charity", "Co-Worker", "Colleague", "Family / Friends",
#     "Friends", "Other/One", "Other/World", "Puppet", "Social Network",
#     "Someone", "Someone known", "Unknown lab workers"), class = "factor"),
#     outcomedv = structure(c(6L, 14L, 6L, 16L, 17L, 7L, 5L, 16L,
#     6L, NA, 6L, NA, 7L, 7L, 14L, 14L, 12L, 14L, 12L, 14L, 3L,
#     3L, 6L, 3L, 7L, 7L, 12L, 17L, 2L, 12L, 17L, 17L, 13L, 8L,
#     15L, 6L, NA, 11L, 1L, 12L, 14L, 9L, 4L, 9L, 4L, 10L, 9L,
#     4L, 10L, 12L, 12L, 9L, 4L, 6L, 6L, 17L), levels = c("CES-D",
#     "EWB", "H", "NE", "ORH", "PA", "PANAS", "PAc", "PE", "PF",
#     "SHI", "SHS", "SHSc", "SWLS", "SWLSc", "Smiling", "WB"), class = "factor"),
#     outcomecode = structure(c(4L, 2L, 4L, 3L, 3L, 4L, 3L, 3L,
#     4L, 4L, 4L, 4L, 4L, 4L, 2L, 2L, 1L, 2L, 1L, 2L, 1L, 1L, 4L,
#     1L, 4L, 4L, 1L, 3L, 3L, 1L, 3L, 3L, 1L, 4L, 2L, 4L, 4L, 1L,
#     3L, 1L, 2L, 4L, 4L, 4L, 4L, 3L, 4L, 4L, 3L, 1L, 1L, 4L, 4L,
#     4L, 4L, 3L), levels = c("Happiness", "Life Satisfaction",
#     "Other", "PN Affect"), class = "factor")), class = "data.frame", row.names = c(NA,
# -56L))
# } else {
#   data("curry", package = "metaforest")
#   df <- curry
# }
# 
# names(df)[which(names(df) == "d")] <- "yi"
# message("There is no column named 'yi' in your data. If you have an effect size column, it will be easier to do the tutorial if you rename it, using syntax like this:
# 
#   names(df)[which(names(df) == 'youreffectsize')] <- 'yi'
# 
#   If you do not yet have an effect size column, you may need to compute it first. Run ?metafor::escalc to see the help for this function.")

## -----------------------------------------------------------------------------
# names(df)[which(names(df) == 'd')] <- 'yi'

## ----echo=FALSE---------------------------------------------------------------
# i<-c("yi","vi","method")
# ii<-c("A vector with the effect sizes",
#       "A vector with the sampling variances",
#       "A character string, indicating what type of meta-analysis to run. FE runs a fixed-effect model")
# ms<-data.frame(i,ii)
# names<-c("Argument", "Function")
# colnames(ms)<-names
# kable(ms)

## ----eval = requireNamespace("metafor", quietly = TRUE), echo=FALSE-----------
library(metafor)

## ----eval = FALSE, echo = TRUE------------------------------------------------
# library(metafor)
# m <- rma(yi = df$yi,     # The yi-column of the df, which contains Cohen's d
#          vi = df$vi,    # The vi-column of the df, which contains the variances
#          method = "FE") # Run a fixed-effect model
# m

## ----eval = TRUE, echo = FALSE------------------------------------------------
cat(c("Fixed-Effects Model (k = 56)", "", "I^2 (total heterogeneity / total variability):   64.95%", 
"H^2 (total variability / sampling variability):  2.85", "", 
"Test for Heterogeneity:", "Q(df = 55) = 156.9109, p-val < .0001", 
"", "Model Results:", "", "estimate      se    zval    pval   ci.lb   ci.ub      ", 
"  0.2059  0.0219  9.4135  <.0001  0.1630  0.2487  *** ", "", 
"---", "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1"
), sep = "\n")

## ----results='asis', echo=FALSE-----------------------------------------------
# pema:::quizz(
#   "How big is the overall effect?" = c(0.206, .01),
#   "True or false: A significant proportion of the variability in effect sizes is attributable to heterogeneity, rather than sampling error." = TRUE,
#   "What can you say about the heterogeneity of the population effect?" = c(answer = "It is assumed to be zero", "It is large, I2 = 64.95%", "It is significant, Q(55) = 156,91, p < .0001", "Can't say anything based on this output"),
#   title = "Formative Assessment")

## ----echo=FALSE, out.width="70%",fig.align='center', fig.cap="An illustration of  parameters of the random-effects-model", fig.alt="An illustration of  parameters of the random-effects-model"----
# knitr::include_graphics("./include/density.png")

## ----eval = FALSE-------------------------------------------------------------
# m_re <- rma(yi = df$yi,     # The yi-column of the df, which contains Cohen's d
#             vi = df$vi)    # The vi-column of the df, which contains the variances
# m_re

## ----eval = TRUE, echo = FALSE------------------------------------------------
cat(c("", "Random-Effects Model (k = 56; tau^2 estimator: REML)", 
"", "tau^2 (estimated amount of total heterogeneity): 0.0570 (SE = 0.0176)", 
"tau (square root of estimated tau^2 value):      0.2388", "I^2 (total heterogeneity / total variability):   67.77%", 
"H^2 (total variability / sampling variability):  3.10", "", 
"Test for Heterogeneity:", "Q(df = 55) = 156.9109, p-val < .0001", 
"", "Model Results:", "", "estimate      se    zval    pval   ci.lb   ci.ub      ", 
"  0.2393  0.0414  5.7805  <.0001  0.1581  0.3204  *** ", "", 
"---", "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1"
)
, sep = "\n")

## ----results='asis', echo=FALSE-----------------------------------------------
# pema:::quizz(
#   "How big is the overall effect?" = c(0.24, .01),
#   "What is the estimated heterogeneity?" = c(0.06, .01),
#   "What can you say about the the expected value of the population effect in the random-effects model, compared to the previous fixed-effect model?" = c(answer = "It is larger", "It is smaller", "It is about the same", "Can't say anything based on this output"),
#   title = "Formative Assessment")
# 
# cat("This is caused by the fact that random-effects models assign more equal weight to all studies, including small ones, which tend to be more biased.")

## ----eval = FALSE-------------------------------------------------------------
# m_cat <- rma(yi ~ donorcode, vi = vi, data = df)
# m_cat

## ----eval = TRUE, echo = FALSE------------------------------------------------
cat(c("", "Mixed-Effects Model (k = 56; tau^2 estimator: REML)", 
"", "tau^2 (estimated amount of residual heterogeneity):     0.0567 (SE = 0.0177)", 
"tau (square root of estimated tau^2 value):             0.2382", 
"I^2 (residual heterogeneity / unaccounted variability): 67.81%", 
"H^2 (unaccounted variability / sampling variability):   3.11", 
"R^2 (amount of heterogeneity accounted for):            0.49%", 
"", "Test for Residual Heterogeneity:", "QE(df = 54) = 155.0054, p-val < .0001", 
"", "Test of Moderators (coefficient 2):", "QM(df = 1) = 1.5257, p-val = 0.2168", 
"", "Model Results:", "", "                  estimate      se    zval    pval    ci.lb   ci.ub    ", 
"intrcpt             0.0829  0.1332  0.6222  0.5338  -0.1781  0.3439    ", 
"donorcodeTypical    0.1730  0.1401  1.2352  0.2168  -0.1015  0.4476    ", 
"", "---", "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1"
), sep = "\n")

## ----results='asis', echo=FALSE-----------------------------------------------
# pema:::quizz(
# "What is the expected population effect size in the Typical group?" = c(0.17, .01),
# "What is the expected population effect size in the Anxious group?" = c(0.255888, .01),
# "True or false: There is a significant difference between the two groups." = FALSE, title = "Formative Assessment")

## ----echo=FALSE---------------------------------------------------------------
# # load("Meta_Analysis_Data.RData")
# # madata<-Meta_Analysis_Data
# # madata$pub_year<-c(2001,2002,2011,2013,2013,2014,1999,2018,2001,2002,2011,2013,2013,2014,1999,2018,2003,2005)
# # madata$pub_year<-as.numeric(madata$pub_year)
# # m.pubyear<-metagen(TE,seTE,studlab = paste(Author),comb.fixed = FALSE,data=madata)

## ----eval = FALSE-------------------------------------------------------------
# m_reg <- rma(yi ~sex,
#              vi = vi,
#              data = df)
# m_reg

## ----eval = TRUE, echo = FALSE------------------------------------------------
cat(c("", "Mixed-Effects Model (k = 56; tau^2 estimator: REML)", 
"", "tau^2 (estimated amount of residual heterogeneity):     0.0544 (SE = 0.0173)", 
"tau (square root of estimated tau^2 value):             0.2333", 
"I^2 (residual heterogeneity / unaccounted variability): 66.50%", 
"H^2 (unaccounted variability / sampling variability):   2.98", 
"R^2 (amount of heterogeneity accounted for):            4.53%", 
"", "Test for Residual Heterogeneity:", "QE(df = 54) = 149.5878, p-val < .0001", 
"", "Test of Moderators (coefficient 2):", "QM(df = 1) = 2.1607, p-val = 0.1416", 
"", "Model Results:", "", "         estimate      se    zval    pval    ci.lb   ci.ub    ", 
"intrcpt    0.0648  0.1253  0.5168  0.6053  -0.1808  0.3104    ", 
"sex        0.0050  0.0034  1.4699  0.1416  -0.0017  0.0116    ", 
"", "---", "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1"
), sep = "\n")

## ----results='asis', echo=FALSE-----------------------------------------------
# pema:::quizz(
# "True or false: There is a significant effect of sex." = FALSE,
# "How to interpret the effect of sex?" = c(answer = "1% increase in male participants is associated with .005 increase of the effect size", "The difference between men and women is .005", "There is no effect of sex", "Can't say based on this output"), title = "Formative Assessment")

## ----eval = FALSE-------------------------------------------------------------
# m_multi <- rma(yi ~ sex + donorcode,
#                vi = vi,
#                data = df)
# m_multi

## ----eval = TRUE, echo = FALSE------------------------------------------------
cat(c("", "Mixed-Effects Model (k = 56; tau^2 estimator: REML)", 
"", "tau^2 (estimated amount of residual heterogeneity):     0.0551 (SE = 0.0175)", 
"tau (square root of estimated tau^2 value):             0.2347", 
"I^2 (residual heterogeneity / unaccounted variability): 66.89%", 
"H^2 (unaccounted variability / sampling variability):   3.02", 
"R^2 (amount of heterogeneity accounted for):            3.42%", 
"", "Test for Residual Heterogeneity:", "QE(df = 53) = 148.6166, p-val < .0001", 
"", "Test of Moderators (coefficients 2:3):", "QM(df = 2) = 3.0602, p-val = 0.2165", 
"", "Model Results:", "", "                  estimate      se     zval    pval    ci.lb   ci.ub    ", 
"intrcpt            -0.0337  0.1626  -0.2074  0.8357  -0.3523  0.2849    ", 
"sex                 0.0043  0.0035   1.2310  0.2183  -0.0025  0.0111    ", 
"donorcodeTypical    0.1361  0.1421   0.9579  0.3381  -0.1424  0.4146    ", 
"", "---", "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1"
), sep = "\n")

## ----eval = FALSE-------------------------------------------------------------
# mods <- c("sex", "age", "location", "donorcode", "interventioncode", "controlcode", "recipients", "outcomecode")
# 
# res_multi2 <- rma(as.formula(paste("yi ~", paste(mods, collapse = "+"))), vi = vi, data = df)
# 
# res_multi2

## ----eval = TRUE, echo = FALSE------------------------------------------------
mods <- c("sex", "age", "location", "donorcode", "interventioncode", "controlcode", "recipients", "outcomecode")
cat(c("", "Mixed-Effects Model (k = 56; tau^2 estimator: REML)", 
"", "tau^2 (estimated amount of residual heterogeneity):     0.0038 (SE = 0.0076)", 
"tau (square root of estimated tau^2 value):             0.0618", 
"I^2 (residual heterogeneity / unaccounted variability): 12.55%", 
"H^2 (unaccounted variability / sampling variability):   1.14", 
"R^2 (amount of heterogeneity accounted for):            93.30%", 
"", "Test for Residual Heterogeneity:", "QE(df = 26) = 34.1905, p-val = 0.1303", 
"", "Test of Moderators (coefficients 2:30):", "QM(df = 29) = 105.3506, p-val < .0001", 
"", "Model Results:", "", "", "---", "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1"
), sep = "\n")

## ----results='asis', echo=FALSE-----------------------------------------------
# pema:::quizz(
# "What is the number of studies included in the second multiple meta-regression (with all predictors)?" = 56L,
# "What is the number of parameters of the second multiple meta-regression (with all predictors)?" = 30L,
# "The $R^2$ of the second multiple meta-regression model is 93.30%. How can we interpret this?" = c(answer = "With caution; the model is likely overfit.", "As a large effect; the moderators explain most of the heterogeneity.", "As a large effect; there must be several significant moderators.", "Can't say based on this output"), title = "Formative Assessment")

## ----echo = FALSE, eval = TRUE------------------------------------------------
warning("Redundant predictors dropped from the model.")

## -----------------------------------------------------------------------------
# df[c(5, 24, 28, 46), c("age", "location", "interventioncode", "controlcode", "outcomecode")]

## ----echo = FALSE, out.width="70%", fig.cap="Illustration of an overfitted model vs. model with a good fit"----
# knitr::include_graphics("./include/overfitting.png")

## ----eval = FALSE, echo = TRUE------------------------------------------------
# library(pema)
# library(tidySEM)
# library(ggplot2)
# options(mc.cores = 4)

## ----echo = FALSE-------------------------------------------------------------
# library(pema)
# library(ggplot2)
# options(mc.cores = 4)

## -----------------------------------------------------------------------------
# df_brma <- df[, c("yi", "vi", mods)]

## ----echo = TRUE, eval = FALSE------------------------------------------------
# set.seed(1)
# fit_lasso <- brma(yi ~ .,
#                   data = df_brma,
#                   vi = "vi",
#                   method = "lasso",
#                   prior = c(df = 1, scale = 1),
#                   mute_stan = FALSE)

## ----echo = FALSE, eval = TRUE------------------------------------------------
# fit_lasso <- readRDS("fitlasso.RData")
# sum <- summary(fit_lasso)
# saveRDS(sum$coefficients[, c("mean", "sd", "2.5%", "97.5%", "n_eff", "Rhat")], "sum.RData")
# saveRDS(I2(fit_lasso), "i2.RData")

sums <- readRDS("sum.RData")
# i2s <- readRDS("i2.RData")

## ----eval = FALSE-------------------------------------------------------------
# sum <- summary(fit_lasso)
# sum$coefficients[, c("mean", "sd", "2.5%", "97.5%", "n_eff", "Rhat")]

## ----echo = FALSE-------------------------------------------------------------
# sums <- data.frame(sums, check.names = FALSE)
# sums$Sig <- c("*", "")[as.integer(apply(sums[, c("2.5%",
#     "97.5%")], 1, function(x) {
#     sum(sign(x)) == 0
#   })) + 1]
# knitr::kable(sums, digits = 2)

## ----results='asis', echo=FALSE-----------------------------------------------
# pema:::quizz(
# "How many significant moderator effects are there?" = TRUE,
# "True or false: There is significant residual heterogeneity." = TRUE,
# "What can we say about the coefficients of this BRMA analysis, compared to the previous `rma()` multiple regression?" = c(answer = "All absolute BRMA coefficients are smaller than RMA coefficients.", "The BRMA coefficients are more variable than RMA coefficients.", "It is easier for coefficients to be significant in BRMA than in RMA.", "The answer depends on the specific analysis."), title = "Formative Assessment")

## ----echo = TRUE, eval = F----------------------------------------------------
# df_brma_threelevel <- df[, c("yi", "vi", "study_id", mods)]
# set.seed(7)
# fit_hs <- brma(yi ~ .,
#                data = df_brma_threelevel,
#                vi = "vi",
#                study = "study_id")

## -----------------------------------------------------------------------------
# # Load the metaforest package
# library(metaforest)

## ----eval = FALSE-------------------------------------------------------------
# # Run model with many trees to check convergence
# set.seed(74)
# check_conv <- MetaForest(yi~.,
# data = df_brma_threelevel,
# study = "study_id",
# whichweights = "random",
# num.trees = 10000)
# # Plot convergence trajectory
# plot(check_conv)

## ----echo = FALSE, out.width = "70%"------------------------------------------
# # saveRDS(check_conv, "check_conv.RData")
# #check_conv <- readRDS("check_conv.RData")
# # Plot convergence trajectory
# #p <- plot(check_conv)
# #ggsave("check_conv.png", device = "png", p)
# knitr::include_graphics("check_conv.png")

## ----eval = FALSE-------------------------------------------------------------
# # Load caret
# library(caret)
# # Set up 5-fold clustered CV
# grouped_cv <- trainControl(method = "cv",
# index = groupKFold(df_brma_threelevel$study_id, k = 5))
# 
# # Set up a tuning grid
# tuning_grid <- expand.grid(whichweights = c("random", "fixed", "unif"),
# mtry = 2:6,
# min.node.size = 2:6)
# # X should contain only retained moderators, clustering variable, and vi
# X <- df_brma_threelevel[, c("study_id", "vi", mods)]
# # Train the model
# set.seed(3)
# mf_cv <- train(y = df_brma_threelevel$yi,
# x = X,
# study = "study_id", # Name of the clustering variable
# method = ModelInfo_mf(),
# trControl = grouped_cv,
# tuneGrid = tuning_grid,
# num.trees = 2500)
# # Best model tuning parameters
# mf_cv$results[which.min(mf_cv$results$RMSE), ]
# 

## ----echo = FALSE-------------------------------------------------------------
# # saveRDS(mf_cv, "mf_cv.RData")
# # mf_cv <- readRDS("mf_cv.RData")
# # mf_cv$results[which.min(mf_cv$results$RMSE), ]
# structure(list(whichweights = structure(2L, levels = c("random",
# "fixed", "unif"), class = "factor"), mtry = 3L, min.node.size = 3L,
#     RMSE = 0.276090448574327, Rsquared = 0.293602765289174, MAE = 0.224021810024353,
#     RMSESD = 0.0861323609105832, RsquaredSD = 0.295168175398074,
#     MAESD = 0.0671963806985692), row.names = 32L, class = "data.frame")
# 

## ----eval = FALSE-------------------------------------------------------------
# # Extract final model
# final <- mf_cv$finalModel
# # Extract R^2_oob from the final model
# r2_oob <- final$forest$r.squared

## ----eval = FALSE-------------------------------------------------------------
# # Plot variable importance
# VarImpPlot(final)
# 
# # Sort the variable names by importance
# ordered_vars <- names(final$forest$variable.importance)[
# order(final$forest$variable.importance, decreasing = TRUE)]
# 
# # Plot partial dependence
# PartialDependence(final, vars = ordered_vars,
# rawdata = TRUE, pi = .95)

## ----results='asis', echo=FALSE-----------------------------------------------
# pema:::quizz(
# "What does the negative permutation importance for `donorcode` indicate?" = c(answer = "Acts of Kindness", "Other", "Prosocial Spending"),
# "Which intervention has the lowest associated effect size?" = c(answer = "Randomly permuting this variable improves model fit", "Randomly permuting this variable diminishes model fit", "This variable has a negative effect on the outcome (effect size)", "This variable has a positive effect on the outcome (effect size)"),
# "Which variable has apparent outlier(s)?" = c(answer = "age", "donorcode", "outcomecode"),
# title = "Formative Assessment")

## ----echo = TRUE, results='hide'----------------------------------------------
# library(bain)

## ----eval = FALSE-------------------------------------------------------------
# res_rma <- rma(yi = yi, vi = vi, data = df)
# funnel(res_rma)

## ----echo = FALSE, eval = TRUE------------------------------------------------
# res_rma <- rma(yi = yi, vi = vi, data = df)
# png("tutorial_funnel.png")
# funnel(res_rma)
# dev.off()
knitr::include_graphics("tutorial_funnel.png")

## -----------------------------------------------------------------------------
# set.seed(1)
# bain(x = c("yi" = df$yi[1]), # Select the first effect size
#      Sigma = matrix(df$vi[1], 1, 1), # Make covariance matrix
#      hypothesis = "yi > 0", # Define informative hypothesis
#      n = df$n1i[1]+df$n2c[1]) # Calculate total sample size

## ----echo = TRUE--------------------------------------------------------------
# set.seed(1)
# res_pbf <- pbf(yi = df$yi,
#                vi = df$vi,
#                ni = sum(df$n1i+df$n2c),
#                hypothesis = "y > 0")

## ----echo = FALSE-------------------------------------------------------------
# 
# knitr::kable(res_pbf[, 1:4])

## ----results='asis', echo=FALSE-----------------------------------------------
# pema:::quizz(
# "What does a negative Bayes factor indicate, for a Bayes factor comparing an informative hypothesis Hi against its complement Hc?" = c(answer = "Negative Bayes factors don't exist", "The evidence for Hc outweighs the evidence for Hi", "The evidence for Hi outweighs the evidence for Hc, but the effect is negative", "The evidence for Hi outweighs the evidence for Hc"),
# "True or false: All Bayes factors must exceed one (BF > 1) to obtain a PBF that also exceeds one (PBF > 1)" = FALSE,
# "True or false: A large Bayes factor means that the hypothesized effect likely exists in the population" = FALSE,
# title = "Formative Assessment")

