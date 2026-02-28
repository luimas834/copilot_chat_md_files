-- Aggregate functions collapse multiple rows into ONE value

-- COUNT(*) — total number of rows
SELECT COUNT(*) FROM Employee;  -- 5

-- COUNT(column) — counts non-NULL values in that column
SELECT COUNT(dept_id) FROM Employee;

-- SUM — total of all values
SELECT SUM(salary) FROM Employee;  -- 280000

-- AVG — average (mean)
SELECT AVG(salary) FROM Employee;  -- 56000

-- MIN / MAX
SELECT MIN(salary), MAX(salary) FROM Employee;  -- 45000, 70000

-- ROUND — often used with AVG
SELECT ROUND(AVG(salary), 2) FROM Employee;  -- 56000.00

-- ⚠️ You CANNOT mix aggregate and non-aggregate columns without GROUP BY:
-- SELECT name, AVG(salary) FROM Employee;  ← ERROR!
-- Which "name" should it show alongside the single average?
-- You need GROUP BY (see below)