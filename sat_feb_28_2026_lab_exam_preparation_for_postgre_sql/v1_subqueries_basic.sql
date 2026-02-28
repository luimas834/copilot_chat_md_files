-- WHAT IS A SUBQUERY?
-- A subquery is a SELECT inside another SELECT.
-- The inner query runs FIRST, then its result feeds into the outer query.

-- ═══════════════════════════════════════
-- TYPE 1: SINGLE-ROW SUBQUERY
-- Returns ONE value. Used with =, >, <, >=, <=, !=
-- ═══════════════════════════════════════

-- "Find employees who earn more than the average salary"
-- Step 1 (inner): What's the average salary? → SELECT AVG(salary) FROM Employee → 56000
-- Step 2 (outer): Who earns more than 56000?

SELECT name, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

-- "Find the employee with the highest salary"
SELECT name, salary
FROM Employee
WHERE salary = (SELECT MAX(salary) FROM Employee);

-- ⚠️ If the subquery accidentally returns MORE than one row,
-- using = will cause an ERROR. Use IN instead.


-- ═══════════════════════════════════════
-- TYPE 2: MULTIPLE-ROW SUBQUERY
-- Returns multiple values. Used with IN, ANY, ALL
-- ═══════════════════════════════════════

-- "Find employees in departments located in Building A"
-- Step 1 (inner): Which dept_ids are in Building A? → D01
-- Step 2 (outer): Which employees have those dept_ids?

SELECT name
FROM Employee
WHERE dept_id IN (
    SELECT dept_id FROM Department WHERE location = 'Building A'
);

-- IN means "is the value one of these?"
-- Think of it as: WHERE dept_id = 'D01' OR dept_id = 'D02' OR ...

-- ANY: true if condition is true for AT LEAST ONE value
SELECT name, salary FROM Employee
WHERE salary > ANY (SELECT salary FROM Employee WHERE dept_id = 'D03');
-- "Salary greater than ANY salary in D03"
-- Equivalent to: salary > MIN(salaries in D03)

-- ALL: true if condition is true for EVERY value
SELECT name, salary FROM Employee
WHERE salary > ALL (SELECT salary FROM Employee WHERE dept_id = 'D03');
-- "Salary greater than ALL salaries in D03"
-- Equivalent to: salary > MAX(salaries in D03)


-- ═══════════════════════════════════════
-- TYPE 3: NESTED SUBQUERIES (subquery inside subquery)
-- ═══════════════════════════════════════

-- "Find employees working in the department that runs 'AI Research'"
-- We need: Employee → Project → match proj_name
SELECT name
FROM Employee
WHERE dept_id IN (
    SELECT dept_id FROM Project WHERE proj_name = 'AI Research'
);

-- Even deeper: "Employees in departments where the dept runs a project
-- AND that department's name is 'CSE'"
SELECT name
FROM Employee
WHERE dept_id IN (
    SELECT dept_id FROM Project
    WHERE dept_id = (
        SELECT dept_id FROM Department WHERE dept_name = 'CSE'
    )
);
-- Innermost runs first: dept_name = 'CSE' → D01
-- Middle: projects with dept_id = D01 → P01, P03
-- Outer: employees with dept_id IN those results


-- ═══════════════════════════════════════
-- TYPE 4: CORRELATED SUBQUERY
-- The inner query uses a value from the OUTER query.
-- It runs ONCE PER ROW of the outer query (slow but powerful).
-- ═══════════════════════════════════════

-- "Find employees earning above their OWN department's average"
SELECT e1.name, e1.salary, e1.dept_id
FROM Employee e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.dept_id = e1.dept_id    -- This links inner to outer!
);

-- HOW IT WORKS (step by step for each row):
-- Row 1: Alice (D01, 50000)
--   Inner query: AVG salary where dept_id = 'D01' = (50000+60000+70000)/3 = 60000
--   Is 50000 > 60000? NO → Alice excluded
--
-- Row 2: Bob (D01, 60000)
--   Inner query: same D01 avg = 60000
--   Is 60000 > 60000? NO → Bob excluded
--
-- Row 5: Eve (D01, 70000)
--   Inner query: same D01 avg = 60000
--   Is 70000 > 60000? YES → Eve included

-- ⚠️ KEY DIFFERENCE:
-- Regular subquery: inner runs ONCE, result is fixed
-- Correlated subquery: inner runs ONCE PER ROW, result changes