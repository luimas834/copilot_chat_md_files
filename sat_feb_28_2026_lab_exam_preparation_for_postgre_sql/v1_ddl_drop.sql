-- Simple drop
DROP TABLE PRODUCT;

-- Safe drop (won't error if table doesn't exist)
DROP TABLE IF EXISTS PRODUCT;

-- CASCADE: Also drops anything that depends on this table
-- (views, foreign keys referencing it, etc.)
DROP TABLE PRODUCT CASCADE;

-- ⚠️ COMMON MISTAKE: Trying to drop a table that other tables reference.
-- If Employee has a FK to Department, you can't drop Department without CASCADE
-- or without dropping Employee first.