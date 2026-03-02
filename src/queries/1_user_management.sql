.open fittrackpro.db
.mode column

-- 1.1
-- Retrieve key member details from the members table.
-- Only necessary columns are selected to avoid unnecessary data and improve query clarity.
SELECT
member_id,
first_name,
last_name,
email,
join_date
FROM members;

-- 1.2
-- Update a specific member's contact details using their primary key (member_id).
-- Using WHERE ensures only the intended record is modified, preventing accidental updates to all rows.
UPDATE members 
SET phone_number = '07000 10005',
    email = 'emily.jones.updated@email.com'
WHERE member_id = 5;

-- 1.3
-- COUNT(*) is used because it efficiently counts all rows, including those with NULL values.
SELECT COUNT(*) AS total_members
FROM members;

-- 1.4
-- INNER JOIN ensures only members with attendance records are included.
-- GROUP BY aggregates registrations per member.
-- ORDER BY DESC with LIMIT 1 returns the top attendee.
SELECT m.member_id AS member_id,
       m.first_name,
       m.last_name,
       COUNT(c.schedule_id) AS registration_count
FROM members m
JOIN class_attendance c ON m.member_id = c.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count DESC
LIMIT 1;

-- 1.5
-- LEFT JOIN is used to include members with zero registrations.
-- ORDER BY ASC ensures the smallest count appears first.
-- LIMIT 1 returns the member with the fewest (or no) registrations.
SELECT m.member_id,
       m.first_name,
       m.last_name,
       COUNT(c.schedule_id) AS registration_count
FROM members m
LEFT JOIN class_attendance c ON m.member_id = c.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count ASC
LIMIT 1;

-- 1.6
-- WHERE filters only 'Attended' records before aggregation.
-- GROUP BY groups records per member.
-- HAVING COUNT(*) >= 2 ensures only members meeting the threshold are counted.
-- COUNT(DISTINCT member_id) counts how many members satisfy this condition.
SELECT COUNT(DISTINCT member_id) AS members_with_2_or_more_attendances
FROM class_attendance
WHERE attendance_status = 'Attended'
GROUP BY member_id
HAVING COUNT(*) >= 2;


