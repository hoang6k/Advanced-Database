--Practice 1
SELECT manager_id,
       job_id,
       SUM(salary)
FROM employees
WHERE manager_id < 120
GROUP BY ROLLUP(manager_id, job_id);

--Practice 2
SELECT manager_id,
       job_id,
       SUM(salary),
       GROUPING(manager_id) GRP_DPT,
       GROUPING(job_id) GRP_JOB
FROM employees
WHERE manager_id < 120
GROUP BY ROLLUP(manager_id, job_id);

--Practice 3
SELECT manager_id,
       job_title,
       SUM(salary)
FROM employees e JOIN jobs j
ON e.job_id = j.job_id
WHERE manager_id < 120
GROUP BY CUBE(manager_id, job_title);

--Practice 4
SELECT department_id,
       manager_id,
       job_id,
       SUM(salary)
FROM employees
GROUP BY GROUPING SETS
    ((department_id, manager_id, job_id),
     (department_id, job_id),
     (manager_id, job_id));

