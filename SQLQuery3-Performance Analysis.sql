/*
===============================================================================
Product Performance: Annual Trend and Year-over-Year Change
===============================================================================
Business question:
    After identifying which product categories contribute most to sales, which
    products within those categories are gaining or losing sales compared with
    the same product in the prior calendar year?

Interpretation:
    This is a descriptive prioritization view. A sales increase or decrease is
    a signal for follow-up, not evidence that a particular cause or action drove it.

SQL techniques:
    - CTEs for annual product-level aggregation.
    - Window function AVG() OVER() for each product's observed-year baseline.
    - Self-join to compare only with the immediately prior calendar year.
    - CASE expressions for readable direction labels.
===============================================================================
*/

USE DataWarehouseAnalytics;
GO

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_key,
        p.product_name,
        p.category,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_key,
        p.product_name,
        p.category
)
SELECT
    current_year.order_year,
    current_year.category,
    current_year.product_name,
    current_year.current_sales,
    AVG(current_year.current_sales) OVER (
        PARTITION BY current_year.product_key
    ) AS avg_annual_sales,
    current_year.current_sales
        - AVG(current_year.current_sales) OVER (
            PARTITION BY current_year.product_key
        ) AS difference_from_product_average,
    prior_year.current_sales AS prior_year_sales,
    current_year.current_sales - prior_year.current_sales AS change_from_prior_year,
    CASE
        WHEN prior_year.current_sales IS NULL THEN NULL
        WHEN prior_year.current_sales = 0 THEN NULL
        ELSE ROUND(
            (current_year.current_sales - prior_year.current_sales) * 100.0
                / prior_year.current_sales,
            2
        )
    END AS prior_year_change_pct,
    CASE
        WHEN prior_year.current_sales IS NULL THEN 'No prior-year comparison'
        WHEN current_year.current_sales > prior_year.current_sales THEN 'Increase'
        WHEN current_year.current_sales < prior_year.current_sales THEN 'Decrease'
        ELSE 'No change'
    END AS prior_year_direction
FROM yearly_product_sales AS current_year
LEFT JOIN yearly_product_sales AS prior_year
    ON prior_year.product_key = current_year.product_key
    AND prior_year.order_year = current_year.order_year - 1
ORDER BY
    current_year.category,
    current_year.product_name,
    current_year.order_year;
