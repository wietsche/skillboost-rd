
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
 sqlite3 mydb.db < scripts/inventory.sql
 sqlite3 mydb.db -header -column "SELECT * FROM inventory"
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

- Is the table `inventory2` from pervious exercise 3NF?
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

## Setup



## Normal forms

What column or combination of columns make a row unique?
Understand dependencies between columns.



### 1NF
A table is in 1NF if it meets the following criteria:
1. Uniqueness: Each row is unique.
2. Atomicity: Each cell contains only atomic (indivisible) values. 

Is this in 1NF?
* No, because the "actors" column contains multiple values in a single cell.

| movie_id | title           | director          | actors                                   |
|----------|-----------------|-------------------|-------------------------------------------|
| 1        | Inception       | Christopher Nolan | [Leonardo DiCaprio, Joseph Gordon-Levitt] |
| 2        | The Dark Knight | Christopher Nolan | [Christian Bale, Heath Ledger]            |

1NF version:

| movie_id | title           | director        | actor          |
|----------|-----------------|-----------------|----------------|
| 1        | Inception       | Christopher Nolan| Leonardo DiCaprio|
| 1        | Inception       | Christopher Nolan| Joseph Gordon-Levitt|
| 2        | The Dark Knight | Christopher Nolan| Christian Bale |
| 2        | The Dark Knight | Christopher Nolan| Heath Ledger   |


### 2NF
A table is in 2NF if it meets the following criteria:
1. It is already in 1NF.
2. No partial dependencies: All non-key attributes must depend on the entire primary key

2NF version:


| movie_id | title           | director          |
|----------|-----------------|-------------------|
| 1        | Inception       | Christopher Nolan |
| 2        | The Dark Knight | Christopher Nolan |

| movie_id | actor                |
|----------|----------------------|
| 1        | Leonardo DiCaprio    |
| 1        | Joseph Gordon-Levitt |
| 2        | Christian Bale       |
| 2        | Heath Ledger         |



Is this in 1NF?
* Yes, atomic data and unique rows
Is this in 2NF?




### 3NF
A table is in 3NF if it meets the following criteria:
1. It is already in 2NF.
2. No transitive dependencies: There are no transitive dependencies between non-key attributes. This means that non-key attributes should not depend on other non-key attributes. Every non-key attribute must depend only on the primary key.





| book_id | title                                | author                    |      genre      | year\_published |
|--------:|:-------------------------------------|:--------------------------|:---------------:|---------------:|
|       6 | 1984                                 | George Orwell             |    Dystopian    |           1949 |
|       3 | The Great Gatsby                     | F. Scott Fitzgerald       |      Novel      |           1925 |
|       9 | And Then There Were None             | Agatha Christie           |     Mystery     |           1939 |
|       2 | Moby-Dick                            | Herman Melville           |    Adventure    |           1851 |
|       8 | Murder on the Orient Express         | Agatha Christie           |     Mystery     |           1934 |
|       1 | Pride and Prejudice                  | Jane Austen               |     Romance     |           1813 |
|       4 | To Kill a Mockingbird                | Harper Lee                | Southern Gothic |           1960 |
|      10 | The Mysterious Affair at Styles      | Agatha Christie           |     Mystery     |           1920 |
|       5 | Don Quixote                          | Miguel de Cervantes       |     Satire      |           1605 |
|       7 | Animal Farm                          | George Orwell             |     Satire      |           1945 |



| book\_id | title                                 | author                    | country         | genre              | year\_published |
|--------:|:--------------------------------------|:--------------------------|:---------------:|:------------------:|---------------:|
| 6       | 1984                                  | George Orwell             | United Kingdom  | Dystopian          |           1949 |
| 3       | The Great Gatsby                      | F. Scott Fitzgerald       | United States   | Novel              |           1925 |
| 9       | And Then There Were None              | Agatha Christie           | United Kingdom  | Mystery            |           1939 |
| 2       | Moby\-Dick                            | Herman Melville           | United States   | Adventure          |           1851 |
| 8       | Murder on the Orient Express          | Agatha Christie           | United Kingdom  | Mystery            |           1934 |
| 1       | Pride and Prejudice                   | Jane Austen               | United Kingdom  | Romance            |           1813 |
| 4       | To Kill a Mockingbird                 | Harper Lee                | United States   | Southern Gothic    |           1960 |
| 10      | The Mysterious Affair at Styles       | Agatha Christie           | United Kingdom  | Mystery            |           1920 |
| 5       | Don Quixote                           | Miguel de Cervantes       | Spain           | Satire             |           1605 |
| 7       | Animal Farm                           | George Orwell             | United Kingdom  | Political Satire   |           1945 |


Authors

| author\_id | name                   | country        |
|-----------:|:-----------------------|:---------------|
| 1          | George Orwell          | United Kingdom |
| 2          | F. Scott Fitzgerald    | United States  |
| 3          | Agatha Christie        | United Kingdom |
| 4          | Herman Melville        | United States  |
| 5          | Jane Austen            | United Kingdom |
| 6          | Harper Lee             | United States  |
| 7          | Miguel de Cervantes    | Spain          |

Genres

| genre\_id | name               |
|---------:|:-------------------|
| 1        | Dystopian          |
| 2        | Novel              |
| 3        | Mystery            |
| 4        | Adventure          |
| 5        | Romance            |
| 6        | Southern Gothic    |
| 7        | Satire             |
| 8        | Political Satire   |

Books

| book\_id | title                                | author\_id | genre\_id | year\_published |
|--------:|:-------------------------------------|----------:|---------:|----------------:|
| 1       | Pride and Prejudice                   | 5         | 5        | 1813            |
| 2       | Moby\-Dick                            | 4         | 4        | 1851            |
| 3       | The Great Gatsby                      | 2         | 2        | 1925            |
| 4       | To Kill a Mockingbird                 | 6         | 6        | 1960            |
| 5       | Don Quixote                           | 7         | 7        | 1605            |
| 6       | 1984                                  | 1         | 1        | 1949            |
| 7       | Animal Farm                           | 1         | 8        | 1945            |
| 8       | Murder on the Orient Express          | 3         | 3        | 1934            |
| 9       | And Then There Were None              | 3         | 3        | 1939            |
| 10      | The Mysterious Affair at Styles       | 3         | 3        | 1920            |

Authors

| column     | type    | nullable | constraints               |
|------------|---------|:--------:|---------------------------|
| author\_id | INTEGER | NO       | PRIMARY KEY               |
| name       | TEXT    | NO       | NOT NULL, UNIQUE          |
| country    | TEXT    | YES      |                           |

Genres

| column     | type    | nullable | constraints               |
|------------|---------|:--------:|---------------------------|
| genre\_id  | INTEGER | NO       | PRIMARY KEY               |
| name       | TEXT    | NO       | NOT NULL, UNIQUE          |

Books

| column         | type    | nullable | constraints                                        |
|----------------|---------|:--------:|----------------------------------------------------|
| book\_id       | INTEGER | NO       | PRIMARY KEY                                        |
| title          | TEXT    | NO       | NOT NULL                                           |
| author\_id     | INTEGER | NO       | NOT NULL, FOREIGN KEY \-\> authors(author\_id)     |
| genre\_id      | INTEGER | YES      | FOREIGN KEY \-\> genres(genre\_id)                 |
| year\_published| INTEGER | YES      |                                                    |


Authors

| column     | type    | constraints     |
|------------|---------|-----------------|
| author\_id | INTEGER | PRIMARY KEY     |
| name       | TEXT    |                 |
| country    | TEXT    |                 |

Genres

| column     | type    | constraints     |
|------------|---------|-----------------|
| genre\_id  | INTEGER | PRIMARY KEY     |
| name       | TEXT    |                 |

Books

| column           | type    | constraints                                      |
|------------------|---------|--------------------------------------------------|
| book\_id         | INTEGER | PRIMARY KEY                                      |
| title            | TEXT    |                                                  |
| author\_id       | INTEGER | FOREIGN KEY \-\> authors(author\_id)             |
| genre\_id        | INTEGER | FOREIGN KEY \-\> genres(genre\_id)               |
| year\_published  | INTEGER |                                                  |

| comic\_id | title        | character\_name | country\_of\_origin |
|----------:|:-------------|:----------------|:-------------------|
|         1 | Spider-Verse | Spider-Man      | United States      |
|         2 | Civil War    | Iron Man        | United States      |
|         3 | Thor         | Thor            | Asgard             |
|         3 | Thor         | Jane Foster     | United States      |
|         4 | Avengers     | Iron Man        | United States      |