-- PRIMARY KEY: Uniquely identifies each row. Cannot be NULL, cannot repeat.
-- Only ONE primary key per table (but it can be composite — multiple columns).

-- NOT NULL: The column must always have a value.

-- UNIQUE: No two rows can have the same value in this column.
-- Difference from PRIMARY KEY: UNIQUE allows ONE null, PK allows NONE.

-- CHECK: A condition that must be true for every row.
-- CHECK (age >= 18)  → age must be 18 or more
-- CHECK (salary > 0) → salary must be positive

-- DEFAULT: Provides a value when none is given during INSERT.
-- status VARCHAR(10) DEFAULT 'active'

-- FOREIGN KEY: Links to another table's PRIMARY KEY. (Covered in Lab IV)

-- Example combining multiple constraints:
CREATE TABLE example (
    id       SERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    age      INT CHECK (age >= 0 AND age <= 150),
    status   VARCHAR(10) DEFAULT 'active'
);