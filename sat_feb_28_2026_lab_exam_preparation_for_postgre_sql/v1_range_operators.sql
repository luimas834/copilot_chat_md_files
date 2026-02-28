-- BETWEEN: inclusive on both ends
SELECT name, salary FROM Employee
WHERE salary BETWEEN 45000 AND 60000;
-- Same as: WHERE salary >= 45000 AND salary <= 60000

-- DISTINCT: removes duplicate values from results
SELECT DISTINCT dept_id FROM Employee;
-- If 3 employees are in D01, D01 appears only ONCE

-- LIMIT: restrict number of rows returned
-- Top 3 highest paid:
SELECT name, salary FROM Employee
ORDER BY salary DESC
LIMIT 3;

-- ⚠️ LIMIT without ORDER BY gives unpredictable rows!
-- Always pair LIMIT with ORDER BY.

-- OFFSET: skip rows (useful for pagination)
SELECT name, salary FROM Employee
ORDER BY salary DESC
LIMIT 3 OFFSET 2;  -- Skip first 2, then show next 3