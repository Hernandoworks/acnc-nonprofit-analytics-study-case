# Non-Profit Analytics — Study Case 01

## ACNC Charity Data: Data Ingestion → Multi-Table Modelling → Data Quality → Complex SQL Analysis

This folder is the primary working area for **Study Case 01**.

### Case objective

Show how a large government source table can be turned into a trustworthy analytical model and then used to answer complex non-profit business questions.

The case is intentionally built in this sequence:

**Understand the source → ingest the data → assess quality → model multiple tables → reconcile the load → analyse across tables → prepare Power BI outputs**.

## What this case showcases

### Data modelling
- Wide government source-table assessment
- Raw/staging layer
- Canonical charity entity
- Domain-based relational tables
- Primary and foreign keys
- Business key vs surrogate key
- System / ETL metadata
- Data lineage and record hashes

### SQL engineering
- PostgreSQL / Supabase
- SQL-first ingestion
- CTEs
- Window functions
- Multi-table joins
- Conditional aggregation
- Windowed ranking
- Percentiles and segmentation
- Financial ratio calculations
- Source-to-target reconciliation

### Data quality
- Column inventory
- NULL / non-NULL profiling
- ABN validity
- Duplicate detection
- Entity reconciliation
- Referential integrity
- Financial measure reconciliation
- Accounting/business-rule checks
- Explicit acceptance criteria

## Dataset baseline

| Metric | Value |
|---|---:|
| Source records | **53,875** |
| Source columns | **92** |
| Distinct ABNs | **53,874** |
| Known duplicate ABN records | **1** |
| Canonical analytical grain | **1 charity per ABN** |

## Detailed approach

### Phase 01 — Understand the source table

Before modifying the data, establish:

- source structure
- row count
- column count
- identifiers
- date fields
- categorical fields
- financial fields
- workforce fields
- registration/fundraising fields
- narrative/operational fields

The first deliverable is a **source data dictionary and domain map**.

### Phase 02 — Ingest into raw/staging

The source is loaded without business transformations into:

`staging.acnc_ais_raw`

The raw layer retains the source for:

- auditability
- repeatable loads
- lineage
- troubleshooting
- source-to-target reconciliation

System metadata records the load:

```text
source_file
source_loaded_at
etl_batch_id
source_load_id
```

### Phase 03 — Assess data quality

The quality assessment asks whether the data is fit for purpose rather than assuming that it is clean.

Checks include:

```text
row count
column count
NULL count
non-NULL count
distinct ABN
duplicate ABN
ABN validity
category consistency
numeric validity
date validity
outlier review
```

### Phase 04 — Build the canonical entity

`ABN` is the source business key.

`charity_id` is the database surrogate key.

The source contains **53,875 records but 53,874 distinct ABNs**. The raw data preserves all source rows; the canonical entity table contains one row per valid ABN.

This makes duplicate handling explicit and reproducible rather than silently deleting source information.

### Phase 05 — Model the source into multiple analytical tables

The source is separated into business domains rather than leaving all 92 fields in one analytical table.

| Table | Grain | Purpose |
|---|---|---|
| `staging.acnc_ais_raw` | 1 source record | Raw lineage |
| `acnc.charities` | 1 unique ABN | Charity master |
| `acnc.operations` | 1 charity | Activities/purposes |
| `acnc.workforce` | 1 charity | Employees/FTE/volunteers/KMP |
| `acnc.financials` | 1 charity/report | Financial facts |
| `acnc.reporting` | 1 charity | Reporting/compliance |
| `acnc.registration` | 1 charity | Incorporation/state registration |
| `acnc.fundraising` | 1 charity | Fundraising footprint |

### Phase 06 — Validate ingestion alignment

The load is not accepted merely because row counts match.

For mapped fields and measures, SQL compares:

- source row count vs target row count
- source non-NULL count vs target non-NULL count
- source NULL count vs target NULL count
- source aggregate vs target aggregate
- source entity population vs target entity population
- source-to-target record matches where required

The authoritative output is:

`analytics.acnc_data_quality_report`

### Phase 07 — Validate business logic

The model is tested against accounting and business relationships.

Examples:

```text
Revenue components ≈ Total revenue
Expense components ≈ Total expenses
Assets - Liabilities ≈ Net assets/liabilities
```

A tolerance is documented for numeric reconciliation.

### Phase 08 — Analyse across multiple tables

The complex-analysis layer demonstrates that the model can support questions that require more than one table.

For example:

```text
charities
   JOIN financials
   JOIN workforce
   JOIN operations
   JOIN registration
```

This enables analysis of organisational profiles rather than isolated KPIs.

## Complex analysis themes

### 1. Charity scale and segmentation

- Charity population by size
- Revenue by size segment
- Asset distribution
- Workforce distribution
- Registration footprint

### 2. Funding dependency

- Government revenue as a share of total revenue
- Donations as a share of total revenue
- Funding-mix differences by charity size
- Concentration of sector revenue

### 3. Financial sustainability

- Net surplus/deficit
- Net margin
- Liability-to-asset ratio
- Revenue and expense intensity
- Financially unusual organisations

### 4. Workforce and volunteer capacity

- FTE by charity segment
- Volunteers by segment
- Volunteer-to-FTE ratio
- Revenue per FTE
- Workforce intensity relative to organisation size

### 5. Cross-domain organisational profiles

Create segments such as:

```text
High-revenue / high-government-dependent
High-volunteer / low-revenue
High-assets / high-liability
High-margin / low-workforce
Large-workforce / high-service-scale
```

These profiles are where the multi-table model becomes analytically useful.

## SQL folder design

```text
02_sql/
├── ingestion/
│   └── load_acnc.sql
├── cleansing/
│   └── clean_acnc.sql
├── modelling/
│   └── build_acnc_model.sql
├── quality_checks/
│   └── acnc_quality_checks.sql
├── reconciliation/
│   └── source_to_target_reconciliation.sql
└── complex_analysis/
    ├── 01_charity_scale.sql
    ├── 02_funding_dependency.sql
    ├── 03_revenue_concentration.sql
    ├── 04_financial_sustainability.sql
    ├── 05_workforce_capacity.sql
    └── 06_cross_domain_segmentation.sql
```

## Notebook folder design

```text
03_notebooks/
├── 01_source_profile.ipynb
├── 02_data_quality.ipynb
├── 03_model_validation.ipynb
├── 04_complex_sql_analysis.ipynb
└── 05_results_and_insights.ipynb
```

The notebooks document and visualise results. **SQL remains the authoritative transformation and QA layer.**

## Data folder design

```text
data/
├── raw/
│   └── README.md
└── sample/
    └── acnc_2024_sample.csv
```

The repository should not contain the full government extract when repository size or redistribution constraints make that unsuitable. The source location, schema and reproducible load process are documented instead.

## Portfolio success criteria

A reviewer should be able to trace the complete chain:

**source table → ingestion → profiling → cleansing → canonical entity → multiple analytical tables → SQL quality checks → reconciliation → complex multi-table analysis → insights → Power BI**.

The main message of Study Case 01 is:

> **Good analytics starts with understanding and modelling the data correctly, then proving that the model is trustworthy before using complex SQL to answer business questions.**
