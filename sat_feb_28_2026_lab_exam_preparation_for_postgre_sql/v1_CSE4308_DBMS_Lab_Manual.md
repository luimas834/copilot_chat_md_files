# CSE 4308 — Database Management Systems Lab
**Prepared by:** Md. Tariquzzaman | **Academic Year:** 2024–2025

---

# Lab I — Simulating Database Using Python

## 1. Objective

The objective of this lab is to understand how basic database operations such as Create, Read, Update, and Delete (CRUD) are implemented internally. This will be achieved by simulating database functionality using a simple text file and Python.

## 2. Dataset Description

A text file named `students.txt` will be used as the data store. Each record in the file represents one student, with fields separated by a pipe (`|`) character.

```
-- Format: ID|Name|Age|Major|GPA
1|Alice Johnson|20|Computer Science|3.8
2|Bob Smith|22|Mathematics|3.5
3|Carol Davis|21|Physics|3.9
4|David Brown|23|Computer Science|3.6
```

## 3. Full Python Solution

```python
# ------------------------------------------------------------
# Basic CRUD System using Text File (students.txt)
# ------------------------------------------------------------
FILENAME = 'students.txt'

# ---------- CREATE ----------
def insert_student(student_id, name, age, major, gpa):
    """Insert a new student record into the file."""
    with open(FILENAME, 'a') as file:
        file.write(f"{student_id}|{name}|{age}|{major}|{gpa}\n")
    print("Record inserted successfully.\n")

# ---------- READ ----------
def read_students():
    """Read and display all records from the file."""
    try:
        with open(FILENAME, 'r') as file:
            print("Student Records:")
            for line in file:
                if not line.startswith('--'):
                    print(line.strip())
            print()
    except FileNotFoundError:
        print("Database file not found.\n")

# ---------- UPDATE ----------
def update_student(student_id, field, new_value):
    """Update a specific student's field."""
    lines = []
    found = False
    with open(FILENAME, 'r') as file:
        for line in file:
            if line.startswith('--'):
                lines.append(line)
                continue
            data = line.strip().split('|')
            if data[0] == str(student_id):
                found = True
                mapping = {'name':1, 'age':2, 'major':3, 'gpa':4}
                if field in mapping:
                    data[mapping[field]] = str(new_value)
                    print(f"Updated {field} for ID {student_id}.")
                line = '|'.join(data) + '\n'
            lines.append(line)
    if not found:
        print("Record not found.")
    else:
        with open(FILENAME, 'w') as file:
            file.writelines(lines)
        print("Record updated successfully.\n")

# ---------- DELETE ----------
def delete_student(student_id):
    """Delete a student record by ID."""
    with open(FILENAME, 'r') as file:
        lines = file.readlines()
    new_lines = [l for l in lines if not (l.split('|')[0] == str(student_id))]
    if len(new_lines) == len(lines):
        print("Record not found.")
    else:
        with open(FILENAME, 'w') as file:
            file.writelines(new_lines)
        print("Record deleted successfully.\n")

# ---------- MENU ----------
def menu():
    while True:
        print("========== Student Database Menu ==========")
        print("1. Insert Student")
        print("2. View All Students")
        print("3. Update Student")
        print("4. Delete Student")
        print("5. Exit")
        choice = input("Enter your choice: ")

        if choice == '1':
            student_id = input("Enter ID: ")
            name = input("Enter Name: ")
            age = input("Enter Age: ")
            major = input("Enter Major: ")
            gpa = input("Enter GPA: ")
            insert_student(student_id, name, age, major, gpa)
        elif choice == '2':
            read_students()
        elif choice == '3':
            student_id = input("Enter ID to update: ")
            field = input("Field to update (name/age/major/gpa): ").lower()
            new_value = input("Enter new value: ")
            update_student(student_id, field, new_value)
        elif choice == '4':
            student_id = input("Enter ID to delete: ")
            delete_student(student_id)
        elif choice == '5':
            print("Exiting program.")
            break
        else:
            print("Invalid choice.\n")

if __name__ == "__main__":
    menu()
```

## 4. Sample Run

```
========== Student Database Menu ==========
1. Insert Student
2. View All Students
3. Update Student
4. Delete Student
5. Exit
Enter your choice: 1
Enter ID: 5
Enter Name: Eve Wilson
Enter Age: 20
Enter Major: Data Science
Enter GPA: 3.9
Record inserted successfully.

Enter your choice: 2
Student Records:
1|Alice Johnson|20|Computer Science|3.8
2|Bob Smith|22|Mathematics|3.5
3|Carol Davis|21|Physics|3.9
4|David Brown|23|Computer Science|3.6
5|Eve Wilson|20|Data Science|3.9
```

---

# Lab II — Lab Workflow

> **Repeat this section for every single lab.**

### Step 1 — Network Setup
Disconnect from the DSL connection via `nmtui`, then connect to the ethernet/wired connection. If no wired connection exists, create one and activate it.

### Step 2 — Download Lab Files
Download the required files from the local server (or Google Classroom).

### Step 3 — Create Your Role and Database

Login to PostgreSQL as `postgres`:

```bash
sudo -i -u postgres psql
```

Then run the following inside the PostgreSQL shell:

```sql
-- Terminate active connections to the database
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'cse4308_12345';

-- Drop database if it exists
DROP DATABASE IF EXISTS cse4308_12345;

-- Drop role if it exists
DROP ROLE IF EXISTS alice;

-- Create new role and database
CREATE ROLE alice LOGIN;
ALTER ROLE alice WITH PASSWORD 'alice123';
CREATE DATABASE cse4308_12345 OWNER alice;
GRANT ALL PRIVILEGES ON DATABASE cse4308_12345 TO alice;
```

This script will: terminate active sessions, drop existing database and role if present, create a new `alice` role with a password, create the `cse4308_12345` database owned by `alice`, and grant all permissions.

Exit PostgreSQL:
```sql
\q
```

### Step 4 — Connect Using Your Newly Created User

```bash
psql -U alice -d cse4308_12345
```

Verify the connection:
```sql
\conninfo
-- Expected: You are connected to database "cse4308_12345" as user "alice".
```

### Step 5 — Load the Lab SQL File *(run outside psql)*

```bash
psql -U alice -d cse4308_12345 -f /home/cse/Downloads/lab3.sql
```

### Step 6 — Reconnect and Verify Tables

```bash
psql -U alice -d cse4308_12345
```

```sql
\dt
SELECT * FROM <table_name>;
```

### Step 7 — Open a Text Editor for Submissions

Save your solutions in the format `fullid_CSE4308_L3_T1.sql`. Example:

```sql
-- Task 1
INSERT INTO students (student_id, name, major, gpa)
VALUES (104, 'David', 'ME', 3.60);

-- Task 2
SELECT name, gpa FROM students WHERE major = 'CSE';
```

---

# Lab III — DDL and DML

## Data Definition Language (DDL)

### 1. Creating a Table

**General Syntax:**

```sql
CREATE TABLE table_name
(
    attribute1 datatype [ NULL | NOT NULL | UNIQUE ],
    attribute2 datatype [ NULL | NOT NULL | UNIQUE ],
    ...
);
```

**Common PostgreSQL Data Types:**
- `INT` — Standard whole numbers
- `VARCHAR(n)` — Variable-length string
- `SERIAL` — Auto-incrementing integer
- `NUMERIC(p,s)` — Exact decimals (e.g., currency)

**Example — The Product Table:**

```sql
CREATE TABLE PRODUCT
(
    PID      SERIAL PRIMARY KEY,       -- Auto-incrementing ID
    PNAME    VARCHAR(50) NOT NULL,     -- Product Name
    PRICE    INT CHECK (PRICE >= 0),   -- Price cannot be negative
    CATEGORY VARCHAR(30)               -- Category (e.g., 'Electronics')
);
```

### 2. Dropping Tables

```sql
DROP TABLE PRODUCT;

-- If other tables reference it, use CASCADE:
DROP TABLE PRODUCT CASCADE;
```

### 3. Altering Tables

```sql
-- Add a new column
ALTER TABLE PRODUCT ADD COLUMN STOCK INT;

-- Remove a column
ALTER TABLE PRODUCT DROP COLUMN STOCK;

-- Change data type
ALTER TABLE PRODUCT ALTER COLUMN PRICE TYPE NUMERIC(10,2);

-- Rename a column
ALTER TABLE PRODUCT RENAME COLUMN PNAME TO PRODUCT_NAME;
```

## Data Manipulation Language (DML)

### 4. Inserting Records

```sql
-- Insert a Mouse (Electronics)
INSERT INTO PRODUCT(PID, PNAME, PRICE, CATEGORY, STOCK)
VALUES (DEFAULT, 'Gaming Mouse', 45, 'Electronics', 100);

-- Insert a Pen (Stationery)
INSERT INTO PRODUCT(PID, PNAME, PRICE, CATEGORY, STOCK)
VALUES (DEFAULT, 'Gel Pen', 5, 'Stationery', 500);
```

### 5. Updating Data

> ⚠️ Always use a `WHERE` clause to avoid updating all rows.

```sql
UPDATE PRODUCT
SET PRICE = 40
WHERE PID = 1;
```

### 6. Deleting Data

```sql
DELETE FROM PRODUCT
WHERE STOCK = 0;
```

### 7. Retrieval (SELECT) and Filtering

```sql
-- Basic filter
SELECT * FROM PRODUCT WHERE PRICE > 50;

-- AND operator (both conditions must be true)
SELECT * FROM PRODUCT
WHERE PRICE > 30 AND CATEGORY = 'Electronics';

-- OR operator (at least one condition must be true)
SELECT * FROM PRODUCT
WHERE CATEGORY = 'Electronics' OR CATEGORY = 'Stationery';
```

---

# Lab IV — Integrity Constraints, Sorting, Subqueries, and Data Filtering

## 1. Sample Database Schema

**Department**

| dept_id (PK) | dept_name | location   |
|--------------|-----------|------------|
| D01          | CSE       | Building A |
| D02          | EEE       | Building B |
| D03          | BBA       | Building C |

**Employee**

| emp_id (PK) | name    | salary | dept_id (FK) |
|-------------|---------|--------|--------------|
| E101        | Alice   | 50000  | D01          |
| E102        | Bob     | 60000  | D01          |
| E103        | Charlie | 55000  | D02          |
| E104        | David   | 45000  | D03          |
| E105        | Eve     | 70000  | D01          |

**Project**

| proj_id (PK) | proj_name      | dept_id (FK) |
|--------------|----------------|--------------|
| P01          | AI Research    | D01          |
| P02          | Circuit Design | D02          |
| P03          | Web Dev        | D01          |

## 2. Integrity Constraints

### 2.1 Primary Key

```sql
CREATE TABLE Department (
    dept_id   VARCHAR(5),
    dept_name VARCHAR(20),
    location  VARCHAR(50),
    CONSTRAINT pk_department PRIMARY KEY (dept_id)
);
```

### 2.2 Foreign Key

```sql
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
```

> **Note:** `ON DELETE CASCADE` ensures that if a Department is deleted, all its Employees are also automatically deleted.

## 3. Data Sorting (ORDER BY)

```sql
-- Single column: descending salary
SELECT name, salary
FROM Employee
ORDER BY salary DESC;

-- Multiple columns: by dept first, then salary within dept
SELECT dept_id, name, salary
FROM Employee
ORDER BY dept_id ASC, salary DESC;
```

## 4. Subqueries

### 4.1 Single-Row Subqueries
Returns one value; used with comparison operators (`=`, `>`, `<`, etc.).

```sql
-- Employees who earn more than the average salary
SELECT name, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);
```

### 4.2 Multiple-Row Subqueries
Returns multiple rows; used with `IN`, `ANY`, or `ALL`.

```sql
-- Employees in departments located in 'Building A'
SELECT name
FROM Employee
WHERE dept_id IN (
    SELECT dept_id FROM Department WHERE location = 'Building A'
);
```

### 4.3 Nested Subqueries

```sql
-- Employees working in the department that runs 'AI Research'
SELECT name
FROM Employee
WHERE dept_id IN (
    SELECT dept_id FROM Project WHERE proj_name = 'AI Research'
);

-- Deep nesting: employees in dept where dept_name = 'CSE' (via Project)
SELECT name
FROM Employee
WHERE dept_id IN (
    SELECT dept_id FROM Project
    WHERE dept_id = (
        SELECT dept_id FROM Department WHERE dept_name = 'CSE'
    )
);
```

### 4.4 Correlated Subqueries
Executes once per row of the outer query.

```sql
-- Employees earning above their own department's average
SELECT e1.name, e1.salary, e1.dept_id
FROM Employee e1
WHERE e1.salary > (
    SELECT AVG(e2.salary) FROM Employee e2
    WHERE e2.dept_id = e1.dept_id
);
```

## 5. Range Operators

```sql
-- BETWEEN
SELECT name, salary FROM Employee
WHERE salary BETWEEN 45000 AND 60000;

-- DISTINCT
SELECT DISTINCT dept_id FROM Employee;
```

## 6. LIMIT

```sql
-- Top 3 highest paid employees
SELECT name, salary
FROM Employee
ORDER BY salary DESC
LIMIT 3;
```

---

# Lab V — Joins, Aggregation, and Grouping

## 1. Sample Database Schema

*(Same Department, Employee, and Project tables as Lab IV.)*

**Database Setup:**

```sql
DROP TABLE IF EXISTS Project CASCADE;
DROP TABLE IF EXISTS Employee CASCADE;
DROP TABLE IF EXISTS Department CASCADE;

CREATE TABLE Department (
    dept_id   VARCHAR(5),
    dept_name VARCHAR(20),
    location  VARCHAR(50),
    CONSTRAINT pk_department PRIMARY KEY (dept_id)
);

CREATE TABLE Employee (
    emp_id  VARCHAR(5),
    name    VARCHAR(30),
    salary  NUMERIC(10, 2),
    dept_id VARCHAR(5),
    CONSTRAINT pk_employee PRIMARY KEY (emp_id),
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Project (
    proj_id   VARCHAR(5),
    proj_name VARCHAR(50),
    dept_id   VARCHAR(5),
    CONSTRAINT pk_project PRIMARY KEY (proj_id),
    CONSTRAINT fk_proj_dept FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Department VALUES ('D01','CSE','Building A'),('D02','EEE','Building B'),('D03','BBA','Building C');
INSERT INTO Employee VALUES ('E101','Alice',50000,'D01'),('E102','Bob',60000,'D01'),('E103','Charlie',55000,'D02'),('E104','David',45000,'D03'),('E105','Eve',70000,'D01');
INSERT INTO Project VALUES ('P01','AI Research','D01'),('P02','Circuit Design','D02'),('P03','Web Dev','D01');
```

## 2. SQL Joins

### 2.1 INNER JOIN
Returns only rows with matching values in both tables.

```sql
SELECT E.name, D.dept_name, D.location
FROM Employee E
INNER JOIN Department D ON E.dept_id = D.dept_id;
```

| name    | dept_name | location   |
|---------|-----------|------------|
| Alice   | CSE       | Building A |
| Bob     | CSE       | Building A |
| Charlie | EEE       | Building B |
| David   | BBA       | Building C |
| Eve     | CSE       | Building A |

### 2.2 LEFT JOIN
Returns all rows from the left table; `NULL` where there's no match on the right.

```sql
SELECT D.dept_id, D.dept_name, P.proj_name
FROM Department D
LEFT JOIN Project P ON D.dept_id = P.dept_id;
```

| dept_id | dept_name | proj_name      |
|---------|-----------|----------------|
| D01     | CSE       | AI Research    |
| D01     | CSE       | Web Dev        |
| D02     | EEE       | Circuit Design |
| D03     | BBA       | NULL           |

### 2.3 RIGHT JOIN
Returns all rows from the right table; `NULL` where there's no match on the left.

```sql
SELECT P.proj_name, D.dept_name
FROM Project P
RIGHT JOIN Department D ON P.dept_id = D.dept_id;
```

### 2.4 FULL OUTER JOIN
Returns all rows when there is a match in either table.

```sql
SELECT E.name, P.proj_name
FROM Employee E
FULL OUTER JOIN Project P ON E.dept_id = P.dept_id;
```

### 2.5 CROSS JOIN
Produces a Cartesian product (every row × every row).

```sql
-- 3 Departments × 3 Projects = 9 rows
SELECT D.dept_name, P.proj_name
FROM Department D
CROSS JOIN Project P;
```

### 2.6 NATURAL JOIN
Implicitly joins on all columns with the same name and data type.

```sql
SELECT name, dept_name, location
FROM Employee
NATURAL JOIN Department;
```

## 3. Aggregate Functions

```sql
SELECT
    COUNT(*) AS total_staff,
    SUM(salary)  AS total_cost,
    AVG(salary)  AS avg_pay,
    MIN(salary)  AS min_pay,
    MAX(salary)  AS max_pay
FROM Employee;
```

| total_staff | total_cost | avg_pay | min_pay | max_pay |
|-------------|------------|---------|---------|---------|
| 5           | 280000     | 56000   | 45000   | 70000   |

## 4. Grouping Data (GROUP BY)

```sql
-- Count employees per department
SELECT dept_id, COUNT(*) AS emp_count
FROM Employee
GROUP BY dept_id;

-- Total salary expense per department name (with JOIN)
SELECT D.dept_name, SUM(E.salary) AS total_salary
FROM Department D
JOIN Employee E ON D.dept_id = E.dept_id
GROUP BY D.dept_name;
```

## 5. Filtering Groups (HAVING)

`HAVING` filters groups **after** aggregation (unlike `WHERE` which filters rows before).

```sql
-- Departments where average salary > 50,000
SELECT dept_id, AVG(salary) AS avg_sal
FROM Employee
GROUP BY dept_id
HAVING AVG(salary) > 50000;
```

| dept_id | avg_sal  |
|---------|----------|
| D01     | 60000.00 |
| D02     | 55000.00 |

---

# Lab VI — Views, Roles, String, Sets and Dates

## 1. Introduction

This lab covers character string processing, temporal date operations, set-theoretic operators, and Data Control Language (DCL) for security management in PostgreSQL.

## 2. Lab Environment Setup

```sql
-- AcademicStaff Table
CREATE TABLE AcademicStaff (
    id          SERIAL PRIMARY KEY,
    full_name   VARCHAR(100),
    email_addr  VARCHAR(100),
    joining_date DATE
);

INSERT INTO AcademicStaff (id, full_name, email_addr, joining_date) VALUES
(101, 'ALICE munn',    'alice.m@university.edu',  '2018-01-15'),
(102, 'bob roberts',   'bob.roberts@gmail.com',   '2019-11-20'),
(103, 'Dr. chaRLie',   'charlie.c@yahoo.com',     '2020-03-10'),
(104, 'DAVID smith',   'david.s@university.edu',  '2021-07-01'),
(105, 'eve O''Connor', 'eve.oconnor@outlook.com', '2022-02-14'),
(106, 'frank LIN',     'frank.lin@protonmail.com','2023-08-30'),
(107, 'Grace HOPPER',  'g.hopper@cs.edu',         '2024-01-05'),
(108, 'helen keller',  'helen.k@org.net',         '2024-09-12');

-- SystemLogs Table
CREATE TABLE SystemLogs (log_id INT PRIMARY KEY, raw_entry TEXT);
INSERT INTO SystemLogs VALUES
(1,' System_Start '),(2,'##CRITICAL_ERROR##'),(3,'User_Login_Success'),
(4,' WARN: Low_Memory '),(5,'__Connection_Timeout__');

-- Course Enrollment Tables
CREATE TABLE Course_Alpha (student_id INT);
CREATE TABLE Course_Beta  (student_id INT);
INSERT INTO Course_Alpha VALUES (1001),(1002),(1003),(1004),(1005);
INSERT INTO Course_Beta  VALUES (1004),(1005),(1006),(1007),(1008);
```

## 3. Scalar Functions: String Processing

### 3.1 Case Conversion

```sql
SELECT
    full_name                AS original,
    UPPER(full_name)         AS upper_case,
    INITCAP(full_name)       AS normalized_case
FROM AcademicStaff WHERE id <= 104;
```

| original    | upper_case  | normalized_case |
|-------------|-------------|-----------------|
| ALICE munn  | ALICE MUNN  | Alice Munn      |
| bob roberts | BOB ROBERTS | Bob Roberts     |
| Dr. chaRLie | DR. CHARLIE | Dr. Charlie     |
| DAVID smith | DAVID SMITH | David Smith     |

### 3.2 String Sanitization (TRIM)

```sql
SELECT
    raw_entry,
    TRIM(raw_entry)               AS standard_trim,
    TRIM(BOTH '#' FROM raw_entry) AS hash_removal
FROM SystemLogs WHERE log_id IN (1, 2, 4);
```

### 3.3 Substring Extraction and Pattern Matching

```sql
-- Extract domain from email
SELECT
    email_addr,
    POSITION('@' IN email_addr) AS at_symbol_index,
    SUBSTR(email_addr, POSITION('@' IN email_addr) + 1) AS domain_only
FROM AcademicStaff WHERE id BETWEEN 101 AND 103;
```

| email_addr             | at_symbol_index | domain_only     |
|------------------------|-----------------|-----------------|
| alice.m@university.edu | 8               | university.edu  |
| bob.roberts@gmail.com  | 12              | gmail.com       |
| charlie.c@yahoo.com    | 10              | yahoo.com       |

### 3.4 Pattern Replacement

```sql
-- Converts User_Login_Success → User Login Success
SELECT raw_entry, REPLACE(raw_entry, '_', ' ') AS clean_text
FROM SystemLogs WHERE log_id = 3;
```

## 4. Temporal Data Management

### 4.1 Intervals and Aging

```sql
-- Calculate tenure (assumed current date: 2025-01-01)
SELECT INITCAP(full_name) AS name, AGE('2025-01-01', joining_date) AS tenure
FROM AcademicStaff WHERE id >= 106;
```

| name         | tenure               |
|--------------|----------------------|
| Frank Lin    | 1 year 4 mons 2 days |
| Grace Hopper | 11 mons 27 days      |
| Helen Keller | 3 mons 20 days       |

### 4.2 Field Extraction (EXTRACT)

```sql
SELECT
    joining_date,
    EXTRACT(YEAR    FROM joining_date) AS join_year,
    EXTRACT(QUARTER FROM joining_date) AS fiscal_qtr
FROM AcademicStaff WHERE id <= 104;
```

## 5. Relational Set Operators

> **Rules:** Queries must return the same number of columns with compatible data types.

### 5.1 UNION vs UNION ALL

```sql
-- UNION: unique students across both courses (8 rows)
SELECT student_id FROM Course_Alpha
UNION
SELECT student_id FROM Course_Beta;

-- UNION ALL: keeps duplicates (faster)
SELECT student_id FROM Course_Alpha
UNION ALL
SELECT student_id FROM Course_Beta;
```

### 5.2 INTERSECT

```sql
-- Students taking BOTH courses
SELECT student_id FROM Course_Alpha
INTERSECT
SELECT student_id FROM Course_Beta;
-- Result: 1004, 1005
```

### 5.3 EXCEPT (Difference)

```sql
-- Students in Alpha who are NOT in Beta
SELECT student_id FROM Course_Alpha
EXCEPT
SELECT student_id FROM Course_Beta;
-- Result: 1001, 1002, 1003
```

## 6. Database Views

### 6.1 Standard Views

```sql
CREATE VIEW View_PublicDirectory AS
SELECT INITCAP(full_name) AS display_name, email_addr
FROM AcademicStaff;

-- Query the view like a table
SELECT * FROM View_PublicDirectory WHERE email_addr LIKE '%edu';
```

### 6.2 Updatable Views with WITH CHECK OPTION

```sql
CREATE OR REPLACE VIEW View_Edu_Staff AS
SELECT id, full_name, email_addr
FROM AcademicStaff
WHERE email_addr LIKE '%edu'
WITH CHECK OPTION;

-- Valid insert (succeeds — email ends in 'edu')
INSERT INTO View_Edu_Staff (full_name, email_addr)
VALUES ('John Doe', 'john.d@university.edu');

-- Invalid insert (fails — gmail.com would disappear from the view)
INSERT INTO View_Edu_Staff (full_name, email_addr)
VALUES ('Jane Doe', 'jane.d@gmail.com');
```

### 6.3 Materialized Views

Unlike standard views, materialized views physically store query results on disk, improving read performance for expensive queries. They require manual refresh when base data changes.

```sql
CREATE MATERIALIZED VIEW MatView_StaffAnalysis AS
SELECT EXTRACT(YEAR FROM joining_date) AS year, COUNT(*) AS total_recruits
FROM AcademicStaff
GROUP BY EXTRACT(YEAR FROM joining_date);

-- Query is instant
SELECT * FROM MatView_StaffAnalysis;

-- Refresh after base table changes
REFRESH MATERIALIZED VIEW MatView_StaffAnalysis;
```

## 7. Data Control Language (DCL)

### 7.1 Creating Security Views

```sql
CREATE OR REPLACE VIEW View_Student_Public AS
SELECT name, cgpa FROM Students;
```

### 7.2 Implementing RBAC (Role-Based Access Control)

**Step 1 — Create Functional Roles:**

```sql
-- Read-Only Role (general staff)
CREATE ROLE role_readonly NOLOGIN;
GRANT SELECT ON Depts TO role_readonly;
GRANT SELECT ON View_Student_Public TO role_readonly;

-- Marks Entry Role (teachers) — inherits from role_readonly
CREATE ROLE role_marks_entry NOLOGIN;
GRANT role_readonly TO role_marks_entry;
GRANT INSERT, UPDATE ON Grades TO role_marks_entry;
```

**Step 2 — Create Users and Assign Roles:**

```sql
CREATE USER user_teacher WITH PASSWORD 'pass123';
CREATE USER user_admin   WITH PASSWORD 'pass123';

GRANT role_marks_entry TO user_teacher;
-- user_teacher inherits: SELECT on Depts, SELECT on View_Student_Public,
-- INSERT/UPDATE on Grades
```

**Step 3 — Verify via Impersonation:**

```sql
SET ROLE user_teacher;
SELECT * FROM Depts;          -- Should succeed
SELECT * FROM Students;       -- Should fail (no permission on raw table)
RESET ROLE;
```

### 7.3 Column-Level Security

```sql
CREATE ROLE auditor NOLOGIN;
-- Allow reading ONLY log_id, hiding raw_entry
GRANT SELECT (log_id) ON SystemLogs TO auditor;
```

### 7.4 Revoking Access

```sql
REVOKE INSERT ON Grades FROM role_marks_entry;
REVOKE role_marks_entry FROM user_teacher;
```

---

# Lab IX — PL/pgSQL: Anonymous Blocks

## 1. Lab Workflow

*(Follow the same PostgreSQL setup steps as described in Lab II. Load the setup file using:)*

```bash
psql -U alice -d cse4308_12345
\i /home/cse/Downloads/setup.sql
```

## 2. Database Schema & Data

Save as `setup.sql` and run with `\i setup.sql`:

```sql
-- 1. CLEANUP
DROP TABLE IF EXISTS employees;

-- 2. CREATE TABLE
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    salary      NUMERIC(10, 2),
    department  VARCHAR(50)
);

-- 3. INSERT KEY PERSONNEL
INSERT INTO employees (first_name, last_name, salary, department) VALUES
('Alice',   'Director',  25000.00, 'Management'),
('Bob',     'Architect', 15000.00, 'IT'),
('Charlie', 'Manager',   12000.00, 'Marketing'),
('Rahim',   'Uddin',      4500.00, 'Operations');

-- 4. BULK INSERT (1000 randomized rows)
INSERT INTO employees (first_name, last_name, salary, department)
SELECT
    (ARRAY['John','Jane','Mike','Sara','Tom','Emily','Chris','Anna','Steve','Laura',
           'Rahim','Karim','Fatima','Ayesha','Rafiq','Jabbar','Nasrin','Monir','Sultana','Kamal'
    ])[floor(random() * 20 + 1)],
    (ARRAY['Smith','Johnson','Williams','Jones','Brown','Davis','Miller','Wilson','Moore','Taylor',
           'Ahmed','Hossain','Khan','Chowdhury','Rahman','Islam','Sarker','Uddin','Ali','Hasan'
    ])[floor(random() * 20 + 1)],
    ROUND((random() * 15000 + 3000)::numeric, 2),
    (ARRAY['IT','HR','Management','Marketing','Sales','Operations'])[floor(random() * 6 + 1)]
FROM generate_series(1, 1000);

-- 5. VERIFY (should return 1004 rows)
SELECT count(*) AS total_employees FROM employees;
```

## 3. Introduction to PL/pgSQL

PL/pgSQL extends SQL with procedural constructs (loops, variables, conditionals). While SQL is declarative, PL/pgSQL lets you specify *how* to achieve a result.

### 3.1 Anonymous Blocks

An anonymous block executes immediately and is not stored in the database. It uses the `DO` statement with dollar-quoting (`$$`).

```sql
DO $$
DECLARE
    -- Variable declarations
BEGIN
    -- Execution logic
EXCEPTION
    -- Error handling
END $$;
```

### 3.2 Outputting Text

```sql
DO $$
BEGIN
    RAISE NOTICE 'Hello from PL/pgSQL!';
END $$;
```

## 4. Variables and Arithmetic

Variables are declared in the `DECLARE` section and assigned with `:=`.

```sql
DO $$
DECLARE
    v_radius NUMERIC        := 5.5;
    v_pi     CONSTANT NUMERIC := 3.14159;
    v_area   NUMERIC;
BEGIN
    v_area := v_pi * (v_radius ^ 2);
    RAISE NOTICE 'Radius: %', v_radius;
    RAISE NOTICE 'Calculated Area: %', v_area;
END $$;
```

## 5. Single Row Queries (SELECT INTO)

To use table data inside a block, store results with `INTO`. The query must return exactly one row.

```sql
DO $$
DECLARE
    v_emp_id   INT  := 1;
    v_full_name TEXT;
    v_salary   NUMERIC;
BEGIN
    SELECT first_name || ' ' || last_name, salary
    INTO v_full_name, v_salary
    FROM employees
    WHERE employee_id = v_emp_id;

    RAISE NOTICE 'Employee: % earns %', v_full_name, v_salary;

    UPDATE employees
    SET salary = salary + 100
    WHERE employee_id = v_emp_id;

    RAISE NOTICE 'Salary updated.';
END $$;
```

## 6. Control Structures

### 6.1 Conditional Logic (IF/ELSE)

```sql
DO $$
DECLARE
    v_salary NUMERIC;
BEGIN
    SELECT salary INTO v_salary FROM employees WHERE first_name = 'Alice';

    IF v_salary > 10000 THEN
        RAISE NOTICE 'Status: Executive Level';
    ELSIF v_salary BETWEEN 5000 AND 10000 THEN
        RAISE NOTICE 'Status: Manager Level';
    ELSE
        RAISE NOTICE 'Status: Entry Level';
    END IF;
END $$;
```

### 6.2 CASE Statement

```sql
DO $$
DECLARE
    v_grade  CHAR(1) := 'B';
    v_result TEXT;
BEGIN
    CASE v_grade
        WHEN 'A' THEN v_result := 'Excellent';
        WHEN 'B' THEN v_result := 'Good';
        ELSE          v_result := 'Average';
    END CASE;
    RAISE NOTICE 'Grade B means: %', v_result;
END $$;
```

## 7. Loops

### 7.1 WHILE Loop

```sql
DO $$
DECLARE
    v_counter INT := 1;
BEGIN
    WHILE v_counter <= 3 LOOP
        RAISE NOTICE 'Count: %', v_counter;
        v_counter := v_counter + 1;
    END LOOP;
END $$;
```

### 7.2 FOR Loop (Iterating Query Results)

```sql
DO $$
DECLARE
    r RECORD;
BEGIN
    RAISE NOTICE '--- IT Department Staff ---';
    FOR r IN
        SELECT first_name, salary FROM employees WHERE department = 'IT'
    LOOP
        RAISE NOTICE 'Name: %, Salary: %', r.first_name, r.salary;
    END LOOP;
END $$;
```

## 8. Using WITH (CTEs) in Blocks

CTEs cannot start a `DO` block, but can be used inside SQL statements within a block.

```sql
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        WITH AvgSal AS (
            SELECT AVG(salary) AS val FROM employees
        )
        SELECT e.first_name, e.salary, a.val AS average
        FROM employees e, AvgSal a
        WHERE e.salary > a.val
    LOOP
        RAISE NOTICE '% earns % (Above Avg: %)',
            r.first_name, r.salary, ROUND(r.average, 2);
    END LOOP;
END $$;
```

---

# Lab X — PL/pgSQL Named Blocks: Functions and Procedures

## 1. Introduction to Named Blocks

Anonymous blocks (`DO $$`) are not stored in the database. **Named blocks (subprograms)** are persistent and reusable. PostgreSQL supports two types: **User-Defined Functions (UDFs)** and **Stored Procedures**.

## 2. User-Defined Functions (UDFs)

A UDF is a named block that returns a specific value. Functions are invoked within SQL expressions and execute within the calling transaction's scope — they **cannot** use `COMMIT` or `ROLLBACK`.

### 2.1 Scalar Function

Returns a single value.

```sql
CREATE OR REPLACE FUNCTION calculate_annual_compensation(p_emp_id INT)
RETURNS NUMERIC AS $$
DECLARE
    v_monthly_salary NUMERIC;
    v_annual_comp    NUMERIC;
BEGIN
    SELECT salary INTO v_monthly_salary
    FROM employees WHERE employee_id = p_emp_id;

    v_annual_comp := (v_monthly_salary * 12) + (v_monthly_salary * 0.5);
    RETURN v_annual_comp;
END;
$$ LANGUAGE plpgsql;

-- Invocation
SELECT calculate_annual_compensation(1);
```

### 2.2 Table-Valued Function

Returns a result set using `RETURNS TABLE` and `RETURN QUERY`.

```sql
CREATE OR REPLACE FUNCTION get_dept_employees(p_dept VARCHAR)
RETURNS TABLE(emp_name VARCHAR, emp_salary NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT name, salary FROM employees WHERE department = p_dept;
END;
$$ LANGUAGE plpgsql;

-- Invocation
SELECT * FROM get_dept_employees('IT');
```

## 3. Stored Procedures

A stored procedure is invoked via `CALL`. Unlike functions, procedures **do not return a value** directly and **can** use `COMMIT` and `ROLLBACK` for transaction control.

```sql
CREATE OR REPLACE PROCEDURE execute_department_transfer(
    p_emp_id   INT,
    p_new_dept VARCHAR,
    p_raise    NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE employees
    SET department = p_new_dept, salary = salary + p_raise
    WHERE employee_id = p_emp_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Identifier % does not exist.', p_emp_id;
    END IF;

    COMMIT;
END;
$$;

-- Invocation
CALL execute_department_transfer(2, 'Management', 2000.00);
```

## 4. Parameter Modes

| Mode   | Description                                                                  |
|--------|------------------------------------------------------------------------------|
| `IN`   | Read-only input from caller (default if omitted)                             |
| `OUT`  | Output variable assigned by the subprogram, returned to the caller           |
| `INOUT`| Initialized by caller, mutated inside the subprogram, returned to caller     |

## 5. Integration of Parameter Modes

### 5.1 Function with Mixed Modes

When a function has `OUT` or `INOUT` parameters, it returns a composite `RECORD`.

```sql
CREATE OR REPLACE FUNCTION evaluate_employee_metrics(
    p_emp_id             IN    INT,
    p_performance_score  INOUT NUMERIC,
    p_eligible_for_promotion OUT BOOLEAN
)
LANGUAGE plpgsql AS $$
DECLARE
    v_current_salary NUMERIC;
BEGIN
    SELECT salary INTO v_current_salary
    FROM employees WHERE employee_id = p_emp_id;

    IF v_current_salary < 10000.00 THEN
        p_performance_score := p_performance_score * 1.10;
    END IF;

    p_eligible_for_promotion := (p_performance_score >= 85.00);
END;
$$;

-- Invocation
SELECT * FROM evaluate_employee_metrics(1, 80.00);
```

### 5.2 Procedure with Mixed Modes

```sql
CREATE OR REPLACE PROCEDURE process_annual_review(
    p_dept_id           IN    VARCHAR,
    p_budget_allocation INOUT NUMERIC,
    p_review_status     OUT   VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
    v_emp_count INT;
BEGIN
    SELECT COUNT(*) INTO v_emp_count
    FROM employees WHERE department = p_dept_id;

    p_budget_allocation := p_budget_allocation - (v_emp_count * 1500.00);

    IF p_budget_allocation > 0 THEN
        p_review_status := 'BUDGET_SURPLUS';
    ELSE
        p_review_status := 'BUDGET_DEFICIT';
    END IF;

    COMMIT;
END;
$$;

-- Invocation
DO $$
DECLARE
    v_dept_budget NUMERIC := 50000.00;
    v_status      VARCHAR;
BEGIN
    CALL process_annual_review('IT', v_dept_budget, v_status);
    RAISE NOTICE 'Remaining Budget: %, Status: %', v_dept_budget, v_status;
END;
$$;
```
