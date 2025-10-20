CREATE TABLE inventory (
    store_id INTEGER,
    sku TEXT,
    stock_count INTEGER,
    PRIMARY KEY (store_id, sku)
);

INSERT INTO inventory (store_id, sku, stock_count) VALUES
(101, 'SKU001', 150),
(101, 'SKU002', 20),
(102, 'SKU003', 75),
(103, 'SKU004', 200),
(104, 'SKU005', 60),
(102, 'SKU006', 10),
(101, 'SKU007', 40),
(103, 'SKU008', 120),
(104, 'SKU009', 30),
(102, 'SKU010', 90);


CREATE TABLE product (
    sku TEXT PRIMARY KEY,
    product_name TEXT,
    department TEXT,
    department_id INTEGER,
    price REAL
);

INSERT INTO product (sku, product_name, department, department_id, price) VALUES
('SKU001', 'Apple Juice', 'Grocery', 1, 2.99),
('SKU002', 'Bluetooth Speaker', 'Electronics', 2, 199.99),
('SKU003', 'T-Shirt', 'Clothing', 3, 29.99),
('SKU004', 'Bread', 'Grocery', 1, 1.49),
('SKU005', 'Pain Reliever', 'Pharmacy', 4, 9.99),
('SKU006', 'Laptop', 'Electronics', 2, 499.99),
('SKU007', 'Jeans', 'Clothing', 3, 49.99),
('SKU008', 'Cereal', 'Grocery', 1, 3.49),
('SKU009', 'Vitamin C', 'Pharmacy', 4, 14.99),
('SKU010', 'Socks', 'Clothing', 3, 19.99);
