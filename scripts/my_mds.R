message("Quick session load")
wd <- "~tl3087/immunosenescence"
setwd(wd)
data_dir <- "data"
plots_dir <- "plots"
results_dir <- "results"
functions_dir <- "functions"

library(methods)

####
# Define feature and instrument channel names
markers <- c("CD16", "CD45RO", "CD20", "CD3", "CD14", "PD1", "CD27", "CD45RA", "CD8", "CD11c", "PDL1", "CD4", "CD56", "IgD")

# Data
cytof.logicle <- readRDS(file.path(results_dir, "cytof.logicle.rds"))

message("Running mds")

set.seed(123)
tictoc::tic("mds time")
mds <- scater::runMDS(
    x = t(cytof.logicle[,markers]),
    ntop = 1000
    )
tictoc::toc()

saveRDS(umap, file.path(results_dir, paste0("mds.logicle.rds")))

message("EOF")

# Your job 2527008 ("mds") has been submitted
