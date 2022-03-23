# Test goes here
# Test should verify that autoPLIER class object can be successfully created

library(testthat)
test_that(
    "Can instantiate autoPLIER as an S3 class",
    {
        ap <- autoPLIER(n_components=200)
        expect_is(ap, class = "autoplier.model.autoPLIER")
    }
)

