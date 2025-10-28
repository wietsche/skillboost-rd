-- Create the product_inventory table
DROP TABLE IF EXISTS product_inventory;
CREATE TABLE product_inventory (
    store_id INTEGER,
    sku TEXT,
    product_name TEXT,
    department TEXT,
    department_id INTEGER,
    price REAL,
    stock_count INTEGER,
    PRIMARY KEY (store_id, sku)
);

INSERT INTO product_inventory (
    store_id, sku, product_name, department, department_id, price, stock_count
) VALUES
(101, 'SKU001', 'Apple Juice', 'Grocery', 1, 2.99, 150),
(101, 'SKU002', 'Bluetooth Speaker', 'Electronics', 2, 199.99, 20),
(101, 'SKU003', 'T-Shirt', 'Clothing', 3, 29.99, 75),
(101, 'SKU005', 'Pain Reliever', 'Pharmacy', 4, 9.99, 60),
(102, 'SKU001', 'Apple Juice', 'Grocery', 1, 2.99, 120),
(102, 'SKU002', 'Bluetooth Speaker', 'Electronics', 2, 199.99, 10),
(102, 'SKU004', 'Bread', 'Grocery', 1, 1.49, 180),
(102, 'SKU005', 'Pain Reliever', 'Pharmacy', 4, 9.99, 40),
(103, 'SKU001', 'Apple Juice', 'Grocery', 1, 2.99, 100),
(103, 'SKU002', 'Bluetooth Speaker', 'Electronics', 2, 199.99, 5),
(103, 'SKU003', 'T-Shirt', 'Clothing', 3, 29.99, 60),
(103, 'SKU004', 'Bread', 'Grocery', 1, 1.49, 220);