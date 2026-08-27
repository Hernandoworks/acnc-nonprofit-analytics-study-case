-- Study Case 01 | ACNC Charity Analytics
-- 02_cleaning.sql
-- Purpose: standardise the raw ACNC attributes before modelling.

CREATE SCHEMA IF NOT EXISTS staging;

DROP VIEW IF EXISTS staging.v_acnc_clean;

CREATE VIEW staging.v_acnc_clean AS
SELECT
    source_load_id,
    source_file,
    etl_batch_id,
    source_loaded_at,

    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'ABN'), '[^0-9]', '', 'g'), '') AS abn,
    NULLIF(TRIM(raw_record->>'Charity Name'), '') AS charity_name,
    NULLIF(TRIM(raw_record->>'Registration Status'), '') AS registration_status,
    NULLIF(TRIM(raw_record->>'Charity Website'), '') AS charity_website,
    NULLIF(TRIM(raw_record->>'Charity Size'), '') AS charity_size,

    CASE LOWER(TRIM(raw_record->>'Basic Religious Charity'))
        WHEN 'yes' THEN TRUE WHEN 'true' THEN TRUE
        WHEN 'no' THEN FALSE WHEN 'false' THEN FALSE
        ELSE NULL
    END AS basic_religious_charity,

    NULLIF(TRIM(raw_record->>'AIS Due Date'), '')::DATE AS ais_due_date,
    NULLIF(TRIM(raw_record->>'Date AIS Received'), '')::DATE AS date_ais_received,
    NULLIF(TRIM(raw_record->>'Financial Report Date Received'), '')::DATE AS financial_report_date_received,

    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Total Revenue'), '[$, ]', '', 'g'), '')::NUMERIC AS total_revenue,
    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Total Expenses'), '[$, ]', '', 'g'), '')::NUMERIC AS total_expenses,
    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Total Assets'), '[$, ]', '', 'g'), '')::NUMERIC AS total_assets,
    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Total Liabilities'), '[$, ]', '', 'g'), '')::NUMERIC AS total_liabilities,
    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Net Assets/Liabilities'), '[$, ]', '', 'g'), '')::NUMERIC AS net_assets_liabilities,

    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Revenue from government'), '[$, ]', '', 'g'), '')::NUMERIC AS revenue_from_government,
    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Donations and bequests'), '[$, ]', '', 'g'), '')::NUMERIC AS donations_and_bequests,
    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Revenue from goods and services'), '[$, ]', '', 'g'), '')::NUMERIC AS revenue_from_goods_and_services,
    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'Revenue from investments'), '[$, ]', '', 'g'), '')::NUMERIC AS revenue_from_investments,
    NULLIF(REGEXP_REPLACE(TRIM(raw_record->>'All other revenue'), '[$, ]', '', 'g'), '')::NUMERIC AS all_other_revenue,

    NULLIF(TRIM(raw_record->>'Staff full time'), '')::NUMERIC AS staff_full_time,
    NULLIF(TRIM(raw_record->>'Staff part time'), '')::NUMERIC AS staff_part_time,
    NULLIF(TRIM(raw_record->>'Staff casual'), '')::NUMERIC AS staff_casual,
    NULLIF(TRIM(raw_record->>'Total full time equivalent staff'), '')::NUMERIC AS total_full_time_equivalent_staff,
    NULLIF(TRIM(raw_record->>'Staff volunteers'), '')::NUMERIC AS staff_volunteers
FROM staging.acnc_ais_source_raw;

-- Cleaning checks
SELECT
    COUNT(*) AS rows,
    COUNT(*) FILTER (WHERE abn ~ '^[0-9]{11}$') AS valid_abn,
    COUNT(*) FILTER (WHERE charity_name IS NULL) AS null_charity_name,
    COUNT(*) FILTER (WHERE total_revenue IS NULL) AS null_total_revenue
FROM staging.v_acnc_clean;
