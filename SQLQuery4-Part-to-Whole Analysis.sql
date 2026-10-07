/*
===============================================================================
Category Sales Mix
===============================================================================
Business question:
    Which product categories account for the largest share of recorded sales?

Use this as the first step in a sales review: understand the category mix, then
use SQLQuery3-Performance Analysis.sql to inspect annual changes for products.
The percentage describes the observed dataset; it does not explain why sales
share differs between categories.

SQL techniques:
    - CTE for category-level sales aggregation.
    - Window SUM() OVER() to calculate the overall total and each category's share.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND(
        CAST(total_sales AS FLOAT) / NULLIF(SUM(total_sales) OVER (), 0) * 100,
        2
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
