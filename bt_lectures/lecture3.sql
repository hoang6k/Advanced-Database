--Practice 1
CREATE OR REPLACE VIEW employees_vu
AS
SELECT employee_id, last_name employee, department_id
FROM employees;

--Practice 2
SELECT * FROM employees_vu;

--Practice 3
SELECT employee, department_id
from employees_vu;

--Practice 4
CREATE OR REPLACE VIEW dept50
    (empno, employee, deptno)
AS
SELECT employee_id, last_name, department_id
FROM employees
WHERE department_id = 50
WITH CHECK OPTION CONSTRAINT dept50_ck;
--
SELECT * FROM dept50;
--
UPDATE dept50
SET deptno = 80
WHERE employee = 'Mohammed';

--Practice 5
CREATE SEQUENCE DEPT_ID_SEQ
  INCREMENT BY 10
  START WITH 200
  MAXVALUE 1000;
--DROP SEQUENCE DEPT_ID_SEQ
INSERT INTO dept
VALUES (DEPT_ID_SEQ.NEXTVAL, 'Education');
INSERT INTO dept
VALUES (DEPT_ID_SEQ.NEXTVAL, 'Administration');

--Practice 6
CREATE SYNONYM emp
FOR employees;

