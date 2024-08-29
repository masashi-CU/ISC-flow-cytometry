mat_to_flowset <- function(mat, markers, id, pheno=NULL){
    # Load libraries
    library(flowCore)
    library(purrr)
    library(dplyr)
    library(tibble)
    
    # Extract sample ID
    ids <- as.character(unique(mat[[id]]))
    
    # Select cells from each sample and return only the markers
    flowframes <- purrr::map(ids, ~ flowCore::flowFrame(exprs = as.matrix(mat[mat[[id]] == .x, colnames(mat) %in% markers]))) %>%
        setNames(ids)
    
    # Create flowset
    if (is.null(pheno)){
        flowset <- flowCore::flowSet(flowframes)
    } else if (all(pheno %in% colnames(mat))) {
        # Construct df of ids x pheno
        suppressMessages(
            phenodf <- mat %>%
                dplyr::group_by(id) %>%
                dplyr::slice(1L) %>%
                dplyr::select(dplyr::all_of(covs)) %>%
                dplyr::ungroup() %>%
                tibble::column_to_rownames(id)
        )
        flowset <- flowCore::flowSet(flowframes)
        flowCore::pData(flowset) <- phenodf
    } else{
        stop("Not all pheno are columns of mat")
    }
    return(flowset)
}