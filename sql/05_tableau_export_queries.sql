-- =========================================================
-- Tableau Export Queries
-- These queries create clean summary tables for dashboarding.
-- =========================================================


-- 1. Category dashboard table
CREATE TABLE IF NOT EXISTS category_summary AS
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
GROUP BY category;


-- 2. Product dashboard table
CREATE TABLE IF NOT EXISTS product_summary AS
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
GROUP BY product_id, category;


-- 3. Monthly dashboard table
CREATE TABLE IF NOT EXISTS monthly_summary AS
SELECT
    SUBSTR(date, 1, 7) AS month,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(units_ordered), 0) AS total_units_ordered,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(demand_forecast), 2) AS avg_demand_forecast,
    ROUND(AVG(forecast_accuracy), 4) AS avg_forecast_accuracy,
    ROUND(SUM(stockout_risk) * 100.0 / COUNT(*), 2) AS stockout_risk_rate,
    ROUND(SUM(overstock_risk) * 100.0 / COUNT(*), 2) AS overstock_risk_rate
FROM inventory_data
GROUP BY SUBSTR(date, 1, 7);


-- 4. Store dashboard table
CREATE TABLE IF NOT EXISTS store_summary AS
SELECT
    store_id,
    region,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(sales_revenue), 2) AS total_sales_revenue,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(demand_forecast), 2) AS avg_demand_forecast,
    ROUND(AVG(forecast_accuracy), 4) AS avg_forecast_accuracy,
    ROUND(SUM(stockout_risk) * 100.0 / COUNT(*), 2) AS stockout_risk_rate,
    ROUND(SUM(overstock_risk) * 100.0 / COUNT(*), 2) AS overstock_risk_rate
FROM inventory_data
GROUP BY store_id, region;