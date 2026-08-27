-- Business question:
-- Which charity segments operate with the greatest volunteer intensity?

SELECT
    c.charity_size,
    COUNT(*) AS charities,
    SUM(w.total_full_time_equivalent_staff) AS total_fte,
    SUM(w.staff_volunteers) AS total_volunteers,
    AVG(
        CASE WHEN w.total_full_time_equivalent_staff > 0
             THEN w.staff_volunteers / w.total_full_time_equivalent_staff END
    ) AS avg_volunteer_fte_ratio,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY w.staff_volunteers) AS median_volunteers
FROM acnc.charities c
JOIN acnc.workforce w ON w.charity_id = c.charity_id
GROUP BY c.charity_size
ORDER BY avg_volunteer_fte_ratio DESC NULLS LAST;
