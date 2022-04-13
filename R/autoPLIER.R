#' AutoPLIER class
#'
#' @param n_components Number of latent variables/latent dimensions.
#' @param regval Regularization value.
#' @param learning_rate Proportion that weights are updated during training.
#' @param scaler Scaler to transform data.
#'
#' @export
autoPLIER <- function(...) {
    check_ap()
    autoplier <- reticulate::import("autoplier.model")
    autoplier$autoPLIER(...)
}



#' AutoPLIER Fit Method
#'
#' @param x_train Training dataset used to train the model.
#' @param pathways Pathways dataset.
#' @param callbacks List of callbacks to apply during training.
#' @param batch_size Fixed batch size.
#' @param maxepoch Max number of epochs.
#' @param verbose Verbosity mode. 0 = silent, 1 = progress bar,
#' 2 = one line per epoch.
#' @param valfrac Fraction of the training dataset used as validation data.
#'
#' @export
autoPLIER.fit <- function(ap, ...) {
    ap$fit(...)  # Object is modified in memory
    ap  # Returns modified object
}



#' AutoPLIER Transform Method
#'
#' @param x_predict Dataset to be transformed into the latent space.
#' @param pathways Pathways dataset.
#'
#' @export
autoPLIER.transform <- function(ap, ...) {
    ap$transform(...)
    ap
}



#' AutoPLIER Fit-Transform Method
#'
#' @param x_train Training dataset used to train the model.
#' @param pathways Pathways dataset.
#' @param callbacks List of callbacks to apply during training.
#' @param batch_size Fixed batch size.
#' @param maxepoch Max number of epochs.
#' @param verbose Verbosity mode. 0 = silent, 1 = progress bar,
#' 2 = one line per epoch.
#' @param valfrac Fraction of the training dataset used as validation data.
#'
#' @export
autoPLIER.fit_transform <- function(ap, ...) {
    ap$fit_transform(...)
    ap
}



#' AutoPLIER Get Top Pathways Method
#'
#' @param LVs List of decomposed latent variables.
#' @param n_pathways Number of pathways to retrieve.
#'
#' @export
autoPLIER.get_top_pathways <- function(ap, ...) {
    ap$get_top_pathways(...)
}



#' AutoPlIER Get Top Pathways LVs Method
#'
#' @param pathway List of pathways.
#' @param n_LVs Number of latent variables to retrieve.
#'
#' @export
autoPLIER.get_top_pathway_LVs <- function(ap, ...) {
    ap$get_top_pathway_LVs(...)
}

# TODO: Put in the rest of the methods from autoPLIER object
# TODO: Document all arguments, description, and examples
# TODO: Testthat fixture for unit testing
