#' Function to grow an EFA tree
#'
#' Function to grow an EFA tree. Simultaneously tests parameter stability in an EFA model across multiple (categorical or continuous) covariates
#' (i.e., tests of measurement invariance). For more details, see Sterner and Goretzko (2023) or Zeileis et al. (2008).
#'
#' @param data Data frame containing only columns of the observed variables (items) in EFA model.
#' @param covariates Data frame containing only columns of the covariates to be tested by the tree.
#' @param model EFA model in lavaan syntax.
#' @param alpha Level of significance to be used in tree. Defaults to 0.05.
#' @param maxdepth Maximum depth of tree, including the parent node. Defaults to 3.
#' @param minsize Minimum number of observations in each node. Defaults to 100.

EFAtree <- function(data, covariates, model,
                     alpha = 0.05, maxdepth = 3, minsize = 100) {

  # if(!requireNamespace(partykit))
  #   install.packages("partykit")
  #
  # if(!requireNamespace(lavaan))
  #   install.packages("lavaan")

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
                                    minsize = minsize, maxdepth = maxdepth))

  tree
}

