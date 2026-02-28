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