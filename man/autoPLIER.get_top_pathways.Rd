% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/autoPLIER.R
\name{autoPLIER.get_top_pathways}
\alias{autoPLIER.get_top_pathways}
\title{AutoPLIER Get Top Pathways Method}
\usage{
autoPLIER.get_top_pathways(ap, LVs, n_pathways)
}
\arguments{
\item{ap}{AutoPLIER object.}

\item{LVs}{List of decomposed latent variables in an array.}

\item{n_pathways}{Number of pathways to retrieve.}
}
\value{
A list containing sub-lists for each listed LV.
}
\description{
Retrieve pathways most related to a list of LVs with coefficients.
}
\examples{
# Example datasets
xtrain <- read.csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"),
 row.names = 1)
pwy <- read.csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR"),
 row.names = 1)

# Fit and transform
mod <- autoPLIER(n_components = 50)
autoPLIER.fit_transform(mod, x_train = xtrain, pathways = pwy, maxepoch=100L, verbose=0)

# Get top pathways
autoPLIER.get_top_pathways(mod, array(c("LV_38", "LV_30")), n_pathways = 2)

}
