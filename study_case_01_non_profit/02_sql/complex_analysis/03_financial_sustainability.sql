-- Business question:
-- How does financial sustainability vary by charity size?

SELECT
    c.charity_size,
    COUNT(*) AS charities,
    SUM(f.total_revenue) AS total_revenue,
    SUM(f.total_expenses) AS total_expenses,
    SUM(f.net_surplus_deficit) AS net_surplus,
    AVG(
        CASE WHEN f.total_revenue <> 0
             THEN f.net_surplus_deficit / f.total_revenue END
    ) AS avg_net_margin,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY f.total_revenue) AS median_revenue,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY f.net_surplus_deficit) AS median_net_surplus
FROM acnc.charities c
JOIN acnc.financials f ON f.charity_id = c.charity_id
GROUP BY c.charity_size
ORDER BY total_revenue DESC;
