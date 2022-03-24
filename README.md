# autoplieR

[![R-CMD-check](https://github.com/Bishop-Laboratory/autoplieR/workflows/R-CMD-check/badge.svg)](https://github.com/Bishop-Laboratory/autoplieR/actions) [![codecov](https://codecov.io/gh/Bishop-Laboratory/autoplieR/branch/main/graph/badge.svg?token=WCITIA5ANM)](https://codecov.io/gh/Bishop-Laboratory/autoplieR)

R port of autoplier 

## Dev notes

To set up the dev environment for autoplieR, do the following:

1. Create a conda/mamba env from the `.yml` file in `tests/`

```shell
mamba env create -n test-autoplier -f tests/env.yml
```

2. Set your python interpreter in RStudio to use the python install in the `test-autoplier` env. If this does not give you a working install of `autoplier`, then use the `install_ap()` function from `R/utils.R`.

3. Install any other dependencies which may be missing.

