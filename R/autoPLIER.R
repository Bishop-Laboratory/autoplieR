#' AutoPLIER class
#'
#' Calls the constructor autoPLIER to create a model.
#'
#' @param ... Additional arguments for autoPLIER. See *details*.
#' @return A Python object called `autoplier.model.autoPLIER` that cannot be
#'   viewed.
#' @details
#' ## Additional arguments
#' * **n_components** - Number of latent variables/latent dimensions.
#' * **regval** - Regularization value. Default: `1.20E-7`.
#' * **learning_rate** - Proportion that weights are updated during training.
#'   Default: `0.0002`.
#' * **scaler** - Scaler to transform data.
#'
#' @examples
#' mod <- autoPLIER(n_components = 50)
#'
#' @export
autoPLIER <- function(...) {
    #check_ap()
    autoplier <- reticulate::import("autoplier.model")
    autoplier$autoPLIER(...)
}



#' AutoPLIER Fit Method
#'
#' Computes the mean and standard deviation for scaling of a created autoPLIER
#' model.
#'
#' @param ap AutoPLIER object.
#' @param ... Additional arguments for autoPLIER.fit. See *details*.
#' @return A Python object called `autoplier.model.autoPLIER` that cannot be
#'   viewed.
#' @details
#' ## Additional arguments
#' * **x_train** - Training dataset used to train the model.
#' * **pathways** - Pathways dataset.
#' * **callbacks** - List of callbacks to apply during training.
#' * **batch_size** - Fixed batch size. Default: `NULL`.
#' * **maxepoch** - Max number of epochs. Default: `2000`.
#' * **verbose** - Verbosity mode. 0 = silent, 1 = progress bar,
#'   2 = one line per epoch. Default: `2`.
#' * **valfrac** - Fraction of the training dataset used as validation data.
#'   Default: `0.3`.
#'
#' @examples
#' # Example datasets
#' xtrain <- read.csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#' pwy <- read.csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#'
#' # Fit the model
#' mod <- autoPLIER(n_components = 50)
#' mod <- autoPLIER.fit(mod, x_train = xtrain, pathways = pwy, maxepoch=100L, verbose = 0)
#'
#' @export
autoPLIER.fit <- function(ap, ...) {
    ap$fit(...)  # Object is modified in memory
    ap  # Returns modified object
}



#' AutoPLIER Transform Method
#'
#' Applies the fitted calculation to the created autoPLIER model.
#'
#' @param ap AutoPLIER object.
#' @param ... Additional arguments for autoPLIER.transform. See *details*.
#' @return A dataframe consisting of a number of LV columns as specified by the
#'   `n_components` in `autoPLIER()`.
#' @details
#' ## Additional arguments
#' * **x_predict** - Dataset to be transformed into the latent space.
#' * **pathways** - Pathways dataset.
#'
#' @examples
#' # Example datasets
#' xtrain <- read.csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#' pwy <- read.csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#'
#' # Fit the model
#' mod <- autoPLIER(n_components = 50)
#' mod <- autoPLIER.fit(mod, x_train = xtrain, pathways = pwy, maxepoch=100L, verbose = 0)
#'
#' # Transform
#' df_ap <- autoPLIER.transform(mod, x_predict = xtrain, pathways = pwy)
#'
#' @export
autoPLIER.transform <- function(ap, ...) {
    ap$transform(...)
}



#' AutoPLIER Fit-Transform Method
#'
#' Simultaneously fit the data and transform the autoPLIER model.
#'
#' @param ap AutoPLIER object.
#' @param ... Additional arguments for autoPLIER.fit_transform. See *details*.
#' @return A dataframe consisting of a number of LV columns as specified by the
#'   `n_components` in `autoPLIER()`.
#' @details
#' ## Additional arguments
#' * **x_train** - Training dataset used to train the model.
#' * **pathways** - Pathways dataset.
#' * **callbacks** - List of callbacks to apply during training.
#' * **batch_size** - Fixed batch size. Default: `NULL`.
#' * **maxepoch** - Max number of epochs. Default: `2000`.
#' * **verbose** - Verbosity mode. 0 = silent, 1 = progress bar,
#'   2 = one line per epoch. Default: `2`.
#' * **valfrac** - Fraction of the training dataset used as validation data.
#'   Default: `0.3`.
#'
#' @examples
#' # Example datasets
#' xtrain <- read.csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#' pwy <- read.csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#'
#' # Fit and transform
#' mod <- autoPLIER(n_components = 50)
#' df_ap <- autoPLIER.fit_transform(mod, x_train = xtrain, pathways = pwy, maxepoch=100L,
#'  verbose = 0)
#'
#' @export
autoPLIER.fit_transform <- function(ap, ...) {
    ap$fit_transform(...)

}



#' AutoPLIER Get Top Pathways Method
#'
#' Retrieve pathways most related to a list of LVs with coefficients.
#'
#' @param ap AutoPLIER object.
#' @param LVs List of decomposed latent variables in an array.
#' @param n_pathways Number of pathways to retrieve.
#' @return A list containing sub-lists for each listed LV.
#'
#' @examples
#' # Example datasets
#' xtrain <- read.csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#' pwy <- read.csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#'
#' # Fit and transform
#' mod <- autoPLIER(n_components = 50)
#' autoPLIER.fit_transform(mod, x_train = xtrain, pathways = pwy, maxepoch=100L, verbose=0)
#'
#' # Get top pathways
#' autoPLIER.get_top_pathways(mod, array(c("LV_38", "LV_30")), n_pathways = 2)
#'
#' @export
#' @importFrom dplyr %>% mutate filter rename group_by arrange
#' @importFrom dplyr desc slice_max group_split group_keys
#' @importFrom rlang .data
#' @importFrom stats setNames
#' @importFrom tibble rownames_to_column
#' @importFrom tidyr pivot_longer
autoPLIER.get_top_pathways <- function(ap, LVs, n_pathways) {
    ap$components_decomposition_ %>%
        rownames_to_column(var = "pathway") %>%
        pivot_longer(cols = -.data$pathway) %>%
        mutate(
            name = gsub(
                .data$name, pattern = "^([0-9]+)[ ]*$", replacement = "LV_\\1"
            )
        ) %>%
        filter(.data$name %in% {{ LVs }}) %>%
        rename(LV=.data$name) %>%
        group_by(.data$LV) %>%
        arrange(.data$LV, desc(.data$value)) %>%
        slice_max(order_by = .data$value, n = n_pathways) %>%
        {setNames(group_split(.), nm=group_keys(.)[[1]])} %>%
        as.list()
}



#' AutoPLIER Get Top Pathways LVs Method
#'
#' Retrieve LVs associated with a named pathway.
#'
#' @param ap AutoPLIER object.
#' @param ... Additional arguments for autoPLIER.get_top_pathway_LVs. See *details*.
#' @return Numeric object with the chosen pathway and its corresponding LVs.
#' @details
#' ## Additional arguments
#' * **pathway** - List of pathways.
#' * **n_LVs** - Number of latent variables to retrieve.
#'
#' @examples
#' # Example datasets
#' xtrain <- read.csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#' pwy <- read.csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR"),
#'  row.names = 1)
#'
#' # Fit and transform
#' mod <- autoPLIER(n_components = 50)
#' autoPLIER.fit_transform(mod, x_train = xtrain, pathways = pwy, maxepoch=100L, verbose=0)
#'
#' # Get LVs for a pathway
#' mod <- autoPLIER.get_top_pathway_LVs(mod, pathway="BIOCARTA_VDR_PATHWAY", n_LVs=2L)
#'
#' @export
autoPLIER.get_top_pathway_LVs <- function(ap, ...) {
    ap$get_top_pathway_LVs(...)
}
