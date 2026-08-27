# SQL — Ingestion

Load the ACNC source into the raw/staging layer using PostgreSQL `\copy` from `psql`.

The raw table preserves the source record and adds system metadata:
- `source_load_id`
- `source_file`
- `source_loaded_at`
- `etl_batch_id`

No Python transformation is required for ingestion.
