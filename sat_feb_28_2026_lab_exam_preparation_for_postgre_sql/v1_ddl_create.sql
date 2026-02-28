-- Basic syntax pattern:
-- CREATE TABLE table_name (
--     column_name  DATA_TYPE  [CONSTRAINTS],
--     ...
-- );

-- Example: Creating a Product table
CREATE TABLE PRODUCT (
    PID      SERIAL PRIMARY KEY,       -- SERIAL = auto-increment integer (1, 2, 3...)
    PNAME    VARCHAR(50) NOT NULL,     -- Up to 50 characters, cannot be empty
    PRICE    INT CHECK (PRICE >= 0),   -- Must be zero or positive
    CATEGORY VARCHAR(30)               -- Optional field (can be NULL)
);

-- IMPORTANT DATA TYPES TO REMEMBER:
-- INT          → whole numbers (1, 2, 100)
-- SERIAL       → auto-incrementing INT (you don't supply the value)
-- VARCHAR(n)   → variable-length string up to n characters
-- NUMERIC(p,s) → exact decimal: p = total digits, s = digits after decimal
--                NUMERIC(10,2) can store 12345678.90
-- DATE         → calendar date ('2025-01-15')
-- TEXT         → unlimited length string
-- BOOLEAN      → true / false
-- CHAR(n)      → fixed-length string, padded with spaces