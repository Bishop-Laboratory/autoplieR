#' AutoPLIER class
#' @export
autoPLIER <- function(...) {
    check_ap()
    autoplier <- reticulate::import("autoplier.model")
    autoplier$autoPLIER(...)
}


#' AutoPLIER Fit Method
#'
#' @param x_train x_train does this thing
#' @export
autoPLIER.fit <- function(ap, ...) {
    ap$fit(...)  # Object is modified in memory
    ap  # Returns modified object
}

# TODO: Put in the rest of the methods from autoPLIER object
# TODO: Document all arguments, description, and examples
# TODO: Testthat fixture for unit testing
