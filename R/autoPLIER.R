#' AutoPLIER class
#'
#' Calls the constructor autoPLIER to create a model.
#'
#' @param n_components Number of latent variables/latent dimensions.
#' @param regval Regularization value. Default: `1.20E-7`.
#' @param learning_rate Proportion that weights are updated during training.
#' Default: `0.0002`.
#' @param scaler Scaler to transform data.
#' @return A Python object called `autoplier.model.autoPLIER` that cannot be
#' viewed.
#'
#' @example
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
#' @param x_train Training dataset used to train the model.
#' @param pathways Pathways dataset.
#' @param callbacks List of callbacks to apply during training.
#' @param batch_size Fixed batch size. Default: `NULL`.
#' @param maxepoch Max number of epochs. Default: `2000`.
#' @param verbose Verbosity mode. 0 = silent, 1 = progress bar,
#' 2 = one line per epoch. Default: `2`.
#' @param valfrac Fraction of the training dataset used as validation data.
#' Default: `0.3`.
#' @return A Python object called `autoplier.model.autoPLIER` that cannot be
#' viewed.
#'
#' @example
#' # Example datasets
#' xtrain <- read_csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR")
#' pwy <- read_csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR")
#'
#' # Fit the model
#' mod <- autoPLIER.fit(mod, x_train = xtrain, pathways = pwy, verbose = 0)
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
#' @param x_predict Dataset to be transformed into the latent space.
#' @param pathways Pathways dataset.
#' @return A dataframe consisting of a number of LV columns as specified by the
#' `n_components` in `autoPLIER()`.
#'
#' @example
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
#' @param x_train Training dataset used to train the model.
#' @param pathways Pathways dataset.
#' @param callbacks List of callbacks to apply during training.
#' @param batch_size Fixed batch size. Default: `NULL`.
#' @param maxepoch Max number of epochs. Default: `2000`.
#' @param verbose Verbosity mode. 0 = silent, 1 = progress bar,
#' 2 = one line per epoch. Default: `2`.
#' @param valfrac Fraction of the training dataset used as validation data.
#' Default: `0.3`.
#' @return A dataframe consisting of a number of LV columns as specified by the
#' `n_components` in `autoPLIER()`.
#'
#' @example
#' df_ap <- autoPLIER.fit_transform(mod, x_train = xtrain, pathways = pwy, verbose = 0)
#'
#' @export
autoPLIER.fit_transform <- function(ap, mod, ...) {
    ap$fit_transform(...)

}



#' AutoPLIER Get Top Pathways Method
#'
#' Retrieve pathways most related to a list of LVs with coefficients.
#'
#' @param ap AutoPLIER object.
#' @param LVs List of decomposed latent variables.
#' @param n_pathways Number of pathways to retrieve.
#' @return A list containing sub-lists for each listed LV.
#'
#' @example
#' autoPLIER.get_top_pathways(mod, LVs = top_LVs, n_pathways = 10)
#'
#' @export
#' @importFrom dplyr %>% mutate filter rename group_by arrange
#' @importFrom dplyr desc slice_max group_split group_keys
#' @importFrom tibble rownames_to_column
#' @importFrom tidyr pivot_longer
autoPLIER.get_top_pathways <- function(ap, LVs, n_pathways) {
    ap$components_decomposition_ %>%
        rownames_to_column(var = "pathway") %>%
        pivot_longer(cols = -pathway) %>%
        mutate(
            name = gsub(
                name, pattern = "^([0-9]+)[ ]*$", replacement = "LV_\\1"
            )
        ) %>%
        filter(name %in% {{ LVs }}) %>%
        rename(LV=name) %>%
        group_by(LV) %>%
        arrange(LV, desc(value)) %>%
        slice_max(order_by = value, n = n_pathways) %>%
        {setNames(group_split(.), nm=group_keys(.)[[1]])} %>%
        as.list()
}



#' AutoPLIER Get Top Pathways LVs Method
#'
#' Retrieve LVs associated with a named pathway.
#'
#' @param ap AutoPLIER object.
#' @param pathway List of pathways.
#' @param n_LVs Number of latent variables to retrieve.
#' @return Numeric object with the chosen pathway and its corresponding LVs.
#'
#' @example
#' autoPLIER.get_top_pathway_LVs(mod, pathway="BIOCARTA_VDR_PATHWAY", n_LVs=2L)
#'
#' @export
autoPLIER.get_top_pathway_LVs <- function(ap, ...) {
    ap$get_top_pathway_LVs(...)
}

# TODO: Put in the rest of the methods from autoPLIER object
# TODO: Document all arguments, description, and examples
# TODO: Testthat fixture for unit testing
