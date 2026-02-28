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