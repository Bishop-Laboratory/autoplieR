autoPLIER <- function(...) {
    autoplier <- reticulate::import("autoplier.model")
    autoplier$autoPLIER(...)
}


#' AutoPLIER Fit Method
#'
#' @param x_train x_train does this thing
autoPLIER.fit <- function(ap, ...) {
    ap$fit(...)
}
