.open fittrackpro.db
.mode column

-- 8.1 
-- Filtering by instructor name isolates sessions led by a specific trainer.
SELECT 
    personal_training_sessions.session_id,
    members.first_name || ' ' || members.last_name AS member_name,
    personal_training_sessions.session_date,
    personal_training_sessions.start_time,
    personal_training_sessions.end_time
FROM personal_training_sessions
JOIN staff
    ON personal_training_sessions.staff_id = staff.staff_id
JOIN members
    ON personal_training_sessions.member_id = members.member_id
WHERE staff.first_name = 'Ivy'
AND staff.last_name = 'Irwin'
ORDER BY personal_training_sessions.session_date;


