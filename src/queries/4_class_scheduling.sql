.open fittrackpro.db
.mode column

-- 4.1 
-- INNER JOINs are used to ensure only scheduled classes with assigned instructors are returned.
-- Ordering by class_id keeps results logically grouped and easy to review.
SELECT 
    classes.class_id,
    classes.name AS class_name,
    staff.first_name || ' ' || staff.last_name AS instructor_name
FROM classes
JOIN class_schedule
    ON classes.class_id = class_schedule.class_id
JOIN staff
    ON class_schedule.staff_id = staff.staff_id
ORDER BY classes.class_id;

-- 4.2 
-- LEFT JOIN ensures classes with zero registrations are still included.
-- GROUP BY schedule_id aggregates attendance per session rather than per class.
-- Capacity minus COUNT() calculates the remaining availability.
SELECT 
    classes.class_id,
    classes.name,
    class_schedule.start_time,
    class_schedule.end_time,
    classes.capacity - COUNT(class_attendance.class_attendance_id) AS available_spots
FROM classes
JOIN class_schedule
    ON classes.class_id = class_schedule.class_id
LEFT JOIN class_attendance
    ON class_schedule.schedule_id = class_attendance.schedule_id
WHERE DATE(class_schedule.start_time) = '2025-02-01'
GROUP BY class_schedule.schedule_id
ORDER BY class_schedule.start_time;

-- 4.3 
-- Filtering by class_id and date ensures the registration targets the correct session.
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
SELECT class_schedule.schedule_id, 11, 'Registered'
FROM class_schedule
WHERE class_schedule.class_id = 1
AND DATE(class_schedule.start_time) = '2025-02-01';


-- 4.4 
-- Both member_id and schedule_id are specified to target only one attendance record so doesnt effect anything else.
DELETE FROM class_attendance
WHERE member_id = 3
AND schedule_id = 7;

-- 4.5 
-- Filtering by attendance_status ensures only active registrations are counted.
-- ORDER BY DESC with LIMIT 1 returns the most popular class.
SELECT 
    classes.class_id,
    classes.name AS class_name,
    COUNT(class_attendance.class_attendance_id) AS registration_count
FROM classes
JOIN class_schedule
    ON classes.class_id = class_schedule.class_id
JOIN class_attendance
    ON class_schedule.schedule_id = class_attendance.schedule_id
WHERE class_attendance.attendance_status = 'Registered'
GROUP BY classes.class_id
ORDER BY registration_count DESC
LIMIT 1;


-- 4.6 
-- A subquery is used to first calculate class counts per member before averaging.
-- Filtering to relevant statuses ensures only valid participation is included.
SELECT 
    AVG(class_count) AS average_classes_per_member
FROM (
    SELECT 
        member_id,
        COUNT(*) AS class_count
    FROM class_attendance
    WHERE attendance_status IN ('Registered', 'Attended')
    GROUP BY member_id
);

