.open fittrackpro.db
.mode column

-- 6.1 
-- NULL is used for check_out_time to represent an active visit that hasn't ended.
INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (7, 1, '2025-02-14 16:30:00', NULL);

-- 6.2
-- DATE() extracts only the date portion for clearer reporting while keeping the full timestamps.
SELECT 
    DATE(check_in_time) AS visit_date,
    check_in_time,
    check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY check_in_time;

-- 6.3 
-- strftime('%w') gets the day of week from a datetime value
-- ORDER BY DESC with LIMIT 1 efficiently identifies the most common visit day.
SELECT 
    strftime('%w', check_in_time) AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;

-- 6.4 
-- A subquery calculates daily attendance per location before averaging.
-- GROUP BY location ensures each location’s average is calculated independently.
SELECT 
    locations.name AS location_name,
    AVG(daily_count) AS avg_daily_attendance
FROM locations
JOIN (
    SELECT 
        location_id,
        DATE(check_in_time) AS visit_date,
        COUNT(*) AS daily_count
    FROM attendance
    GROUP BY location_id, DATE(check_in_time)
) AS daily_counts
ON locations.location_id = daily_counts.location_id
GROUP BY locations.location_id;

