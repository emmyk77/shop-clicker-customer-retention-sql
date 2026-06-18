-- =============================QUERY 3 Category Churn =============================
-- Write a query to identify which product categories have the highest churn rate. For example, identify the top 5 product categories with the highest number of customers 
-- who made a purchase but did not return for another purchase.
SELECT
    category, 
    COUNT(*) AS customers_who_purchased_once_and_did_not_return
FROM ( 
    SELECT p.customer_id, pr.category, COUNT(*) AS purchase_count
    FROM purchases p
    JOIN products pr 
        ON p.product_id = pr.product_id
    GROUP BY p.customer_id, pr.category
    HAVING COUNT(*) = 1
) AS category_churn
GROUP BY category
ORDER BY customers_who_purchased_once_and_did_not_return DESC
LIMIT 5;

