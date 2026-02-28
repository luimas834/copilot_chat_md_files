-- GROUP BY splits rows into groups, then aggregates each group separately

-- "How many employees in each department?"
SELECT dept_id, COUNT(*) AS emp_count
FROM Employee
GROUP BY dept_id;
-- Result:
-- D01 | 3
-- D02 | 1
-- D03 | 1

-- ⚠️ RULE: Every column in SELECT must either:
--   1. Be in GROUP BY, OR
--   2. Be inside an aggregate function (COUNT, SUM, AVG, etc.)
--
-- WRONG: SELECT dept_id, name, COUNT(*) FROM Employee GROUP BY dept_id;
--   → "name" is not in GROUP BY and not aggregated. ERROR!
--
-- RIGHT: SELECT dept_id, COUNT(*) FROM Employee GROUP BY dept_id;

-- With JOIN:
SELECT D.dept_name, SUM(E.salary) AS total_salary
FROM Department D
JOIN Employee E ON D.dept_id = E.dept_id
GROUP BY D.dept_name;

-- Multiple aggregates per group:
SELECT dept_id,
       COUNT(*)     AS emp_count,
       AVG(salary)  AS avg_salary,
       MAX(salary)  AS highest_salary
FROM Employee
GROUP BY dept_id;