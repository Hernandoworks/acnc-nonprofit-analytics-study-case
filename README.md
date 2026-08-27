# ACNC Non-Profit Analytics Study Case

An end-to-end Australian charity analytics study case using the ACNC 2024 Annual Information Statement dataset.

## Objective
Demonstrate a production-style analytics workflow from government source data through SQL-first ingestion, data-quality validation, relational modelling and Power BI-ready analysis.

## Pipeline

```text
ACNC source
   ↓
staging.acnc_ais_raw
   ↓
SQL profiling + cleansing
   ↓
ABN standardisation / deduplication
   ↓
ACNC relational model
   ├── charities
   ├── operations
   ├── workforce
   ├── financials
   ├── reporting
   ├── registration
   └── fundraising
   ↓
SQL QA / reconciliation
   ↓
Analytics views
   ↓
Power BI
```

## Current dataset baseline

- Source records: **53,875**
- Distinct ABNs: **53,874**
- Known duplicate ABN records: **1**
- Source columns: **92**
- Canonical grain: **1 charity per ABN**

## Phase 1 — Data Engineering

1. Source import
2. Source table inventory
3. Data-quality assessment
4. SQL cleansing and typing
5. ABN entity resolution
6. Relational modelling
7. Supabase ingestion
8. SQL reconciliation
9. Persistent QA report

## Phase 2 — Analysis

Planned Power BI themes:

- Charity landscape
- Organisation size
- Financial sustainability
- Revenue and funding mix
- Workforce and volunteers
- Governance and reporting
- Registration/fundraising footprint
- Opportunity and trend analysis

## Data-quality position

The raw ACNC dataset is **fit for analytical use after controlled cleansing and validation**. It should not be described as perfectly clean. The known duplicate ABN is retained in the raw layer and resolved in the canonical entity layer.

## Technology

- PostgreSQL / Supabase
- SQL
- Python notebooks for documentation, SQL execution and exploratory visualisation
- Power BI

## Repository structure

```text
01_source/
02_sql_pipeline/
03_data_quality/
04_model/
05_notebooks/
06_analytics/
07_powerbi/
08_docs/
```

## Governance

System metadata is separated from business/source fields:

- Raw: `source_file`, `source_loaded_at`, `etl_batch_id`, `source_load_id`
- Curated: `source_file`, `etl_batch_id`, `created_at`, `updated_at`, `record_hash`

## Security

Do not commit Supabase passwords, service-role keys, database URLs or other secrets. Supabase RLS is currently a separate security hardening item and should be enabled with explicit policies before client-side exposure.
