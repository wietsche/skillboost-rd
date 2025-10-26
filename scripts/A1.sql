--Drop if exists
DROP TABLE IF EXISTS inventory2;
DROP TABLE IF EXISTS product;


CREATE TABLE inventory2 (
    store_id INTEGER,
    sku TEXT,
    stock_count INTEGER,
    PRIMARY KEY (store_id, sku)
);


CREATE TABLE product (
    sku TEXT PRIMARY KEY,
    product_name TEXT,
    department TEXT,
    department_id INTEGER,
    price REAL
);


-- Populate product with distinct product info from legacy inventory table
INSERT OR IGNORE INTO product (sku, product_name, department, department_id, price)
SELECT DISTINCT sku, product_name, department, department_id, price
FROM inventory;

-- Populate inventory_2nf with store-level stock counts
INSERT OR REPLACE INTO inventory2 (store_id, sku, stock_count)
SELECT store_id, sku, stock_count
FROM inventory;

-- Verify the new tables
-- set ouput format to columns
.headers on
.mode column
SELECT * FROM product;
SELECT * FROM inventory2;
