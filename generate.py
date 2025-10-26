# python
import os
import random
import string
from datetime import datetime, timezone
from typing import List

from sqlalchemy import create_engine, text

# Config
NUM_DEPARTMENTS = 5
NUM_PRODUCTS = 10000
NUM_STORES = 800
BATCH_SIZE = 1_000
DEFAULT_DB_URL = os.environ.get("DATABASE_URL", "sqlite:///my.db")

# Inventory distribution controls
TARGET_PRODUCT_STORE_COVERAGE = 0.6     # mean fraction of stores carrying a product
COVERAGE_CONCENTRATION = 12.0           # higher -> tighter around target
BASE_STOCK = 120
MAX_STOCK = 500

ADJECTIVES = [
    "Agile", "Brisk", "Calm", "Dapper", "Eager", "Fierce", "Gentle", "Hearty", "Ideal",
    "Jazzy", "Keen", "Lively", "Mellow", "Nimble", "Opal", "Plucky", "Quirky", "Rapid",
    "Sleek", "Trendy", "Urban", "Vivid", "Witty", "Xeno", "Young", "Zesty"
]
NOUNS = [
    "Widget", "Gadget", "Device", "Tool", "Gear", "Supply", "Accessory", "Item",
    "Kit", "Pack", "Bundle", "Module", "Unit", "Component", "Article"
]

def random_sku(existing: set) -> str:
    while True:
        sku = "".join(random.choices(string.ascii_uppercase, k=3)) + "-" + "".join(random.choices(string.digits, k=6))
        if sku not in existing:
            existing.add(sku)
            return sku

def random_product_name() -> str:
    return f"{random.choice(ADJECTIVES)} {random.choice(NOUNS)}"

def dirichlet_weights(k: int, alpha: float = 1.5) -> List[float]:
    samples = [random.gammavariate(alpha, 1.0) for _ in range(k)]
    total = sum(samples) or 1.0
    return [s / total for s in samples]

def ensure_inventory_schema(engine) -> None:
    # Ensure inventory has composite PK (store_id, sku) to allow multiple stores per product.
    with engine.begin() as conn:
        cols = conn.execute(text("PRAGMA table_info(inventory)")).all()
        if not cols:
            return
        pk_cols = [c[1] for c in cols if c[5] > 0]
        if pk_cols == ["store_id", "sku"]:
            return
        if pk_cols == ["store_id"]:
            conn.execute(text("PRAGMA foreign_keys=OFF"))
            conn.execute(text("ALTER TABLE inventory RENAME TO inventory_old"))
            conn.execute(text("""
                CREATE TABLE inventory (
                    store_id INTEGER NOT NULL,
                    sku TEXT NOT NULL,
                    stock_count INTEGER,
                    PRIMARY KEY (store_id, sku)
                )
            """))
            conn.execute(text("""
                INSERT INTO inventory (store_id, sku, stock_count)
                SELECT store_id, sku, stock_count FROM inventory_old
            """))
            conn.execute(text("DROP TABLE inventory_old"))
            conn.execute(text("PRAGMA foreign_keys=ON"))

def wipe_data(engine) -> None:
    with engine.begin() as conn:
        conn.execute(text("PRAGMA foreign_keys=ON"))
        conn.execute(text("DELETE FROM inventory"))
        conn.execute(text("DELETE FROM product"))
        conn.execute(text("DELETE FROM department"))

def ensure_departments(engine) -> List[int]:
    sql = text("""
        INSERT OR IGNORE INTO department (department_id, department)
        VALUES (:id, :name)
    """)
    with engine.begin() as conn:
        rows = [{"id": i, "name": f"Department {i:02d}"} for i in range(1, NUM_DEPARTMENTS + 1)]
        for i in range(0, len(rows), BATCH_SIZE):
            conn.execute(sql, rows[i:i + BATCH_SIZE])
        ids = conn.execute(
            text("SELECT department_id FROM department ORDER BY department_id LIMIT :n"),
            {"n": NUM_DEPARTMENTS}
        ).scalars().all()
    return ids

def count_products(conn) -> int:
    return conn.execute(text("SELECT COUNT(*) FROM product")).scalar_one()

def insert_products(engine, dept_ids: List[int]) -> int:
    inserted = 0
    with engine.begin() as conn:
        existing = count_products(conn)
        remaining = max(0, NUM_PRODUCTS - int(existing))
        if remaining == 0:
            return 0

        sql = text("""
            INSERT OR IGNORE INTO product (sku, product_name, department_id, price)
            VALUES (:sku, :product_name, :department_id, :price)
        """)
        used_skus = set(conn.execute(text("SELECT sku FROM product")).scalars().all())
        batch = []
        dept_count = len(dept_ids) if dept_ids else 1
        dept_weights = dirichlet_weights(dept_count) if dept_count > 0 else [1.0]
        for _ in range(remaining):
            dept_id = random.choices(dept_ids, weights=dept_weights, k=1)[0] if dept_ids else None
            batch.append({
                "sku": random_sku(used_skus),
                "product_name": random_product_name(),
                "department_id": dept_id,
                "price": round(random.uniform(1.99, 199.99), 2),
            })
            if len(batch) >= BATCH_SIZE:
                conn.execute(sql, batch)
                inserted += len(batch)
                batch.clear()
        if batch:
            conn.execute(sql, batch)
            inserted += len(batch)
    return inserted

def insert_inventory(engine) -> int:
    # Sparse availability: sample which stores carry each product; then set varied stock.
    inserted = 0
    with engine.begin() as conn:
        products = conn.execute(
            text("SELECT sku, department_id FROM product ORDER BY sku")
        ).all()
        if not products:
            return 0

        depts = conn.execute(text("SELECT department_id FROM department ORDER BY department_id")).scalars().all()
        if not depts:
            depts = sorted({d for _, d in products if d is not None})
        dept_index = {d: i for i, d in enumerate(depts)} if depts else {}

        # Per-store department preferences and capacity
        store_dept_prefs = []
        for _ in range(NUM_STORES):
            prefs = dirichlet_weights(len(depts), alpha=1.2) if depts else [1.0]
            store_dept_prefs.append(prefs)
        store_capacity = [random.uniform(0.8, 1.2) for _ in range(NUM_STORES)]

        # Product popularity normalization
        raw_pop = {sku: random.lognormvariate(0.0, 0.5) for sku, _ in products}
        mean_pop = (sum(raw_pop.values()) / len(raw_pop)) if raw_pop else 1.0
        pop = {k: v / mean_pop for k, v in raw_pop.items()}

        # Product coverage prior
        a = max(0.5, TARGET_PRODUCT_STORE_COVERAGE * COVERAGE_CONCENTRATION)
        b = max(0.5, (1.0 - TARGET_PRODUCT_STORE_COVERAGE) * COVERAGE_CONCENTRATION)

        sql = text("""
            INSERT OR IGNORE INTO inventory (store_id, sku, stock_count)
            VALUES (:store_id, :sku, :stock_count)
        """)
        batch = []

        for sku, dept_id in products:
            base_p = random.betavariate(a, b)  # base availability per product
            candidates = []
            best_store = None
            best_p = -1.0

            for store_id in range(1, NUM_STORES + 1):
                idx = store_id - 1
                pref = 1.0
                if dept_id in dept_index:
                    pref = store_dept_prefs[idx][dept_index[dept_id]]
                # Blend: base availability × store capacity × dept preference
                p = base_p * (0.5 + 0.5 * pref) * store_capacity[idx]
                p = max(0.02, min(0.95, p))
                if p > best_p:
                    best_p = p
                    best_store = store_id
                if random.random() < p:
                    candidates.append(store_id)

            # Ensure every product is carried by at least one store
            if not candidates and best_store is not None:
                candidates.append(best_store)

            # Insert all available store×product rows with varied stock
            for store_id in candidates:
                idx = store_id - 1
                pref = 1.0
                if dept_id in dept_index:
                    pref = store_dept_prefs[idx][dept_index[dept_id]]
                mean = BASE_STOCK * store_capacity[idx] * pop[sku] * (0.7 + 0.6 * pref)
                sigma = max(5.0, 0.35 * mean)
                count = int(round(random.gauss(mean, sigma)))
                count = max(0, min(MAX_STOCK, count))
                batch.append({
                    "store_id": store_id,
                    "sku": sku,
                    "stock_count": count,
                })
                if len(batch) >= BATCH_SIZE:
                    conn.execute(sql, batch)
                    inserted += len(batch)
                    batch.clear()

        if batch:
            conn.execute(sql, batch)
            inserted += len(batch)

    return inserted

def main():
    random.seed(42)
    db_url = DEFAULT_DB_URL  # sqlite:///my.db
    engine = create_engine(db_url, future=True)

    ensure_inventory_schema(engine)
    wipe_data(engine)
    dept_ids = ensure_departments(engine)
    added_products = insert_products(engine, dept_ids)
    added_inventory = insert_inventory(engine)

    print(f"{datetime.now(timezone.utc).isoformat()} Seed complete.")
    print(f"Departments: {len(dept_ids)} total \(ensured\).")
    print(f"Products inserted: {added_products}.")
    print(f"Inventory rows inserted: {added_inventory}.")
    print(f"DB: {db_url}")

if __name__ == "__main__":
    main()
