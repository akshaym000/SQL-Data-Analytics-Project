SQL Data Analytics Project: Sales, Products & Customers

1. Project Overview

This project demonstrates a complete data analytics workflow using SQL, from database design and data loading to in-depth analysis and reporting. The primary goal was to build a robust data foundation and derive actionable business intelligence from sales, product, and customer data.

The entire project is self-contained in a single SQL script, showcasing proficiency in:

Database Design: Implementing a star schema for optimal querying.

Data Loading: Using BULK INSERT to efficiently populate the database.

Advanced SQL: Employing CTEs, window functions (LAG(), SUM() OVER()), and CASE statements for complex analysis.

Business Reporting: Creating reusable views to provide a single source of truth for key metrics.

2. Project Components
   
The project is structured around a DataWarehouseAnalytics database with a star schema model, consisting of the following tables:

gold.fact_sales: A fact table storing granular sales transactions.

gold.dim_customers: A dimension table with customer details.

gold.dim_products: A dimension table with product details.

3. Key Analyses & Reports
   
The SQL script performs several key analyses to uncover business insights:

Change Over Time Analysis: Tracks sales performance and customer counts over monthly periods to identify trends and seasonality.

Cumulative & Performance Analysis: Uses window functions to calculate running totals and moving averages, and performs year-over-year (YoY) comparisons to benchmark product performance.

Part-to-Whole Analysis: Determines the percentage contribution of each product category to overall sales.

Data Segmentation: Groups customers and products into meaningful segments (e.g., VIP/Regular/New customers, and High/Mid/Low-Performer products) for targeted strategies.

The script concludes with the creation of two comprehensive reporting views:

gold.report_products: A consolidated view of all product-level metrics and KPIs.

gold.report_customers: A detailed report on customer behavior, including segmentation and key spending metrics.

4. How to Use
   
To replicate this project and run the analysis yourself:

Ensure you have a SQL Server environment set up.

Download the .sql script and the CSV files (from the original project source if you have them, as the BULK INSERT paths are hardcoded).

Modify the file paths in the BULK INSERT statements to match the location of the CSV files on your machine.

Execute the entire script in SQL Server Management Studio (SSMS) or your preferred SQL client.
