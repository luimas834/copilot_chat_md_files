-- ═══════════════════════════════════════
-- CURRENT DATE AND TIME
-- ═══════════════════════════════════════
SELECT CURRENT_DATE;       -- 2025-01-01 (just the date)
SELECT CURRENT_TIMESTAMP;  -- 2025-01-01 14:30:00 (date + time)
SELECT NOW();              -- same as CURRENT_TIMESTAMP

-- ═══════════════════════════════════════
-- AGE — Calculate difference between dates
-- ═══════════════════════════════════════
SELECT AGE('2025-01-01', '2020-06-15');
-- Result: '4 years 6 mons 16 days'

-- With a table:
SELECT full_name, AGE(CURRENT_DATE, joining_date) AS tenure
FROM AcademicStaff;

-- ═══════════════════════════════════════
-- EXTRACT — Pull out parts of a date
-- ═══════════════════════════════════════
SELECT EXTRACT(YEAR    FROM DATE '2025-03-15');  -- 2025
SELECT EXTRACT(MONTH   FROM DATE '2025-03-15');  -- 3
SELECT EXTRACT(DAY     FROM DATE '2025-03-15');  -- 15
SELECT EXTRACT(QUARTER FROM DATE '2025-03-15');  -- 1 (Jan-Mar = Q1)
SELECT EXTRACT(DOW     FROM DATE '2025-03-15');  -- 6 (0=Sun, 6=Sat)

-- ⚠️ EXTRACT returns a NUMERIC value, not text
-- EXTRACT(MONTH FROM ...) returns 3, not 'March'

-- ═══════════════════════════════════════
-- DATE ARITHMETIC
-- ═══════════════════════════════════════
SELECT DATE '2025-01-01' + INTERVAL '3 months';    -- 2025-04-01
SELECT DATE '2025-01-01' - INTERVAL '10 days';     -- 2024-12-22
SELECT DATE '2025-12-31' - DATE '2025-01-01';      -- 364 (integer days)