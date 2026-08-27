# Study Case 01 — Data

## Source

ACNC 2024 Annual Information Statement (AIS) dataset.

## Dataset baseline

- Source records: 53,875
- Distinct ABNs: 53,874
- Source columns: 92
- Canonical analytical grain: 1 charity per ABN

## Data handling

The full government extract is intentionally **not committed to Git** because it is a large source dataset and may contain redistributable-content/licensing considerations.

Store the source locally and load it into Supabase/PostgreSQL through the SQL ingestion process documented in `02_sql/ingestion/`.

A small representative sample is provided in `sample/acnc_2024_sample.csv` for notebook development and schema testing.
