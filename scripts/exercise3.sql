
.mode column
.headers on

DROP INDEX IF EXISTS idx_inventory_sku;
--CREATE INDEX idx_inventory_sku ON inventory(sku);

EXPLAIN QUERY PLAN
SELECT COUNT(*) FROM inventory WHERE sku = 'TVH-742472';

.timer on
SELECT COUNT(*) FROM inventory WHERE sku = 'TVH-742472';
.timer off


