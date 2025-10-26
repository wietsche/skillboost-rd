SELECT date('now');

-- show CREATE statement (sqlite3 shell command)
.schema your_table

-- column list: cid, name, type, notnull, dflt_value, pk
PRAGMA table_info('your_table');

-- foreign keys for the table: id, seq, table, from, to, ...
PRAGMA foreign_key_list('your_table');

-- list indexes on the table (sqlite3 shell command)
.indexes your_table