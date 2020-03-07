--Practice 1
SELECT e.last_name, d.department_name, e.salary
FROM employees e
JOIN departments d
ON (e.department_id = d.department_id)
WHERE (salary, NVL(commission_pct,0)) IN (SELECT salary, NVL(commission_pct,0)
    FROM employees e
    JOIN departments d
    ON (e.department_id = d.department_id)
    WHERE d.location_id = 1700);

--Practice 2
SELECT last_name ename, salary, dept.department_id deptno, dept.dept_avg_sal
FROM employees outer
JOIN
(SELECT department_id, AVG(salary) dept_avg_sal
FROM employees
GROUP BY department_id) dept
ON (outer.department_id = dept.department_id)
WHERE salary > (SELECT AVG(salary)
  FROM employees
  WHERE department_id = outer. department_id)
ORDER BY dept.dept_avg_sal;

--Practice 3
SELECT last_name
FROM employees outer
WHERE EXISTS (SELECT 'X'
    FROM employees inner
    WHERE inner.department_id = outer.department_id
    AND inner.hire_date > outer.hire_date
    AND inner.salary > outer.salary);

--Practice 4
WITH 
summary AS(
    SELECT d.department_name, SUM(e.salary) AS dept_total
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
    GROUP BY d.department_name)
SELECT department_name, dept_total
FROM summary
WHERE dept_total > (SELECT SUM(dept_total)*1/8
  FROM summary)
ORDER BY dept_total DESC;
