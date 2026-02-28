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