.open fittrackpro.db
.mode column


-- 3.1 
-- A date range is used instead of BETWEEN to create a 30-day window.
-- SQLite’s date() function ensures a proper date without manual calculation.
SELECT 
    equipment_id,
    name,
    next_maintenance_date
FROM equipment
WHERE next_maintenance_date >= '2025-01-01'
  AND next_maintenance_date < date('2025-01-01', '+30 days')
ORDER BY next_maintenance_date;

-- 3.2 
-- GROUP BY is used to aggregate equipment by type.
SELECT 
    type AS equipment_type,
    COUNT(*) AS count
FROM equipment
GROUP BY type;

-- 3.3 
-- julianday() is used because SQLite stores dates as text and you need to convert it for calculations.
SELECT 
    type,
    AVG(julianday('now') - julianday(purchase_date)) AS avg_age_days
FROM equipment
GROUP BY type;

