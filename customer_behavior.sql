select * from customer limit 20;

SELECT gender, SUM("purchase_amount_(usd)") AS revenue
FROM customer
GROUP BY gender;


SELECT *
FROM customer
WHERE discount_applied = 'Yes'
  AND "purchase_amount_(usd)" >= (
        SELECT AVG("purchase_amount_(usd)") 
        FROM customer
      );

select item_purchased , round(AVG(review_rating::numeric),2) as "Average Product Rating"
from customer 
group by item_purchased 
order by avg(review_rating)desc
limit 5;

SELECT shipping_type,
       ROUND(AVG("purchase_amount_(usd)"), 2) AS avg_purchase_amount
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;


SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG("purchase_amount_(usd)"), 2) AS avg_spend,
       ROUND(SUM("purchase_amount_(usd)"), 2) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC, avg_spend DESC;


SELECT 
    item_purchased,
    ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

WITH customer_type AS (
    SELECT 
        customer_id,
        previous_purchases,
        CASE 
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer
)
SELECT 
    customer_segment, 
    COUNT(*) AS "Number of Customers"
FROM customer_type
GROUP BY customer_segment;


WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT 
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;


