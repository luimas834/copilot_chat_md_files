-- Basic update
UPDATE PRODUCT
SET PRICE = 40
WHERE PID = 1;

-- Update multiple columns at once
UPDATE PRODUCT
SET PRICE = 50, CATEGORY = 'Premium Electronics'
WHERE PID = 1;

-- ⚠️⚠️⚠️ THE MOST DANGEROUS MISTAKE IN SQL:
-- Forgetting the WHERE clause updates ALL rows!
UPDATE PRODUCT SET PRICE = 0;
-- This sets EVERY product's price to 0. Disaster!

-- Arithmetic in updates
UPDATE PRODUCT
SET PRICE = PRICE * 1.10;  -- 10% price increase for ALL products
-- (Only do this intentionally without WHERE)

-- Update with a condition
UPDATE PRODUCT
SET PRICE = PRICE * 0.90   -- 10% discount
WHERE CATEGORY = 'Stationery';