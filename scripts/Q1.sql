-- Create the inventory table

CREATE TABLE inventory (
    store_id INTEGER,
    sku TEXT,
    product_name TEXT,
    department TEXT,
    department_id INTEGER,
    price REAL,
    stock_count INTEGER,
    PRIMARY KEY (store_id, sku)
);

INSERT INTO inventory (
    store_id, sku, product_name, department, department_id, price, stock_count
) VALUES
(101, 'SKU001', 'Apple Juice', 'Grocery', 1, 2.99, 150),
(101, 'SKU002', 'Bluetooth Speaker', 'Electronics', 2, 199.99, 20),
(102, 'SKU003', 'T-Shirt', 'Clothing', 3, 29.99, 75),
(103, 'SKU004', 'Bread', 'Grocery', 1, 1.49, 200),
(104, 'SKU005', 'Pain Reliever', 'Pharmacy', 4, 9.99, 60),
(102, 'SKU006', 'Laptop', 'Electronics', 2, 499.99, 10),
(101, 'SKU007', 'Jeans', 'Clothing', 3, 49.99, 40),
(103, 'SKU008', 'Cereal', 'Grocery', 1, 3.49, 120),
(104, 'SKU009', 'Vitamin C', 'Pharmacy', 4, 14.99, 30),
(102, 'SKU010', 'Socks', 'Clothing', 3, 19.99, 90);