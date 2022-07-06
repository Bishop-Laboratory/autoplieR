# autoplieR

[![R-CMD-check](https://github.com/Bishop-Laboratory/autoplieR/workflows/R-CMD-check/badge.svg)](https://github.com/Bishop-Laboratory/autoplieR/actions) [![codecov](https://codecov.io/gh/Bishop-Laboratory/autoplieR/branch/main/graph/badge.svg?token=WCITIA5ANM)](https://codecov.io/gh/Bishop-Laboratory/autoplieR)

autoplieR is the R port of autoPLIER, a Tensorflow-based model inspired by PLIER to embed Omics data into a latent space. 

## Installation

```r
# From GitHub
library(remotes)
install_github("Bishop-Laboratory/autoplieR")
```

## Quick start

```r
xtrain <- read.csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"), row.names = 1)
pwy <- read.csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR"), row.names = 1)

# Initiate autoPLIER model 
# Perform fit and transform 
mod <- autoPLIER(n_components = 100)
mod <- autoPLIER.fit(mod, x_train = xtrain, pathways = pwy, verbose = 0)
trans <- autoPLIER.transform(mod, x_predict = xtrain, pathways = pwy)

# Get pathways most associated with the LVs
top_pwys <- autoPLIER.get_top_pathways(mod, LVs = lv, n_pathways = 5)

# Get LVs most associated with a chosen pathway
top_LVs_pwys <- autoPLIER.get_top_pathway_LVs(mod, pathway = "BIOCARTA_LYM_PATHWAY", n_LVs = 5L)
```

## Dev notes

To set up the dev environment for autoplieR, do the following:

1. Create a conda/mamba env from the `.yml` file in `tests/`

```shell
mamba env create -n test-autoplier -f tests/env.yml
```

2. Set your python interpreter in RStudio to use the python install in the `test-autoplier` env. If this does not give you a working install of `autoplier`, then use the `install_ap()` function from `R/utils.R`.

3. Install any other dependencies which may be missing.

