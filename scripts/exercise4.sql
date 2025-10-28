-- set output format
.mode column
.headers on

# Drop existing objects if they exist
DROP TRIGGER IF EXISTS trg_sample_backup_on_delete;
DROP TABLE IF EXISTS sample_backup;
DROP TABLE IF EXISTS sample;

-- Create sample table and insert data
CREATE TABLE sample (
  id INTEGER PRIMARY KEY,
  code TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO sample (id, code) VALUES
  (1, 'Alpha'),
  (2, 'Bravo'),
  (3, 'Charlie'),
  (4, 'Delta'),
  (5, 'Echo');


-- Create index on code column
CREATE INDEX idx_sample_code ON sample(code);
EXPLAIN QUERY PLAN SELECT * FROM sample WHERE code = 'Charlie';


-- Create trigger to back up deleted rows
CREATE TRIGGER trg_sample_backup_on_delete
AFTER DELETE ON sample
FOR EACH ROW
BEGIN
  INSERT INTO sample_backup (id, code, created_at, deleted_at)
  VALUES (OLD.id, OLD.code, OLD.created_at, CURRENT_TIMESTAMP);
END;

-- Create sample_backup table
CREATE TABLE sample_backup (
  backup_id INTEGER PRIMARY KEY,
  id INTEGER,
  code TEXT,
  created_at DATETIME,
  deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Delete a row to test the trigger
BEGIN TRANSACTION;
DELETE FROM sample WHERE id = 4;
DELETE FROM sample WHERE id = 5;
INSERT INTO sample (id, code) VALUES (6, 'Foxtrot');
COMMIT; -- ROLLBACK;

-- Verify remaining data in sample table
SELECT * FROM sample_backup ORDER BY backup_id;