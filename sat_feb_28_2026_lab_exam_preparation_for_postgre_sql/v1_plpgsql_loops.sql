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