-- Study Case 01 | ACNC Charity Analytics
-- 01_ingestion.sql
-- Purpose: load the ACNC source into a raw PostgreSQL staging layer.
-- The database pipeline is SQL-first; psql \copy is the only local-file step.

CREATE SCHEMA IF NOT EXISTS staging;

DROP TABLE IF EXISTS staging.acnc_ais_source_raw;

CREATE TABLE staging.acnc_ais_source_raw (
    source_load_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_file TEXT NOT NULL,
    etl_batch_id TEXT NOT NULL,
    source_loaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    raw_record JSONB NOT NULL
);

-- Example psql load pattern:
-- \copy staging.acnc_ais_source_raw(source_file,etl_batch_id,raw_record)
-- FROM '/path/to/acnc_2024_raw.jsonl'
-- WITH (FORMAT text);
--
-- For CSV ingestion, use the actual 92-column column list in the
-- repository's end-to-end loader or the Supabase import process, then
-- populate the system columns above.

-- Basic ingestion control
SELECT
    COUNT(*) AS raw_rows,
    COUNT(DISTINCT etl_batch_id) AS batches,
    MIN(source_loaded_at) AS first_loaded_at,
    MAX(source_loaded_at) AS last_loaded_at
FROM staging.acnc_ais_source_raw;
