--Practice 1
SELECT DISTINCT job_id FROM EMPLOYEES;

--Practice 2
SELECT last_name || ', ' || job_id AS "Employee and Title"
FROM employees;

--Practice 3
SELECT last_name AS ‘Employee’, salary AS ‘Monthly Salary’
FROM employees
WHERE salary BETWEEN 5000 AND 12000
AND department_id IN (20, 50);

--Practice 4
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;

--Practice 5
SELECT last_name 
FROM employees
WHERE last_name LIKE '%a%'
AND last_name LIKE '%e%';

--Practice 6
SELECT last_name, job_id, salary
FROM employees
WHERE job_id IN ('SA_REP', 'ST_CLERK')
AND salary NOT IN (2500, 3500, 7000);
