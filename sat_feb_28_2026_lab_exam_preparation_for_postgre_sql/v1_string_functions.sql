-- ═══════════════════════════════════════
-- CASE CONVERSION
-- ═══════════════════════════════════════
SELECT UPPER('hello world');    -- 'HELLO WORLD'
SELECT LOWER('HELLO WORLD');    -- 'hello world'
SELECT INITCAP('hello world'); -- 'Hello World'  (capitalizes first letter of each word)

-- ═══════════════════════════════════════
-- TRIM — Remove unwanted characters from edges
-- ═══════════════════════════════════════
SELECT TRIM('  hello  ');                     -- 'hello'        (removes spaces from both sides)
SELECT TRIM(LEADING ' ' FROM '  hello  ');    -- 'hello  '      (only left side)
SELECT TRIM(TRAILING ' ' FROM '  hello  ');   -- '  hello'      (only right side)
SELECT TRIM(BOTH '#' FROM '##hello##');       -- 'hello'        (removes specific character)

-- ⚠️ TRIM only removes from the EDGES, not from the middle
-- TRIM('##he##llo##') → 'he##llo'  (middle ## stays)

-- ═══════════════════════════════════════
-- POSITION — Find where a character/string is located
-- ═══════════════════════════════════════
SELECT POSITION('@' IN 'alice@uni.edu');  -- 6  (1-based index)
-- Returns 0 if not found

-- ═══════════════════════════════════════
-- SUBSTR / SUBSTRING — Extract part of a string
-- ═══════════════════════════════════════
SELECT SUBSTR('Hello World', 7);      -- 'World'     (from position 7 to end)
SELECT SUBSTR('Hello World', 1, 5);   -- 'Hello'     (from position 1, take 5 chars)

-- Practical: Extract domain from email
SELECT SUBSTR('alice@uni.edu', POSITION('@' IN 'alice@uni.edu') + 1);
-- → 'uni.edu'

-- ═══════════════════════════════════════
-- REPLACE — Substitute text
-- ═══════════════════════════════════════
SELECT REPLACE('User_Login_Success', '_', ' ');
-- → 'User Login Success'

-- ═══════════════════════════════════════
-- LENGTH — Count characters
-- ═══════════════════════════════════════
SELECT LENGTH('Hello');  -- 5

-- ═══════════════════════════════════════
-- CONCAT / || — Join strings together
-- ═══════════════════════════════════════
SELECT CONCAT('Hello', ' ', 'World');    -- 'Hello World'
SELECT 'Hello' || ' ' || 'World';       -- 'Hello World' (PostgreSQL style)