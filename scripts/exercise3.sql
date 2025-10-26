
.mode column
.headers on

DROP INDEX IF EXISTS idx_inventory_sku;

.timer on
SELECT COUNT(*) AS count_without_index FROM inventory WHERE sku = 'TVH-742472';

--.timer off
--CREATE INDEX idx_inventory_sku ON inventory(sku);
--
--
--.timer on
--SELECT COUNT(*) AS count_with_index FROM inventory WHERE sku = 'TVH-742472';
