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