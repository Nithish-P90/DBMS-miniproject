import sqlite3
import os
from pathlib import Path

def init_database():
    # Get absolute paths
    base_dir = Path(__file__).parent
    db_path = base_dir / "food.db"
    schema_path = base_dir.parent / "sql" / "schema.sql"
    seed_path = base_dir.parent / "sql" / "seed_data.sql"
    
    # Remove existing database
    if db_path.exists():
        os.remove(db_path)
        print(f"Removed existing database at {db_path}")
    
    # Create new database connection
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Read and execute schema
    print("Creating database schema...")
    with open(schema_path, 'r') as f:
        schema_sql = f.read()
        cursor.executescript(schema_sql)
    
    # Read and execute seed data
    print("Inserting seed data...")
    with open(seed_path, 'r') as f:
        seed_sql = f.read()
        cursor.executescript(seed_sql)
    
    conn.commit()
    conn.close()
    
    print(f"\nDatabase initialized successfully!")
    print(f"Database location: {db_path.absolute()}")
    print(f"Tables created: users, restaurants, menu_items, orders, order_items")
    print(f"Trigger created: increment_order_count")

if __name__ == "__main__":
    init_database()
