.open fittrackpro.db
.mode column

-- 5.1 
-- INNER JOIN ensures only members with membership records are included.
-- Selecting join_date with membership type provides context for membership duration.
SELECT 
    members.member_id,
    members.first_name,
    members.last_name,
    memberships.type AS membership_type,
    members.join_date
FROM members
JOIN memberships
    ON members.member_id = memberships.member_id
WHERE memberships.status = 'Active';

-- 5.2 
-- julianday() is required in SQLite to calculate time differences from datetime values.
-- Multiplying by 24 * 60 gets the difference from days into minutes.
SELECT 
    memberships.type AS membership_type,
    AVG(
        (julianday(attendance.check_out_time) - 
         julianday(attendance.check_in_time)) * 24 * 60
    ) AS avg_visit_duration_minutes
FROM attendance
JOIN memberships
    ON attendance.member_id = memberships.member_id
GROUP BY memberships.type;

-- 5.3 
-- strftime('%Y',) extracts the year from a date stored as text
-- Filtering by year allowsme to identfy memberships ending within a specific calendar year.
SELECT 
    members.member_id,
    members.first_name,
    members.last_name,
    members.email,
    memberships.end_date
FROM members
JOIN memberships
    ON members.member_id = memberships.member_id
WHERE strftime('%Y', memberships.end_date) = '2025';

