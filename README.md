# `EFAtree` package
This is an R package to grow Exploratory Factor Analysis Trees (EFA trees)

# Installation
To download the development version from GitHub, you can use:

```javascript
install.packages("devtools")

devtools::install_github("philippsterner/EFAtree")
```

# Growing EFA trees
EFA trees test whether parameters of an EFA model are stable (i.e., invariant) across groups.
The groups are defined by a set of covariates which can be categorical or continuous.
Thus, an EFA tree tests measurement invariance across multiple covariates simultaneously and splits the data into subsamples if it finds statistically significant parameter instabilities.

The resulting models estimated in the subsamples (so called leaf nodes) can be interpreted like single-group EFA models.
The only difference is that we now know that the models are not invariant across the groups that resulted from the tree.
For example, if the tree splits the data on the covariate *age* at the value 35, we know that measurement models differ for individuals below and above 35 years.
Subsequent splits on two different covariates can be interpreted as an interaction between the covariates on which the data was split (e.g., individuals from Germany that are younger than 35 years).

The function ```EFAtree()``` needs three arguments: 
- `data`: Data frame containing only columns of the observed variables (items) in EFA model. That is, index your data frame by `data[ , ]` to select only the columns that contain the items in your EFA model.
- `covariates`: Data frame containing only columns of the covariates to be tested by the tree. That is, index your data frame by `data[ , ]` to select only the columns that contain the covariates that define the groups across which measurement invariance should be investigated.
- `model`: EFA model in lavaan syntax. Use `?lavaan::model.syntax` for more information.

Additional arguments with default values are:
- `alpha = 0.05`: Numeric. Level of significance to be used in tree (by default, Bonferroni correction is used to ensure that the chosen level of significance holds for the whole tree).
- `maxdepth = 3`: Integer. Maximum depth of tree, including the parent node.
- `minsize = 100`: Integer. Minimum number of observations in each node. Defaults to 100.
- `...`: Additional arguments from `partykit::mob_control()`. Usually, no additional arguments are needed.

The EFA tree should be stored in an object to access the models in the leaf nodes. For example:

```javascript
tree <- EFAtree(data, covariates, model)
```


Various information can be extracted from this `tree` object. Most importantly:
- `tree` returns the resulting partition, including the split covariates, split points, and parameter estimates in the nodes.
- `tree$node$info$test` returns the test statistics and p-values of the hypothesis tests in the chosen node. You can choose different nodes by indexing. For example, `tree$node[1]$info$test` returns the test results from the first ("left") node of the tree (if a test was conducted in that node).
- `tree$node$info$object` returns the model (estimated by `lavaan::cfa()`). You can inspect the lavaan output by using `lavaan::summary(tree$node$info$object)`. Again, use indexing to inspect models in different nodes.

# References
Sterner, P., & Goretzko, D. (2023). Exploratory factor analysis trees: Evaluating measurement invariance between multiple covariates. *Structural Equation Modeling: A Multidisciplinary Journal*, *30*, 871–886. https://doi.org/10.1080/10705511.2023.2188573

Zeileis, A., Hothorn, T., & Hornik, K. (2008). Model-based recursive partitioning. *Journal of Computational and Graphical Statistics*, *17*, 492–514. https://doi.org/10.1198/106186008X319331

# Note
This package is a work-in-progress. If you find bugs, please report them. If you have suggestions for improvements, I am also happy about feedback.
