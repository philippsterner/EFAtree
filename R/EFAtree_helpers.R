#' Functions to plot an EFA tree and inspect its notes
#'
#' @param treeobj Fitted EFA tree model.
#' @param node.id ID to identify a node in the tree.
#' 
#' @returns . 
#' 
#' @references Sterner, P., & Goretzko, D. (2023). Exploratory factor analysis trees: Evaluating measurement invariance between multiple covariates. Structural Equation Modeling: A Multidisciplinary Journal, 30, 871–886. https://doi.org/10.1080/10705511.2023.2188573
#' 
#' @references Zeileis, A., Hothorn, T., & Hornik, K. (2008). Model-based recursive partitioning. Journal of Computational and Graphical Statistics, 17, 492–514. https://doi.org/10.1198/106186008X319331

EFAtree_plot <- function(treeobj){
  displ <- function(info) {
    n <- info$nobs
    paste("n =", n)
  }
  partykit::plot.modelparty(treeobj,
                            terminal_panel = node_terminal,
                            tp_args = list(FUN = displ))
}

EFAtree_splitrules <- function(treeobj, node.id = nodeids(treeobj)){
  partykit:::.list.rules.party(treeobj, i = node.id)
}

EFAtree_teststats <- function(treeobj, node.id = NULL){
  if(is.null(node.id)){
    message("Hypothesis tests for full data set:")
    treeobj$node$info$test
  } else{
    if(node.id <= length(treeobj)){
      message(paste("Hypothesis tests in node", node.id))
      treeobj[node.id]$node$info$test
    } else{
      message("Select a valid node. Hypothesis tests for full data set:")
      treeobj$node$info$test
    } 
  }
}

