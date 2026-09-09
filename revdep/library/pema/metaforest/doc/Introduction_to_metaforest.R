## ----setup, include = FALSE---------------------------------------------------
run_everything = FALSE
knitr::opts_chunk$set(
  eval = nzchar(Sys.getenv("run_vignettes")),
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE-------------------------------------------------------------
# # Install the metaforest package. This needs to be done only once.
# install.packages("metaforest")
# # Then, load the metaforest package
# library(metaforest)
# # Assign the fukkink_lont data, which is included in
# # the metaforest package, to an object called "data"
# data <- fukkink_lont
# # Because MetaForest uses the random number generator (for bootstrapping),
# # we set a random seed so analyses can be replicated exactly.
# set.seed(62)

## ----echo = FALSE, message=FALSE----------------------------------------------
# library(metaforest)
# data <- fukkink_lont
# set.seed(62)

## ----eval = FALSE-------------------------------------------------------------
# # Run model with many trees to check convergence
# check_conv <- MetaForest(yi~.,
#                         data = data,
#                         study = "id_exp",
#                         whichweights = "random",
#                         num.trees = 20000)
# # Plot convergence trajectory
# plot(check_conv)

## ----echo = FALSE-------------------------------------------------------------
# check_conv <- readRDS("C:/Git_Repositories/S4_meta-analysis/check_conv.RData")
# plot(check_conv)

## ----eval=FALSE---------------------------------------------------------------
# # Model with 5000 trees for replication
# mf_rep <- MetaForest(yi~.,
#                         data = data,
#                         study = "id_exp",
#                         whichweights = "random",
#                         num.trees = 5000)
# # Run recursive preselection, store results in object 'preselect'
# preselected <- preselect(mf_rep,
#                          replications = 100,
#                          algorithm = "recursive")
# # Plot the results
# plot(preselected)
# # Retain only moderators with positive variable importance in more than
# # 50% of replications
# retain_mods <- preselect_vars(preselected, cutoff = .5)

## ----echo = FALSE-------------------------------------------------------------
# preselected <- readRDS("C:/Git_Repositories/S4_meta-analysis/preselected.RData")
# retain_mods <- preselect_vars(preselected, cutoff = .5)

## ----eval = FALSE-------------------------------------------------------------
# # Load the caret library
# library(caret)
# # Set up 10-fold grouped (=clustered) CV
# grouped_cv <- trainControl(method = "cv",
#                            index = groupKFold(data$id_exp, k = 10))
# 
# # Set up a tuning grid for the three tuning parameters of MetaForest
# tuning_grid <- expand.grid(whichweights = c("random", "fixed", "unif"),
#                        mtry = 2:6,
#                        min.node.size = 2:6)
# 
# # X should contain only retained moderators, clustering variable, and vi
# X <- data[, c("id_exp", "vi", retain_mods)]
# 
# # Train the model
# mf_cv <- train(y = data$yi,
#                x = X,
#                study = "id_exp", # Name of the clustering variable
#                method = ModelInfo_mf(),
#                trControl = grouped_cv,
#                tuneGrid = tuning_grid,
#                num.trees = 5000)
# # Examine optimal tuning parameters
# mf_cv$results[which.min(mf_cv$results$RMSE), ]

## ----echo = FALSE, warning=FALSE----------------------------------------------
# mf_cv <- readRDS("C:/Git_Repositories/S4_meta-analysis/mf_cv.RData")
# mf_cv$results[which.min(mf_cv$results$RMSE), ]
# # Extract R^2_{cv} for the optimal tuning parameters
# r2_cv <- mf_cv$results$Rsquared[which.min(mf_cv$results$RMSE)]

## -----------------------------------------------------------------------------
# # For convenience, extract final model
# final <- mf_cv$finalModel
# # Extract R^2_{oob} from the final model
# r2_oob <- final$forest$r.squared
# # Plot convergence
# plot(final)

## -----------------------------------------------------------------------------
# # Plot variable importance
# VarImpPlot(final)
# # Sort the variable names by importance, so that the
# # partial dependence plots will be ranked by importance
# ordered_vars <- names(final$forest$variable.importance)[
#   order(final$forest$variable.importance, decreasing = TRUE)]
# # Plot partial dependence
# PartialDependence(final, vars = ordered_vars,
#                   rawdata = TRUE, pi = .95)

