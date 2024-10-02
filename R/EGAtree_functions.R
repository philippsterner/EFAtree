#' Function to grow an EGA tree
#'
#' Function to grow an EFA tree. Simultaneously tests parameter stability in an EFA model across multiple (categorical or continuous) covariates
#' (i.e., tests of measurement invariance).
#'
#' @param data Data frame containing only columns of the observed variables (items).
#' @param covariates Data frame containing only columns of the covariates to be tested by the tree.
#' @param ... additional arguments passed to [mob_control] (mob) or [ctree_control] (ctree).
#'
#' @returns A list containing: an object of class `mob` and a list as returned by [EGAnet::EGA()]. 
#' 
#' @references Goretzko, D., & Sterner, P. (2024). Exploratory Graph Analysis Trees - A Network-based Approach to Investigate Measurement Invariance with Numerous Covariates. https://doi.org/10.31234/osf.io/9cx8z
#' 
#' @references Jones, P.J., Mair, P., Simon, T., & Zeileis, A. (2020) Network Trees: A Method for Recursively Partitioning Covariance Structures. Psychometrika, 85, 926–945. https://doi.org/10.1007/s11336-020-09731-4
#' 
#' @references Golino, H., & Christensen, A. P. (2024). EGAnet: Exploratory Graph Analysis – A framework for estimating the number of dimensions in multivariate data using network psychometrics. https://doi.org/10.32614/CRAN.package.EGAnet


EGAtree <- function(data, covariates, ...){
  tree <- networktree::networktree(nodevars = data, splitvars = covariates, ...)
  
  if(length(unique(predict(tree, type = "node"))) > 1){
    subsets = split(data, predict(tree, type = "node"))
    ega = lapply(subsets, FUN = function(x){EGA(x)})
  } else{
    ega = EGA(data)
  }
  list(tree = tree, ega = ega)
}