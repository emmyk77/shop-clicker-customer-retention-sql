-- ==============================QUERY 1--Purchase Frequency =============================================

-- Write a query to identify customers who have made fewer than 2 purchases in the last 6 months.
SELECT  c.customer_id, c.full_name,  c.location,  
	COUNT(p.purchase_id) 				      AS total_purchases,
	MAX(p.purchase_date)					  AS last_purchase_date,  
    DATEDIFF(CURDATE(), MAX(p.purchase_date)) AS days_since_last_purchase
FROM customers c
LEFT JOIN purchases p
    ON c.customer_id = p.customer_id
    AND p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.customer_id, c.full_name, c.location
HAVING COUNT(p.purchase_id) < 2
ORDER BY total_purchases DESC, days_since_last_purchase DESC;