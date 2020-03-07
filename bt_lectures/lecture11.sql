--Practice 1
SELECT last_name, salary, department_id
FROM employees
START WITH last_name = 'Mourgos'
CONNECT BY PRIOR employee_id = manager_id;

--Practice 2
SELECT last_name
FROM employees
WHERE last_name <> 'Lorentz'
START WITH last_name = 'Lorentz'
CONNECT BY employee_id = PRIOR manager_id;

--Practice 3
SELECT LPAD(last_name, LENGTH(last_name) + (LEVEL*2) - 2, '_') AS name,
manager_id AS mgr, department_id AS deptno
FROM employees
START WITH last_name = 'Kochhar'
CONNECT BY PRIOR employee_id = manager_id;
