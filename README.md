# `EFAtree` package
This is an R package to grow Exploratory Factor Analysis Trees (EFA trees)

# Installation
To download the development version from GitHub, you can use:

```javascript
install.packages("devtools")

devtools::install_github("philippsterner/EFAtree")
```

Cautionary note: Under the current version of `lavaan` (0.6-18), the ```EFAtree()``` function will result in an error message. 
Thus, the package currently requires `lavaan` version 0.6-17.
If loading the `EFAtree` package tells you "namespace ‘lavaan’ 0.6-18 is being loaded, but == 0.6.17 is required", you can use the following code to install the required version of `lavaan`:

```javascript
remove.packages("lavaan")

devtools::install_version("lavaan", version = "0.6-17")
```

Afterwards, restart your R session ("Session" > "Restart R") and try `library(EFAtree)` again.
As soon as the issue is fixed, we will update the instructions on here.
(Thank you to our student, Markus Dietzfelbinger, who discovered this error!)

# Growing EFA trees
EFA trees test whether parameters of an EFA model are stable (i.e., invariant) across groups.
The groups are defined by a set of covariates which can be categorical or continuous.
Thus, an EFA tree tests measurement invariance across multiple covariates simultaneously and splits the data into subsamples if it finds statistically significant parameter instabilities.

The resulting models estimated in the subsamples (so called leaf nodes) can be interpreted like single-group EFA models.
The only difference is that we now know that the models are not invariant across the groups that resulted from the tree.
For example, if the tree splits the data on the covariate *age* at the value 35, we know that measurement models differ for individuals below and above 35 years.
Subsequent splits on two different covariates can be interpreted as an interaction between the covariates on which the data was split (e.g., individuals from Germany that are younger than 35 years).

The function ```EFAtree()``` needs three arguments: 
- `data`: Data frame containing only columns of the observed variables (items) in EFA model. That is, index your data frame by `data[ ]` to select only the columns that contain the items in your EFA model.
- `covariates`: Data frame containing only columns of the covariates to be tested by the tree. That is, index your data frame by `data[ ]` to select only the columns that contain the covariates that define the groups across which measurement invariance should be investigated. (Be careful not to index by `data[ , ]` because this will return a vector if only a single covariate is selected as a potential split variable. `data[ ]` also returns single columns as data frames.)
- `model`: EFA model in lavaan syntax. Use `?lavaan::model.syntax` for more information.

Additional arguments with default values are:
- `alpha = 0.05`: Numeric. Level of significance to be used in tree (by default, Bonferroni correction is used to ensure that the chosen level of significance holds for the whole tree).
- `maxdepth = 3`: Integer. Maximum depth of tree, including the parent node.
- `minsize = 100`: Integer. Minimum number of observations in each node. Defaults to 100.
- `...`: Additional arguments from `partykit::mob_control()`. Usually, no additional arguments are needed.

# Inspecting the results

The EFA tree should be stored in an object to access the models in the leaf nodes. For example:

```javascript
tree <- EFAtree(data, covariates, model)
```

Various information can be extracted from this `tree` object by applying helper functions. Most importantly:
- `tree` returns the resulting partition, including the split covariates, split points, and parameter estimates in the nodes.
- `EFAtree::EFAtree_plot()` can be applied to the `tree` object to plot the resulting partitions.
- `EFAtree::EFAtree_teststats()` returns the test statistics and p-values of the hypothesis tests in the chosen node. You can choose different nodes. For example, `EFAtree::EFAtree_teststats(tree, node.id = 1)` returns the test results from the parent node. `EFAtree::EFAtree_teststats(tree, node.id = 2)` and `EFAtree::EFAtree_teststats(tree, node.id = 3)` return the test results of the first ("left")  and second ("right") node of the tree, respectively (if a test was conducted in that node).
- `tree$node$info$object` returns the model (estimated by `lavaan::cfa()`). You can inspect the lavaan output by using `lavaan::summary(tree$node$info$object)`. You can use indexing to inspect models in different nodes, for example `lavaan::summary(tree$node[1]$info$object)`.

More helper functions to access relevant information in the tree objects are currently under development.


# References
Sterner, P., & Goretzko, D. (2023). Exploratory factor analysis trees: Evaluating measurement invariance between multiple covariates. *Structural Equation Modeling: A Multidisciplinary Journal*, *30*, 871–886. https://doi.org/10.1080/10705511.2023.2188573

Zeileis, A., Hothorn, T., & Hornik, K. (2008). Model-based recursive partitioning. *Journal of Computational and Graphical Statistics*, *17*, 492–514. https://doi.org/10.1198/106186008X319331

# Note
This package is a work-in-progress. If you find bugs, please report them. If you have suggestions for improvements, I am also happy about feedback.
