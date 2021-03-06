% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/autoPLIER.R
\name{autoPLIER.fit}
\alias{autoPLIER.fit}
\title{AutoPLIER Fit Method}
\usage{
autoPLIER.fit(ap, ...)
}
\arguments{
\item{ap}{AutoPLIER object.}

\item{...}{Additional arguments for autoPLIER.fit. See \emph{details}.}
}
\value{
A Python object called \code{autoplier.model.autoPLIER} that cannot be
viewed.
}
\description{
Computes the mean and standard deviation for scaling of a created autoPLIER
model.
}
\details{
\subsection{Additional arguments}{
\itemize{
\item \strong{x_train} - Training dataset used to train the model.
\item \strong{pathways} - Pathways dataset.
\item \strong{callbacks} - List of callbacks to apply during training.
\item \strong{batch_size} - Fixed batch size. Default: \code{NULL}.
\item \strong{maxepoch} - Max number of epochs. Default: \code{2000}.
\item \strong{verbose} - Verbosity mode. 0 = silent, 1 = progress bar,
2 = one line per epoch. Default: \code{2}.
\item \strong{valfrac} - Fraction of the training dataset used as validation data.
Default: \code{0.3}.
}
}
}
\examples{
# Example datasets
xtrain <- read.csv(system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"),
 row.names = 1)
pwy <- read.csv(system.file("extdata", "pathways.csv.xz", package = "autoplieR"),
 row.names = 1)

# Fit the model
mod <- autoPLIER(n_components = 50)
mod <- autoPLIER.fit(mod, x_train = xtrain, pathways = pwy, maxepoch=100L, verbose = 0)

}
