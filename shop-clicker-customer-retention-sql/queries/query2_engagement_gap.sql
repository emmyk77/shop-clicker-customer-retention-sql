-- =============================QUERY 2 engagement gap===========================
-- Write a query to find customers who have not interacted with the company in the past 3 months
SELECT c.customer_id, c.full_name,
    ci.interaction_type AS last_interaction_type,
    ci.interaction_date AS last_interaction_date,
    DATEDIFF(CURDATE(), ci.interaction_date) 	AS days_since_last_interaction
FROM customers c
LEFT JOIN (
    SELECT customer_id, interaction_type, interaction_date
    FROM customer_interactions ci1
    WHERE interaction_date = (
        SELECT MAX(ci2.interaction_date)
        FROM customer_interactions ci2
        WHERE ci2.customer_id = ci1.customer_id)) ci
ON c.customer_id = ci.customer_id
WHERE ci.interaction_date IS NULL
   OR ci.interaction_date < CURDATE() - INTERVAL 3 MONTH;


