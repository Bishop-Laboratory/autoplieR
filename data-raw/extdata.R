library(tidyverse)

## Get the metadata ##
df_metadata <- read_tsv("https://github.com/Bishop-Laboratory/autoPLIER-analysis/raw/main/data/Overmyer21/GSE157103_metadata.tsv") %>%
    dplyr::rename(sampleID=1)
# Keep patients with COVID - select 50 at random
df_metadata_filtered <- df_metadata %>%
    filter(COVID == 1)
# Write to filtered
outfile <- "inst/extdata/GSE157103_icu_metadata.csv"
write_csv(df_metadata_filtered, file = outfile)
system(paste0("xz -f ", outfile))

## Get the TPM ##
df_log1tpm <- read_tsv(
    "https://github.com/Bishop-Laboratory/autoPLIER-analysis/raw/main/data/Overmyer21/GSE157103_genes.log1tpm.tsv.gz"
) %>% dplyr::rename(sampleID=1)
# Downsample to TPM to match the metadata
df_log1tpm_matched <- df_log1tpm %>%
    filter(sampleID %in% df_metadata_filtered$sampleID) %>%
    arrange(match(sampleID, df_metadata_filtered$sampleID))
all(df_log1tpm_matched$sampleID == df_metadata_filtered$sampleID)  #Should be TRUE
# Decrease the precision to save space
df_log1tpm_small <- df_log1tpm_matched %>%
    mutate(across(.cols = where(is.numeric), signif, digits=6))
# Save to file
outfile <-  "inst/extdata/GSE157103_icu_tpm.csv"
write_csv(df_log1tpm_small, file = outfile)
system(paste0("xz -f ", outfile))

## Get the pathways ##
outfile <- "inst/extdata/pathways.csv"
download.file(
    "https://github.com/dmontemayor/autoplier/raw/devel/tests/test_data/test_pathways.csv",
    destfile = outfile
)
system(paste0("xz -f ", outfile))

