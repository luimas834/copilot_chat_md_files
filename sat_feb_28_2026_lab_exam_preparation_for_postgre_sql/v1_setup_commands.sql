-- 1. Login as postgres superuser
-- Run this in your TERMINAL (bash), NOT inside psql
sudo -i -u postgres psql

-- 2. Inside psql as postgres, create your role and database
-- COMMON MISTAKE: Forgetting to terminate existing connections first!
-- If someone (or you) is already connected to the DB, DROP will fail.
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'cse4308_12345';

DROP DATABASE IF EXISTS cse4308_12345;
DROP ROLE IF EXISTS alice;

CREATE ROLE alice LOGIN;
ALTER ROLE alice WITH PASSWORD 'alice123';
CREATE DATABASE cse4308_12345 OWNER alice;
GRANT ALL PRIVILEGES ON DATABASE cse4308_12345 TO alice;

-- 3. Exit postgres superuser
\q

-- 4. Reconnect as your user (run in TERMINAL)
-- psql -U alice -d cse4308_12345

-- 5. Load lab file (run in TERMINAL, not inside psql)
-- psql -U alice -d cse4308_12345 -f /home/cse/Downloads/lab3.sql
-- OR if you're already inside psql:
-- \i /home/cse/Downloads/lab3.sql