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