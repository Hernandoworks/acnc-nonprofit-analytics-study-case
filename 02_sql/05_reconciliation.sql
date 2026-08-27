-- Study Case 01 | ACNC Charity Analytics
-- 05_reconciliation.sql
-- Source-to-target reconciliation. All calculations are SQL-side.

WITH src AS (
    SELECT
        SUM(total_revenue) AS total_revenue,
        SUM(total_expenses) AS total_expenses,
        SUM(total_assets) AS total_assets,
        SUM(total_liabilities) AS total_liabilities,
        COUNT(*) AS rows
    FROM staging.v_acnc_clean
), tgt AS (
    SELECT
        SUM(total_revenue) AS total_revenue,
        SUM(total_expenses) AS total_expenses,
        SUM(total_assets) AS total_assets,
        SUM(total_liabilities) AS total_liabilities,
        COUNT(*) AS rows
    FROM acnc.financials
), measures AS (
    SELECT 'total_revenue' AS measure, src.total_revenue AS source_value, tgt.total_revenue AS target_value FROM src,tgt
    UNION ALL SELECT 'total_expenses',src.total_expenses,tgt.total_expenses FROM src,tgt
    UNION ALL SELECT 'total_assets',src.total_assets,tgt.total_assets FROM src,tgt
    UNION ALL SELECT 'total_liabilities',src.total_liabilities,tgt.total_liabilities FROM src,tgt
)
SELECT
    measure,
    source_value,
    target_value,
    target_value-source_value AS difference,
    CASE WHEN source_value=0 THEN NULL
         ELSE 100.0*(target_value-source_value)/ABS(source_value) END AS difference_pct,
    CASE WHEN ABS(COALESCE(target_value,0)-COALESCE(source_value,0)) <= 0.01
         THEN 'PASS' ELSE 'FAIL' END AS status
FROM measures
ORDER BY measure;

-- Entity-level reconciliation example: identify individual revenue mismatches.
SELECT
    s.abn,
    s.total_revenue AS source_total_revenue,
    f.total_revenue AS target_total_revenue,
    f.total_revenue - s.total_revenue AS difference
FROM staging.v_acnc_clean s
JOIN acnc.charities c ON c.abn=s.abn
JOIN acnc.financials f ON f.charity_id=c.charity_id
WHERE COALESCE(s.total_revenue,0) <> COALESCE(f.total_revenue,0)
ORDER BY ABS(f.total_revenue - s.total_revenue) DESC;
