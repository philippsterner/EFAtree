#' Function to grow an EFA tree
#'
#' Function to grow an EFA tree. Simultaneously tests parameter stability in an EFA model across multiple (categorical or continuous) covariates
#' (i.e., tests of measurement invariance).
#'
#' @param data Data frame containing only columns of the observed variables (items) in EFA model.
#' @param covariates Data frame containing only columns of the covariates to be tested by the tree.
#' @param model EFA model in lavaan syntax. For more details, see [lavaan::model.syntax()]
#' @param alpha Numeric. Level of significance to be used in tree. Defaults to 0.05.
#' @param maxdepth Integer. Maximum depth of tree, including the parent node. Defaults to 3.
#' @param minsize Integer. Minimum number of observations in each node. Defaults to 100.
#' @param ... Additional arguments from [partykit::mob_control()].
#' 
#' @returns An object of class `mob`. 
#' Additionally, every node of the tree contains an object of class `lavaan`, estimated by [lavaan::cfa()].
#' 
#' @details The resulting partition (i.e., tree structure) can be inspected by calling the object of class `mob` in the console. To inspect the estimated models in the nodes of the tree, use `lavaan::summary(YOUROUTPUT$node$info$object)`. You can choose different nodes by indexing, for example `lavaan::summary(YOUROUTPUT$node[1]$info$object)` shows the estimated EFA in the first ("left") node of the resulting tree.
#' 
#' @references Sterner, P., & Goretzko, D. (2023). Exploratory factor analysis trees: Evaluating measurement invariance between multiple covariates. Structural Equation Modeling: A Multidisciplinary Journal, 30, 871–886. https://doi.org/10.1080/10705511.2023.2188573
#' 
#' @references Zeileis, A., Hothorn, T., & Hornik, K. (2008). Model-based recursive partitioning. Journal of Computational and Graphical Statistics, 17, 492–514. https://doi.org/10.1198/106186008X319331

EFAtree <- function(data, covariates, model,
                     alpha = 0.05, maxdepth = 3, minsize = 100, ...) {

  lavaan_fit <- function(input) {
    function(y, x = NULL, start = NULL,
             weights = NULL, offset = NULL, ...,
             estfun = FALSE, object = FALSE) {
      sem <- cfa(model = input, data = y,
                 start = start, auto.var = TRUE, auto.efa = TRUE)
      list(
        coefficients = sem@ParTable$est,
        objfun = -as.numeric(logLik(sem)),
        estfun = if(estfun) estfun(sem) else NULL,
        object = if(object) sem else NULL
      )
    }
  }

  tree <- mob(as.formula(
    paste(
      paste(colnames(data), collapse = "+"),
      paste("~"),
      paste(colnames(covariates), collapse = "+"))),
              data = cbind(data, covariates),
              fit = lavaan_fit(model),
              control = mob_control(ytype = "data.frame", alpha = alpha,
                                    minsize = minsize, maxdepth = maxdepth,
                                    ...))

  tree
}

