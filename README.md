# SQL Sales Analytics: Category Mix and Product Trends

## Project brief

This is a portfolio analysis of a sales dataset, framed as a sales-planning review:

> Which product categories contribute most to recorded sales, and which products within those categories are gaining or losing sales compared with the prior calendar year?

The project first summarizes category sales mix, then compares annual product sales with the same product's sales in the prior calendar year. The goal is to help an analyst decide where to investigate further—not to claim that the data explains why sales changed or that a specific business action will improve them.

This is a self-directed portfolio exercise, not work commissioned by a company. The SQL produces descriptive comparisons; it does not establish causation.

## Analysis path

1. **Category mix** — `SQLQuery4-Part-to-Whole Analysis.sql` calculates total sales by category and each category's percentage of overall sales. This gives a high-level view of where recorded revenue is concentrated.
2. **Product movement** — `SQLQuery3-Performance Analysis.sql` compares each product's annual sales with its own observed-year average and, when available, the immediately prior calendar year's sales. It reports the dollar change, percentage change, and direction.
3. **Follow-up analyses** — the other scripts examine time trends, cumulative annual metrics, segmentation, and reusable customer and product reports.

A missing prior-year value is labeled as having no prior-year comparison; it is not treated as zero growth. Percentage change is left blank if the prior-year sales are zero.

## Data model

The workflow uses a simple star-schema layout in SQL Server:

- `gold.fact_sales` stores transaction-level sales.
- `gold.dim_customers` stores customer attributes.
- `gold.dim_products` stores product attributes.

## Additional analyses and reports

- **Change over time:** sales, quantity, and distinct customers by month or year.
- **Cumulative analysis:** annual cumulative sales and average price.
- **Segmentation:** product cost bands and customer groups based on spending and observed purchase history.
- **Reusable reports:** `gold.report_products` and `gold.report_customers` views with product- and customer-level metrics.

## What the project demonstrates

- Designing and querying a fact-and-dimension model.
- Aggregation with `GROUP BY` and common table expressions.
- Window functions such as `SUM() OVER` and `AVG() OVER`.
- Year-over-year comparison, including handling years with no matching prior-year record.
- Conditional labels with `CASE` expressions.
- Building SQL views for repeatable reporting.

## Repository contents

- `data script.sql` — creates the database and tables, then loads the CSV files.
- `SQLQuery1-Change over time.sql` — time-based sales and customer summaries.
- `SQLQuery2-Cumulative analysis.sql` — annual cumulative sales and average price.
- `SQLQuery3-Performance Analysis.sql` — annual product performance and prior-calendar-year comparisons.
- `SQLQuery4-Part-to-Whole Analysis.sql` — category sales mix.
- `SQLQuery5-Data Segmentation Analysis.sql` — product cost bands and customer segments.
- `SQLQuery6-Product Report.sql` — creates the product reporting view.
- `SQLQuery7-Customer Report.sql` — creates the customer reporting view.

## Setup and run

1. Use SQL Server 2022 or later; the analysis uses `DATETRUNC`.
2. Obtain the three source CSV files for customers, products, and sales. They are not included in this repository.
3. In `data script.sql`, replace the example file paths in the `BULK INSERT` statements with paths accessible to the SQL Server service account.
4. Run `data script.sql` first.
5. To follow the main story, run `SQLQuery4-Part-to-Whole Analysis.sql` and then `SQLQuery3-Performance Analysis.sql`. Run the other analyses as needed. Run the product and customer report scripts to create their views.

**Database reset warning:** `data script.sql` drops and recreates `DataWarehouseAnalytics` if it already exists. Running it deletes the existing database and its contents. Back up anything you need before running the script.

## Interview summary

> I framed this as a sales-planning review: first, where is recorded sales concentrated by category, and then which products are gaining or losing sales year over year? I used SQL to aggregate category sales and compare each product with the immediately prior calendar year, while keeping missing comparison years distinct from zero growth. It is a descriptive portfolio analysis, so I would use the patterns to decide what to investigate next rather than claim a cause or business impact.
