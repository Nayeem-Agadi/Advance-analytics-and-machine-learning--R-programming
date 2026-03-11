# Advanced Analytics & Machine Learning — R Programming

![R](https://img.shields.io/badge/Language-R-276DC3?style=flat&logo=r)
![Models](https://img.shields.io/badge/Models-Lasso%20%7C%20GAM%20%7C%20SVM-orange?style=flat)
![Dataset](https://img.shields.io/badge/Records-10%2C891-blue?style=flat)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat)
![License](https://img.shields.io/badge/License-Academic-lightgrey?style=flat)

> **Predicting business online ratings using multi-platform review data and advanced machine learning models in R.**

**Author:** Mohammed Nayeem Agadi &nbsp;|&nbsp; **Date:** May 2024 &nbsp;|&nbsp; **Type:** University Project

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Repository Structure](#-repository-structure)
- [Dataset Description](#-dataset-description)
- [Methodology](#-methodology)
  - [A1 — Data Loading & Statistical Summary](#a1--data-loading--statistical-summary)
  - [A2 — Data Cleaning & Imputation](#a2--data-cleaning--imputation)
  - [A3 — Data Subsetting](#a3--data-subsetting)
  - [B — Lasso Regression](#b--lasso-regression)
  - [C — Generalised Additive Models (GAM)](#c--generalised-additive-models-gam)
  - [D — Support Vector Machine (SVM)](#d--support-vector-machine-svm)
- [Results & Model Comparison](#-results--model-comparison)
- [Key Findings](#-key-findings)
- [R Packages Used](#-r-packages-used)
- [How to Reproduce](#-how-to-reproduce)

---

## 📌 Project Overview

In the evolving landscape of digital commerce, online reviews play a crucial role in shaping business reputation and consumer decision-making. This project investigates how **business characteristics and multi-platform customer reviews correlate with online ratings**, using a dataset of **10,891 records** spanning multiple review platforms.

The analysis applies three machine learning techniques to identify the most significant predictors of a business's online score:

- 🔵 **Lasso Regression** — for feature selection via L1 regularisation
- 🟢 **Generalised Additive Models (GAM)** — for flexible non-linear modelling
- 🔴 **Support Vector Machines (SVM)** — for linear boundary classification

The ultimate goal is to derive actionable insights into how factors such as CEO background, service volume, location, and platform influence perceived service quality.

---

## 📂 Repository Structure

```
Advance-analytics-and-machine-learning--R-programming/
│
├── AALM.rmd                                          # R Markdown — full analysis & narrative
├── AALM_analysis.R                                   # Standalone R script (all code extracted)
├── AAML.html                                         # Rendered HTML report
├── student_merge_platform_business_file_final15.csv  # Dataset (10,891 records)
└── README.md                                         # This file
```

---

## 📊 Dataset Description

The dataset merges business review data from **multiple online platforms** with detailed business characteristics including CEO demographics and service claims.

| Variable | Type | Description |
|----------|------|-------------|
| `score` | Numeric (1–5) | **Target variable** — business online rating |
| `review_count` | Integer | Number of customer reviews |
| `Platform` | Factor | Source review platform (Platform 1, 2, etc.) |
| `business_id` | Factor | Unique business identifier |
| `city` | Factor | City of the business |
| `state` | Factor | US state |
| `postal_code` | Factor | Postal code |
| `Gender` | Factor | CEO gender (M/F) |
| `CEO_sch_cat` | Factor | CEO school category code |
| `CEO_grd_yr` | Factor | CEO graduation year |
| `field_cat` | Factor | CEO field of study category |
| `ZIP.Code` | Factor | ZIP code (extended) |
| `Business_ID_other` | Factor | Secondary business ID |
| `Rural_metropolitan_Desc` | Factor | Urban/rural classification |
| `Tot_Clms_Services` | Integer | Total service claims |
| `Brnd_Tot_Clms_Services` | Integer | Brand service claims |
| `Gnrc_Tot_Clms_Services` | Integer | Generic service claims |
| `Othr_Tot_Clms_Services` | Integer | Other service claims |
| `LIS_Tot_Clms_Services` | Integer | LIS service claims |
| `Opioid_Tot_Clms_Services` | Integer | Opioid-related claims |
| `Antbtc_Tot_Clms_Services` | Integer | Antibiotic-related claims |

### Data Quality

| Metric | Value |
|--------|-------|
| Total records | 10,891 |
| Total variables | 21 |
| Records after full cleaning | 678 |
| Data retention after cleaning | ~6.2% |
| Incomplete cases | 9,081 |

**Notable missing value counts:**

| Column | Missing Values | Zeros |
|--------|---------------|-------|
| `Business_ID_other` | 4,919 | 0 |
| `Tot_Clms_Services` | 4,919 | 0 |
| `Brnd_Tot_Clms_Services` | 7,510 | 268 |
| `Gnrc_Tot_Clms_Services` | 4,986 | 0 |
| `Othr_Tot_Clms_Services` | 7,521 | 2,552 |
| `LIS_Tot_Clms_Services` | 5,898 | 209 |
| `Opioid_Tot_Clms_Services` | 6,454 | 1,935 |
| `Antbtc_Tot_Clms_Services` | 6,787 | 556 |
| `CEO_grd_yr` | 8 | 0 |

---

## 🔬 Methodology

### A1 — Data Loading & Statistical Summary

The dataset was loaded and profiled across all 21 variables. Key steps included:
- Examining structural composition and variable types
- Quantifying missing values (`NA`) and zero entries per column
- Generating statistical summaries (`mean`, `median`, `min`, `max`, `NA counts`)

Score distribution across the dataset showed values ranging from **1.0 to 5.0**, with a mean of **3.491** and median of **3.5**. Review counts ranged from 5 to 413, with a mean of **15.49**.

---

### A2 — Data Cleaning & Imputation

**Step 1 — Cleaned Dataset (for comparison)**

Rows containing any zero or missing value were removed, resulting in a dramatically reduced but higher-quality dataset:

| Dataset | Records | Notes |
|---------|---------|-------|
| Original | 10,891 | High missing/zero prevalence |
| Cleaned (zeros + NAs removed) | 678 | ~93% reduction |

Key observations from comparing distributions:
- **Score distribution**: The cleaned dataset shows a more uniform distribution around mid-range scores (2–4), vs. inflated spikes at every integer in the original
- **Review count vs. score**: A positive correlation emerged in the cleaned data — businesses with more reviews tend to score higher; this trend was absent in the noisy original data
- **CEO gender**: More balanced gender distribution in the cleaned dataset

**Step 2 — Imputation (for modelling)**

Rather than discarding data, missing values were imputed to retain all 10,891 records for modelling:

| Variable Type | Strategy |
|---------------|----------|
| Numeric | Replaced with **column mean** |
| Categorical / Factor | Replaced with **column mode** |

**Step 3 — Variable Type Conversion**

All categorical identifiers were converted to `factor`, and service claim columns to `integer`.

---

### A3 — Data Subsetting

The first **2,400 records** were extracted and divided into three equal subsets of **800 rows each** for model evaluation.

| Subset | Rows | Used For |
|--------|------|----------|
| Subset 1 | 800 | Lasso (feature selection) + GAM + SVM |
| Subset 2 | 800 | Lasso + GAM + SVM |
| Subset 3 | 800 | Lasso + GAM (+ `Rural_metropolitan_Desc`) + SVM |

The **target variable `score` was binarised**:
- `0` = High rating (score > 3)
- `1` = Low rating (score ≤ 3)

---

### B — Lasso Regression

Lasso (Least Absolute Shrinkage and Selection Operator) was applied using `glmnet` with binomial family and cross-validated lambda selection. An 80/20 train/test split was used per subset.

#### Lasso — Top Predictors

The most consistently significant predictors across all three subsets:

| Rank | Predictor | Subset 1 Coeff | Subset 2 Coeff | Subset 3 Coeff |
|------|-----------|---------------|---------------|---------------|
| 1 | `field_cat23` | 0.538 | 0.538 | 0.886 |
| 2 | `city443` | 0.491 | 0.491 | — |
| 3 | `business_id1463` | 0.226 | 0.226 | 0.563 |
| 4 | `CEO_grd_yr27` | 0.142 | 0.142 | 0.179 |
| 5 | `field_cat64` | -0.080 | -0.080 | — |
| 6 | `postal_code529` | — | — | 0.741 |
| 7 | `field_cat8` | — | — | 0.439 |

#### Lasso — Performance Results

| Subset | Accuracy | AUC | Sensitivity | Specificity |
|--------|----------|-----|-------------|-------------|
| Subset 1 | 59.39% | 0.4967 | 98.10% | 0.00% |
| Subset 2 | 59.39% | 0.4967 | 98.10% | 0.00% |
| Subset 3 | 56.70% | 0.4803 | 96.00% | 3.60% |

> ⚠️ **Interpretation:** High sensitivity but near-zero specificity indicates a strong majority-class bias. The model predicts almost all samples as the majority class (high rating), reflecting class imbalance in the dataset.

---

### C — Generalised Additive Models (GAM)

GAM was applied using `mgcv::gam()` with binomial family. Predictors used: `field_cat`, `CEO_grd_yr`, `CEO_sch_cat`, `city` (Subsets 1 & 2), with `Rural_metropolitan_Desc` added for Subset 3.

#### GAM — Performance Results

| Subset | Accuracy | AUC | Precision | Recall | F1 Score |
|--------|----------|-----|-----------|--------|----------|
| Subset 1 | 55.73% | 0.5556 | 62.41% | 62.17% | 62.29% |
| Subset 2 | 55.73% | 0.5556 | 62.41% | 62.17% | 62.29% |
| Subset 3 | 55.51% | 0.5556 | 62.26% | 61.80% | 62.03% |

> ✅ **Interpretation:** GAM achieved the best **balanced class discrimination** (highest AUC = 0.5556) and the most balanced precision/recall trade-off. Adding `Rural_metropolitan_Desc` in Subset 3 produced only marginal changes, suggesting geographic classification contributes minimally over and above existing predictors.

---

### D — Support Vector Machine (SVM)

SVM with a **linear kernel** was applied using `e1071::svm()` with a 70/30 train/test split. Predictors mirrored those used in GAM for fair comparison.

#### SVM — Performance Results

| Subset | Predictors | Accuracy |
|--------|-----------|----------|
| Subset 1 | `field_cat`, `city`, `CEO_grd_yr`, `CEO_sch_cat` | 51.81% |
| Subset 2 | `field_cat`, `city`, `CEO_grd_yr`, `CEO_sch_cat` | 51.81% |
| Subset 3 | Above + `Rural_metropolitan_Desc` | 50.97% |

> ⚠️ **Interpretation:** The linear kernel appears to underfit the data. The addition of `Rural_metropolitan_Desc` slightly reduced accuracy, suggesting it introduces noise rather than signal in a linear decision boundary context. Non-linear kernels (RBF, polynomial) may be more appropriate.

---

## 📈 Results & Model Comparison

### Full Performance Summary

| Model | Subset | Accuracy | AUC | Precision | Recall | F1 Score |
|-------|--------|----------|-----|-----------|--------|----------|
| **Lasso** | 1 | 59.39% | 0.497 | — | 98.10% | — |
| **Lasso** | 2 | 59.39% | 0.497 | — | 98.10% | — |
| **Lasso** | 3 | 56.70% | 0.480 | — | 96.00% | — |
| **GAM** | 1 | 55.73% | **0.556** | 62.41% | 62.17% | 62.29% |
| **GAM** | 2 | 55.73% | **0.556** | 62.41% | 62.17% | 62.29% |
| **GAM** | 3 | 55.51% | **0.556** | 62.26% | 61.80% | 62.03% |
| **SVM** | 1 | 51.81% | — | — | — | — |
| **SVM** | 2 | 51.81% | — | — | — | — |
| **SVM** | 3 | 50.97% | — | — | — | — |

### Model Comparison at a Glance

| Criterion | Lasso | GAM | SVM |
|-----------|-------|-----|-----|
| Best Accuracy | ✅ 59.4% | 55.7% | 51.8% |
| Best AUC | — | ✅ 0.556 | — |
| Class balance | ❌ Biased | ✅ Balanced | ❌ Near-random |
| Interpretability | ✅ High | ✅ High | ❌ Low |
| Handles non-linearity | ❌ No | ✅ Yes | ❌ (linear kernel) |
| **Recommended** | | ✅ **GAM** | |

---

## 🔑 Key Findings

1. **`field_cat23` and `city443`** were the most consistently significant predictors across all Lasso subsets, demonstrating robust and repeatable influence on business ratings.

2. **CEO characteristics matter**: Graduation year (`CEO_grd_yr`) and school category (`CEO_sch_cat`) consistently appeared as significant predictors, suggesting leadership background influences perceived business quality.

3. **Class imbalance is a key challenge**: Lasso models achieved high sensitivity (~98%) but near-zero specificity, indicating the dataset is skewed toward high-rated businesses. Future work should address this via oversampling (SMOTE) or class-weighted models.

4. **GAM is the best model overall**: While Lasso achieved the highest raw accuracy, this was largely due to majority-class prediction. GAM provided the best balance of discrimination (AUC 0.556), interpretability, and balanced precision/recall.

5. **SVM linear kernel underperforms**: Consistent accuracy near 50–52% across all subsets suggests the decision boundary in this dataset is non-linear. RBF or polynomial kernels should be explored in future iterations.

6. **Geographic factors have limited additional predictive power**: Adding `Rural_metropolitan_Desc` to Subset 3 models did not meaningfully improve performance, suggesting urban/rural classification is already captured by other variables like `city` and `postal_code`.

---

## 📦 R Packages Used

| Package | Version | Purpose |
|---------|---------|---------|
| `tidyverse` | Latest | Data manipulation & piping |
| `ggplot2` | Latest | Data visualisation |
| `gridExtra` | Latest | Multi-plot grid layouts |
| `dplyr` | Latest | Data wrangling |
| `glmnet` | Latest | Lasso regression with cross-validation |
| `mgcv` | Latest | Generalised Additive Models |
| `e1071` | Latest | Support Vector Machines |
| `caret` | Latest | Model evaluation, confusion matrices, data splitting |
| `pROC` | Latest | ROC curves and AUC computation |
| `kableExtra` | Latest | Formatted HTML tables |

---

## 🚀 How to Reproduce

### Prerequisites

- R ≥ 4.0.0
- RStudio (recommended)

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/Nayeem-Agadi/Advance-analytics-and-machine-learning--R-programming.git
cd Advance-analytics-and-machine-learning--R-programming
```

**2. Install required packages**
```r
install.packages(c("tidyverse", "ggplot2", "gridExtra", "dplyr",
                   "glmnet", "mgcv", "e1071", "caret", "pROC", "kableExtra"))
```

**3. Run the analysis**

**Option A — R Markdown (full narrative report):**
- Open `AALM.rmd` in RStudio
- Ensure `student_merge_platform_business_file_final15.csv` is in the same directory
- Click **Knit** to render the full HTML report

**Option B — Standalone R Script (code only):**
```r
source("AALM_analysis.R")
```

**Option C — View rendered report directly:**
- Open `AAML.html` in any web browser — no R installation needed

---

## 📄 Report

The full rendered analysis report with all visualisations, output tables, and narrative is available as [`AAML.html`](./AAML.html).

---

*Queens University Belfast — Advanced Analytics & Machine Learning, R Programming | Mohammed Nayeem Agadi | May 2024*
