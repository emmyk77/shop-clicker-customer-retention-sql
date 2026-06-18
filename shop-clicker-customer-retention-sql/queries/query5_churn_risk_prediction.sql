-- ================================QUERY 5 Churn Risk Prediction=============================================
-- Write a query to predict which customers are at risk of churning based on their lack of purchases or interactions. 
-- For example, identify customers who have made only 1 purchase and have not interacted with the company in the past 6 months.
SELECT c.customer_id, c.full_name, c.location, COUNT(DISTINCT p.purchase_id) AS total_purchases,
    MAX(p.purchase_date) AS last_purchase_date, MAX(ci.interaction_date) AS last_interaction_date,
    DATEDIFF(CURDATE(), MAX(p.purchase_date)) AS days_since_purchase, DATEDIFF(CURDATE(), MAX(ci.interaction_date)) AS days_since_interaction
FROM customers c
LEFT JOIN purchases p
    ON c.customer_id = p.customer_id
LEFT JOIN customer_interactions ci
    ON c.customer_id = ci.customer_id
GROUP BY c.customer_id, c.full_name, c.location
HAVING COUNT(DISTINCT p.purchase_id) <= 1
    AND (MAX(ci.interaction_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
        OR MAX(ci.interaction_date) IS NULL)
ORDER BY days_since_purchase DESC;
