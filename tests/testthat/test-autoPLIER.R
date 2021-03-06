### Tests the autoPLIER object and its methods ###

# Set the conda environment
if (Sys.getenv("RETICULATE_PYTHON") == "" & Sys.getenv("GHA") != "GHA") {
    print("SETTING ENV!")
    Sys.setenv(RETICULATE_PYTHON = "~/miniconda3/envs/test-autoplier/bin/python")
    reticulate::use_condaenv("test-autoplier", required = TRUE)
} else {
    print(Sys.getenv())
}

err <- try (
    autoPLIER(n_components=200)
)
if ("try-error" %in% class(err)) {
    autoplieR:::install_ap()
}

# Libraries
library(autoplieR)
library(testthat)

# Get test data from package's extdata folder
testxfl <- system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR")
pathwayfl <- system.file("extdata", "pathways.csv.xz", package = "autoplieR")
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

# Test transform method
test_that(
    "Test transform",
    {
        ap <- autoPLIER(n_components=100)
        ap <- autoPLIER.fit(
            ap, x_train=x_train, pathways=pathways,
            maxepoch=100L, verbose=0
        )
        ap <- autoPLIER.transform(
            ap, x_predict=x_train, pathways=pathways
        )
        expect_type(ap, type = "list")
    }
)

# Test fit_transform method
test_that(
    "Test fit_transform",
    {
        ap <- autoPLIER(n_components=100)
        ap <- autoPLIER.fit_transform(
            ap, x_train=x_train, pathways=pathways,
            maxepoch=100L, verbose=0, valfrac=.3
        )
        expect_type(ap, type = "list")
    }
)

# Test get_top_pathways method
test_that(
    "Test get_top_pathways",
    {
        ap <- autoPLIER(n_components=100)
        autoPLIER.fit_transform(
            ap, x_train=x_train, pathways=pathways,
            maxepoch=100L, verbose=0, valfrac=.3
        )
        ap <- autoPLIER.get_top_pathways(
            ap, n_pathways=5, LVs=array(c("LV_38", "LV_30"))
        )
        expect_type(ap, type = "list")
    }
)

# Test get_top_pathway_LVs method
test_that(
    "Test get_top_pathway_LVs",
    {
        ap <- autoPLIER(n_components=100)
        autoPLIER.fit_transform(
            ap, x_train=x_train, pathways=pathways,
            maxepoch=100L, verbose=0, valfrac=.3
        )
        ap <- autoPLIER.get_top_pathway_LVs(
            ap, pathway="BIOCARTA_VDR_PATHWAY", n_LVs=2L
        )
        expect_type(ap, type = "double")
    }
)
