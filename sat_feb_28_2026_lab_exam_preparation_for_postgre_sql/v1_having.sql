-- WHERE filters individual ROWS (before grouping)
-- HAVING filters GROUPS (after aggregation)

-- "Show departments where the average salary is above 50000"
SELECT dept_id, AVG(salary) AS avg_sal
FROM Employee
GROUP BY dept_id
HAVING AVG(salary) > 50000;

-- ⚠️ You CANNOT use column aliases in HAVING:
-- HAVING avg_sal > 50000  ← WRONG in PostgreSQL (actually PostgreSQL allows
--                           this but standard SQL doesn't — be safe, repeat
--                           the expression)

-- FULL QUERY ORDER (memorize this!):
-- SELECT   → what columns to show
-- FROM     → which table(s)
-- JOIN     → combining tables
-- WHERE    → filter rows BEFORE grouping
-- GROUP BY → form groups
-- HAVING   → filter groups AFTER aggregation
-- ORDER BY → sort the final result
-- LIMIT    → restrict number of rows

-- Example using everything:
SELECT D.dept_name, COUNT(*) AS emp_count, AVG(E.salary) AS avg_sal
FROM Employee E
JOIN Department D ON E.dept_id = D.dept_id
WHERE E.salary > 40000                 -- filter rows first
GROUP BY D.dept_name                   -- then group
HAVING COUNT(*) >= 1                   -- filter groups
ORDER BY avg_sal DESC                  -- sort result
LIMIT 5;                               -- show top 5