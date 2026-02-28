-- Full syntax: specify all columns
INSERT INTO PRODUCT (PID, PNAME, PRICE, CATEGORY)
VALUES (DEFAULT, 'Gaming Mouse', 45, 'Electronics');
-- DEFAULT tells PostgreSQL to auto-generate the SERIAL value

-- You can omit SERIAL columns entirely:
INSERT INTO PRODUCT (PNAME, PRICE, CATEGORY)
VALUES ('Gel Pen', 5, 'Stationery');

-- Insert multiple rows at once:
INSERT INTO PRODUCT (PNAME, PRICE, CATEGORY) VALUES
    ('Keyboard', 80, 'Electronics'),
    ('Notebook', 10, 'Stationery'),
    ('Monitor', 300, 'Electronics');

-- ⚠️ COMMON MISTAKES:
-- 1. String values MUST be in SINGLE quotes: 'Hello' not "Hello"
--    Double quotes are for identifiers (column/table names) in PostgreSQL
-- 2. Number values have NO quotes: 45 not '45'
-- 3. Order of values must match order of columns listed