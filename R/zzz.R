# global reference to scipy (will be initialized in .onLoad)
.onLoad <- function(libname, pkgname) {
    reticulate::configure_environment(package = "autoplieR", force = FALSE)

    # Global
    utils::globalVariables(".")
}
