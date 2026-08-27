-- Business question:
-- How concentrated is the charity sector's reported revenue?

WITH ranked AS (
    SELECT
        c.charity_id,
        c.charity_name,
        f.total_revenue,
        SUM(f.total_revenue) OVER () AS sector_revenue,
        SUM(f.total_revenue) OVER (
            ORDER BY f.total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        ROW_NUMBER() OVER (ORDER BY f.total_revenue DESC) AS revenue_rank
    FROM acnc.charities c
    JOIN acnc.financials f ON f.charity_id = c.charity_id
    WHERE f.total_revenue > 0
)
SELECT
    revenue_rank,
    charity_name,
    total_revenue,
    cumulative_revenue / NULLIF(sector_revenue, 0) AS cumulative_revenue_share
FROM ranked
ORDER BY revenue_rank
LIMIT 100;
