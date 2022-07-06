## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(tidy = FALSE, 
                      cache = FALSE,
                      message = FALSE,
                      error = FALSE,
                      warning = FALSE,
                      fig.align = "center")

## ----quickstart, eval=FALSE---------------------------------------------------
#  mod <- autoPLIER(n_components = 100)
#  fit <- autoPLIER.fit(x_train = xtrain, pathways = pwy, verbose = 0)
#  trans <- autoPLIER.transform(x_predict = xtrain, pathways = pwy)
#  
#  # Get pathways most associated with the LVs
#  top_pwys <- autoPLIER.get_top_pathways(LVs = lv, n_pathways = 5)
#  
#  # Get LVs most associated with a chosen pathway
#  top_LVs_pwys <- autoPLIER.get_top_pathway_LVs(pathway = "HALLMARK_MYC_TARGETS_V2", n_LVs = 5)

## ----library------------------------------------------------------------------
library(autoplieR)
library(glmnet)
library(caret)
library(tidyverse)
library(msigdbr)

## ----data---------------------------------------------------------------------
# Load pathways data
pathways <- msigdbr(category = "H") %>% 
    select(gs_name, gene_symbol) %>% 
    mutate(value=1) %>% 
    distinct() %>% 
    pivot_wider(
        id_cols = gs_name, names_from = gene_symbol,
        values_from = value, values_fill = 0
    ) %>% 
    column_to_rownames("gs_name")

# Get TPM data
metadata <- read_csv(
    system.file("extdata", "GSE157103_icu_metadata.csv.xz", package = "autoplieR"), 
    show_col_types = FALSE
) %>% rename(sampleID=1)
tpm <- read_csv(
    system.file("extdata", "GSE157103_icu_tpm.csv.xz", package = "autoplieR"), 
    show_col_types = FALSE
) %>% rename(sampleID=1)

## ----build_model--------------------------------------------------------------
# Create a model
ap <- autoPLIER(n_components = 50, learning_rate = 0.000001)

## ----fit_and_transform--------------------------------------------------------
# Fit model
ap <- autoPLIER.fit(ap, x_train = column_to_rownames(tpm, var = "sampleID"), pathways = pathways, verbose = 0)

# Transform the new data
df_ap <- autoPLIER.transform(ap, x_predict = column_to_rownames(tpm, var = "sampleID"), pathways = pathways)
colnames(df_ap) <- paste0("LV_", gsub(colnames(df_ap), pattern = " ", replacement = ""))

## ----pca_plots, fig.dim = c(6, 4)---------------------------------------------
# Compute TSNE
pca_res <- prcomp(df_ap, scale. = TRUE)

# Index and bind metadata for 'COVID' and 'ICU_1'
df_pca <- as.data.frame(pca_res$x[,1:2])
rownames(df_pca) <- rownames(df_ap)

df_plot <- df_pca %>%
    rownames_to_column(var="sampleID") %>% 
    as_tibble() %>% 
    inner_join(metadata) %>% 
    mutate(
        COVID=as.factor(COVID),
        ICU=as.factor(ICU_1)
    )

# Plot for ICU and non-ICU
ggplot(df_plot, aes(x = PC1, y = PC2, color = ICU)) +
    geom_point() +
    theme_bw()

## ----log_mod, fig.dim = c(8, 4)-----------------------------------------------
# Fit model 
log_lambda_grid <- seq(0, -20, length=200) 
lambda_grid <- 10^log_lambda_grid
icu <- metadata %>% 
    filter(COVID == 1) %>% 
    pull(ICU_1)
lr_model <- cv.glmnet(
    as.matrix(df_ap), icu, alpha = 1, 
    family = "binomial", type.measure='class', lambda = lambda_grid
)

plot(lr_model)

## ----lambda-------------------------------------------------------------------
# Select the best lambda
lambda <- lr_model$lambda[which.min(lr_model$cvm)]

## ----final_log_mod------------------------------------------------------------
# Build the logistic model
lr_final <- glmnet(
    df_ap, icu, alpha = 1,
    family = "binomial", type.measure='class', lambda = lambda
)

## -----------------------------------------------------------------------------
pred <- predict(lr_final, as.matrix(df_ap), type="class")

# Show the confusion matrix
pred %>% 
    as.data.frame() %>% 
    rownames_to_column("sampleID") %>% 
    as_tibble() %>% 
    rename(pred_icu=s0) %>% 
    mutate(icu=icu, pred_icu=as.numeric(pred_icu)) %>% 
    group_by(pred_icu, icu) %>% 
    tally() %>%
    pivot_wider(
        id_cols = pred_icu, names_from = icu, 
        values_from = n, names_prefix = "Real: "
    ) %>% 
    mutate(pred_icu = paste0("Predicted: ", pred_icu)) %>% 
    column_to_rownames("pred_icu")

## ----  fig.height=5, fig.width=5----------------------------------------------
# Get the coefficients
coeffs <- coef(lr_final)

# Analyze the LVs in the coefs
coefs_tidy <- coeffs %>% 
    as.matrix() %>% 
    as.data.frame() %>% 
    rownames_to_column("LV") %>% 
    as_tibble() %>% 
    arrange(desc(s0)) %>% 
    filter(abs(s0) != 0, LV != "(Intercept)") %>% 
    rename(Weight=s0) %>% 
    mutate(LV = factor(LV, levels = unique(.$LV)))
    
# Plot the LVs and their coefs
ggplot(coefs_tidy, aes(x = LV, y = Weight, fill=Weight)) +
    geom_col(color="black", size = .15) +
    coord_flip() +
    xlab(NULL) +
    theme_bw(base_size = 13) +
    theme(axis.text.y = element_text(size = 10), legend.position = "none") +
    ylab("Coefficient weight (association with ICU)") +
    xlab("Non-Zero Latent variables (LVs)") +
    ggtitle("LV weights for prediction of ICU status") +
    scale_fill_distiller(type="div", palette="RdBu") 

## ----LVs, fig.dim = c(8, 5)---------------------------------------------------
# Retrieve LVs associated with being in the ICU
top_LVs <- coefs_tidy %>% slice_max(order_by = Weight, n = 5)
top_pos_LVs_pwys <- autoPLIER.get_top_pathways(ap, LVs = top_LVs$LV, n_pathways = 10)

top_pos_LVs_pwys %>%
    bind_rows() %>%
    mutate(LV = as.factor(LV)) %>%
    ggplot(., aes(value, pathway, fill = value)) + 
    facet_grid(LV ~ ., scales = "free_y") + 
    geom_col(color = "black", size = .05) + 
    theme_minimal(base_size = 8) + theme(legend.position = "none") +
    ggtitle("Pathways corresponding to LVs associated with ICU") +
    scale_fill_distiller(type="div", palette="RdBu") 

# Retrieve LVs associated with not being in the ICU
top_neg_LVs <- coefs_tidy %>% slice_min(order_by = Weight, n = 5)
top_neg_LVs_pwys <- autoPLIER.get_top_pathways(ap, LVs = top_neg_LVs$LV, n_pathways = 10)

top_neg_LVs_pwys %>%
    bind_rows() %>%
    mutate(LV = as.factor(LV)) %>%
    ggplot(., aes(value, pathway, fill = value)) + 
    facet_grid(LV ~ ., scales = "free_y") + 
    geom_col(color = "black", size = .05) + 
    theme_minimal(base_size = 8) + theme(legend.position = "none") +
    ggtitle("Pathways corresponding to LVs associated with non-ICU") +
    scale_fill_distiller(type="div", palette="RdBu") 

## -----------------------------------------------------------------------------
sessionInfo()

