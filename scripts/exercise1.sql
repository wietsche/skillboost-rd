--Drop if exists
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS product_and_department;


CREATE TABLE inventory (
    store_id INTEGER PRIMARY KEY,
    sku TEXT,
    stock_count INTEGER,
    PRIMARY KEY (store_id, sku)
);


CREATE TABLE product_and_department (
    sku TEXT PRIMARY KEY,
    product_name TEXT,
    department TEXT,
    department_id INTEGER,
    price REAL
);


-- Populate product with distinct product info from legacy inventory table
INSERT INTO product_and_department (sku, product_name, department, department_id, price)
SELECT DISTINCT sku, product_name, department, department_id, price
FROM product_inventory;

-- Populate inventory_2nf with store-level stock counts
INSERT INTO inventory (store_id, sku, stock_count)
SELECT store_id, sku, stock_count
FROM product_inventory;

-- Verify the new tables
-- set ouput format to columns
.headers on
.mode column
--.timer on
SELECT * FROM product_and_department LIMIT 10;
SELECT * FROM inventory LIMIT 10;
