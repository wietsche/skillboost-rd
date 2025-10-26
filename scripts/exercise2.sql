-- Drop tables if they exist
DROP TABLE IF EXISTS product2;
DROP TABLE IF EXISTS department;

CREATE TABLE product2 (
    sku TEXT PRIMARY KEY,
    product_name TEXT,
    department_id INTEGER,
    price REAL,
    FOREIGN KEY (department_id) REFERENCES department (department_id)
);

CREATE TABLE department (
    department_id INTEGER PRIMARY KEY,
    department TEXT
);

-- select from original produc ttable into product2 an department table
INSERT INTO department (department_id, department)
SELECT DISTINCT department_id, department
FROM product;

INSERT INTO product2 (sku, product_name, department_id, price)
SELECT sku, product_name, department_id, price
FROM product;

.headers on
.mode column
SELECT * FROM department;
SELECT * FROM product2;