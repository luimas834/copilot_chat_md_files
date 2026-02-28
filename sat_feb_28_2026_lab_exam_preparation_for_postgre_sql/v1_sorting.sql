-- ASC = ascending (smallest first) — this is the DEFAULT
-- DESC = descending (largest first)

-- Sort by salary, highest first
SELECT name, salary FROM Employee
ORDER BY salary DESC;

-- Sort by multiple columns:
-- First by department (alphabetically), then within each dept by salary (highest first)
SELECT dept_id, name, salary FROM Employee
ORDER BY dept_id ASC, salary DESC;

-- ⚠️ You can also sort by column position number:
SELECT name, salary FROM Employee
ORDER BY 2 DESC;  -- 2 = second column = salary
-- But using column names is clearer and preferred in exams.

-- ORDER BY always comes AFTER WHERE (if WHERE exists)
SELECT name, salary FROM Employee
WHERE dept_id = 'D01'
ORDER BY salary DESC;