import sqlite3
import pandas as pd
from pathlib import Path

project_root = Path(__file__).resolve().parents[1]

db_path = project_root / "database" / "inventory.db"
output_dir = project_root / "data" / "processed" / "validation_outputs"
output_dir.mkdir(parents=True, exist_ok=True)

conn = sqlite3.connect(db_path)

queries = {
    "01_total_row_count": """
        SELECT 
            COUNT(*) AS total_rows
        FROM inventory_data;
    """,

    "02_date_range": """
        SELECT
            MIN(date) AS min_date,
            MAX(date) AS max_date
        FROM inventory_data;
    """,

    "03_dimension_counts": """
        SELECT
            COUNT(DISTINCT store_id) AS total_stores,
            COUNT(DISTINCT product_id) AS total_products,
            COUNT(DISTINCT category) AS total_categories,
            COUNT(DISTINCT region) AS total_regions
        FROM inventory_data;
    """,

    "04_category_distribution": """
        SELECT
            category,
            COUNT(*) AS row_count,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM inventory_data), 2) AS percentage_of_rows
        FROM inventory_data
        GROUP BY category
        ORDER BY row_count DESC;
    """,

    "05_duplicate_check": """
        SELECT
            date,
            store_id,
            product_id,
            COUNT(*) AS duplicate_count
        FROM inventory_data
        GROUP BY date, store_id, product_id
        HAVING COUNT(*) > 1;
    """,

    "06_missing_inventory_coverage": """
        SELECT
            COUNT(*) AS missing_inventory_coverage_rows
        FROM inventory_data
        WHERE inventory_coverage_ratio IS NULL;
    """
}

for name, query in queries.items():
    df = pd.read_sql_query(query, conn)
    output_path = output_dir / f"{name}.csv"
    df.to_csv(output_path, index=False)
    print(f"Exported: {output_path}")

conn.close()