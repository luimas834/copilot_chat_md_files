# Copilot Chat Conversation Export: Lab exam preparation for PostgreSQL

**User:** @luimas834
**Thread URL:** https://github.com/copilot/c/40180c15-2bb4-4e49-8352-5d957ee02ac4

## @luimas834

i have a lab exam on all these topic except the first one file handling.....so give  me very detailed guidline on each topic with what may be confusion for doing it in psql....and also at ending give special focus on funcitons  and   procedures and their  working...with a bit more practice examples....give from very very basic....

## Copilot



# 📘 Complete DBMS Lab Exam Preparation Guide

This is a comprehensive, from-the-ground-up guide covering every topic in your labs (II through X), with special attention to common pitfalls in `psql` and an extended deep-dive into Functions & Procedures.

---

## Part 1: Lab Setup & Workflow (Lab II)

### The PostgreSQL Connection Flow

Every lab starts the same way. Memorize this sequence:

```text
Step 1: Login as superuser postgres
Step 2: Create your ROLE (user) and DATABASE
Step 3: Exit superuser
Step 4: Reconnect as YOUR role to YOUR database
Step 5: Load the .sql file
Step 6: Verify tables with \dt
```

### Key Commands & Common Confusions

```sql name=setup_commands.sql
-- 1. Login as postgres superuser
-- Run this in your TERMINAL (bash), NOT inside psql
sudo -i -u postgres psql

-- 2. Inside psql as postgres, create your role and database
-- COMMON MISTAKE: Forgetting to terminate existing connections first!
-- If someone (or you) is already connected to the DB, DROP will fail.
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'cse4308_12345';

DROP DATABASE IF EXISTS cse4308_12345;
DROP ROLE IF EXISTS alice;

CREATE ROLE alice LOGIN;
ALTER ROLE alice WITH PASSWORD 'alice123';
CREATE DATABASE cse4308_12345 OWNER alice;
GRANT ALL PRIVILEGES ON DATABASE cse4308_12345 TO alice;

-- 3. Exit postgres superuser
\q

-- 4. Reconnect as your user (run in TERMINAL)
-- psql -U alice -d cse4308_12345

-- 5. Load lab file (run in TERMINAL, not inside psql)
-- psql -U alice -d cse4308_12345 -f /home/cse/Downloads/lab3.sql
-- OR if you're already inside psql:
-- \i /home/cse/Downloads/lab3.sql
```

### ⚠️ Top Confusions

| Confusion | Explanation |
|---|---|
| `sudo -i -u postgres psql` vs `psql -U alice -d mydb` | First is for superuser login. Second is for YOUR user login. |
| `-f` flag vs `\i` | `-f` is used from the **terminal**. `\i` is used **inside psql**. Both load SQL files. |
| `\dt` shows nothing | You loaded the file into a different database, or as a different user. Check with `\conninfo`. |
| `DROP DATABASE` fails | Someone is connected. Use `pg_terminate_backend` first. |
| Semicolons | **Every SQL statement MUST end with `;`** inside psql. Forgetting this is the #1 beginner error. psql will just show `=>` waiting for more input. |

---

## Part 2: DDL — Data Definition Language (Lab III)

DDL is about **structure** — creating, modifying, and destroying tables.

### CREATE TABLE — The Blueprint

```sql name=ddl_create.sql
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
```

### Common Constraints Explained

```sql name=constraints_explained.sql
-- PRIMARY KEY: Uniquely identifies each row. Cannot be NULL, cannot repeat.
-- Only ONE primary key per table (but it can be composite — multiple columns).

-- NOT NULL: The column must always have a value.

-- UNIQUE: No two rows can have the same value in this column.
-- Difference from PRIMARY KEY: UNIQUE allows ONE null, PK allows NONE.

-- CHECK: A condition that must be true for every row.
-- CHECK (age >= 18)  → age must be 18 or more
-- CHECK (salary > 0) → salary must be positive

-- DEFAULT: Provides a value when none is given during INSERT.
-- status VARCHAR(10) DEFAULT 'active'

-- FOREIGN KEY: Links to another table's PRIMARY KEY. (Covered in Lab IV)

-- Example combining multiple constraints:
CREATE TABLE example (
    id       SERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    age      INT CHECK (age >= 0 AND age <= 150),
    status   VARCHAR(10) DEFAULT 'active'
);
```

### DROP TABLE

```sql name=ddl_drop.sql
-- Simple drop
DROP TABLE PRODUCT;

-- Safe drop (won't error if table doesn't exist)
DROP TABLE IF EXISTS PRODUCT;

-- CASCADE: Also drops anything that depends on this table
-- (views, foreign keys referencing it, etc.)
DROP TABLE PRODUCT CASCADE;

-- ⚠️ COMMON MISTAKE: Trying to drop a table that other tables reference.
-- If Employee has a FK to Department, you can't drop Department without CASCADE
-- or without dropping Employee first.
```

### ALTER TABLE — Modifying Structure

```sql name=ddl_alter.sql
-- ADD a new column
ALTER TABLE PRODUCT ADD COLUMN STOCK INT;
-- Now PRODUCT has: PID, PNAME, PRICE, CATEGORY, STOCK

-- DROP a column
ALTER TABLE PRODUCT DROP COLUMN STOCK;

-- CHANGE a column's data type
ALTER TABLE PRODUCT ALTER COLUMN PRICE TYPE NUMERIC(10,2);
-- ⚠️ This can fail if existing data can't be converted to the new type!

-- RENAME a column
ALTER TABLE PRODUCT RENAME COLUMN PNAME TO PRODUCT_NAME;

-- ADD a constraint after table creation
ALTER TABLE PRODUCT ADD CONSTRAINT chk_price CHECK (PRICE >= 0);

-- DROP a constraint
ALTER TABLE PRODUCT DROP CONSTRAINT chk_price;

-- RENAME the table itself
ALTER TABLE PRODUCT RENAME TO PRODUCTS;
```

### ⚠️ DDL Confusions

| Confusion | Explanation |
|---|---|
| `SERIAL` vs `INT` | `SERIAL` auto-generates values (1, 2, 3...). Don't supply a value for it in INSERT — use `DEFAULT`. |
| `VARCHAR(50)` vs `TEXT` | `VARCHAR(50)` limits to 50 chars. `TEXT` has no limit. Use `VARCHAR` when the lab specifies a limit. |
| `NUMERIC(10,2)` meaning | 10 total digits, 2 after decimal. So max value is `99999999.99`. |
| Dropping referenced tables | Must use `CASCADE` or drop the child table first. |

---

## Part 3: DML — Data Manipulation Language (Lab III)

DML is about **data** — inserting, reading, updating, and deleting rows.

### INSERT — Adding Data

```sql name=dml_insert.sql
-- Full syntax: specify all columns
INSERT INTO PRODUCT (PID, PNAME, PRICE, CATEGORY)
VALUES (DEFAULT, 'Gaming Mouse', 45, 'Electronics');
-- DEFAULT tells PostgreSQL to auto-generate the SERIAL value

-- You can omit SERIAL columns entirely:
INSERT INTO PRODUCT (PNAME, PRICE, CATEGORY)
VALUES ('Gel Pen', 5, 'Stationery');

-- Insert multiple rows at once:
INSERT INTO PRODUCT (PNAME, PRICE, CATEGORY) VALUES
    ('Keyboard', 80, 'Electronics'),
    ('Notebook', 10, 'Stationery'),
    ('Monitor', 300, 'Electronics');

-- ⚠️ COMMON MISTAKES:
-- 1. String values MUST be in SINGLE quotes: 'Hello' not "Hello"
--    Double quotes are for identifiers (column/table names) in PostgreSQL
-- 2. Number values have NO quotes: 45 not '45'
-- 3. Order of values must match order of columns listed
```

### SELECT — Reading Data

```sql name=dml_select.sql
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
```

### UPDATE — Modifying Data

```sql name=dml_update.sql
-- Basic update
UPDATE PRODUCT
SET PRICE = 40
WHERE PID = 1;

-- Update multiple columns at once
UPDATE PRODUCT
SET PRICE = 50, CATEGORY = 'Premium Electronics'
WHERE PID = 1;

-- ⚠️⚠️⚠️ THE MOST DANGEROUS MISTAKE IN SQL:
-- Forgetting the WHERE clause updates ALL rows!
UPDATE PRODUCT SET PRICE = 0;
-- This sets EVERY product's price to 0. Disaster!

-- Arithmetic in updates
UPDATE PRODUCT
SET PRICE = PRICE * 1.10;  -- 10% price increase for ALL products
-- (Only do this intentionally without WHERE)

-- Update with a condition
UPDATE PRODUCT
SET PRICE = PRICE * 0.90   -- 10% discount
WHERE CATEGORY = 'Stationery';
```

### DELETE — Removing Data

```sql name=dml_delete.sql
-- Delete specific rows
DELETE FROM PRODUCT WHERE PID = 3;

-- Delete with condition
DELETE FROM PRODUCT WHERE PRICE = 0;

-- ⚠️ Same danger as UPDATE — forgetting WHERE deletes EVERYTHING:
DELETE FROM PRODUCT;  -- All rows gone!

-- To delete all rows but keep the table structure:
-- DELETE FROM PRODUCT;    ← slower, logged, can rollback
-- TRUNCATE TABLE PRODUCT; ← faster, but can't easily rollback
```

---

## Part 4: Integrity Constraints, Sorting, Subqueries (Lab IV)

### Primary Key and Foreign Key — The Relationship System

```sql name=constraints_keys.sql
-- Think of it this way:
-- PRIMARY KEY = The table's unique ID card
-- FOREIGN KEY = A reference/pointer to another table's ID card

-- Parent table (must be created FIRST)
CREATE TABLE Department (
    dept_id   VARCHAR(5),
    dept_name VARCHAR(20),
    location  VARCHAR(50),
    CONSTRAINT pk_department PRIMARY KEY (dept_id)
);

-- Child table (references parent — created SECOND)
CREATE TABLE Employee (
    emp_id  VARCHAR(5),
    name    VARCHAR(30),
    salary  NUMERIC(10, 2),
    dept_id VARCHAR(5),
    CONSTRAINT pk_employee PRIMARY KEY (emp_id),
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- WHAT DO CASCADE OPTIONS MEAN?
--
-- ON DELETE CASCADE:
--   If you delete Department 'D01', ALL employees in D01 are also deleted.
--   Think: "If the parent dies, children die too."
--
-- ON DELETE SET NULL:
--   If you delete Department 'D01', employees' dept_id becomes NULL.
--   Think: "If the parent dies, children become orphans."
--
-- ON DELETE RESTRICT (or NO ACTION — default):
--   If you try to delete Department 'D01' while employees exist, it FAILS.
--   Think: "You can't abandon your children."
--
-- ON UPDATE CASCADE:
--   If you change D01 to D10, all employees' dept_id also changes to D10.

-- ⚠️ COMMON MISTAKES:
-- 1. Creating the child table BEFORE the parent table → ERROR
-- 2. Inserting a child row with a dept_id that doesn't exist in parent → ERROR
-- 3. The FK column and the referenced PK column must have the SAME data type
```

### ORDER BY — Sorting Results

```sql name=sorting.sql
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
```

### BETWEEN, DISTINCT, LIMIT

```sql name=range_operators.sql
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
```

### Subqueries — Queries Inside Queries

This is where many students get confused. Let's build up from scratch.

```sql name=subqueries_basic.sql
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
```

---

## Part 5: Joins, Aggregation, and Grouping (Lab V)

### Joins — Combining Tables

Joins are how you connect data across multiple tables. Think of it as **stitching tables together** on a matching column.

```sql name=joins_visual.sql
-- ═══════════════════════════════════════════════════════════
-- VISUAL MENTAL MODEL:
--
--   LEFT TABLE          RIGHT TABLE
--   ┌─────────┐         ┌─────────┐
--   │ Employee│         │  Dept   │
--   │─────────│         │─────────│
--   │ Alice D01│────────│ D01 CSE │
--   │ Bob   D01│────────│         │
--   │ Charlie D02│──────│ D02 EEE │
--   │ David D03│────────│ D03 BBA │
--   │ Eve   D01│────────│         │
--   └─────────┘         │ D04 LAW │ ← no matching employee
--                        └─────────┘
--
-- INNER JOIN: Only rows that have a match on BOTH sides
-- LEFT JOIN:  ALL from left + matches from right (NULL if no match)
-- RIGHT JOIN: ALL from right + matches from left (NULL if no match)
-- FULL OUTER: ALL from both (NULL where no match on either side)
-- CROSS JOIN: Every row × every row (Cartesian product)
-- ═══════════════════════════════════════════════════════════
```

```sql name=joins_all.sql
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
```

### ⚠️ Join Confusions

| Confusion | Explanation |
|---|---|
| `JOIN` vs `INNER JOIN` | Same thing. `JOIN` alone defaults to `INNER JOIN`. |
| `ON` vs `WHERE` in joins | `ON` specifies the join condition. `WHERE` filters the result. For INNER JOIN they're equivalent, but for LEFT/RIGHT joins, putting a condition in `ON` vs `WHERE` gives DIFFERENT results. |
| Which table is "left"? | The table that appears FIRST (before `LEFT JOIN`). |
| `NATURAL JOIN` surprises | It matches ALL same-named columns. If both tables have an `id` column AND a `dept_id` column, it joins on BOTH — probably not what you want. |

### Aggregate Functions

```sql name=aggregates.sql
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
```

### GROUP BY — Grouping Data

```sql name=group_by.sql
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
```

### HAVING — Filtering Groups

```sql name=having.sql
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
```

---

## Part 6: Views, Strings, Dates, Sets, and DCL (Lab VI)

### String Functions

```sql name=string_functions.sql
-- ═══════════════════════════════════════
-- CASE CONVERSION
-- ═══════════════════════════════════════
SELECT UPPER('hello world');    -- 'HELLO WORLD'
SELECT LOWER('HELLO WORLD');    -- 'hello world'
SELECT INITCAP('hello world'); -- 'Hello World'  (capitalizes first letter of each word)

-- ═══════════════════════════════════════
-- TRIM — Remove unwanted characters from edges
-- ═══════════════════════════════════════
SELECT TRIM('  hello  ');                     -- 'hello'        (removes spaces from both sides)
SELECT TRIM(LEADING ' ' FROM '  hello  ');    -- 'hello  '      (only left side)
SELECT TRIM(TRAILING ' ' FROM '  hello  ');   -- '  hello'      (only right side)
SELECT TRIM(BOTH '#' FROM '##hello##');       -- 'hello'        (removes specific character)

-- ⚠️ TRIM only removes from the EDGES, not from the middle
-- TRIM('##he##llo##') → 'he##llo'  (middle ## stays)

-- ═══════════════════════════════════════
-- POSITION — Find where a character/string is located
-- ═══════════════════════════════════════
SELECT POSITION('@' IN 'alice@uni.edu');  -- 6  (1-based index)
-- Returns 0 if not found

-- ═══════════════════════════════════════
-- SUBSTR / SUBSTRING — Extract part of a string
-- ═══════════════════════════════════════
SELECT SUBSTR('Hello World', 7);      -- 'World'     (from position 7 to end)
SELECT SUBSTR('Hello World', 1, 5);   -- 'Hello'     (from position 1, take 5 chars)

-- Practical: Extract domain from email
SELECT SUBSTR('alice@uni.edu', POSITION('@' IN 'alice@uni.edu') + 1);
-- → 'uni.edu'

-- ═══════════════════════════════════════
-- REPLACE — Substitute text
-- ═══════════════════════════════════════
SELECT REPLACE('User_Login_Success', '_', ' ');
-- → 'User Login Success'

-- ═══════════════════════════════════════
-- LENGTH — Count characters
-- ═══════════════════════════════════════
SELECT LENGTH('Hello');  -- 5

-- ═══════════════════════════════════════
-- CONCAT / || — Join strings together
-- ═══════════════════════════════════════
SELECT CONCAT('Hello', ' ', 'World');    -- 'Hello World'
SELECT 'Hello' || ' ' || 'World';       -- 'Hello World' (PostgreSQL style)
```

### Date / Time Functions

```sql name=date_functions.sql
-- ═══════════════════════════════════════
-- CURRENT DATE AND TIME
-- ═══════════════════════════════════════
SELECT CURRENT_DATE;       -- 2025-01-01 (just the date)
SELECT CURRENT_TIMESTAMP;  -- 2025-01-01 14:30:00 (date + time)
SELECT NOW();              -- same as CURRENT_TIMESTAMP

-- ═══════════════════════════════════════
-- AGE — Calculate difference between dates
-- ═══════════════════════════════════════
SELECT AGE('2025-01-01', '2020-06-15');
-- Result: '4 years 6 mons 16 days'

-- With a table:
SELECT full_name, AGE(CURRENT_DATE, joining_date) AS tenure
FROM AcademicStaff;

-- ═══════════════════════════════════════
-- EXTRACT — Pull out parts of a date
-- ═══════════════════════════════════════
SELECT EXTRACT(YEAR    FROM DATE '2025-03-15');  -- 2025
SELECT EXTRACT(MONTH   FROM DATE '2025-03-15');  -- 3
SELECT EXTRACT(DAY     FROM DATE '2025-03-15');  -- 15
SELECT EXTRACT(QUARTER FROM DATE '2025-03-15');  -- 1 (Jan-Mar = Q1)
SELECT EXTRACT(DOW     FROM DATE '2025-03-15');  -- 6 (0=Sun, 6=Sat)

-- ⚠️ EXTRACT returns a NUMERIC value, not text
-- EXTRACT(MONTH FROM ...) returns 3, not 'March'

-- ═══════════════════════════════════════
-- DATE ARITHMETIC
-- ═══════════════════════════════════════
SELECT DATE '2025-01-01' + INTERVAL '3 months';    -- 2025-04-01
SELECT DATE '2025-01-01' - INTERVAL '10 days';     -- 2024-12-22
SELECT DATE '2025-12-31' - DATE '2025-01-01';      -- 364 (integer days)
```

### Set Operators

```sql name=set_operators.sql
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
```

### Views

```sql name=views.sql
-- A VIEW is a saved SELECT query. It acts like a virtual table.
-- It stores NO data — it just runs the query every time you access it.

-- ═══════════════════════════════════════
-- STANDARD (REGULAR) VIEW
-- ═══════════════════════════════════════
CREATE VIEW View_PublicDirectory AS
SELECT INITCAP(full_name) AS display_name, email_addr
FROM AcademicStaff;

-- Now you can use it like a table:
SELECT * FROM View_PublicDirectory;
SELECT * FROM View_PublicDirectory WHERE email_addr LIKE '%edu';

-- Drop a view:
DROP VIEW View_PublicDirectory;
DROP VIEW IF EXISTS View_PublicDirectory;

-- ═══════════════════════════════════════
-- VIEW WITH CHECK OPTION
-- Makes the view "updatable" but enforces its WHERE condition
-- ═══════════════════════════════════════
CREATE OR REPLACE VIEW View_Edu_Staff AS
SELECT id, full_name, email_addr
FROM AcademicStaff
WHERE email_addr LIKE '%edu'
WITH CHECK OPTION;

-- This succeeds (email ends in 'edu' — passes the check):
INSERT INTO View_Edu_Staff (full_name, email_addr)
VALUES ('John Doe', 'john.d@university.edu');

-- This FAILS (email is gmail.com — would NOT appear in the view):
INSERT INTO View_Edu_Staff (full_name, email_addr)
VALUES ('Jane Doe', 'jane.d@gmail.com');
-- ERROR: new row violates check option for view "view_edu_staff"

-- ⚠️ WITHOUT "WITH CHECK OPTION", the gmail insert would succeed
-- but the row would be invisible through the view (confusing!)
-- WITH CHECK OPTION prevents this confusion.

-- ═══════════════════════════════════════
-- MATERIALIZED VIEW
-- Unlike regular views, this STORES data physically on disk.
-- Faster to query, but data can become stale.
-- ═══════════════════════════════════════
CREATE MATERIALIZED VIEW MatView_StaffAnalysis AS
SELECT EXTRACT(YEAR FROM joining_date) AS year, COUNT(*) AS total_recruits
FROM AcademicStaff
GROUP BY EXTRACT(YEAR FROM joining_date);

-- Query it (fast — reads stored data):
SELECT * FROM MatView_StaffAnalysis;

-- After inserting new staff, the materialized view is STALE.
-- You must manually refresh:
REFRESH MATERIALIZED VIEW MatView_StaffAnalysis;

-- ⚠️ KEY DIFFERENCES:
-- Regular View:       No stored data, always fresh, can be slower
-- Materialized View:  Stored data, can be stale, fast reads, needs REFRESH
```

### DCL — Roles and Permissions

```sql name=dcl.sql
-- DCL controls WHO can do WHAT in the database.

-- ═══════════════════════════════════════
-- CREATING ROLES (run as superuser/postgres)
-- ═══════════════════════════════════════
-- A ROLE without LOGIN is a "group role" — used to bundle permissions
CREATE ROLE role_readonly NOLOGIN;
-- A ROLE with LOGIN (or CREATE USER) is a "user" — can actually connect
CREATE USER user_teacher WITH PASSWORD 'pass123';
-- CREATE USER is just shorthand for: CREATE ROLE ... LOGIN

-- ═══════════════════════════════════════
-- GRANTING PERMISSIONS
-- ═══════════════════════════════════════
-- Grant on tables:
GRANT SELECT ON Department TO role_readonly;
GRANT INSERT, UPDATE ON Employee TO role_readonly;
GRANT ALL PRIVILEGES ON Employee TO role_readonly;  -- SELECT, INSERT, UPDATE, DELETE

-- Grant on views:
GRANT SELECT ON View_PublicDirectory TO role_readonly;

-- Grant a role TO a user (inheritance):
GRANT role_readonly TO user_teacher;
-- Now user_teacher has all permissions that role_readonly has

-- Column-level grants:
GRANT SELECT (emp_id, name) ON Employee TO role_readonly;
-- Can only see emp_id and name columns, NOT salary

-- ═══════════════════════════════════════
-- REVOKING PERMISSIONS
-- ═══════════════════════════════════════
REVOKE INSERT ON Employee FROM role_readonly;
REVOKE role_readonly FROM user_teacher;

-- ═══════════════════════════════════════
-- TESTING PERMISSIONS (Impersonation)
-- ═══════════════════════════════════════
SET ROLE user_teacher;        -- Act as user_teacher
SELECT * FROM Department;     -- Will this work? (depends on grants)
RESET ROLE;                   -- Go back to original role

-- ⚠️ COMMON CONFUSIONS:
-- GRANT ... TO role   → gives permissions
-- REVOKE ... FROM role → takes permissions away
-- GRANT role TO user  → makes user a member of that role
-- NOLOGIN role cannot connect to database — it's just a permission container
```

---

## Part 7: PL/pgSQL Anonymous Blocks (Lab IX)

### What Is PL/pgSQL?

SQL is **declarative** — you say WHAT you want.
PL/pgSQL is **procedural** — you say HOW to do it, step by step, with variables, loops, and conditions.

### Anonymous Block Structure

```sql name=plpgsql_structure.sql
-- An anonymous block runs immediately and is NOT saved.
-- It uses the DO statement.

DO $$
DECLARE
    -- Declare variables here
    -- variable_name  DATA_TYPE  [:= initial_value];
BEGIN
    -- Your code here
    -- SQL statements, assignments, control flow
EXCEPTION
    -- Optional: handle errors
    WHEN others THEN
        RAISE NOTICE 'An error occurred: %', SQLERRM;
END $$;

-- ⚠️ CRITICAL THINGS:
-- 1. $$ are "dollar quotes" — they wrap the block body (instead of single quotes)
--    This avoids escaping issues with single quotes inside the block.
-- 2. The block ends with "END $$;" — note the semicolon AFTER $$
-- 3. Every statement inside the block needs a semicolon too.
-- 4. DECLARE and EXCEPTION sections are optional.
--    Minimum valid block:
DO $$ BEGIN RAISE NOTICE 'Hello!'; END $$;
```

### Variables

```sql name=plpgsql_variables.sql
DO $$
DECLARE
    -- Basic variable declarations
    v_name      VARCHAR(50) := 'Alice';        -- initialized
    v_age       INT;                            -- uninitialized (starts as NULL)
    v_salary    NUMERIC(10,2) := 50000.00;
    v_is_active BOOLEAN := TRUE;
    v_pi        CONSTANT NUMERIC := 3.14159;   -- CONSTANT: cannot be changed

    -- %TYPE: copies the data type from a table column
    -- Useful when you don't want to guess the type
    v_emp_salary employees.salary%TYPE;
    -- v_emp_salary will have the same type as employees.salary

    -- %ROWTYPE: creates a variable that can hold an entire row
    v_emp_row   employees%ROWTYPE;
BEGIN
    -- Assignment uses := (not = which is comparison)
    v_age := 25;
    v_salary := v_salary * 1.10;  -- 10% raise

    -- Output using RAISE NOTICE
    -- % is a placeholder that gets replaced by the value after the comma
    RAISE NOTICE 'Name: %, Age: %, Salary: %', v_name, v_age, v_salary;

    -- ⚠️ COMMON MISTAKE: Using = instead of :=
    -- v_age = 25;   ← This is a COMPARISON (returns boolean), not assignment!
    -- v_age := 25;  ← This is the CORRECT assignment operator

    -- ⚠️ COMMON MISTAKE: Forgetting to declare variables
    -- Using v_undeclared := 10; without DECLARE → ERROR

    -- ⚠️ COMMON MISTAKE: Trying to modify a CONSTANT
    -- v_pi := 3.14;  ← ERROR: "v_pi" is declared CONSTANT
END $$;
```

### SELECT INTO — Getting Data from Tables

```sql name=plpgsql_select_into.sql
-- To use table data inside a block, you must SELECT ... INTO variable(s)

DO $$
DECLARE
    v_emp_name TEXT;
    v_emp_salary NUMERIC;
BEGIN
    -- Single row query → INTO single variables
    SELECT first_name || ' ' || last_name, salary
    INTO v_emp_name, v_emp_salary
    FROM employees
    WHERE employee_id = 1;

    RAISE NOTICE 'Employee: % earns %', v_emp_name, v_emp_salary;

    -- ⚠️ WARNING: The query MUST return exactly ONE row!
    -- If it returns 0 rows → variables become NULL (no error by default)
    -- If it returns more than 1 row → ERROR!

    -- To handle "not found":
    IF NOT FOUND THEN
        RAISE NOTICE 'No employee found!';
    END IF;
END $$;

-- Using INTO with a RECORD type:
DO $$
DECLARE
    r RECORD;
BEGIN
    SELECT * INTO r
    FROM employees
    WHERE employee_id = 1;

    RAISE NOTICE 'Name: %, Dept: %', r.first_name, r.department;
    -- Access fields with dot notation: r.column_name
END $$;

-- ⚠️ SELECT INTO in PL/pgSQL vs SQL:
-- In PL/pgSQL:  SELECT name INTO v_name FROM employees;  → stores in variable
-- In plain SQL:  SELECT name INTO new_table FROM employees;  → creates a new TABLE
-- Different meanings! In a DO block, it's always the PL/pgSQL meaning.
```

### Control Structures

```sql name=plpgsql_control.sql
-- ═══════════════════════════════════════
-- IF / ELSIF / ELSE
-- ═══════════════════════════════════════
DO $$
DECLARE
    v_score INT := 75;
BEGIN
    IF v_score >= 90 THEN
        RAISE NOTICE 'Grade: A';
    ELSIF v_score >= 80 THEN      -- Note: ELSIF not ELSEIF
        RAISE NOTICE 'Grade: B';
    ELSIF v_score >= 70 THEN
        RAISE NOTICE 'Grade: C';
    ELSE
        RAISE NOTICE 'Grade: F';
    END IF;                        -- Must end with END IF (two words!)
END $$;

-- ⚠️ It's ELSIF in PostgreSQL (not ELSEIF, not ELSE IF)
-- ⚠️ END IF has a space (not ENDIF)


-- ═══════════════════════════════════════
-- CASE Statement (two forms)
-- ═══════════════════════════════════════

-- Form 1: Simple CASE (comparing one expression)
DO $$
DECLARE
    v_dept VARCHAR := 'IT';
    v_budget NUMERIC;
BEGIN
    CASE v_dept
        WHEN 'IT'         THEN v_budget := 100000;
        WHEN 'HR'         THEN v_budget := 80000;
        WHEN 'Management' THEN v_budget := 150000;
        ELSE                   v_budget := 50000;
    END CASE;
    RAISE NOTICE 'Budget for %: %', v_dept, v_budget;
END $$;

-- Form 2: Searched CASE (each WHEN has its own condition)
DO $$
DECLARE
    v_salary NUMERIC := 55000;
BEGIN
    CASE
        WHEN v_salary > 80000 THEN RAISE NOTICE 'Senior';
        WHEN v_salary > 50000 THEN RAISE NOTICE 'Mid-level';
        ELSE                       RAISE NOTICE 'Junior';
    END CASE;
END $$;
```

### Loops

```sql name=plpgsql_loops.sql
-- ═══════════════════════════════════════
-- WHILE LOOP
-- ═══════════════════════════════════════
DO $$
DECLARE
    v_counter INT := 1;
BEGIN
    WHILE v_counter <= 5 LOOP
        RAISE NOTICE 'Counter: %', v_counter;
        v_counter := v_counter + 1;
    END LOOP;
END $$;
-- Output: Counter: 1, Counter: 2, ... Counter: 5


-- ═══════════════════════════════════════
-- FOR LOOP (integer range)
-- ═══════════════════════════════════════
DO $$
BEGIN
    FOR i IN 1..5 LOOP
        RAISE NOTICE 'i = %', i;
    END LOOP;

    -- Reverse:
    FOR i IN REVERSE 5..1 LOOP
        RAISE NOTICE 'Countdown: %', i;
    END LOOP;

    -- With step:
    FOR i IN 1..10 BY 2 LOOP     -- 1, 3, 5, 7, 9
        RAISE NOTICE 'Odd: %', i;
    END LOOP;
END $$;
-- ⚠️ Note: "i" does NOT need to be declared in the DECLARE section!
-- FOR loop variables are implicitly declared.


-- ═══════════════════════════════════════
-- FOR LOOP (iterating over query results) — MOST USEFUL
-- ═══════════════════════════════════════
DO $$
DECLARE
    r RECORD;   -- RECORD can hold any row structure
BEGIN
    FOR r IN
        SELECT first_name, salary
        FROM employees
        WHERE department = 'IT'
        ORDER BY salary DESC
    LOOP
        RAISE NOTICE 'Name: %, Salary: %', r.first_name, r.salary;
    END LOOP;
END $$;
-- This processes each row one by one.
-- r.first_name and r.salary access the columns.

-- ⚠️ The query inside FOR...IN does NOT need INTO.
-- INTO is only for single-row queries outside of FOR loops.


-- ═══════════════════════════════════════
-- SIMPLE LOOP (with EXIT)
-- ═══════════════════════════════════════
DO $$
DECLARE
    v_counter INT := 0;
BEGIN
    LOOP
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 5;  -- Break out of the loop
        RAISE NOTICE 'Value: %', v_counter;
    END LOOP;
END $$;
-- CONTINUE WHEN skips to next iteration:
-- CONTINUE WHEN v_counter = 3;  → skips printing when counter is 3
```

### CTE Inside a Block

```sql name=plpgsql_cte.sql
-- CTEs (WITH ... AS) CANNOT start a DO block directly.
-- But they CAN be used inside a SQL statement within the block.

-- ⚠️ WRONG:
-- DO $$ BEGIN
--     WITH avg_data AS (SELECT AVG(salary) FROM employees)
--     SELECT * FROM avg_data;      ← bare SELECT not allowed in DO block
-- END $$;

-- ✓ RIGHT (use FOR loop):
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        WITH AvgSal AS (
            SELECT AVG(salary) AS val FROM employees
        )
        SELECT e.first_name, e.salary, a.val AS average
        FROM employees e, AvgSal a
        WHERE e.salary > a.val
    LOOP
        RAISE NOTICE '% earns % (Avg: %)',
            r.first_name, r.salary, ROUND(r.average, 2);
    END LOOP;
END $$;
```

---

## Part 8: Functions & Procedures — DEEP DIVE (Lab X)

This is the most important section for your exam. Let's go very deep.

### The Big Picture: Anonymous vs Named Blocks

```text
┌──────────────────────────────────────────────────────────────────────┐
│                     PL/pgSQL Code Blocks                            │
├──────────────────────┬───────────────────────────────────────────────┤
│  Anonymous Block     │  Named Block (Subprogram)                    │
│  (DO $$ ... $$)      │  ┌─────────────┬─────────────────────┐       │
│                      │  │  FUNCTION   │  PROCEDURE          │       │
│  • Runs immediately  │  │             │                     │       │
│  • Not saved in DB   │  │  • RETURNS  │  • No RETURN value  │       │
│  • Cannot be called  │  │    a value  │  • Called via CALL   │       │
│    again             │  │  • Called   │  • CAN use COMMIT/  │       │
│                      │  │    via      │    ROLLBACK          │       │
│                      │  │    SELECT   │                     │       │
│                      │  │  • CANNOT   │                     │       │
│                      │  │    COMMIT/  │                     │       │
│                      │  │    ROLLBACK │                     │       │
│                      │  └─────────────┴─────────────────────┘       │
└──────────────────────┴───────────────────────────────────────────────┘
```

### Function Syntax — Complete Template

```sql name=function_template.sql
-- ═══════════════════════════════════════════════════════════════
-- FUNCTION TEMPLATE
-- ═══════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION function_name(
    -- Parameters (all default to IN mode)
    param1  DATA_TYPE,
    param2  DATA_TYPE DEFAULT default_value   -- optional default
)
RETURNS return_type   -- What the function gives back
AS $$
DECLARE
    -- Local variables
    v_result return_type;
BEGIN
    -- Your logic here
    -- ...
    RETURN v_result;   -- MUST return something matching RETURNS type
END;
$$ LANGUAGE plpgsql;

-- To call a function:
SELECT function_name(arg1, arg2);

-- To drop a function:
DROP FUNCTION function_name(DATA_TYPE, DATA_TYPE);
-- ⚠️ You must include parameter types because PostgreSQL allows
-- overloading (multiple functions with same name, different params)

-- CREATE OR REPLACE:
-- If the function already exists, it replaces it.
-- If it doesn't exist, it creates it.
-- ⚠️ You can NOT change the return type with REPLACE — you must DROP first.
```

### Function Type 1: Scalar Function (Returns One Value)

```sql name=function_scalar.sql
-- A scalar function returns a SINGLE value (one number, one string, etc.)

-- ═══════════════════════════════════════
-- Example 1: Simple calculation
-- ═══════════════════════════════════════
CREATE OR REPLACE FUNCTION calculate_annual_compensation(p_emp_id INT)
RETURNS NUMERIC AS $$
DECLARE
    v_monthly_salary NUMERIC;
    v_annual_comp    NUMERIC;
BEGIN
    -- Get the employee's monthly salary
    SELECT salary INTO v_monthly_salary
    FROM employees WHERE employee_id = p_emp_id;

    -- Check if employee exists
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee with ID % not found', p_emp_id;
    END IF;

    -- Calculate: 12 months salary + 50% bonus
    v_annual_comp := (v_monthly_salary * 12) + (v_monthly_salary * 0.5);

    RETURN v_annual_comp;
END;
$$ LANGUAGE plpgsql;

-- How to call it:
SELECT calculate_annual_compensation(1);
-- Returns: 312500.00  (if salary is 25000)

-- You can use it in queries:
SELECT first_name, salary, calculate_annual_compensation(employee_id) AS annual
FROM employees
WHERE employee_id <= 4;


-- ═══════════════════════════════════════
-- Example 2: String function
-- ═══════════════════════════════════════
CREATE OR REPLACE FUNCTION format_employee_name(p_emp_id INT)
RETURNS TEXT AS $$
DECLARE
    v_first VARCHAR;
    v_last  VARCHAR;
BEGIN
    SELECT first_name, last_name INTO v_first, v_last
    FROM employees WHERE employee_id = p_emp_id;

    RETURN UPPER(v_last) || ', ' || INITCAP(v_first);
    -- Returns something like: "DIRECTOR, Alice"
END;
$$ LANGUAGE plpgsql;

SELECT format_employee_name(1);


-- ═══════════════════════════════════════
-- Example 3: Boolean function
-- ═══════════════════════════════════════
CREATE OR REPLACE FUNCTION is_high_earner(p_emp_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    v_salary NUMERIC;
    v_avg    NUMERIC;
BEGIN
    SELECT salary INTO v_salary FROM employees WHERE employee_id = p_emp_id;
    SELECT AVG(salary) INTO v_avg FROM employees;

    RETURN v_salary > v_avg;
END;
$$ LANGUAGE plpgsql;

-- Use in WHERE clause:
SELECT first_name, salary
FROM employees
WHERE is_high_earner(employee_id) = TRUE;
```

### Function Type 2: Table-Valued Function (Returns Multiple Rows)

```sql name=function_table.sql
-- Returns a result set (like a virtual table)
-- Uses RETURNS TABLE(...) and RETURN QUERY

-- ═══════════════════════════════════════
-- Example 1: Get employees by department
-- ═══════════════════════════════════════
CREATE OR REPLACE FUNCTION get_dept_employees(p_dept VARCHAR)
RETURNS TABLE(
    emp_name   TEXT,
    emp_salary NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT first_name || ' ' || last_name, salary
    FROM employees
    WHERE department = p_dept
    ORDER BY salary DESC;
END;
$$ LANGUAGE plpgsql;

-- Call it like a table (use FROM):
SELECT * FROM get_dept_employees('IT');

-- ⚠️ IMPORTANT DIFFERENCES:
-- Scalar function:  SELECT my_func(1);            ← in SELECT list
-- Table function:   SELECT * FROM my_func('IT');   ← in FROM clause

-- ⚠️ COLUMN NAMES in RETURNS TABLE must NOT conflict with table columns.
-- If your table has "name" and your RETURNS TABLE also has "name",
-- PostgreSQL gets confused. Use different names like "emp_name".


-- ═══════════════════════════════════════
-- Example 2: Search with multiple criteria
-- ═══════════════════════════════════════
CREATE OR REPLACE FUNCTION search_employees(
    p_min_salary NUMERIC DEFAULT 0,
    p_dept       VARCHAR DEFAULT NULL
)
RETURNS TABLE(
    emp_id     INT,
    emp_name   TEXT,
    emp_salary NUMERIC,
    emp_dept   VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT employee_id, first_name || ' ' || last_name, salary, department
    FROM employees
    WHERE salary >= p_min_salary
      AND (p_dept IS NULL OR department = p_dept)
    ORDER BY salary DESC;
END;
$$ LANGUAGE plpgsql;

-- Various calls:
SELECT * FROM search_employees(10000, 'IT');      -- IT dept, salary >= 10000
SELECT * FROM search_employees(5000);              -- all depts, salary >= 5000
SELECT * FROM search_employees();                  -- all employees
```

### Stored Procedures

```sql name=procedures.sql
-- ═══════════════════════════════════════════════════════════════
-- PROCEDURE TEMPLATE
-- ═══════════════════════════════════════════════════════════════
CREATE OR REPLACE PROCEDURE procedure_name(
    param1  IN DATA_TYPE,
    param2  IN DATA_TYPE
)
LANGUAGE plpgsql AS $$
DECLARE
    -- local variables
BEGIN
    -- Your logic here (typically DML: INSERT, UPDATE, DELETE)

    -- Unlike functions, procedures CAN commit/rollback:
    COMMIT;
END;
$$;

-- To call:
CALL procedure_name(arg1, arg2);
-- ⚠️ Procedures are called with CALL, NOT SELECT

-- To drop:
DROP PROCEDURE procedure_name(DATA_TYPE, DATA_TYPE);


-- ═══════════════════════════════════════
-- Example 1: Transfer an employee to another department
-- ═══════════════════════════════════════
CREATE OR REPLACE PROCEDURE transfer_employee(
    p_emp_id   INT,
    p_new_dept VARCHAR,
    p_raise    NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE employees
    SET department = p_new_dept, salary = salary + p_raise
    WHERE employee_id = p_emp_id;

    -- Check if the update affected any rows
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee ID % does not exist!', p_emp_id;
    END IF;

    RAISE NOTICE 'Employee % transferred to % with raise of %',
        p_emp_id, p_new_dept, p_raise;

    COMMIT;
END;
$$;

CALL transfer_employee(2, 'Management', 2000.00);


-- ═══════════════════════════════════════
-- Example 2: Bulk salary increase for a department
-- ═══════════════════════════════════════
CREATE OR REPLACE
