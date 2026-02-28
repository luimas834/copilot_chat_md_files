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