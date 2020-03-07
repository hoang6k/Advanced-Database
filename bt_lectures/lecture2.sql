--Practice 1
CREATE TABLE DEPT
( id NUMBER(7) CONSTRAINT dept_department_id PRIMARY KEY,
name VARCHAR2(25));

--Practice 2
INSERT INTO DEPT
SELECT department_id, department_name
FROM departments;

--Practice 3
CREATE TABLE EMP
(id number(7) CONSTRAINT 
    emp_employee_id PRIMARY KEY,
 last_name VARCHAR2(25),
 first_name VARCHAR2(25),
 dept_id NUMBER(7) CONSTRAINT empdept_fk1
      REFERENCES DEPT(id));

--Practice 4
CREATE TABLE EMPLOYEES2 AS 
SELECT employee_id id, first_name, last_name, salary, department_id dept_id 
FROM employees

--Practice 5
DROP TABLE EMPLOYEES2;

--Practice 6
CREATE INDEX emp_dept_id_idx ON emp (dept_id);


