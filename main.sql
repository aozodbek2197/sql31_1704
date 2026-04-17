-- 1-mashq
WITH RECURSIVE hierarchy AS (
    SELECT 
        id, 
        name, 
        manager_id, 
        CAST(name AS CHAR(200)) AS path,
        0 AS level
    FROM employees 
    WHERE manager_id IS NULL
    UNION ALL
    SELECT 
        e.id, 
        e.name, 
        e.manager_id, 
        CONCAT(h.path, ' > ', e.name),
        h.level + 1
    FROM employees e
    JOIN hierarchy h ON e.manager_id = h.id
)
SELECT id, name, path, level
FROM hierarchy
ORDER BY path;
-- 2-mashq
WITH RECURSIVE years AS (
    SELECT MIN(YEAR(order_date)) AS year FROM orders
    UNION ALL
    SELECT year + 1 FROM years WHERE year < (SELECT MAX(YEAR(order_date)) FROM orders)
),
yearly_sales AS (
    SELECT 
        YEAR(order_date) AS year,
        SUM(amount) AS total_sales
    FROM orders
    GROUP BY YEAR(order_date)
)
SELECT 
    y.year,
    COALESCE(ys.total_sales, 0) AS total_sales,
    SUM(COALESCE(ys.total_sales, 0)) OVER (ORDER BY y.year) AS cumulative_sales
FROM years y
LEFT JOIN yearly_sales ys ON y.year = ys.year
ORDER BY y.year;
