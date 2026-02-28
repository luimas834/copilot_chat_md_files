-- ═══════════════════════════════════════
-- 1. INNER JOIN (most common)
-- Only matching rows from BOTH tables
-- ═══════════════════════════════════════
SELECT E.name, D.dept_name, D.location
FROM Employee E
INNER JOIN Department D ON E.dept_id = D.dept_id;
-- If an employee has dept_id = 'D99' (doesn't exist in Department),
-- that employee will NOT appear in results.

-- ⚠️ You can write just "JOIN" — it defaults to INNER JOIN
SELECT E.name, D.dept_name
FROM Employee E
JOIN Department D ON E.dept_id = D.dept_id;


-- ═══════════════════════════════════════
-- 2. LEFT JOIN (LEFT OUTER JOIN)
-- ALL rows from LEFT table, matched rows from right (NULL if no match)
-- ═══════════════════════════════════════
SELECT D.dept_id, D.dept_name, P.proj_name
FROM Department D
LEFT JOIN Project P ON D.dept_id = P.dept_id;

-- Result:
-- D01 | CSE | AI Research
-- D01 | CSE | Web Dev
-- D02 | EEE | Circuit Design
-- D03 | BBA | NULL          ← BBA has no projects, but still appears!


-- ═══════════════════════════════════════
-- 3. RIGHT JOIN (RIGHT OUTER JOIN)
-- ALL rows from RIGHT table, matched rows from left
-- ═══════════════════════════════════════
SELECT P.proj_name, D.dept_name
FROM Project P
RIGHT JOIN Department D ON P.dept_id = D.dept_id;
-- Same result as the LEFT JOIN above (just tables swapped)
-- RIGHT JOINs are rare — people usually rewrite as LEFT JOIN


-- ═══════════════════════════════════════
-- 4. FULL OUTER JOIN
-- ALL rows from BOTH tables
-- ═══════════════════════════════════════
SELECT E.name, P.proj_name
FROM Employee E
FULL OUTER JOIN Project P ON E.dept_id = P.dept_id;
-- Shows ALL employees and ALL projects
-- Unmatched employees get NULL for proj_name
-- Unmatched projects get NULL for name


-- ═══════════════════════════════════════
-- 5. CROSS JOIN (Cartesian Product)
-- Every row from table A × every row from table B
-- 3 departments × 3 projects = 9 rows
-- ═══════════════════════════════════════
SELECT D.dept_name, P.proj_name
FROM Department D
CROSS JOIN Project P;
-- No ON clause! That's the key difference.
-- ⚠️ Be careful: 1000 rows × 1000 rows = 1,000,000 rows!


-- ═══════════════════════════════════════
-- 6. NATURAL JOIN
-- Automatically joins on columns with THE SAME NAME in both tables
-- ═══════════════════════════════════════
SELECT name, dept_name, location
FROM Employee
NATURAL JOIN Department;
-- PostgreSQL finds "dept_id" exists in both tables and joins on it.
-- ⚠️ DANGER: If tables share a column name you didn't intend to join on,
-- you'll get wrong results. Explicit JOIN ... ON is safer.


-- ═══════════════════════════════════════
-- MULTI-TABLE JOINS
-- You can chain multiple joins
-- ═══════════════════════════════════════
SELECT E.name, D.dept_name, P.proj_name
FROM Employee E
JOIN Department D ON E.dept_id = D.dept_id
JOIN Project P ON D.dept_id = P.dept_id;
-- This gives employees with their dept name AND project name
-- Only shows rows where ALL three match