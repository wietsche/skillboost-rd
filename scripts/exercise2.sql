-- Drop tables if they exist
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS department;

CREATE TABLE product (
    sku TEXT PRIMARY KEY,
    product_name TEXT,
    department_id INTEGER,
    price REAL
);

CREATE TABLE department (
    department_id INTEGER PRIMARY KEY,
    department TEXT
);

-- select from original product ttable into product2 an department table
INSERT INTO department (department_id, department)
SELECT DISTINCT department_id, department
FROM product_and_department;

INSERT INTO product (sku, product_name, department_id, price)
SELECT sku, product_name, department_id, price
FROM product_and_department;

.headers on
.mode column
SELECT * FROM inventory;
SELECT * FROM product;
SELECT * FROM department;
