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