[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/wietsche/skillboost-rd)

# Tutorial on Database Normalization (1NF, 2NF, 3NF)

## Setup

### clone repo
```bash
mkdir ~/skillsboost
cd ~/skillsboost
git clone git@github.com:wietsche/skillsboost-rd.git
```

### install sqlite3
```bash
brew install sqlite3
```
or manual
```bash
cd ~/skillsboost
wget https://www.sqlite.org/2025/sqlite-tools-osx-arm64-3500400.zip
unzip sqlite-tools-osx-arm64-3500400.zip
```

## Normal forms

### 1NF
First Normal Form (1NF) is the most basic level of database normalization. A table is in 1NF if it meets the following criteria:
1. Atomicity: Each cell contains only atomic (indivisible) values. For example, a cell should not contain a list or set of values.
2. Uniqueness: Each row is unique, meaning that there are no duplicate rows in the table. This is often achieved by defining a primary key.
3. No repeating groups: There are no repeating groups or arrays in any of the columns. Each attribute should contain a single value for each record.
4. Consistent data types: Each column should contain values of a consistent data type (e.g., all values in a column should be integers, strings, etc.).

### 2NF
A table is in 2NF if it meets the following criteria:
1. It is already in 1NF.
2. No partial dependencies: All non-key attributes must depend on the entire primary key, not just part of it. This means that if the primary key is composite (i.e., consists of multiple columns), no non-key attribute should depend on only one part of the key.

### 3NF
A table is in 3NF if it meets the following criteria:
1. It is already in 2NF.
2. No transitive dependencies: There are no transitive dependencies between non-key attributes. This means that non-key attributes should not depend on other non-key attributes. Every non-key attribute must depend only on the primary key.







Consider the following table and questions:


| store_id | sku      | product_name      | department   | department_id | price  | stock_count |
|----------|----------|------------------|--------------|--------------|--------|-------------|
| 101      | SKU001   | Apple Juice      | Grocery      | 1            | 2.99   | 150         |
| 101      | SKU002   | Bluetooth Speaker| Electronics  | 2            | 199.99 | 20          |
| 102      | SKU003   | T-Shirt          | Clothing     | 3            | 29.99  | 75          |
| 103      | SKU004   | Bread            | Grocery      | 1            | 1.49   | 200         |
| 104      | SKU005   | Pain Reliever    | Pharmacy     | 4            | 9.99   | 60          |
| 102      | SKU006   | Laptop           | Electronics  | 2            | 499.99 | 10          |
| 101      | SKU007   | Jeans            | Clothing     | 3            | 49.99  | 40          |
| 103      | SKU008   | Cereal           | Grocery      | 1            | 3.49   | 120         |
| 104      | SKU009   | Vitamin C        | Pharmacy     | 4            | 14.99  | 30          |
| 102      | SKU010   | Socks            | Clothing     | 3            | 19.99  | 90          |


Is it 1NF compliant? Why or why not?

Yes, the table is in First Normal Form (1NF) because it meets the following criteria:
1. Atomicity: Each cell contains only atomic (indivisible) values. For example, the 'product_name' column contains single product names, not lists or sets of names.
2. Uniqueness: Each row is unique, identified by the combination of 'store_id' and 'sku', which together can serve as a composite primary key.
3. No repeating groups: There are no repeating groups or arrays in any of the columns. Each attribute contains a single value for each record.
4. Consistent data types: Each column contains values of a consistent data type (e.g., 'price' is always a decimal number, 'stock_count' is always an integer).
5. Proper column structure: Each column represents a single attribute of the entity being described (products in stores).
6. No multi-valued attributes: There are no columns that contain multiple values for a single attribute.
7. Clear and unambiguous column names: Each column has a clear and descriptive name that indicates the type of data it holds.

Is it 2NF compliant? Why or why not?

No, the table is not in Second Normal Form (2NF) because it does not meet the following criteria:

There are partial dependencies: The table has a composite primary key consisting of 'store_id' and 'sku'. However, some non-key attributes depend only on part of this composite key. For example, 'product_name', 'department', 'department_id', and 'price' depend only on 'sku', not on the combination of 'store_id' and 'sku'. This means that these attributes are partially dependent on the primary key, which violates the 2NF requirement.
  a. For instance, the 'product_name' for SKU001 (Apple Juice) is the same regardless of which store it is in. Therefore, 'product_name' is dependent only on 'sku', not on the full composite key ('store_id', 'sku').

To be in 2NF, all non-key attributes must depend on the entire primary key, not just part of it. To achieve 2NF, the table would need to be decomposed into two or more tables to eliminate these partial dependencies. For example, one table could store product details (sku, product_name, department, department_id, price) and another table could store inventory details (store_id, sku, stock_count).
We need to remove the following partial dependencies:
- product_name -> sku
- department -> sku
- department_id -> sku
- price -> sku

To achieve 2NF, we must refacor the table into two tables:

**Store_Inventory Table:**

| store_id | sku      | stock_count |
|----------|----------|-------------|
| 101      | SKU001   | 150         |
| 101      | SKU002   | 20          |
| 102      | SKU003   | 75          |
| 103      | SKU004   | 200         |
| 104      | SKU005   | 60          |
| 102      | SKU006   | 10          |
| 101      | SKU007   | 40          |
| 103      | SKU008   | 120         |
| 104      | SKU009   | 30          |
| 102      | SKU010   | 90          |

Is this 2nF compliant? Yes, because:
1. It is in 1NF: Each cell contains atomic values, each row is unique, and there are no repeating groups.
2. No partial dependencies: The primary key is 'store_id' and 'sku', and the only non-key attribute is 'stock_count', which depends on the entire primary key.

Is this 3NF compliant? Yes, because:
1. It is in 2NF: As established, there are no partial dependencies.

**Product_Details Table:**

| sku      | product_name      | department   | department_id | price  |
|----------|------------------|--------------|---------------|--------|
| SKU001   | Apple Juice      | Grocery      | 1             | 2.99   |
| SKU002   | Bluetooth Speaker| Electronics  | 2             | 199.99 |
| SKU003   | T-Shirt          | Clothing     | 3             | 29.99  |
| SKU004   | Bread            | Grocery      | 1             | 1.49   |
| SKU005   | Pain Reliever    | Pharmacy     | 4             | 9.99   |
| SKU006   | Laptop           | Electronics  | 2             | 499.99 |
| SKU007   | Jeans            | Clothing     | 3             | 49.99  |
| SKU008   | Cereal           | Grocery      | 1             | 3.49   |
| SKU009   | Vitamin C        | Pharmacy     | 4             | 14.99  |
| SKU010   | Socks            | Clothing     | 3             | 19.99  |

1. It is in 1NF: Each cell contains atomic values, each row is unique, and there are no repeating groups.

Is this 2NF compliant? Yes, because:
1. It is in 1NF: Each cell contains atomic values, each row is unique, and there are no repeating groups.
2. No partial dependencies: The primary key is 'sku', and all non-key attributes depend on the entire primary key.

Is this 3NF compliant? No, because:
There are transitive dependencies: The 'department' and 'department_id' attributes are transitively dependent on the primary key 'sku' through the 'department_id' attribute. This means that 'department' can be determined by 'department_id', which violates the 3NF requirement.


| sku      | product_name      | department_id | price  |
|----------|------------------|---------------|--------|
| SKU001   | Apple Juice      | 1             | 2.99   |
| SKU002   | Bluetooth Speaker| 2             | 199.99 |
| SKU003   | T-Shirt          | 3             | 29.99  |
| SKU004   | Bread            | 1             | 1.49   |
| SKU005   | Pain Reliever    | 4             | 9.99   |
| SKU006   | Laptop           | 2             | 499.99 |
| SKU007   | Jeans            | 3             | 49.99  |
| SKU008   | Cereal           | 1             | 3.49   |
| SKU009   | Vitamin C        | 4             | 14.99  |
| SKU010   | Socks            | 3             | 19.99  |

| sku      | product_name      | department_id | price  |
|----------|------------------|---------------|--------|
| SKU001   | Apple Juice      | 1             | 2.99   |
| SKU002   | Bluetooth Speaker| 2             | 199.99 |
| SKU003   | T-Shirt          | 3             | 29.99  |
| SKU004   | Bread            | 1             | 1.49   |
| SKU005   | Pain Reliever    | 4             | 9.99   |
| SKU006   | Laptop           | 2             | 499.99 |
| SKU007   | Jeans            | 3             | 49.99  |
| SKU008   | Cereal           | 1             | 3.49   |
| SKU009   | Vitamin C        | 4             | 14.99  |
| SKU010   | Socks            | 3             | 19.99  |

Now we have three tables:
**Store_Inventory Table:**
| store_id | sku      | stock_count |
|----------|----------|-------------|

**Product_Details Table:**
| sku      | product_name      | department_id | price  |
|----------|------------------|---------------|--------|

**Department Table:**
| department_id | department   |
|---------------|--------------|

** No lets do this in SQlite **

```bash
mkdir ~/skillsboost-rd
cd ~/skillsboost-rd
wget https://www.sqlite.org/2025/sqlite-tools-osx-arm64-3500400.zip
```

create three DDL files: store_inventory.sql, product_details.sql, department.sql

store_inventory.sql
```bash
cat > store_inventory.sql <<'EOF'
CREATE TABLE Store_Inventory (
    store_id INTEGER,
    sku TEXT,
    stock_count INTEGER,
    PRIMARY KEY (store_id, sku),
    FOREIGN KEY (sku) REFERENCES Product_Details(sku)
);
EOF
```
product_details.sql
```sql
CREATE TABLE Product_Details (
    sku TEXT PRIMARY KEY,
    product_name TEXT,
    department_id INTEGER,
    price REAL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);
```department.sql
```sql
CREATE TABLE Department (
    department_id INTEGER PRIMARY KEY,
    department TEXT
);
``` 

Create a sqlite database from the command line
```bash
unzip sqlite-tools-osx-arm64-3500400.zip
./sqlite3 skillsboost.db
.save
.q
```













