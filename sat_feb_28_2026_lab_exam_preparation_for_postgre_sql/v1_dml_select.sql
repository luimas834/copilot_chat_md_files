-- All columns, all rows
SELECT * FROM PRODUCT;

-- Specific columns
SELECT PNAME, PRICE FROM PRODUCT;

-- With filtering (WHERE clause)
SELECT * FROM PRODUCT WHERE PRICE > 50;

-- AND: both conditions must be true
SELECT * FROM PRODUCT
WHERE PRICE > 30 AND CATEGORY = 'Electronics';

-- OR: at least one condition must be true
SELECT * FROM PRODUCT
WHERE CATEGORY = 'Electronics' OR CATEGORY = 'Stationery';

-- NOT: negation
SELECT * FROM PRODUCT
WHERE NOT CATEGORY = 'Electronics';
-- Same as: WHERE CATEGORY != 'Electronics'
-- Same as: WHERE CATEGORY <> 'Electronics'

-- LIKE: pattern matching
-- % = any sequence of characters
-- _ = exactly one character
SELECT * FROM PRODUCT WHERE PNAME LIKE 'G%';     -- starts with G
SELECT * FROM PRODUCT WHERE PNAME LIKE '%Mouse';  -- ends with Mouse
SELECT * FROM PRODUCT WHERE PNAME LIKE '%am%';    -- contains 'am'
SELECT * FROM PRODUCT WHERE PNAME LIKE '_e%';     -- second letter is 'e'

-- IS NULL / IS NOT NULL
SELECT * FROM PRODUCT WHERE CATEGORY IS NULL;
SELECT * FROM PRODUCT WHERE CATEGORY IS NOT NULL;

-- ⚠️ You CANNOT use = NULL. It's always IS NULL.
-- WHERE CATEGORY = NULL   ← WRONG (always returns nothing)
-- WHERE CATEGORY IS NULL  ← CORRECT