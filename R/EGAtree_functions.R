#' Function to grow an EGA tree
#'
#' Function to grow an EFA tree. Simultaneously tests parameter stability in an EFA model across multiple (categorical or continuous) covariates
#' (i.e., tests of measurement invariance).
#'
#' @param data Data frame containing only columns of the observed variables (items).
#' @param covariates Data frame containing only columns of the covariates to be tested by the tree.
#'
#' @returns . 


EGAtree <- function(data, covariates){
  tree <- networktree::networktree(nodevars = data, splitvars = covariates)
  
  if(length(unique(predict(tree, type = "node"))) > 1){
    subsets = split(data, predict(tree, type = "node"))
    ega = lapply(subsets, FUN = function(x){EGA(x)})
  } else{
    ega = EGA(data)
  }
  list(tree = tree, ega = ega)
}