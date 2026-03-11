# =============================================================================
# Advanced Analytics & Machine Learning — R Programming
# Author: Mohammed Nayeem Agadi
# Date: May 2024
# Description: Full analysis pipeline — Data Loading, Cleaning, Lasso, GAM, SVM
# =============================================================================

# -----------------------------------------------------------------------------
# SECTION 0: Load Libraries
# -----------------------------------------------------------------------------
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(dplyr)
library(glmnet)
library(mgcv)
library(e1071)
library(caret)
library(pROC)
library(kableExtra)

# -----------------------------------------------------------------------------
# SECTION A1: Data Loading and Statistical Summary
# -----------------------------------------------------------------------------

# Load dataset
data <- read.csv("student_merge_platform_business_file_final15.csv")

# View structure and summary
str(data)
summary(data)
head(data)

# Check null/incomplete cases
sum(!complete.cases(data))

# Check NA values per column
na_count <- sapply(data, function(x) sum(is.na(x)))
na_count

# Check number of zeros per column
zero_count <- sapply(data, function(x) sum(x == 0, na.rm = TRUE))
zero_count

# Combine into a readable data frame
counts_df <- data.frame(Column = names(data), NA_Count = na_count, Zero_Count = zero_count)
counts_df

# Formatted table
counts_df %>%
  kable("html") %>%
  kable_styling(bootstrap_options = c("striped", "hover"))

# -----------------------------------------------------------------------------
# SECTION A2: Data Cleaning — Creating Cleaned Dataset and Comparison
# -----------------------------------------------------------------------------

# Remove rows with zeros or NAs
data_cleaned <- data %>%
  mutate(across(everything(), ~ ifelse(. == 0, NA, .))) %>%
  drop_na()

cat("Original Data Dimensions:", dim(data), "\n")
cat("Cleaned Data Dimensions:", dim(data_cleaned), "\n")

# Density Plots for Scores — Original vs Cleaned
p9 <- ggplot(data, aes(x = score, fill = "Original")) +
  geom_density(alpha = 0.5, fill = "blue") +
  ggtitle("Density Plot of Scores - Original Dataset")

p10 <- ggplot(data_cleaned, aes(x = score, fill = "Cleaned")) +
  geom_density(alpha = 0.5, fill = "green") +
  ggtitle("Density Plot of Scores - Cleaned Dataset")

grid.arrange(p9, p10, ncol = 2)

# Scatter Plots: Review Count vs Score
p11 <- ggplot(data, aes(x = review_count, y = score)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  ggtitle("Review Count vs. Score - Original Dataset") +
  xlab("Review Count") + ylab("Score")

p12 <- ggplot(data_cleaned, aes(x = review_count, y = score)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", color = "darkgreen", se = FALSE) +
  ggtitle("Review Count vs. Score - Cleaned Dataset") +
  xlab("Review Count") + ylab("Score")

grid.arrange(p11, p12, ncol = 2)

# Bar Plots: CEO Gender Distribution
p13 <- ggplot(data, aes(x = Gender)) +
  geom_bar(fill = "coral") +
  ggtitle("Distribution of CEO Gender - Original Dataset") +
  xlab("Gender") + ylab("Count")

p14 <- ggplot(data_cleaned, aes(x = Gender)) +
  geom_bar(fill = "purple") +
  ggtitle("Distribution of CEO Gender - Cleaned Dataset") +
  xlab("Gender") + ylab("Count")

grid.arrange(p13, p14, ncol = 2)

# -----------------------------------------------------------------------------
# SECTION A2b: Variable Type Conversion
# -----------------------------------------------------------------------------

data <- data %>%
  mutate(
    Platform = as.factor(Platform),
    business_id = as.factor(business_id),
    city = as.factor(city),
    state = as.factor(state),
    postal_code = as.factor(postal_code),
    Gender = as.factor(Gender),
    CEO_sch_cat = as.factor(CEO_sch_cat),
    CEO_grd_yr = as.factor(CEO_grd_yr),
    field_cat = as.factor(field_cat),
    `ZIP.Code` = as.factor(`ZIP.Code`),
    Business_ID_other = as.factor(Business_ID_other),
    Rural_metropolitan_Desc = as.factor(Rural_metropolitan_Desc),
    Tot_Clms_Services = as.integer(Tot_Clms_Services),
    Brnd_Tot_Clms_Services = as.integer(Brnd_Tot_Clms_Services),
    Gnrc_Tot_Clms_Services = as.integer(Gnrc_Tot_Clms_Services),
    Othr_Tot_Clms_Services = as.integer(Othr_Tot_Clms_Services),
    LIS_Tot_Clms_Services = as.integer(LIS_Tot_Clms_Services),
    Opioid_Tot_Clms_Services = as.integer(Opioid_Tot_Clms_Services),
    Antbtc_Tot_Clms_Services = as.integer(Antbtc_Tot_Clms_Services),
    review_count = as.integer(review_count)
  )

# -----------------------------------------------------------------------------
# SECTION A2c: Missing Value Imputation
# -----------------------------------------------------------------------------

# Helper: mode function
get_mode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Impute numeric columns with mean
data <- data %>%
  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .)))

# Impute categorical columns with mode
data <- data %>%
  mutate(across(where(is.factor), ~ifelse(is.na(.), get_mode(.), .)))

# -----------------------------------------------------------------------------
# SECTION A3: Subsetting Data into 3 Subsets (800 rows each)
# -----------------------------------------------------------------------------

# Take first 2400 rows
data_subset <- data[1:2400, ]
print(dim(data_subset))

# Set seed and binarise score: 0 = high rating (>3), 1 = low rating (<=3)
set.seed(7)
data_subset$score <- if_else(data_subset$score > 3, 0, 1)

# Shuffle indices
indices <- sample(1:nrow(data_subset))
subset_size <- nrow(data_subset) / 3

# Create three equal subsets
subset_1 <- data_subset[indices[1:subset_size], ]
subset_2 <- data_subset[indices[(subset_size + 1):(2 * subset_size)], ]
subset_3 <- data_subset[indices[(2 * subset_size + 1):(3 * subset_size)], ]

print(dim(subset_1)); print(dim(subset_2)); print(dim(subset_3))

# Convert variables to factors in all subsets
convert_vars <- function(df) {
  df %>% mutate(
    Platform = as.factor(Platform),
    business_id = as.factor(business_id),
    city = as.factor(city),
    state = as.factor(state),
    postal_code = as.factor(postal_code),
    Gender = as.factor(Gender),
    CEO_sch_cat = as.factor(CEO_sch_cat),
    CEO_grd_yr = as.factor(CEO_grd_yr),
    field_cat = as.factor(field_cat),
    `ZIP.Code` = as.factor(`ZIP.Code`),
    Business_ID_other = as.factor(Business_ID_other),
    Rural_metropolitan_Desc = as.factor(Rural_metropolitan_Desc),
    Tot_Clms_Services = as.integer(Tot_Clms_Services),
    Brnd_Tot_Clms_Services = as.integer(Brnd_Tot_Clms_Services),
    Gnrc_Tot_Clms_Services = as.integer(Gnrc_Tot_Clms_Services),
    Othr_Tot_Clms_Services = as.integer(Othr_Tot_Clms_Services),
    LIS_Tot_Clms_Services = as.integer(LIS_Tot_Clms_Services),
    Opioid_Tot_Clms_Services = as.integer(Opioid_Tot_Clms_Services),
    Antbtc_Tot_Clms_Services = as.integer(Antbtc_Tot_Clms_Services),
    review_count = as.integer(review_count),
    score = as.factor(score)
  )
}

subset_1 <- subset_2 <- subset_3 <- convert_vars(data_subset)

# Remove single-level factor variables from each subset
remove_single_level_factors <- function(df) {
  factor_vars <- sapply(df, is.factor)
  to_keep <- sapply(df[factor_vars], function(x) length(unique(x)) > 1)
  problematic_vars <- names(to_keep[to_keep == FALSE])
  if (length(problematic_vars) > 0) df[problematic_vars] <- NULL
  df
}

subset_1 <- remove_single_level_factors(subset_1)
subset_2 <- remove_single_level_factors(subset_2)
subset_3 <- remove_single_level_factors(subset_3)

# =============================================================================
# SECTION B: LASSO REGRESSION
# =============================================================================

# ---- Lasso — Subset 1 -------------------------------------------------------
x1 <- model.matrix(score ~ ., data = subset_1)[, -1]
y1 <- subset_1$score

set.seed(321)
train_indices_1 <- sample(seq_len(nrow(x1)), size = floor(0.8 * nrow(x1)))
test_indices_1 <- setdiff(seq_len(nrow(x1)), train_indices_1)

x_train_1 <- x1[train_indices_1, ]; y_train_1 <- y1[train_indices_1]
x_test_1 <- x1[test_indices_1, ];  y_test_1 <- y1[test_indices_1]

grid_1 <- 10^seq(10, -2, length = 100)
lasso_mod_1 <- glmnet(x_train_1, y_train_1, alpha = 1, lambda = grid_1, family = "binomial")
cv_lasso_mod_1 <- cv.glmnet(x_train_1, y_train_1, alpha = 1, family = "binomial")
plot(cv_lasso_mod_1)

best_lambda_1 <- cv_lasso_mod_1$lambda.min
predictions_1 <- predict(cv_lasso_mod_1, newx = x_test_1, s = "lambda.min", type = "response")
predicted_classes_1 <- ifelse(predictions_1 > 0.5, 1, 0)

accuracy_1 <- mean(predicted_classes_1 == y_test_1)
cat("Lasso Subset 1 Accuracy:", accuracy_1, "\n")

conf_matrix_1 <- confusionMatrix(as.factor(predicted_classes_1), as.factor(y_test_1))
print(conf_matrix_1)

roc_obj_1 <- roc(response = y_test_1, predictor = as.numeric(predictions_1))
plot(roc_obj_1, main = "ROC Curve for Lasso Regression - Subset 1")
cat("AUC Subset 1:", auc(roc_obj_1), "\n")

plot(cv_lasso_mod_1$glmnet.fit, xvar = "lambda", label = TRUE)

# Top 17 Predictors — Subset 1
non_zero_coefs_1 <- coef(cv_lasso_mod_1, s = "lambda.min")
coef_df_1 <- as.data.frame(as.matrix(non_zero_coefs_1))
coef_df_1$Predictor <- rownames(coef_df_1)
rownames(coef_df_1) <- NULL
coef_df_1 <- coef_df_1[-1, , drop = FALSE]
coef_df_1 <- coef_df_1[order(abs(coef_df_1$s1), decreasing = TRUE), ]
top17_predictors_1 <- head(coef_df_1, 17)
print(top17_predictors_1)

ggplot(top17_predictors_1, aes(x = reorder(Predictor, s1), y = s1, fill = Predictor)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 12)) +
  labs(x = "Variable", y = "Coefficient", title = "Top 17 Predictor Variables - Subset 1")

# ---- Lasso — Subset 2 -------------------------------------------------------
x2 <- model.matrix(score ~ ., data = subset_2)[, -1]
y2 <- subset_2$score

set.seed(321)
train_indices_2 <- sample(seq_len(nrow(x2)), size = floor(0.8 * nrow(x2)))
test_indices_2 <- setdiff(seq_len(nrow(x2)), train_indices_2)

x_train_2 <- x2[train_indices_2, ]; y_train_2 <- y2[train_indices_2]
x_test_2 <- x2[test_indices_2, ];  y_test_2 <- y2[test_indices_2]

grid_2 <- 10^seq(10, -2, length = 100)
lasso_mod_2 <- glmnet(x_train_2, y_train_2, alpha = 1, lambda = grid_2, family = "binomial")
cv_lasso_mod_2 <- cv.glmnet(x_train_2, y_train_2, alpha = 1, family = "binomial")
plot(cv_lasso_mod_2)

best_lambda_2 <- cv_lasso_mod_2$lambda.min
predictions_2 <- predict(cv_lasso_mod_2, newx = x_test_2, s = "lambda.min", type = "response")
predicted_classes_2 <- ifelse(predictions_2 > 0.5, 1, 0)

accuracy_2 <- mean(predicted_classes_2 == y_test_2)
cat("Lasso Subset 2 Accuracy:", accuracy_2, "\n")

conf_matrix_2 <- confusionMatrix(as.factor(predicted_classes_2), as.factor(y_test_2))
print(conf_matrix_2)

roc_obj_2 <- roc(response = y_test_2, predictor = as.numeric(predictions_2))
plot(roc_obj_2, main = "ROC Curve for Lasso Regression - Subset 2")
cat("AUC Subset 2:", auc(roc_obj_2), "\n")

non_zero_coefs_2 <- coef(cv_lasso_mod_2, s = "lambda.min")
coef_df_2 <- as.data.frame(as.matrix(non_zero_coefs_2))
coef_df_2$Predictor <- rownames(coef_df_2)
rownames(coef_df_2) <- NULL
coef_df_2 <- coef_df_2[-1, , drop = FALSE]
coef_df_2 <- coef_df_2[order(abs(coef_df_2$s1), decreasing = TRUE), ]
top5_predictors_2 <- head(coef_df_2, 20)

ggplot(top5_predictors_2, aes(x = reorder(Predictor, s1), y = s1, fill = Predictor)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 12)) +
  labs(x = "Variable", y = "Coefficient", title = "Top Predictor Variables - Subset 2")

# ---- Lasso — Subset 3 -------------------------------------------------------
x3 <- model.matrix(score ~ ., data = subset_3)[, -1]
y3 <- subset_3$score

set.seed(15)
train_indices_3 <- sample(seq_len(nrow(x3)), size = floor(0.8 * nrow(x3)))
test_indices_3 <- setdiff(seq_len(nrow(x3)), train_indices_3)

x_train_3 <- x3[train_indices_3, ]; y_train_3 <- y3[train_indices_3]
x_test_3 <- x3[test_indices_3, ];  y_test_3 <- y3[test_indices_3]

grid_3 <- 10^seq(10, -2, length = 100)
lasso_mod_3 <- glmnet(x_train_3, y_train_3, alpha = 1, lambda = grid_3, family = "binomial")
cv_lasso_mod_3 <- cv.glmnet(x_train_3, y_train_3, alpha = 1, family = "binomial")
plot(cv_lasso_mod_3)

best_lambda_3 <- cv_lasso_mod_3$lambda.min
predictions_3 <- predict(cv_lasso_mod_3, newx = x_test_3, s = "lambda.min", type = "response")
predicted_classes_3 <- ifelse(predictions_3 > 0.5, 1, 0)

accuracy_3 <- mean(predicted_classes_3 == y_test_3)
cat("Lasso Subset 3 Accuracy:", accuracy_3, "\n")

conf_matrix_3 <- confusionMatrix(as.factor(predicted_classes_3), as.factor(y_test_3))
print(conf_matrix_3)

roc_obj_3 <- roc(response = y_test_3, predictor = as.numeric(predictions_3))
plot(roc_obj_3, main = "ROC Curve for Lasso Regression - Subset 3")
cat("AUC Subset 3:", auc(roc_obj_3), "\n")

non_zero_coefs_3 <- coef(cv_lasso_mod_3, s = "lambda.min")
coef_df_3 <- as.data.frame(as.matrix(non_zero_coefs_3))
coef_df_3$Predictor <- rownames(coef_df_3)
rownames(coef_df_3) <- NULL
coef_df_3 <- coef_df_3[-1, , drop = FALSE]
coef_df_3 <- coef_df_3[order(abs(coef_df_3$s1), decreasing = TRUE), ]
top5_predictors_3 <- head(coef_df_3, 20)

ggplot(top5_predictors_3, aes(x = reorder(Predictor, s1), y = s1, fill = Predictor)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 12)) +
  labs(x = "Variable", y = "Coefficient", title = "Top Predictor Variables - Subset 3")

# =============================================================================
# SECTION C: GENERALISED ADDITIVE MODELS (GAM)
# =============================================================================

# ---- GAM — Subset 1 ---------------------------------------------------------
var_to_fac_1 <- c("field_cat", "business_id", "CEO_grd_yr", "CEO_sch_cat", "ZIP.Code", "city", "Business_ID_other", "score")
subset_1[var_to_fac_1] <- lapply(subset_1[var_to_fac_1], factor)

set.seed(7)
index <- createDataPartition(subset_1$score, p = 0.8, list = TRUE, times = 1)
GAM_train_data_1 <- subset_1[index[[1]], ]
GAM_test_data_1  <- subset_1[-index[[1]], ]

GAM_train_data_1[var_to_fac_1] <- lapply(GAM_train_data_1[var_to_fac_1], factor)
GAM_test_data_1[var_to_fac_1] <- lapply(var_to_fac_1, function(var_name) {
  factor(GAM_test_data_1[[var_name]], levels = levels(GAM_train_data_1[[var_name]]))
})

GAM_gam_model_1 <- gam(score ~ field_cat + CEO_grd_yr + CEO_sch_cat + city,
                        data = GAM_train_data_1, family = binomial)
GAM_predictions_1 <- predict(GAM_gam_model_1, GAM_test_data_1, type = "response")
GAM_predicted_class_1 <- ifelse(GAM_predictions_1 > 0.5, 1, 0)

GAM_confusion_matrix_1 <- confusionMatrix(factor(GAM_predicted_class_1), GAM_test_data_1$score)
GAM_accuracy_1 <- GAM_confusion_matrix_1$overall['Accuracy']
precision_1 <- GAM_confusion_matrix_1$byClass['Precision']
recall_1 <- GAM_confusion_matrix_1$byClass['Recall']
F1_1 <- 2 * (precision_1 * recall_1) / (precision_1 + recall_1)

cat("GAM Subset 1 — Accuracy:", GAM_accuracy_1, "| Precision:", precision_1,
    "| Recall:", recall_1, "| F1:", F1_1, "\n")

# ---- GAM — Subset 2 ---------------------------------------------------------
var_to_fac_2 <- c("field_cat", "business_id", "CEO_grd_yr", "CEO_sch_cat", "ZIP.Code", "city", "Business_ID_other", "score")
subset_2[var_to_fac_2] <- lapply(subset_2[var_to_fac_2], factor)

set.seed(7)
index <- createDataPartition(subset_2$score, p = 0.8, list = TRUE, times = 1)
GAM_train_data_2 <- subset_2[index[[1]], ]
GAM_test_data_2  <- subset_2[-index[[1]], ]

GAM_train_data_2[var_to_fac_2] <- lapply(GAM_train_data_2[var_to_fac_2], factor)
GAM_test_data_2[var_to_fac_2] <- lapply(var_to_fac_2, function(var_name) {
  factor(GAM_test_data_2[[var_name]], levels = levels(GAM_train_data_2[[var_name]]))
})

GAM_gam_model_2 <- gam(score ~ field_cat + CEO_grd_yr + CEO_sch_cat + city,
                        data = GAM_train_data_2, family = binomial)
GAM_predictions_2 <- predict(GAM_gam_model_2, GAM_test_data_2, type = "response")
GAM_predicted_class_2 <- ifelse(GAM_predictions_2 > 0.5, 1, 0)

GAM_confusion_matrix_2 <- confusionMatrix(factor(GAM_predicted_class_2), GAM_test_data_2$score)
GAM_accuracy_2 <- GAM_confusion_matrix_2$overall['Accuracy']
precision_2 <- GAM_confusion_matrix_2$byClass['Precision']
recall_2 <- GAM_confusion_matrix_2$byClass['Recall']
F1_2 <- 2 * (precision_2 * recall_2) / (precision_2 + recall_2)

cat("GAM Subset 2 — Accuracy:", GAM_accuracy_2, "| Precision:", precision_2,
    "| Recall:", recall_2, "| F1:", F1_2, "\n")

# ---- GAM — Subset 3 ---------------------------------------------------------
var_to_fac_3 <- c("field_cat", "postal_code", "Rural_metropolitan_Desc", "business_id",
                  "CEO_grd_yr", "CEO_sch_cat", "ZIP.Code", "city", "Business_ID_other", "score")
subset_3[var_to_fac_3] <- lapply(subset_3[var_to_fac_3], factor)

set.seed(7)
index <- createDataPartition(subset_2$score, p = 0.8, list = TRUE, times = 1)
GAM_train_data_3 <- subset_3[index[[1]], ]
GAM_test_data_3  <- subset_3[-index[[1]], ]

GAM_train_data_3[var_to_fac_3] <- lapply(GAM_train_data_3[var_to_fac_3], factor)
GAM_test_data_3[var_to_fac_3] <- lapply(var_to_fac_3, function(var_name) {
  factor(GAM_test_data_3[[var_name]], levels = levels(GAM_train_data_3[[var_name]]))
})

GAM_gam_model_3 <- gam(score ~ CEO_grd_yr + CEO_sch_cat + city + field_cat + Rural_metropolitan_Desc,
                        data = GAM_train_data_3, family = binomial)
GAM_predictions_3 <- predict(GAM_gam_model_3, GAM_test_data_3, type = "response")
GAM_predicted_class_3 <- ifelse(GAM_predictions_3 > 0.5, 1, 0)

GAM_confusion_matrix_3 <- confusionMatrix(factor(GAM_predicted_class_3), GAM_test_data_3$score)
GAM_accuracy_3 <- GAM_confusion_matrix_3$overall['Accuracy']
precision_3 <- GAM_confusion_matrix_3$byClass['Precision']
recall_3 <- GAM_confusion_matrix_3$byClass['Recall']
F1_3 <- 2 * (precision_3 * recall_3) / (precision_3 + recall_3)
AUC_gam3 <- roc(GAM_test_data_3$score, GAM_predictions_3)$auc

cat("GAM Subset 3 — Accuracy:", GAM_accuracy_3, "| Precision:", precision_3,
    "| Recall:", recall_3, "| F1:", F1_3, "| AUC:", AUC_gam3, "\n")

# =============================================================================
# SECTION D: SUPPORT VECTOR MACHINE (SVM)
# =============================================================================

# ---- SVM — Subset 1 ---------------------------------------------------------
data_svm1 <- subset_1
set.seed(7)
train_idx <- sample(1:nrow(data_svm1), 0.7 * nrow(data_svm1))
train_data_svm1 <- data_svm1[train_idx, ]
test_data_svm1  <- data_svm1[-train_idx, ]

svm_model_1 <- svm(score ~ field_cat + city + CEO_grd_yr + CEO_sch_cat,
                   data = train_data_svm1, type = "C-classification", kernel = "linear")
predictions_svm1 <- predict(svm_model_1, test_data_svm1)
accuracy_svm1 <- sum(predictions_svm1 == test_data_svm1$score) / length(test_data_svm1$score)
cat("SVM Subset 1 Accuracy:", accuracy_svm1, "\n")

# ---- SVM — Subset 2 ---------------------------------------------------------
data_svm2 <- subset_2
set.seed(7)
train_idx <- sample(1:nrow(data_svm2), 0.7 * nrow(data_svm2))
train_data_svm2 <- data_svm2[train_idx, ]
test_data_svm2  <- data_svm2[-train_idx, ]

svm_model_2 <- svm(score ~ field_cat + CEO_grd_yr + CEO_sch_cat + city,
                   data = train_data_svm2, type = "C-classification", kernel = "linear")
predictions_svm2 <- predict(svm_model_2, test_data_svm2)
accuracy_svm2 <- sum(predictions_svm2 == test_data_svm2$score) / length(test_data_svm2$score)
cat("SVM Subset 2 Accuracy:", accuracy_svm2, "\n")

# ---- SVM — Subset 3 ---------------------------------------------------------
data_svm3 <- subset_3
set.seed(7)
train_idx <- sample(1:nrow(data_svm3), 0.7 * nrow(data_svm3))
train_data_svm3 <- data_svm3[train_idx, ]
test_data_svm3  <- data_svm3[-train_idx, ]

svm_model_3 <- svm(score ~ CEO_grd_yr + CEO_sch_cat + city + field_cat + Rural_metropolitan_Desc,
                   data = train_data_svm3, type = "C-classification", kernel = "linear")
predictions_svm3 <- predict(svm_model_3, test_data_svm3)
accuracy_svm3 <- sum(predictions_svm3 == test_data_svm3$score) / length(test_data_svm3$score)
cat("SVM Subset 3 Accuracy:", accuracy_svm3, "\n")

# =============================================================================
# SECTION E: MODEL COMPARISON SUMMARY
# =============================================================================

cat("\n========== MODEL PERFORMANCE SUMMARY ==========\n")
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "Model", "Subset", "Accuracy", "AUC", "Precision", "F1"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "Lasso",  "1", "59.4%", "0.497", "—", "—"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "Lasso",  "2", "59.4%", "0.497", "—", "—"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "Lasso",  "3", "56.7%", "0.480", "—", "—"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "GAM",    "1", "55.7%", "0.556", "62.4%", "62.3%"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "GAM",    "2", "55.7%", "0.556", "62.4%", "62.3%"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "GAM",    "3", "55.5%", "0.556", "62.3%", "62.0%"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "SVM",    "1", "51.8%", "—", "—", "—"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "SVM",    "2", "51.8%", "—", "—", "—"))
cat(sprintf("%-10s %-10s %-10s %-10s %-10s %-10s\n", "SVM",    "3", "51.0%", "—", "—", "—"))
cat("RECOMMENDED MODEL: GAM — Best balance of interpretability and predictive performance.\n")

# =============================================================================
# END OF ANALYSIS
# =============================================================================
