--Practice 1
SELECT e.last_name, d.department_id, d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.department_id;

--Practice 2
SELECT e.last_name "Employee", e.employee_id "Emp#", m.last_name "Manager", m.employee_id "Mgr#"
FROM employees e JOIN employees m
ON (e.manager_id = m.employee_id);
----------
SELECT e.last_name "Employee", e.employee_id "Emp#", m.last_name "Manager", m.employee_id "Mgr#"
FROM employees e LEFT OUTER JOIN employees m
ON (e.manager_id = m.employee_id)
ORDER BY "Emp#";

--Practice 3
SELECT e.last_name "Employee", e.hire_date "Emp Hire Date", m.last_name "Manager", m.hire_date "Mgr Hire Date"
FROM employees e JOIN employees m
ON (e.manager_id = m.employee_id)
WHERE e.hire_date < m.hire_date;

--Practice 4
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
AND department_id IN (SELECT department_id FROM employees WHERE last_name LIKE '%u%');

--Practice 5
SELECT last_name, department_id, TO_CHAR(null) department_name
FROM employees
UNION
SELECT TO_CHAR(null) last_name, department_id, department_name
FROM departments;

--Practice 6
SELECT employee_id, job_id
FROM employees
INTERSECT
SELECT employee_id, job_id
FROM job_history;

--Practice 7
SELECT country_id, country_name
FROM countries
MINUS
SELECT DISTINCT l.country_id, c.country_name
    FROM locations l JOIN countries c
    ON l.country_id = c.country_id;
