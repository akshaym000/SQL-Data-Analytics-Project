/*================================================================
Product Report
================================================================
Purpose:
- This report consolidates key product metrics and behaviors

Highlights:
1. Gathers essential fields such as product name, category, subcategory and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates Product-level metrics:
   - total orders
   - total sales
   - total quantity sold
   - total customers(unique)
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last order)
   - average order revenue
   - average monthly revenue
================================================================
*/
USE DataWarehouseAnalytics;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS (
/*----------------------------------------------------------------------------------
 1) Base Query: Retrieves core columns from fact_sales and dim_products
----------------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL -- only consider valid sales dates
),

/*----------------------------------------------------------------------------------
 2) Product Aggregations: Summarizes key metrics at the product level
----------------------------------------------------------------------------------*/
product_aggregations AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        -- Lifespan is calculated as the number of months from the first to the last sale.
        -- Adding 1 to make it inclusive (e.g., a product sold only in May has a 1-month lifespan).
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) + 1 AS lifespan_in_months,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        -- Correctly calculate avg selling price as total sales divided by total quantity.
        -- Use NULLIF to prevent division-by-zero errors.
        ROUND(SUM(sales_amount) / NULLIF(SUM(quantity), 0), 2) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

/*----------------------------------------------------------------------------------
 3) Final Query: Combines all product results into one output
----------------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan_in_months,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    -- Average Order Revenue (AOR)
    -- Cast to FLOAT to avoid integer division and ensure accurate decimal results.
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE CAST(total_sales AS FLOAT) / total_orders
    END AS avg_order_revenue,
    -- Average Monthly Revenue
    -- The improved lifespan calculation simplifies this logic.
    CAST(total_sales AS FLOAT) / lifespan_in_months AS avg_monthly_revenue
FROM product_aggregations;
