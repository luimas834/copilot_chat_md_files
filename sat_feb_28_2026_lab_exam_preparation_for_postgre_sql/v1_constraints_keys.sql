-- Think of it this way:
-- PRIMARY KEY = The table's unique ID card
-- FOREIGN KEY = A reference/pointer to another table's ID card

-- Parent table (must be created FIRST)
CREATE TABLE Department (
    dept_id   VARCHAR(5),
    dept_name VARCHAR(20),
    location  VARCHAR(50),
    CONSTRAINT pk_department PRIMARY KEY (dept_id)
);

-- Child table (references parent — created SECOND)
CREATE TABLE Employee (
    emp_id  VARCHAR(5),
    name    VARCHAR(30),
    salary  NUMERIC(10, 2),
    dept_id VARCHAR(5),
    CONSTRAINT pk_employee PRIMARY KEY (emp_id),
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- WHAT DO CASCADE OPTIONS MEAN?
--
-- ON DELETE CASCADE:
--   If you delete Department 'D01', ALL employees in D01 are also deleted.
--   Think: "If the parent dies, children die too."
--
-- ON DELETE SET NULL:
--   If you delete Department 'D01', employees' dept_id becomes NULL.
--   Think: "If the parent dies, children become orphans."
--
-- ON DELETE RESTRICT (or NO ACTION — default):
--   If you try to delete Department 'D01' while employees exist, it FAILS.
--   Think: "You can't abandon your children."
--
-- ON UPDATE CASCADE:
--   If you change D01 to D10, all employees' dept_id also changes to D10.

-- ⚠️ COMMON MISTAKES:
-- 1. Creating the child table BEFORE the parent table → ERROR
-- 2. Inserting a child row with a dept_id that doesn't exist in parent → ERROR
-- 3. The FK column and the referenced PK column must have the SAME data type