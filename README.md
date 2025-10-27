
## Setup 

### Launch your codespace
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/wietsche/skillboost-rd)

or
### DIY
```bash
mkdir ~/skillsboost
cd ~/skillsboost
git clone git@github.com:wietsche/skillsboost-rd.git
```

```bash
brew install sqlite3
```
or
```bash
cd ~/skillsboost
wget https://www.sqlite.org/2025/sqlite-tools-osx-arm64-3500400.zip
unzip sqlite-tools-osx-arm64-3500400.zip
```


## SQLlite

Ways of running queries

### 1. Shell
```bash
sqlite3 mydb.db "SELECT date('now');"
```

### 2. REPL
```bash
sqlite3 mydb.db
SELECT date('now');
.q
```

### 3. File input
```bash
sqlite3 mydb.db < scripts/scratch.sql
```

### 4. GUI

## Exercises

### Exercise 1

```
 sqlite3 mydb.db < scripts/setup.sql
 sqlite3 mydb.db -header -column "SELECT * FROM product_inventory;"
```
Questions:
- Is this in 1NF?
   - Uniqueness: Each row is unique?
   - Atomicity: Each cell contains only atomic (indivisible) values?
- How would you improve the data model? 
Answer:
```
 sqlite3 mydb.db < scripts/exercise1.sql
```
Test for 2NF:
* It is already in 1NF.
* Are there partial dependencies?


### Exercise 2

- Is the table `inventory` from pervious exercise 3NF?
- How would you improve on the model?

Answer:
```
 sqlite3 mydb.db < scripts/exercise2.sql
```
Test for 3NF:
 * It is in 2NF
 * Are there trasnitive dependencies?

### Exercise 3

Insert data into the normalized tables from exercise 2.
```bash
python generate.py
```