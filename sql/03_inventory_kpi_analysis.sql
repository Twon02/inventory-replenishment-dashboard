-- =========================================================
-- Inventory Replenishment & Stockout Risk Dashboard
-- Core KPI Analysis
-- =========================================================


-- 1. Executive KPI summary
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT store_id) AS total_stores,
    COUNT(DISTINCT product_id) AS total_products,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(units_ordered), 0) AS total_units_ordered,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(forecast_accuracy), 4) AS avg_forecast_accuracy,
    ROUND(SUM(stockout_risk) * 100.0 / COUNT(*), 2) AS stockout_risk_rate,
    ROUND(SUM(overstock_risk) * 100.0 / COUNT(*), 2) AS overstock_risk_rate
FROM inventory_data;


-- 2. KPI summary by category
SELECT
    category,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(demand_forecast), 2) AS avg_demand_forecast,
    ROUND(AVG(forecast_accuracy), 4) AS avg_forecast_accuracy,
    ROUND(SUM(stockout_risk) * 100.0 / COUNT(*), 2) AS stockout_risk_rate,
    ROUND(SUM(overstock_risk) * 100.0 / COUNT(*), 2) AS overstock_risk_rate,
    ROUND(SUM(inventory_value), 2) AS total_inventory_value
FROM inventory_data
GROUP BY category
ORDER BY total_sales_revenue DESC;


-- 3. KPI summary by product
SELECT
    product_id,
    category,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(demand_forecast), 2) AS avg_demand_forecast,
    ROUND(AVG(forecast_accuracy), 4) AS avg_forecast_accuracy,
    ROUND(SUM(stockout_risk) * 100.0 / COUNT(*), 2) AS stockout_risk_rate,
    ROUND(SUM(overstock_risk) * 100.0 / COUNT(*), 2) AS overstock_risk_rate,
    ROUND(SUM(inventory_value), 2) AS total_inventory_value
FROM inventory_data
GROUP BY product_id, category
ORDER BY total_sales_revenue DESC;


-- 4. Store-level performance
SELECT
    store_id,
    region,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(forecast_accuracy), 4) AS avg_forecast_accuracy,
    ROUND(SUM(stockout_risk) * 100.0 / COUNT(*), 2) AS stockout_risk_rate,
    ROUND(SUM(overstock_risk) * 100.0 / COUNT(*), 2) AS overstock_risk_rate
FROM inventory_data
GROUP BY store_id, region
ORDER BY total_sales_revenue DESC;


-- 5. Monthly inventory trend
SELECT
    SUBSTR(date, 1, 7) AS month,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(units_ordered), 0) AS total_units_ordered,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(SUM(stockout_risk) * 100.0 / COUNT(*), 2) AS stockout_risk_rate,
    ROUND(SUM(overstock_risk) * 100.0 / COUNT(*), 2) AS overstock_risk_rate
FROM inventory_data
GROUP BY SUBSTR(date, 1, 7)
ORDER BY month;


-- 6. Highest stockout-risk products
SELECT
    product_id,
    category,
    COUNT(*) AS total_observations,
    SUM(stockout_risk) AS stockout_risk_days,
    ROUND(SUM(stockout_risk) * 100.0 / COUNT(*), 2) AS stockout_risk_rate,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(demand_forecast), 2) AS avg_demand_forecast,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue
FROM inventory_data
GROUP BY product_id, category
HAVING stockout_risk_rate > 50
ORDER BY stockout_risk_rate DESC, total_sales_revenue DESC;


-- 7. Highest overstock-risk products
SELECT
    product_id,
    category,
    COUNT(*) AS total_observations,
    SUM(overstock_risk) AS overstock_risk_days,
    ROUND(SUM(overstock_risk) * 100.0 / COUNT(*), 2) AS overstock_risk_rate,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(demand_forecast), 2) AS avg_demand_forecast,
    ROUND(SUM(inventory_value), 2) AS total_inventory_value
FROM inventory_data
GROUP BY product_id, category
HAVING overstock_risk_rate > 50
ORDER BY overstock_risk_rate DESC, total_inventory_value DESC;


-- 8. Products with poor forecast accuracy
SELECT
    product_id,
    category,
    ROUND(AVG(forecast_accuracy), 4) AS avg_forecast_accuracy,
    ROUND(AVG(abs_forecast_error), 2) AS avg_absolute_forecast_error,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue
FROM inventory_data
GROUP BY product_id, category
ORDER BY avg_forecast_accuracy ASC;