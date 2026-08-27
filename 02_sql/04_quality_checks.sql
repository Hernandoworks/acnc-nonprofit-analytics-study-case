-- Study Case 01 | ACNC Charity Analytics
-- 04_quality_checks.sql
-- SQL-only data-quality controls.

CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS analytics.acnc_data_quality_report;
CREATE TABLE analytics.acnc_data_quality_report (
    report_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    run_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    check_group TEXT NOT NULL,
    check_name TEXT NOT NULL,
    table_name TEXT,
    column_name TEXT,
    source_rows BIGINT,
    database_rows BIGINT,
    source_non_nulls BIGINT,
    database_non_nulls BIGINT,
    source_nulls BIGINT,
    database_nulls BIGINT,
    source_value NUMERIC,
    database_value NUMERIC,
    difference NUMERIC,
    difference_pct NUMERIC,
    threshold NUMERIC,
    status TEXT NOT NULL,
    details TEXT
);

-- 1. Row/entity baseline.
INSERT INTO analytics.acnc_data_quality_report
(check_group,check_name,table_name,source_rows,database_rows,status,details)
SELECT
    'INGESTION','RAW_ROW_COUNT','staging.acnc_ais_source_raw',COUNT(*),COUNT(*),
    CASE WHEN COUNT(*)=53875 THEN 'PASS' ELSE 'FAIL' END,
    'Expected 53,875 source records'
FROM staging.acnc_ais_source_raw;

INSERT INTO analytics.acnc_data_quality_report
(check_group,check_name,table_name,source_rows,database_rows,status,details)
SELECT
    'ENTITY','DISTINCT_ABN_TO_CHARITIES',
    'staging.acnc_ais_source_raw -> acnc.charities',
    COUNT(DISTINCT REGEXP_REPLACE(TRIM(abn),'[^0-9]','','g')),
    (SELECT COUNT(*) FROM acnc.charities),
    CASE WHEN COUNT(DISTINCT REGEXP_REPLACE(TRIM(abn),'[^0-9]','','g')) =
                    (SELECT COUNT(*) FROM acnc.charities)
         THEN 'PASS' ELSE 'FAIL' END,
    'Canonical grain is one charity per ABN'
FROM staging.acnc_ais_source_raw
WHERE REGEXP_REPLACE(TRIM(abn),'[^0-9]','','g') ~ '^[0-9]{11}$';

-- 2. Null-count checks for critical columns.
WITH s AS (
    SELECT COUNT(*) rows, COUNT(charity_name) non_nulls, COUNT(*)-COUNT(charity_name) nulls
    FROM staging.v_acnc_clean
), t AS (
    SELECT COUNT(*) rows, COUNT(charity_name) non_nulls, COUNT(*)-COUNT(charity_name) nulls
    FROM acnc.charities
)
INSERT INTO analytics.acnc_data_quality_report
(check_group,check_name,column_name,source_rows,database_rows,source_non_nulls,database_non_nulls,source_nulls,database_nulls,status,details)
SELECT
    'COMPLETENESS','NULL_RECONCILIATION','charity_name',
    s.rows,t.rows,s.non_nulls,t.non_nulls,s.nulls,t.nulls,
    CASE WHEN s.non_nulls=t.non_nulls AND s.nulls=t.nulls THEN 'PASS' ELSE 'FAIL' END,
    'Source vs canonical non-null/null counts'
FROM s CROSS JOIN t;

WITH s AS (
    SELECT COUNT(*) rows, COUNT(total_revenue) non_nulls, COUNT(*)-COUNT(total_revenue) nulls
    FROM staging.v_acnc_clean
), t AS (
    SELECT COUNT(*) rows, COUNT(total_revenue) non_nulls, COUNT(*)-COUNT(total_revenue) nulls
    FROM acnc.financials
)
INSERT INTO analytics.acnc_data_quality_report
(check_group,check_name,column_name,source_rows,database_rows,source_non_nulls,database_non_nulls,source_nulls,database_nulls,status,details)
SELECT
    'COMPLETENESS','NULL_RECONCILIATION','total_revenue',
    s.rows,t.rows,s.non_nulls,t.non_nulls,s.nulls,t.nulls,
    CASE WHEN s.non_nulls=t.non_nulls AND s.nulls=t.nulls THEN 'PASS' ELSE 'FAIL' END,
    'Source vs financial non-null/null counts'
FROM s CROSS JOIN t;

-- 3. Orphan records.
INSERT INTO analytics.acnc_data_quality_report
(check_group,check_name,table_name,database_rows,status,details)
SELECT 'INTEGRITY','ORPHAN_RECORDS','acnc.financials',COUNT(*),
       CASE WHEN COUNT(*)=0 THEN 'PASS' ELSE 'FAIL' END,
       'Financial rows without a charity parent'
FROM acnc.financials f
LEFT JOIN acnc.charities c ON c.charity_id=f.charity_id
WHERE c.charity_id IS NULL;

-- 4. Business accounting rules.
INSERT INTO analytics.acnc_data_quality_report
(check_group,check_name,table_name,database_rows,status,details)
SELECT 'BUSINESS_RULE','REVENUE_RECONCILIATION','acnc.financials',
       COUNT(*) FILTER (WHERE ABS(
          COALESCE(revenue_from_government,0)+COALESCE(donations_and_bequests,0)+
          COALESCE(revenue_from_goods_and_services,0)+COALESCE(revenue_from_investments,0)+
          COALESCE(all_other_revenue,0)-COALESCE(total_revenue,0)
       ) > 0.01),
       CASE WHEN COUNT(*) FILTER (WHERE ABS(
          COALESCE(revenue_from_government,0)+COALESCE(donations_and_bequests,0)+
          COALESCE(revenue_from_goods_and_services,0)+COALESCE(revenue_from_investments,0)+
          COALESCE(all_other_revenue,0)-COALESCE(total_revenue,0)
       ) > 0.01)=0 THEN 'PASS' ELSE 'FAIL' END,
       'Revenue components versus reported total';

INSERT INTO analytics.acnc_data_quality_report
(check_group,check_name,table_name,database_rows,status,details)
SELECT 'BUSINESS_RULE','BALANCE_SHEET_RECONCILIATION','acnc.financials',
       COUNT(*) FILTER (WHERE ABS(
          COALESCE(total_assets,0)-COALESCE(total_liabilities,0)-COALESCE(net_assets_liabilities,0)
       ) > 0.01),
       CASE WHEN COUNT(*) FILTER (WHERE ABS(
          COALESCE(total_assets,0)-COALESCE(total_liabilities,0)-COALESCE(net_assets_liabilities,0)
       ) > 0.01)=0 THEN 'PASS' ELSE 'FAIL' END,
       'Assets less liabilities versus net assets';

CREATE OR REPLACE VIEW analytics.v_acnc_validation_summary AS
SELECT
    COUNT(*) AS checks_run,
    COUNT(*) FILTER (WHERE status='PASS') AS passed,
    COUNT(*) FILTER (WHERE status='FAIL') AS failed,
    COUNT(*) FILTER (WHERE status='INFO') AS informational,
    CASE WHEN COUNT(*) FILTER (WHERE status='FAIL')=0 THEN 'PASS' ELSE 'FAIL' END AS overall_status,
    MAX(run_at) AS last_checked_at
FROM analytics.acnc_data_quality_report;

SELECT * FROM analytics.v_acnc_validation_summary;
SELECT * FROM analytics.acnc_data_quality_report
ORDER BY CASE status WHEN 'FAIL' THEN 1 WHEN 'PASS' THEN 2 ELSE 3 END,
         check_group, check_name, column_name;
