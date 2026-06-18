# 🛒 Shop Clicker — Customer Retention & Inactivity Analysis

> A SQL-based analytical project that builds a fictional e-commerce database from scratch and uses structured queries to identify customer churn patterns, engagement gaps, and at-risk buyer segments.

---

## 📌 Project Overview

E-commerce businesses bleed revenue quietly. Customers sign up, buy once or twice, then disappear — and without a solid data foundation, there is no way to know why or when it happens.

This project simulates that problem. I designed a relational database for a fictional e-commerce store called **Shop Clicker**, populated it with realistic customer data, and wrote five targeted SQL queries to surface early warning signs of churn before customers are already gone.

**This project was completed as part of a structured SQL learning assignment, and reflects real business thinking applied to query design.**

---

## 🗂️ Repository Structure

```
shop-clicker-sql/
│
├── README.md
├── schema/
│   └── create_tables.sql          # All CREATE TABLE statements
├── data/
│   └── sample_data.sql            # INSERT statements for 10+ customers, 5 products, etc.
├── queries/
│   ├── query1_purchase_frequency.sql
│   ├── query2_engagement_gap.sql
│   ├── query3_category_churn.sql
│   ├── query4_negative_feedback.sql
│   └── query5_churn_risk_prediction.sql
├── reports/
│   ├── COMPREHENSIVE_REPORT.docx
│   └── ShopClicker_KeyFindings.png
└── assets/
    └── schema_diagram.png
```

---

## 🗄️ Database Design

The database consists of **five relational tables** linked through primary and foreign keys:

| Table | Description |
|---|---|
| `customers` | Customer ID, name, age, gender, location, sign-up date |
| `products` | Product ID, name, price, category |
| `purchases` | Purchase ID, customer ID, product ID, quantity, amount, date |
| `customer_interactions` | Customer ID, interaction type, interaction date, feedback rating |
| `customer_feedback` | Customer ID, feedback date, feedback content, satisfaction rating |

### Relationships
- `purchases.customer_id` → `customers.customer_id`
- `purchases.product_id` → `products.product_id`
- `customer_interactions.customer_id` → `customers.customer_id`
- `customer_feedback.customer_id` → `customers.customer_id`

> 📎 See `assets/schema_diagram.png` for the full ERD (generated via [dbdiagram.io](https://dbdiagram.io))

---

## 🔍 SQL Queries

### Query 1 — Customer Purchase Frequency
**Business Question:** Which customers have made fewer than 2 purchases in the last 6 months?

Uses `LEFT JOIN` with a date filter and `HAVING COUNT() < 2` to isolate low-frequency buyers, along with `DATEDIFF()` to show how long since their last purchase. This gives a marketing team a direct re-engagement shortlist.

```sql
SELECT  c.customer_id, c.full_name, c.location,
        COUNT(p.purchase_id)                      AS total_purchases,
        MAX(p.purchase_date)                      AS last_purchase_date,
        DATEDIFF(CURDATE(), MAX(p.purchase_date)) AS days_since_last_purchase
FROM customers c
LEFT JOIN purchases p
    ON c.customer_id = p.customer_id
    AND p.purchase_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.customer_id, c.full_name, c.location
HAVING COUNT(p.purchase_id) < 2
ORDER BY total_purchases DESC, days_since_last_purchase DESC;
```

---

### Query 2 — Customer Engagement Gap
**Business Question:** Which customers have had no interaction with the company in the past 3 months?

Uses a correlated subquery inside a `LEFT JOIN` to find each customer's most recent interaction, then filters for those older than 3 months or missing entirely. Returns last interaction type and date so the support team knows how and when to follow up.

```sql
SELECT c.customer_id, c.full_name,
       ci.interaction_type AS last_interaction_type,
       ci.interaction_date AS last_interaction_date,
       DATEDIFF(CURDATE(), ci.interaction_date) AS days_since_last_interaction
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
```

---

### Query 3 — Product Category Churn
**Business Question:** Which product categories have the highest number of customers who bought once and never came back?

Uses a subquery to find customers with exactly one purchase per category, then groups by category and ranks by churn count. Identifies which product lines have the weakest repeat purchase rate — useful for product and pricing strategy.

```sql
SELECT
    category,
    COUNT(*) AS customers_who_purchased_once_and_did_not_return
FROM (
    SELECT p.customer_id, pr.category, COUNT(*) AS purchase_count
    FROM purchases p
    JOIN products pr ON p.product_id = pr.product_id
    GROUP BY p.customer_id, pr.category
    HAVING COUNT(*) = 1
) AS category_churn
GROUP BY category
ORDER BY customers_who_purchased_once_and_did_not_return DESC
LIMIT 5;
```

---

### Query 4 — Negative Feedback Analysis
**Business Question:** Which customers have left a satisfaction rating below 3 in the last 6 months?

A straightforward `JOIN` and `WHERE` filter on the feedback table, sorted by lowest rating first. Surfaces dissatisfied customers for service recovery before a complaint becomes a lost customer.

```sql
SELECT c.customer_id, c.full_name, c.location,
       cf.feedback_date, cf.feedback_content, cf.satisfaction_rating
FROM customers c
JOIN customer_feedback cf ON c.customer_id = cf.customer_id
WHERE cf.satisfaction_rating < 3
  AND cf.feedback_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY cf.satisfaction_rating ASC, cf.feedback_date DESC;
```

---

### Query 5 — Churn Risk Prediction
**Business Question:** Which customers have made only 1 purchase AND have had no interaction in the past 6 months?

The most complex query in the project. Combines `LEFT JOIN` across both the purchases and interactions tables, uses `COUNT(DISTINCT)` and `DATEDIFF()` to calculate inactivity windows, and applies a `HAVING` clause with compound conditions to flag the highest-risk profiles. Produces a ready-to-use churn list for retention campaigns.

```sql
SELECT
    c.customer_id, c.full_name, c.location,
    COUNT(DISTINCT p.purchase_id)                        AS total_purchases,
    MAX(p.purchase_date)                                 AS last_purchase_date,
    MAX(ci.interaction_date)                             AS last_interaction_date,
    DATEDIFF('2026-04-01', MAX(p.purchase_date))         AS days_since_purchase,
    DATEDIFF('2026-04-01', MAX(ci.interaction_date))     AS days_since_interaction
FROM customers c
LEFT JOIN purchases p ON c.customer_id = p.customer_id
LEFT JOIN customer_interactions ci ON c.customer_id = ci.customer_id
GROUP BY c.customer_id, c.full_name, c.location, c.signup_date
HAVING COUNT(DISTINCT p.purchase_id) <= 1
   AND (MAX(ci.interaction_date) < DATE_SUB('2026-04-01', INTERVAL 6 MONTH)
        OR MAX(ci.interaction_date) IS NULL)
ORDER BY days_since_purchase DESC;
```

---

## 📊 Sample Output

### Query 4 — Negative Feedback (Example)

| customer_id | full_name | location | feedback_date | feedback_content | satisfaction_rating |
|---|---|---|---|---|---|
| C005 | Sarah Bello | Lagos | 2025-11-12 | Customer service was poor | 2 |
| C009 | Paul Yusuf | Abuja | 2025-10-03 | Response to complaint was slow | 2 |

### Query 5 — Churn Risk (Example)

| customer_id | full_name | total_purchases | last_purchase_date | last_interaction_date | days_since_purchase |
|---|---|---|---|---|---|
| C009 | Paul Yusuf | 1 | 2025-07-14 | 2025-08-01 | 261 |
| C003 | Michael Obi | 1 | 2025-08-20 | NULL | 224 |

---

## 🛠️ Tools Used

- **MySQL** — database creation and query execution
- **MySQL Workbench** — schema design and query testing
- **dbdiagram.io** — ERD / schema diagram
- **MS Word** — project report documentation

---

## 💡 Key Learnings

This project taught me the difference between **knowing SQL syntax** and **thinking in SQL**.

The hardest part was not the code itself — it was translating real business questions into query logic. Query 2 required me to learn correlated subqueries to isolate the most recent interaction per customer. Query 5 pushed me to combine `LEFT JOIN` across multiple tables with compound `HAVING` conditions in a single query.

I also discovered that for some queries, multiple approaches exist. Where alternatives were too complex for my current level, I went with the approach I could understand, implement, and explain clearly. I welcome feedback on alternative approaches — that is exactly how this kind of learning deepens.

---

## 📁 How to Run

1. Clone this repository
2. Open MySQL Workbench (or any MySQL client)
3. Run `schema/create_tables.sql` to create the database and tables
4. Run `data/sample_data.sql` to insert sample records
5. Run any query file from the `queries/` folder

```bash
# Or via CLI
mysql -u root -p < schema/create_tables.sql
mysql -u root -p shopclicker < data/sample_data.sql
```

---

## 👤 Author

**Emmanuel Kebodi Friday (Emmyk)**
Data Analyst | Emmyk Consults | Lagos, Nigeria

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/your-linkedin-handle)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black)](https://github.com/your-github-handle)

---

*This project is part of my public SQL learning journey documented on LinkedIn. Feedback, suggestions, and pull requests are welcome.*
