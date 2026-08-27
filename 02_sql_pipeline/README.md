# SQL Pipeline

This folder contains the database-first ACNC pipeline.

## Execution order

1. `01_schema_and_system_columns.sql`
2. `02_ingest_and_stage.sql`
3. `03_cleanse_and_model.sql`
4. `04_data_quality_and_reconciliation.sql`
5. `05_analytics_views.sql`

The only client-side file operation is PostgreSQL `\copy`; ingestion, cleansing, modelling and QA remain SQL-driven.

## Grain

- Raw staging: one row per source record
- `acnc.charities`: one row per valid ABN
- `acnc.financials`: one charity/reporting record
- `acnc.workforce`: one charity/reporting record
- Operations/reporting/registration/fundraising: one charity record
