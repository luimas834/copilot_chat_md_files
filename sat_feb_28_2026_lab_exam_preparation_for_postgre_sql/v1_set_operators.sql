-- Set operators combine results of TWO SELECT queries.
-- ⚠️ RULES:
-- 1. Both queries must return the SAME NUMBER of columns
-- 2. Corresponding columns must have COMPATIBLE data types

-- ═══════════════════════════════════════
-- UNION — All unique rows from both queries (removes duplicates)
-- ═══════════════════════════════════════
SELECT student_id FROM Course_Alpha
UNION
SELECT student_id FROM Course_Beta;
-- Alpha has: 1001, 1002, 1003, 1004, 1005
-- Beta has:  1004, 1005, 1006, 1007, 1008
-- Result:    1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008  (8 unique)

-- ═══════════════════════════════════════
-- UNION ALL — All rows, INCLUDING duplicates (faster)
-- ═══════════════════════════════════════
SELECT student_id FROM Course_Alpha
UNION ALL
SELECT student_id FROM Course_Beta;
-- Result: 1001,1002,1003,1004,1005,1004,1005,1006,1007,1008 (10 rows)
-- 1004 and 1005 appear twice

-- ═══════════════════════════════════════
-- INTERSECT — Only rows that appear in BOTH queries
-- ═══════════════════════════════════════
SELECT student_id FROM Course_Alpha
INTERSECT
SELECT student_id FROM Course_Beta;
-- Result: 1004, 1005 (in both courses)

-- ═══════════════════════════════════════
-- EXCEPT — Rows in first query but NOT in second
-- ═══════════════════════════════════════
SELECT student_id FROM Course_Alpha
EXCEPT
SELECT student_id FROM Course_Beta;
-- Result: 1001, 1002, 1003 (only in Alpha)

-- ⚠️ ORDER MATTERS for EXCEPT:
-- Alpha EXCEPT Beta ≠ Beta EXCEPT Alpha
-- Beta EXCEPT Alpha → 1006, 1007, 1008

-- ⚠️ EXCEPT is like set subtraction (A - B)