
message("Quick session load")
wd <- "~tl3087/immunosenescence"
setwd(wd)
data_dir <- "data"
plots_dir <- "plots"
results_dir <- "results"
functions_dir <- "functions"

library(methods)
library(ggplot2)

theme_set(theme_classic())
theme_update(
  axis.text = element_text(size = 20), # change font size of axis text
  axis.title = element_text(size = 20), # change font size of axis titles
  legend.text = element_text(size = 20), # change font size of legend text
  legend.title = element_text(size = 20) # change font size of legend title
)
####
# Define feature and instrument channel names
markers <- c("CD16", "CD45RO", "CD20", "CD3", "CD14", "PD1", "CD27", "CD45RA", "CD8", "CD11c", "PDL1", "CD4", "CD56", "IgD")
instrument.chan <- c("FSCA", "FSCH", "FSCW", "SSCA", "SSCH", "SSCW", "LD", "Time")
covs <- c("diagnosis", "flowcyto_batch_number", "experimental_batch_number", "cohort", "race", "sex", "ethnicity", "donation_age")

# Data
cytof.logicle <- readRDS(file.path(results_dir, "cytof.logicle.rds"))

message("Running umap")

tictoc::tic("umap time")
umap <- umap::umap(
  d = cytof.logicle[,markers],
  method = "naive",
  random_state=123,
  verbose = TRUE
)
tictoc::toc()
saveRDS(umap, file.path(results_dir, paste0("umap.logicle.umap.rds")))
data.frame(UMAP1 = umap[, 1], UMAP2 = umap[, 2]) %>%
ggplot(aes(x = UMAP1, y = UMAP2)) +
scattermore::geom_scattermore()
ggsave(file.path(plots_dir, "umap_logicle_umap.png"))

message("EOF")

#  2527004
