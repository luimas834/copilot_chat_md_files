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