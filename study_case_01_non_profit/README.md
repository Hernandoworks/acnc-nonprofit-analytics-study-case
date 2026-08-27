# Non-Profit Analytics — Study Case 01

## ACNC Charity Data: Data Modelling, Complex SQL Analysis & Data Quality

This folder is the primary working area for **Study Case 01**.

### Objective
Show an end-to-end analytics workflow using the ACNC 2024 Annual Information Statement dataset, with emphasis on:

- data modelling
- SQL-first ingestion and transformation
- data quality and reconciliation
- complex analytical SQL
- Python notebooks for documentation and result visualisation
- Power BI as the later presentation layer

## Structure

```text
study_case_01_non_profit/
├── 01_source/
├── 02_sql/
│   ├── ingestion/
│   ├── cleansing/
│   ├── modelling/
│   ├── quality_checks/
│   ├── reconciliation/
│   └── complex_analysis/
├── 03_notebooks/
│   ├── 01_source_profile.ipynb
│   ├── 02_data_quality.ipynb
│   ├── 03_model_validation.ipynb
│   └── 04_complex_sql_analysis.ipynb
├── 04_data_dictionary/
├── 05_model/
├── 06_powerbi/
└── 07_docs/
```

## Analysis focus

The complex SQL section will cover charity scale, financial sustainability, revenue concentration, government funding dependency, donation dependency, workforce capacity, volunteer intensity, KMP remuneration, size-segment benchmarking and financial outlier analysis.

## Data-quality principle

A successful load is **not** defined by row count alone. The case requires row-count, non-null, identifier, measure, referential-integrity and accounting-rule reconciliation before data is accepted for analysis.
