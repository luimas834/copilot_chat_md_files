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