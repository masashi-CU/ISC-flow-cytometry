fcs_to_longmat <- function(fcs) {
    library(flowCore)
    # Check flowSet
    if(class(fcs) != "flowSet"){
        stop("This is not a flowSet object.")
    }
    # flatten matrix
    mat <- matrix(
        flowCore::fsApply(fcs, flowCore::exprs),
        byrow = FALSE,
        ncol = length(flowCore::colnames(fcs)),
        dimnames = list(NULL, flowCore::colnames(fcs))
    )
    # Get metadata
    meta <- flowCore::pData(fcs)
    meta$ncells <- as.numeric(fsApply(fcs, nrow))
    # Select variables to expand
    c <- setdiff(names(meta), "ncells")
    # repeat every value x of column c ncells times
    rd <- data.frame(lapply(meta[c], function(x) {
        v <- rep(x, meta$ncells)
    }), row.names = NULL)
    rd$name <- as.factor(rd$name)
    
    # Check rownames
    if(nrow(mat) != nrow(rd)){
        stop("Matrix and metadata dimen")
    }
    return(list(mat = mat, rd = rd))
}