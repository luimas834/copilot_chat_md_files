-- Delete specific rows
DELETE FROM PRODUCT WHERE PID = 3;

-- Delete with condition
DELETE FROM PRODUCT WHERE PRICE = 0;

-- ⚠️ Same danger as UPDATE — forgetting WHERE deletes EVERYTHING:
DELETE FROM PRODUCT;  -- All rows gone!

-- To delete all rows but keep the table structure:
-- DELETE FROM PRODUCT;    ← slower, logged, can rollback
-- TRUNCATE TABLE PRODUCT; ← faster, but can't easily rollback