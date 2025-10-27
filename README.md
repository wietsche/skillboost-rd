# SkillsBoost RD

Hands‑on SQL and Python exercises focused on normalization, data modeling, and a SQLite workflow. Includes a Python seeder to generate realistic product, department, and inventory data.

## Setup

### Launch a Codespace
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/wietsche/skillsboost-rd)

### Local (macOS)

Prepare workspace:
    
    mkdir -p ~/skillsboost
    cd ~/skillsboost
    git clone git@github.com:wietsche/skillsboost-rd.git
    cd skillsboost-rd

Install SQLite:
    
    # Option A: Homebrew
    brew install sqlite

    # Option B: Download tools (Apple Silicon example)
    wget https://www.sqlite.org/2025/sqlite-tools-osx-arm64-3500400.zip
    unzip sqlite-tools-osx-arm64-3500400.zip

Python environment:
    
    # Optional: create a virtual environment
    python3 -m venv .venv
    source .venv/bin/activate

    # Dependency used by seed.py
    pip install -r requirements.txt

## SQLite

Ways to run queries:

1. One‑off command
    
        sqlite3 my.db "SELECT date('now');"

2. REPL
    
        sqlite3 my.db
        SELECT date('now');
        .q

3. From a file
    
        sqlite3 my.db < scripts/scratch.sql

4. GUI  
Use any SQLite GUI of your choice.

## Exercises

### Exercise 1
Load the initial dataset and inspect a denormalized table:
    
    sqlite3 my.db < scripts/setup.sql
    sqlite3 my.db -header -column "SELECT * FROM product_inventory;"

Questions:
- Is the table in 1NF?
  - Uniqueness: Is each row unique?
  - Atomicity: Does each cell contain only atomic values?
- How would you improve the data model?

Apply suggested improvements:
    
    sqlite3 my.db < scripts/exercise1.sql

Test for 2NF:
- It is already in 1NF.
- No partial dependencies on key

### Exercise 2
Evaluate 3NF on the `inventory` table and improve the model:
    
    sqlite3 my.db < scripts/exercise2.sql

Test for 3NF:
- It is in 2NF
- No transitive dependencies

### Exercise 3
Generate sample data into the normalized schema using Python:
    
    # Uses DATABASE_URL if set, defaults to sqlite:///my.db
    python seed.py

## Sample triggers and transactions

Create a sample table, backup table, and a delete trigger:
    
    sqlite3 my.db < scripts/trigger.sql

Run a delete inside a transaction to ensure atomicity:
    
    sqlite3 my.db < scripts/examples.sql

## Notes

- Default database file: `my.db`
- Seeding config and distribution knobs are in `seed.py`
- macOS shell examples assume `sqlite3` is on `PATH`
