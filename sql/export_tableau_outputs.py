import sqlite3
import pandas as pd
from pathlib import Path

project_root = Path(__file__).resolve().parents[1]

db_path = project_root / "database" / "inventory.db"
output_dir = project_root / "data" / "processed" / "tableau_outputs"
output_dir.mkdir(parents=True, exist_ok=True)

conn = sqlite3.connect(db_path)

queries = {
    "category_summary": """
        SELECT *
        FROM category_summary;
    """,

    "product_summary": """
        SELECT *
        FROM product_summary;
    """,

    "monthly_summary": """
        SELECT *
        FROM monthly_summary;
    """,

    "store_summary": """
        SELECT *
        FROM store_summary;
    """,

    "abc_analysis": """
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
    """,

    "full_inventory_data": """
        SELECT *
        FROM inventory_data;
    """
}

for name, query in queries.items():
    df = pd.read_sql_query(query, conn)
    output_path = output_dir / f"{name}.csv"
    df.to_csv(output_path, index=False)
    print(f"Exported {name}: {df.shape[0]} rows, {df.shape[1]} columns")

conn.close()

print("All Tableau outputs exported successfully.")