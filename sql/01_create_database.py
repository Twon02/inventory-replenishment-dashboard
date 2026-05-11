import pandas as pd
import sqlite3
from pathlib import Path

# File paths
project_root = Path(__file__).resolve().parents[1]
csv_path = project_root / "data" / "processed" / "cleaned_retail_inventory.csv"
db_path = project_root / "database" / "inventory.db"

# Make sure database folder exists
db_path.parent.mkdir(parents=True, exist_ok=True)

# Load processed CSV
df = pd.read_csv(csv_path)

# Convert date column
df["date"] = pd.to_datetime(df["date"])

# Connect to SQLite database
conn = sqlite3.connect(db_path)

# Load data into SQL table
df.to_sql("inventory_data", conn, if_exists="replace", index=False)

# Confirm load
row_count = pd.read_sql("SELECT COUNT(*) AS row_count FROM inventory_data;", conn)
print(row_count)

# Close connection
conn.close()

print(f"Database created successfully at: {db_path}")