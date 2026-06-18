-- ================================QUERY 4 negative feedback =========================
-- Write a query to analyze customer satisfaction ratings. 
-- Identify customers who have left negative feedback (e.g., satisfaction rating below 3) in the past 6 months.

SELECT c.customer_id, c.full_name, c.location, cf.feedback_date, cf.feedback_content, cf.satisfaction_rating
FROM customers c
JOIN customer_feedback cf
    ON c.customer_id = cf.customer_id
WHERE cf.satisfaction_rating < 3
AND cf.feedback_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);