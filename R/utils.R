#' Check whether AutoPLIER is installed
#'
#' @returns logical
check_ap <- function() {
    has_ap <- reticulate::py_module_available("autoplier")
    if (! has_ap) {
        stop("AutoPLIER not installed, please run 'install_ap()'")
    }
}

#' Install AutoPLIER
#'
#' @returns NULL
install_ap <- function() {
    reticulate::py_install("git+https://github.com/dmontemayor/autoplier.git@devel", pip = TRUE)
    return(NULL)
}
