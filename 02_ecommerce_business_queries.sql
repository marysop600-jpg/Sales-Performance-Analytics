USE ECommerce_DB;
GO

-- 1. Sales and Revenue by Category
SELECT 
    p.category,
    COUNT(s.order_id) AS total_orders,
    SUM(s.quantity) AS units_sold,
    SUM(s.total_amount) AS total_revenue
FROM dbo.Fact_Sales s
JOIN dbo.Dim_Products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 2. Performance by City
SELECT 
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(s.order_id) AS total_orders,
    SUM(s.total_amount) AS city_revenue
FROM dbo.Fact_Sales s
JOIN dbo.Dim_Customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY city_revenue DESC;

-- 3. Repeat Customers Analysis
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(s.order_id) AS orders_count,
    SUM(s.total_amount) AS total_spent
FROM dbo.Fact_Sales s
JOIN dbo.Dim_Customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(s.order_id) > 1
ORDER BY total_spent DESC;

-- 4. Top Performing Products (Ranking)
SELECT 
    p.product_name,
    p.category,
    SUM(s.total_amount) AS revenue,
    DENSE_RANK() OVER(ORDER BY SUM(s.total_amount) DESC) AS rank_no
FROM dbo.Fact_Sales s
JOIN dbo.Dim_Products p ON s.product_id = p.product_id
GROUP BY p.product_name, p.category;