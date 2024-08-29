message("Quick session load")
wd <- "~tl3087/immunosenescence"
setwd(wd)
data_dir <- "data"
plots_dir <- "plots"
results_dir <- "results"
functions_dir <- "functions"
markers <- c("CD16", "CD45RO", "CD20", "CD3", "CD14", "PD1", "CD27", "CD45RA", "CD8", "CD11c", "PDL1", "CD4", "CD56", "IgD")
library(methods)
library(tidyverse)
library(magrittr)

message("Load data")
cytof.logicle <- readRDS(file.path(results_dir, "cytof.logicle.rds"))
cytof.logicle %<>%
    dplyr::filter(ga %in% c("non_hispanic_white", "aa", "hispanic"))

message("Binarizing matrix")
# Belonging for each cell to each cluster as 1, otherwise 0
clust <- "pg_clust"
designmat <- model.matrix(as.formula(paste0("~", clust, " + 0")), setNames(cytof.logicle[clust], clust)) # clust must be character
cytof.logicle <- cbind(designmat, cytof.logicle)
cytof.logicle$flowcyto_batch_number <- as.numeric(cytof.logicle$flowcyto_batch_number)

message("Define parallelization parameters")
options(future.globals.maxSize = 400 * 1024^3)
#future::plan("multisession", workers = 3)
future::plan("multicore", workers = 30)
#future::plan("sequential")

tictoc::tic()
message("Run models")
progressr::with_progress({
  clusters <- stringr::str_subset(colnames(cytof.logicle), clust)
  p <- progressr::progressor(steps = length(clusters))
  mod <-
    furrr::future_map(clusters, function(cluster) {
      message(paste0("\nProcessed: ", cluster))
      tryCatch(
        expr = {
          # Create formula
          full_fm <-
            as.formula(
              paste0(
                cluster,
                "~ 1 + donation_age + ga + sex + diagnosis + (1 | id) + (1 | flowcyto_batch_number)"
              )
            )
          # Run model
          full_model <- lme4::glmer(
            formula = full_fm,
            data = cytof.logicle,
            family = binomial,
            nAGQ = 1,
            verbose = 2,
            control = lme4::glmerControl(optimizer = "bobyqa")
          )
          # save model
          # saveRDS(full_model, file.path(results_dir, paste0("models/", cluster, ".rds")))
          # Return
          return(full_model)
        },
        error = function(e) {
          e
        }
      )
    }) %>%
      setNames(clusters)
})
tictoc::toc() #5334.768 sec elapsed

message("Saving list of models")
saveRDS(mod, file.path(results_dir, "pg_clust_glmer.rds"))

message("EOF")

# Your job 2527008 ("mds") has been submitted
