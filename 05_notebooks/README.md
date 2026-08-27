# Python Notebooks

Python notebooks document and visualise the process, but PostgreSQL remains the authoritative transformation and validation engine.

## Planned notebook sequence

1. Source import and inventory
2. Data-quality assessment
3. SQL cleansing and canonicalisation
4. Exploratory analysis from the source/curated tables
5. Supabase model inspection
6. SQL-first reconciliation
7. Analytical exploration
8. Power BI preparation

## Rule

Do not use Python to decide whether source values reconcile with Supabase. Run reconciliation in SQL and use Python only to execute/display results or build exploratory visualisations.
