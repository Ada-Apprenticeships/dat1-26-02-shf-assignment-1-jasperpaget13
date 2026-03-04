.open fittrackpro.db
.mode column

-- 7.1 
-- Ordering by position groups staff by role, improving readability and clarity.
SELECT 
    staff_id,
    first_name,
    last_name,
    position AS role
FROM staff
ORDER BY position;

-- 7.2 
-- The date range limits results to a specific 30-day period using the DATE() function.
-- INNER JOIN ensures only trainers with recorded sessions are counted
SELECT 
    staff.staff_id AS trainer_id,
    staff.first_name || ' ' || staff.last_name AS trainer_name,
    COUNT(personal_training_sessions.session_id) AS session_count
FROM staff
JOIN personal_training_sessions
    ON staff.staff_id = personal_training_sessions.staff_id
WHERE staff.position = 'Trainer'
AND personal_training_sessions.session_date 
    BETWEEN '2025-01-20' AND DATE('2025-01-20', '+30 days')
GROUP BY staff.staff_id;

