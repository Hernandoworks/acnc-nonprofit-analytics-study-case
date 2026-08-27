# Non-Profit Analytics — Study Case 01

## ACNC Charity Data: Data Modelling, Complex SQL Analysis & Data Quality

An end-to-end Australian non-profit analytics study case using the ACNC 2024 Annual Information Statement dataset.

### Case objective

Demonstrate how to turn a large government charity dataset into a trustworthy analytical model and answer complex business questions with SQL.

This case is deliberately focused on **data modelling, SQL analytics and data quality** before the Power BI presentation layer.

### Study Case 01 scope

**Primary skills demonstrated**

- Relational data modelling
- PostgreSQL / Supabase
- SQL-first ingestion and transformation
- Entity resolution and deduplication
- Data-quality engineering
- Source-to-target reconciliation
- Complex analytical SQL
- Financial ratio analysis
- Workforce and volunteer analysis
- Funding dependency analysis
- Power BI-ready analytical views

### Dataset baseline

| Metric | Value |
|---|---:|
| Source records | **53,875** |
| Distinct ABNs | **53,874** |
| Known duplicate ABN records | **1** |
| Source columns | **92** |
| Canonical entity grain | **1 charity per ABN** |

### Analytical question

> **What can we learn about the scale, financial sustainability, funding model, workforce capacity and operating profile of Australian charities once the ACNC AIS data is correctly modelled and quality-assured?**

### Architecture

```text
ACNC 2024 source
        │
        ▼
raw / staging
        │
        ▼
SQL profiling + cleansing
        │
        ├── ABN standardisation
        ├── duplicate detection
        ├── type conversion
        └── completeness checks
        │
        ▼
canonical charity entity
        │
        ├── operations
        ├── workforce
        ├── financials
        ├── reporting
        ├── registration
        └── fundraising
        │
        ▼
SQL validation + reconciliation
        │
        ▼
analytical views
        │
        ▼
Power BI
```

### Data model

```text
                        acnc.charities
                              │
            ┌─────────────────┼─────────────────┐
            │                 │                 │
            ▼                 ▼                 ▼
    acnc.financials    acnc.workforce    acnc.operations
            │
            ├── acnc.reporting
            ├── acnc.registration
            └── acnc.fundraising
```

**Key design decision:** `ABN` is the source business key; `charity_id` is the curated surrogate key.

### Study case workflow

1. Understand the source table
2. Profile the 92 columns
3. Assess completeness and uniqueness
4. Detect and document duplicate entities
5. Clean and type the source using SQL
6. Build the relational model
7. Validate row counts and non-null counts
8. Reconcile critical financial measures source-to-target
9. Test accounting business rules
10. Build complex analytical SQL
11. Publish Power BI-ready views

### Complex SQL analysis themes

- Charity population by size and registration status
- Revenue concentration and funding mix
- Government funding dependency
- Donation dependency
- Net margin and financial sustainability
- Liquidity / leverage indicators
- Asset and liability structure
- Workforce capacity and FTE
- Volunteer intensity
- KMP remuneration analysis
- Comparison across charity-size segments
- Identification of financially unusual organisations
- Multi-dimensional charity segmentation

### Data quality standard

The case does **not** treat a matching row count as sufficient evidence of successful ingestion.

Acceptance requires:

- Raw record count reconciliation
- Unique ABN reconciliation
- Column-level NULL / non-NULL checks
- Source-to-target measure reconciliation
- Referential-integrity checks
- Business-rule validation
- Documented duplicate handling

The database-side QA output is the authoritative control.

### System metadata

**Raw / staging**

- `source_load_id`
- `source_file`
- `source_loaded_at`
- `etl_batch_id`

**Curated / end tables**

- `source_file`
- `etl_batch_id`
- `created_at`
- `updated_at`
- `record_hash`

### Repository structure

```text
Non-Profit-Analytics-Study-Case_01/
│
├── 01_source/
│   └── README.md
├── 02_sql/
│   ├── 01_ingestion.sql
│   ├── 02_cleaning.sql
│   ├── 03_model.sql
│   ├── 04_quality_checks.sql
│   ├── 05_reconciliation.sql
│   └── 06_complex_analysis.sql
├── 03_notebooks/
│   ├── 01_source_profile.ipynb
│   ├── 02_data_quality.ipynb
│   ├── 03_model_validation.ipynb
│   └── 04_sql_analysis.ipynb
├── 04_data_dictionary/
│   └── README.md
├── 05_model/
│   └── README.md
├── 06_powerbi/
│   └── README.md
└── 07_docs/
    └── study_case_01.md
```

### Technology

- PostgreSQL / Supabase
- SQL
- Python notebooks as an execution/documentation layer
- Power BI

### Portfolio positioning

This study case is intended to demonstrate **end-to-end analytical engineering**, not simply dashboard creation: source understanding → data modelling → quality assurance → complex SQL → decision-ready analytics.
