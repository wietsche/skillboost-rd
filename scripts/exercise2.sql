
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
    department TEXT,
    dept_manager TEXT
);


INSERT INTO department (department, dept_manager)
SELECT DISTINCT department, dept_manager
FROM product_and_department;

INSERT INTO product (sku, product_name, department_id, price)
SELECT sku, product_name, department_id, price
FROM product_and_department AS pd
JOIN department AS d
ON pd.department = d.department;

.headers on
.mode column
SELECT * FROM inventory LIMIT 10;
SELECT * FROM product LIMIT 10;
SELECT * FROM department LIMIT 10;
