-- =========================================================
-- ABC Analysis
-- Classify products by revenue contribution
-- =========================================================

WITH product_revenue AS (
    SELECT
        product_id,
        category,
        ROUND(SUM(sales_revenue), 2) AS total_sales_revenue,
        ROUND(SUM(units_sold), 0) AS total_units_sold
    FROM inventory_data
    GROUP BY product_id, category
),

revenue_share AS (
    SELECT
        product_id,
        category,
        total_sales_revenue,
        total_units_sold,
        ROUND(
            total_sales_revenue * 100.0 / SUM(total_sales_revenue) OVER (),
            2
        ) AS revenue_percentage
    FROM product_revenue
),

abc_calc AS (
    SELECT
        product_id,
        category,
        total_sales_revenue,
        total_units_sold,
        revenue_percentage,
        ROUND(
            SUM(revenue_percentage) OVER (
                ORDER BY total_sales_revenue DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ),
            2
        ) AS cumulative_revenue_percentage
    FROM revenue_share
)

SELECT
    product_id,
    category,
    total_sales_revenue,
    total_units_sold,
    revenue_percentage,
    cumulative_revenue_percentage,
    CASE
        WHEN cumulative_revenue_percentage <= 80 THEN 'A'
        WHEN cumulative_revenue_percentage <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM abc_calc
ORDER BY total_sales_revenue DESC;