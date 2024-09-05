#' Functions to plot an EGA tree and inspect its notes
#'
#' @param treeobj Fitted EFA tree model.
#' @param node.id ID to identify a node in the tree.
#' 
#' @returns . 


EGAtree_teststats <- function(treeobj, node.id = NULL){
  if(is.null(node.id)){
    message("Hypothesis tests for full data set:")
    treeobj$tree$node$info$test
  } else{
    if(node.id <= length(treeobj$tree)){
      message(paste("Hypothesis tests in node", node.id))
      treeobj$tree[node.id]$node$info$test
    } else{
      message("Select a valid node. Hypothesis tests for full data set:")
      treeobj$tree$node$info$test
    } 
  }
}

EGAtree_splitrules <- function(treeobj, node.id = nodeids(treeobj$tree)){
  partykit:::.list.rules.party(treeobj$tree, i = node.id)
}

EGAtree_plot <- function(treeobj){
  displ <- function(info) {
    n <- info$nobs
    paste("n =", n)
  }
  partykit::plot.modelparty(treeobj$tree,
                            terminal_panel = node_terminal,
                            tp_args = list(FUN = displ))
}


EGAtree_ega <- function(treeobj, node.id){
  if(node.id %in% rownames(summary(treeobj$ega))){
    treeobj$ega[[which(node.id == rownames(summary(treeobj$ega)))]]$plot.EGA
  } else{
    message("Please select a terminal node.")
  }
}