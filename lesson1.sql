----------------------------------------------------------
-- EMPTY THE TWO TREES DATABASE IN CASE IT CONTAINS CONTENT
----------------------------------------------------------
DROP TABLE IF EXISTS HR.employees;
DROP SCHEMA IF EXISTS HR;

-- Create the database schemas
CREATE SCHEMA HR;
SET SCHEMA 'HR';
-- On psql:
-- SET search_path TO HR;

-----------------------------------
-- EX1
-----------------------------------
-- Create a table for the Two Trees category data
CREATE TABLE HR.employees (
  employee_id CHAR(5) NOT NULL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(100),
  phone_number VARCHAR(50),
  hire_date DATE,
  job VARCHAR(100),
  Salary INT,
  manager VARCHAR(100),
  department VARCHAR(100)
);

opsschool=# select * from HR.employees;
 employee_id | first_name  |    last_name     |   email    | phone_number | hire_date  | job | salary | manager | department
-------------+-------------+------------------+------------+--------------+------------+-----+--------+---------+------------
 FV418       | Flavorville | 798 Ravinia Road | Des Moines | IA           | 2020-10-15 |     |  25000 |         |
 1           | Flavorville | 798 Ravinia Road | Des Moines | IA           | 2020-10-15 |     |  25000 |         |
(2 rows)

-----------------------------------
-- EX2
-----------------------------------
CREATE SEQUENCE employees_id_seq OWNED BY employees.employee_id;
ALTER TABLE employees ALTER COLUMN employee_id SET DEFAULT nextval('employees_id_seq');

-- Add data to the customers table
INSERT INTO HR.employees VALUES
    (2, 'Flavorville', '798 Ravinia Road', 'Des Moines', 'IA', '2020-10-15', '', 25000, '', '')
;
INSERT INTO HR.employees (first_name) VALUES
   ('Flavorville')
;
INSERT INTO HR.employees (first_name) VALUES
   ('Flavorville')
;
INSERT INTO HR.employees (first_name) VALUES
   ('Flavorville')
;
INSERT INTO HR.employees (first_name) VALUES
   ('Flavorville')
;

opsschool=# select * from HR.employees;
 employee_id | first_name  |    last_name     |   email    | phone_number | hire_date  | job | salary | manager | department
-------------+-------------+------------------+------------+--------------+------------+-----+--------+---------+------------
 FV418       | Flavorville | 798 Ravinia Road | Des Moines | IA           | 2020-10-15 |     |  25000 |         |
 1           | Flavorville | 798 Ravinia Road | Des Moines | IA           | 2020-10-15 |     |  25000 |         |
 2           | Flavorville |                  |            |              |            |     |        |         |
 3           | Flavorville |                  |            |              |            |     |        |         |
 4           | Flavorville |                  |            |              |            |     |        |         |
 5           | Flavorville |                  |            |              |            |     |        |         |

(6 rows)

-----------------------------------
-- EX3
-----------------------------------
-- DELETE FROM employees;
ALTER TABLE employees ADD constraint fk_employees_employee_id FOREIGN KEY (manager) REFERENCES employees (employee_id) ON UPDATE CASCADE ON DELETE CASCADE;
INSERT INTO HR.employees (first_name, last_name, manager) VALUES
    ('Flavorville','vv',20)
;
INSERT 0 1
opsschool=# select * from HR.employees;
 employee_id | first_name  | last_name | email | phone_number | hire_date | job | salary | manager | department
-------------+-------------+-----------+-------+--------------+-----------+-----+--------+---------+------------
 20          | Flavorville | vv        |       |              |           |     |        |         |
 21          | Flavorville | vv        |       |              |           |     |        | 20      |
(2 rows)

-----------------------------------
-- EX4
-----------------------------------
ALTER TABLE employees ALTER COLUMN first_name SET NOT NULL;
ALTER TABLE employees ALTER COLUMN last_name SET NOT NULL;
ALTER TABLE employees ALTER COLUMN phone_number SET DEFAULT '081234567';
ALTER TABLE employees ADD CONSTRAINT salaries_above_30 CHECK (salary > 30000);

opsschool=# INSERT INTO HR.employees (first_name, last_name, salary, manager) VALUES
    ('Flavorville','vv', 25000, 1)
;
ERROR:  null value in column "employee_id" of relation "employees" violates not-null constraint
DETAIL:  Failing row contains (null, Flavorville, vv, null, 081234567, null, null, 25000, 1, null).

opsschool=# select * from HR.employees;
 employee_id | first_name  | last_name | email | phone_number | hire_date | job | salary | manager | department
-------------+-------------+-----------+-------+--------------+-----------+-----+--------+---------+------------
 1           | Flavorville | vv        |       | 081234567   |           |     |  33000 | 1       |
(1 row)
