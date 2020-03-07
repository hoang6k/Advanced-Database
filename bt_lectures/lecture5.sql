--Practice 1
SELECT INITCAP(last_name) "Name", LENGTH(last_name) "Length"
FROM employees
WHERE last_name LIKE ('J%') OR last_name LIKE('A%') OR last_name LIKE('M%')
ORDER BY last_name;

--Practice 2
SELECT last_name, ROUND((SYSDATE - hire_date)/30) as "MONTHS_WORKED"
FROM employees
ORDER BY "MONTHS_WORKED" DESC;

--Practice 3
SELECT last_name, hire_date,
   TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), 'MONDAY'), 
   '"Monday, the " fmddspth " of " Month ", " YYYY') REVIEW
FROM employees;

--Practice 4
SELECT last_name, NVL2(commission_pct, TO_CHAR(commission_pct), 'No Commision') "COMM"
FROM employees;

--Practice 5
SELECT job_id,
    DECODE(job_id, 
        'AD_PRES', 'A',
        'ST_MAN', 'B',
        'IT_PROG', 'C',
        'SA_REP', 'D',
        'ST_CLERCK', 'E',
        0) "GRADE"
FROM employees;

--Practice 6
SELECT ROUND(MAX(salary)) "Maximum", ROUND(MIN(salary)) "Minimum",
        ROUND (SUM(salary)) "Sum", ROUND (AVG(salary)) "Average"
FROM employees;

--Practice 7
SELECT job_id, ROUND(MAX(salary)) "Maximum", ROUND(MIN(salary)) "Minimum",
        ROUND (SUM(salary)) "Sum", ROUND (AVG(salary)) "Average"
FROM employees
GROUP BY job_id;

--Practice 8
SELECT COUNT(DISTINCT manager_id) "Number of Managers"
FROM employees;

--Practice 9
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) > 6000
ORDER BY MIN(salary) DESC;
