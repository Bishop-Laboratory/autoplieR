### Tests the autoPLIER object and its methods ###

# Set the conda environment
if (Sys.getenv("RETICULATE_PYTHON") == "") {
    print("SETTING ENV!")
    Sys.setenv(RETICULATE_PYTHON = "~/miniconda3/envs/test-autoplier/bin/python")
} else {
    print(Sys.getenv())
}
reticulate::use_condaenv("test-autoplier", required = TRUE)

# Libraries
library(autoplieR)
library(testthat)

# Get test data from package's extdata folder
testxfl <- system.file("extdata", "test_X.csv.xz", package = "autoplieR")
pathwayfl <- system.file("extdata", "test_pathways.csv.xz", package = "autoplieR")
x_train <- read.csv(testxfl, row.names = 1)
pathways <- read.csv(pathwayfl, row.names = 1)

# Test class
test_that(
    "Can instantiate autoPLIER as an S3 class",
    {
        ap <- autoPLIER(n_components=200)
        expect_is(ap, class = "autoplier.model.autoPLIER")
    }
)

# Test fit method
test_that(
    "Test fit",
    {
        ap <- autoPLIER(n_components=100)
        ap <- autoPLIER.fit(
            ap, x_train=x_train, pathways=pathways,
            maxepoch=100L, verbose=0
        )
        expect_is(ap, class = "autoplier.model.autoPLIER")
    }
)

