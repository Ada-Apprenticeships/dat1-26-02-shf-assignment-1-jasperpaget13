.open fittrackpro.db
.mode column


-- 2.1 
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (11, 50.00, DATETIME('now'), 'Credit Card', 'Monthly membership fee');

-- 2.2 
-- Using strftime('%Y-%m') to get the year and month from payment_date
-- Filter only membership fee payments with BETWEEN for the specified 4-month period.
SELECT 
    strftime('%Y-%m', payment_date) AS month,
    SUM(amount) AS total_revenue
FROM payments
WHERE payment_type = 'Monthly membership fee'
AND payment_date BETWEEN '2024-11-01' AND '2025-02-28'
GROUP BY month
ORDER BY month;

-- 2.3 
-- Filtering by payment_type isolates day pass transactions from other payment types
SELECT 
    payment_id,
    amount,
    payment_date,
    payment_method
FROM payments
WHERE payment_type = 'Day pass'
ORDER BY payment_date;

