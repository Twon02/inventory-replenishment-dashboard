-- 1. Check total row count
SELECT 
    COUNT(*) AS total_rows
FROM inventory_data;


-- 2. Check date range
SELECT
    MIN(date) AS min_date,
    MAX(date) AS max_date
FROM inventory_data;


-- 3. Check number of stores, products, categories, and regions
SELECT
    COUNT(DISTINCT store_id) AS total_stores,
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT category) AS total_categories,
    COUNT(DISTINCT region) AS total_regions
FROM inventory_data;


-- 4. Check category distribution
SELECT
    category,
    COUNT(*) AS row_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM inventory_data), 2) AS percentage_of_rows
FROM inventory_data
GROUP BY category
ORDER BY row_count DESC;


-- 5. Check duplicate records
SELECT
    date,
    store_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM inventory_data
GROUP BY date, store_id, product_id
HAVING COUNT(*) > 1;


-- 6. Check missing inventory coverage ratio
SELECT
    COUNT(*) AS missing_inventory_coverage_rows
FROM inventory_data
WHERE inventory_coverage_ratio IS NULL;