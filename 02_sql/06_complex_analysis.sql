-- Study Case 01 | ACNC Charity Analytics
-- 06_complex_analysis.sql
-- Complex, decision-oriented PostgreSQL analysis.

-- 1. Charity population by size and registration status
SELECT
    charity_size,
    registration_status,
    COUNT(*) AS charities
FROM acnc.charities
GROUP BY charity_size, registration_status
ORDER BY charities DESC;

-- 2. Revenue concentration by charity size
WITH ranked AS (
    SELECT
        c.charity_id,
        c.charity_size,
        f.total_revenue,
        SUM(f.total_revenue) OVER () AS sector_revenue,
        SUM(f.total_revenue) OVER (
            PARTITION BY c.charity_size
        ) AS size_revenue
    FROM acnc.charities c
    JOIN acnc.financials f ON f.charity_id=c.charity_id
)
SELECT DISTINCT
    charity_size,
    size_revenue,
    sector_revenue,
    100.0 * size_revenue / NULLIF(sector_revenue,0) AS revenue_share_pct
FROM ranked
ORDER BY revenue_share_pct DESC;

-- 3. Government funding dependency
SELECT
    c.charity_id,
    c.charity_name,
    c.charity_size,
    f.total_revenue,
    f.revenue_from_government,
    ROUND(100.0 * f.revenue_from_government / NULLIF(f.total_revenue,0),2) AS government_funding_pct,
    CASE
        WHEN f.total_revenue = 0 OR f.total_revenue IS NULL THEN 'No revenue base'
        WHEN f.revenue_from_government / f.total_revenue >= 0.75 THEN 'High dependency'
        WHEN f.revenue_from_government / f.total_revenue >= 0.40 THEN 'Moderate dependency'
        ELSE 'Lower dependency'
    END AS dependency_segment
FROM acnc.charities c
JOIN acnc.financials f ON f.charity_id=c.charity_id
ORDER BY government_funding_pct DESC NULLS LAST;

-- 4. Donation dependency
SELECT
    charity_size,
    COUNT(*) AS charities,
    ROUND(100.0 * SUM(donations_and_bequests) / NULLIF(SUM(total_revenue),0),2) AS donation_share_pct
FROM acnc.charities c
JOIN acnc.financials f ON f.charity_id=c.charity_id
GROUP BY charity_size
ORDER BY donation_share_pct DESC NULLS LAST;

-- 5. Financial sustainability segmentation
SELECT
    c.charity_size,
    COUNT(*) AS charities,
    COUNT(*) FILTER (WHERE f.total_revenue > 0 AND f.net_surplus_deficit > 0) AS surplus_charities,
    COUNT(*) FILTER (WHERE f.total_revenue > 0 AND f.net_surplus_deficit < 0) AS deficit_charities,
    ROUND(100.0 * AVG(
        CASE WHEN f.total_revenue <> 0
             THEN f.net_surplus_deficit / f.total_revenue
        END
    ),2) AS avg_net_margin,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY
        CASE WHEN f.total_revenue <> 0
             THEN f.net_surplus_deficit / f.total_revenue
        END
    ) AS median_net_margin
FROM acnc.charities c
JOIN acnc.financials f ON f.charity_id=c.charity_id
GROUP BY c.charity_size
ORDER BY median_net_margin DESC NULLS LAST;

-- 6. Volunteer intensity
SELECT
    c.charity_size,
    COUNT(*) AS charities,
    SUM(w.staff_volunteers) AS volunteers,
    SUM(w.total_full_time_equivalent_staff) AS fte,
    ROUND(
        SUM(w.staff_volunteers) / NULLIF(SUM(w.total_full_time_equivalent_staff),0),2
    ) AS volunteers_per_fte
FROM acnc.charities c
JOIN acnc.workforce w ON w.charity_id=c.charity_id
GROUP BY c.charity_size
ORDER BY volunteers_per_fte DESC NULLS LAST;

-- 7. Labour intensity: employee cost relative to revenue
SELECT
    c.charity_size,
    ROUND(
        100.0 * SUM(f.employee_expenses) / NULLIF(SUM(f.total_revenue),0),2
    ) AS employee_cost_ratio_pct,
    ROUND(
        SUM(f.employee_expenses) / NULLIF(SUM(w.total_full_time_equivalent_staff),0),2
    ) AS employee_cost_per_fte
FROM acnc.charities c
JOIN acnc.financials f ON f.charity_id=c.charity_id
JOIN acnc.workforce w ON w.charity_id=c.charity_id
GROUP BY c.charity_size
ORDER BY employee_cost_ratio_pct DESC NULLS LAST;

-- 8. Asset / liability profile
SELECT
    c.charity_size,
    SUM(f.total_assets) AS assets,
    SUM(f.total_liabilities) AS liabilities,
    ROUND(100.0 * SUM(f.total_liabilities) / NULLIF(SUM(f.total_assets),0),2) AS liability_asset_pct
FROM acnc.charities c
JOIN acnc.financials f ON f.charity_id=c.charity_id
GROUP BY c.charity_size
ORDER BY liability_asset_pct DESC NULLS LAST;

-- 9. Outlier screening: very large organisations within the top 1% of revenue.
WITH p AS (
    SELECT PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY total_revenue) AS p99_revenue
    FROM acnc.financials
    WHERE total_revenue IS NOT NULL
)
SELECT
    c.abn,
    c.charity_name,
    c.charity_size,
    f.total_revenue,
    f.total_assets,
    f.total_liabilities
FROM acnc.charities c
JOIN acnc.financials f ON f.charity_id=c.charity_id
CROSS JOIN p
WHERE f.total_revenue >= p.p99_revenue
ORDER BY f.total_revenue DESC;

-- 10. Multi-dimensional segmentation: size + funding dependency + sustainability
WITH metrics AS (
    SELECT
        c.charity_id,
        c.charity_size,
        f.total_revenue,
        f.net_surplus_deficit,
        f.revenue_from_government / NULLIF(f.total_revenue,0) AS gov_dependency,
        f.net_surplus_deficit / NULLIF(f.total_revenue,0) AS margin,
        w.staff_volunteers / NULLIF(w.total_full_time_equivalent_staff,0) AS volunteer_fte
    FROM acnc.charities c
    JOIN acnc.financials f ON f.charity_id=c.charity_id
    JOIN acnc.workforce w ON w.charity_id=c.charity_id
)
SELECT
    charity_size,
    CASE WHEN gov_dependency >= .75 THEN 'High Government Dependency'
         WHEN gov_dependency >= .40 THEN 'Moderate Government Dependency'
         ELSE 'Lower Government Dependency' END AS funding_segment,
    CASE WHEN margin < 0 THEN 'Deficit'
         WHEN margin >= .10 THEN 'Strong Surplus'
         ELSE 'Thin / Moderate Surplus' END AS sustainability_segment,
    COUNT(*) AS charities,
    ROUND(AVG(volunteer_fte),2) AS avg_volunteers_per_fte
FROM metrics
GROUP BY charity_size, funding_segment, sustainability_segment
ORDER BY charities DESC;
