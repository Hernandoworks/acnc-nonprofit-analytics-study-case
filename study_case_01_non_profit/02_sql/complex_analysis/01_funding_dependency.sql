-- Business question:
-- Which charities are most dependent on government funding?

WITH x AS (
    SELECT
        c.charity_id,
        c.abn,
        c.charity_name,
        c.charity_size,
        f.total_revenue,
        f.revenue_from_government,
        f.donations_and_bequests,
        CASE
            WHEN f.total_revenue > 0
            THEN f.revenue_from_government / f.total_revenue
        END AS government_funding_pct
    FROM acnc.charities c
    JOIN acnc.financials f ON f.charity_id = c.charity_id
)
SELECT *
FROM x
WHERE total_revenue > 0
ORDER BY government_funding_pct DESC NULLS LAST
LIMIT 100;
