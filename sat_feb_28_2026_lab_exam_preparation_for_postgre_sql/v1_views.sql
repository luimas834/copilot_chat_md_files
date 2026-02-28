-- A VIEW is a saved SELECT query. It acts like a virtual table.
-- It stores NO data — it just runs the query every time you access it.

-- ═══════════════════════════════════════
-- STANDARD (REGULAR) VIEW
-- ═══════════════════════════════════════
CREATE VIEW View_PublicDirectory AS
SELECT INITCAP(full_name) AS display_name, email_addr
FROM AcademicStaff;

-- Now you can use it like a table:
SELECT * FROM View_PublicDirectory;
SELECT * FROM View_PublicDirectory WHERE email_addr LIKE '%edu';

-- Drop a view:
DROP VIEW View_PublicDirectory;
DROP VIEW IF EXISTS View_PublicDirectory;

-- ═══════════════════════════════════════
-- VIEW WITH CHECK OPTION
-- Makes the view "updatable" but enforces its WHERE condition
-- ═══════════════════════════════════════
CREATE OR REPLACE VIEW View_Edu_Staff AS
SELECT id, full_name, email_addr
FROM AcademicStaff
WHERE email_addr LIKE '%edu'
WITH CHECK OPTION;

-- This succeeds (email ends in 'edu' — passes the check):
INSERT INTO View_Edu_Staff (full_name, email_addr)
VALUES ('John Doe', 'john.d@university.edu');

-- This FAILS (email is gmail.com — would NOT appear in the view):
INSERT INTO View_Edu_Staff (full_name, email_addr)
VALUES ('Jane Doe', 'jane.d@gmail.com');
-- ERROR: new row violates check option for view "view_edu_staff"

-- ⚠️ WITHOUT "WITH CHECK OPTION", the gmail insert would succeed
-- but the row would be invisible through the view (confusing!)
-- WITH CHECK OPTION prevents this confusion.

-- ═══════════════════════════════════════
-- MATERIALIZED VIEW
-- Unlike regular views, this STORES data physically on disk.
-- Faster to query, but data can become stale.
-- ═══════════════════════════════════════
CREATE MATERIALIZED VIEW MatView_StaffAnalysis AS
SELECT EXTRACT(YEAR FROM joining_date) AS year, COUNT(*) AS total_recruits
FROM AcademicStaff
GROUP BY EXTRACT(YEAR FROM joining_date);

-- Query it (fast — reads stored data):
SELECT * FROM MatView_StaffAnalysis;

-- After inserting new staff, the materialized view is STALE.
-- You must manually refresh:
REFRESH MATERIALIZED VIEW MatView_StaffAnalysis;

-- ⚠️ KEY DIFFERENCES:
-- Regular View:       No stored data, always fresh, can be slower
-- Materialized View:  Stored data, can be stale, fast reads, needs REFRESH