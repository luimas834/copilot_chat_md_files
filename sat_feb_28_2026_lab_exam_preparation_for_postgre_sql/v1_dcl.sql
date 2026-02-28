-- DCL controls WHO can do WHAT in the database.

-- ═══════════════════════════════════════
-- CREATING ROLES (run as superuser/postgres)
-- ═══════════════════════════════════════
-- A ROLE without LOGIN is a "group role" — used to bundle permissions
CREATE ROLE role_readonly NOLOGIN;
-- A ROLE with LOGIN (or CREATE USER) is a "user" — can actually connect
CREATE USER user_teacher WITH PASSWORD 'pass123';
-- CREATE USER is just shorthand for: CREATE ROLE ... LOGIN

-- ═══════════════════════════════════════
-- GRANTING PERMISSIONS
-- ═══════════════════════════════════════
-- Grant on tables:
GRANT SELECT ON Department TO role_readonly;
GRANT INSERT, UPDATE ON Employee TO role_readonly;
GRANT ALL PRIVILEGES ON Employee TO role_readonly;  -- SELECT, INSERT, UPDATE, DELETE

-- Grant on views:
GRANT SELECT ON View_PublicDirectory TO role_readonly;

-- Grant a role TO a user (inheritance):
GRANT role_readonly TO user_teacher;
-- Now user_teacher has all permissions that role_readonly has

-- Column-level grants:
GRANT SELECT (emp_id, name) ON Employee TO role_readonly;
-- Can only see emp_id and name columns, NOT salary

-- ═══════════════════════════════════════
-- REVOKING PERMISSIONS
-- ═══════════════════════════════════════
REVOKE INSERT ON Employee FROM role_readonly;
REVOKE role_readonly FROM user_teacher;

-- ═══════════════════════════════════════
-- TESTING PERMISSIONS (Impersonation)
-- ═══════════════════════════════════════
SET ROLE user_teacher;        -- Act as user_teacher
SELECT * FROM Department;     -- Will this work? (depends on grants)
RESET ROLE;                   -- Go back to original role

-- ⚠️ COMMON CONFUSIONS:
-- GRANT ... TO role   → gives permissions
-- REVOKE ... FROM role → takes permissions away
-- GRANT role TO user  → makes user a member of that role
-- NOLOGIN role cannot connect to database — it's just a permission container