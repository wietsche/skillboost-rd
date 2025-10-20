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


CREATE TABLE department (
    department_id INTEGER PRIMARY KEY,
    department TEXT
);

INSERT INTO department (department_id, department) VALUES
(1, 'Grocery'),
(2, 'Electronics'),
(3, 'Clothing'),
(4, 'Pharmacy');

CREATE TABLE product (
    sku TEXT PRIMARY KEY,
    product_name TEXT,
    department_id INTEGER,
    price REAL,
    FOREIGN KEY (department_id) REFERENCES department (department_id)
);

INSERT INTO product (sku, product_name, department_id, price) VALUES
('SKU001', 'Apple Juice', 1, 2.99),
('SKU002', 'Bluetooth Speaker', 2, 199.99),
('SKU003', 'T-Shirt', 3, 29.99),
('SKU004', 'Bread', 1, 1.49),
('SKU005', 'Pain Reliever', 4, 9.99),
('SKU006', 'Laptop', 2, 499.99),
('SKU007', 'Jeans', 3, 49.99),
('SKU008', 'Cereal', 1, 3.49),
('SKU009', 'Vitamin C', 4, 14.99),
('SKU010', 'Socks', 3, 19.99);
