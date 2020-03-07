/*
--T?o hàm chuy?n ð?i ði?m s? thành ch?
CREATE OR REPLACE FUNCTION QUY_DOI_DIEM(diem_chu VARCHAR)
RETURN NUMBER
AS
BEGIN
    CASE diem_chu
    WHEN '+A' THEN RETURN 4.5;
    WHEN 'A ' THEN RETURN 4.0;
    WHEN 'A-' THEN RETURN 3.5;
    WHEN 'B+' THEN RETURN 3.0;
    WHEN 'B ' THEN RETURN 2.5;
    WHEN 'B-' THEN RETURN 2.0;
    WHEN 'C+' THEN RETURN 1.5;
    WHEN 'C ' THEN RETURN 1.0;
    WHEN 'C-' THEN RETURN 0.5;
    ELSE RETURN NULL;
    END CASE;
END;
/
--T?o hàm tính CPA và GPA
CREATE OR REPLACE FUNCTION CPA
    (st_id VARCHAR, semester VARCHAR, year VARCHAR)
RETURN NUMBER AS cpa NUMBER(3,2);
BEGIN
    IF semester = 'Spring' THEN
    SELECT SUM(x.diem_max*course.credits)/SUM(course.credits) INTO cpa
    FROM (SELECT takes.course_id, MAX(QUY_DOI_DIEM(takes.grade)) AS diem_max
            FROM takes
            WHERE takes.id = st_id
                AND ((takes.semester='Spring' AND takes.year=year)
                    OR takes.year < year)
            GROUP BY takes.course_id) x, course
    WHERE x.course_id = course.course_id;
    ELSE
    SELECT SUM(x.diem_max*course.credits)/SUM(course.credits) INTO cpa
    FROM (SELECT takes.course_id, MAX(QUY_DOI_DIEM(takes.grade)) AS diem_max
            FROM takes
            WHERE takes.id = st_id
                AND takes.year < year
            GROUP BY takes.course_id) x, course
    WHERE x.course_id = course.course_id;
    END IF;
    RETURN cpa;
END;
/
CREATE OR REPLACE FUNCTION GPA
    (st_id VARCHAR, semester VARCHAR, year VARCHAR)
RETURN NUMBER AS gpa NUMBER(3,2);
BEGIN
    IF semester = 'Spring' THEN
    SELECT SUM(QUY_DOI_DIEM(takes.grade)*course.credits)/SUM(course.credits) INTO gpa
    FROM takes, course
    WHERE takes.course_id = course.course_id
        AND takes.id = st_id
        AND takes.semester = 'Spring'
        AND takes.year = year;
    ELSE
    SELECT SUM(QUY_DOI_DIEM(takes.grade)*course.credits)/SUM(course.credits) INTO gpa
    FROM takes, course
    WHERE takes.course_id = course.course_id
        AND takes.id = st_id
        AND takes.semester = 'Fall'
        AND takes.year = year;
    END IF;
    RETURN gpa;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
END;
/
--Hàm tính s? lý?ng tín ch? tích l?y theo t?ng k?
CREATE OR REPLACE FUNCTION TIN_CHI_TICH_LUY_THEO_KI(st_id VARCHAR, semester VARCHAR, year VARCHAR)
RETURN INT AS tctl INT;
BEGIN
    IF semester = 'Spring' THEN
    SELECT SUM(course.credits) INTO tctl
    FROM (SELECT takes.course_id, MAX(QUY_DOI_DIEM(takes.grade)) AS diem_max
            FROM takes
            WHERE takes.id = st_id
                AND ((takes.semester = 'Spring' AND takes.year = year)
                    OR takes.year = year)
            GROUP BY takes.course_id) x, course
    WHERE x.course_id = course.course_id
        AND diem_max >= 1.0;
    ELSE
    SELECT SUM(course.credits) INTO tctl
    FROM (SELECT takes.course_id, MAX(QUY_DOI_DIEM(takes.grade)) AS diem_max
            FROM takes
            WHERE takes.id = st_id
                AND takes.year <= year
            GROUP BY takes.course_id) x, course
    WHERE x.course_id = course.course_id
        AND diem_max >= 1;
    END IF;
    RETURN tctl;
END;
/
--In ra k?t qu? h?c t?p
CREATE OR REPLACE PROCEDURE sp_bai6(st_id VARCHAR)
AS
query VARCHAR(1000) := 'SELECT year, semester, GPA(id, semester, takes.year), CPA(id, semester, takes.year),
                        TIN_CHI_TICH_LUY_THEO_KI(id, semester, takes.year)
                        FROM takes
                        WHERE id = '''||st_id||''' GROUP BY takes.year, semester, id ORDER BY year ASC, semester DESC';
cur SYS_REFCURSOR;
year VARCHAR(15);
semester VARCHAR(15);
gpa NUMBER(3,2);
cpa NUMBER(3,2);
tctl INT;
BEGIN
    OPEN cur FOR query;
    DBMS_OUTPUT.PUT_LINE(query);
    DBMS_OUTPUT.PUT_LINE(rpad('year',8,' ')||rpad('semester',15,' ')||rpad('GPA',8,' ')||rpad('CPA',8,' ')||rpad('TinChiTichLuyTheoKi',20,' '));
    DBMS_OUTPUT.PUT_LINE(rpad('-',140,'-'));
    LOOP
    FETCH cur INTO year, semester, gpa, cpa, tctl;
    EXIT WHEN cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(rpad(year,8,' ')||rpad(semester,15,' ')||rpad(gpa,8,' ')||rpad(cpa,8,' ')||rpad(tctl,10,' '));
    END LOOP;
    CLOSE cur;
END;
    



CREATE OR REPLACE PROCEDURE SP_SHOW_RESULT_STUDENT_BAI6
    (student_id NUMBER, mycursor OUT SYS_REFCURSOR )
IS
BEGIN
    OPEN mycursor FOR
    SELECT t.id, s.name, t.semester, t.year, ROUND(SUM( t.score * c.credits )/SUM(c.credits),2) AS gpa,
        ROUND((SELECT SUM(MAX(t1.score) * c1.credits) / SUM(c1.credits)
                FROM vw_bai1_ScoreToNumber t1, course c1
                WHERE t1.id = student_id
                    AND t1.course_id = c1.course_id
                    AND t1.year <= t.year
                    AND t1.semester <= t.semester
                GROUP BY t1.course_id, c1.credits),2) AS cpa,
        (SELECT SUM(c1.credits)
        FROM vw_bai1_ScoreToNumber t1, course c1
        WHERE t1.id = student_id
            AND t1.course_id = c1.course_id
            AND t1.year <= t.year
            AND t1.semester <= t.semester
        GROUP BY t1.id) total_cred
    FROM student s
    JOIN vw_bai1_ScoreToNumber t ON s.id = t.id
        AND t.id = student_id
    JOIN course c ON c.course_id = t.course_id
    GROUP BY t.id, s.name, t.semester, t.year
    ORDER BY t.year, t.semester DESC;
END;
*/


--Ðánh s? cho k? h?c
CREATE OR REPLACE VIEW vw_bai6_ConvertSemester AS
SELECT id,
    course_id,
    sec_id,
    semester,
    year,
    score,
    CASE
        WHEN semester = 'Fall' THEN CONCAT( year, '2' )
        WHEN semester = 'Spring' THEN CONCAT( year, '1')
    END AS semester_number
FROM vw_bai1_ScoreToNumber;
/
-- T?o view t?ng h?p k?t qu? c?a sinh viên
CREATE OR REPLACE VIEW vw_bai6_ScoreData AS
SELECT hk.id, st.name, hk.course_id, hk.Sec_id, hk.semester, hk.year, hk.score, c.credits, hk.semester_number
FROM vw_bai6_ConvertSemester hk
JOIN course c ON c.course_id = hk.course_id
JOIN student st ON st.id = hk.id;
/
-- T?o hàm tính s? tín ch? tích l?y.
CREATE OR REPLACE FUNCTION func_tctl(student_id NUMBER, semester_max NUMBER)
RETURN FLOAT IS FunctionResult FLOAT;
BEGIN
    SELECT SUM(pn.credits) INTO FunctionResult
    FROM (SELECT th.id, th.name, th.course_id, th.credits, MAX(score) as max_point
        FROM vw_bai6_ScoreData th
        WHERE TO_NUMBER(th.semester_number) <= TO_NUMBER(semester_max)
        GROUP BY th.course_id, th.name, th.credits, th.id) pn
    WHERE pn.id = student_id
    AND pn.max_point >= 1
    GROUP BY pn.id, pn.name;
    RETURN FunctionResult;
END func_tctl;
/
--Hàm tính CPA
CREATE OR REPLACE FUNCTION func_cpa(student_id NUMBER, semester_max NUMBER)
RETURN FLOAT IS FunctionResult FLOAT;
BEGIN
    SELECT ROUND(SUM(pn.max_point*pn.credits)/SUM(pn.credits), 2) INTO FunctionResult
    FROM
        (SELECT th.id, th.name, th.course_id, th.credits, MAX(score) AS max_point
        FROM vw_bai6_ScoreData th
        WHERE TO_NUMBER(th.semester_number) <= TO_NUMBER(semester_max)
        GROUP BY th.course_id, th.name, th.credits, th.id) pn
        WHERE pn.id = student_id
            GROUP BY pn.id, pn.name;
        RETURN (FunctionResult);
END func_cpa;
/
-- T?o th? t?c show k?t qu? h?c t?p c?a h?c sinh theo t?ng k?. 
CREATE OR REPLACE PROCEDURE sp_bai6
    (student_id NUMBER, mycursor OUT SYS_REFCURSOR )
IS
BEGIN
    OPEN mycursor FOR
    SELECT th.id, th.name, th.semester, th.year, th.semester_number,  
        ROUND(SUM(th.score*th.credits)/SUM(th.credits) , 2) AS gpa, SUM(th.credits), 
        func_cpa(student_id,th.semester_number) AS cpa, 
        func_tctl(student_id,th.semester_number) AS tctl 
    FROM vw_bai6_ScoreData th
    WHERE id = student_id
    GROUP BY th.semester_number, th.name, th.semester, th.year, th.id 
    ORDER BY th.semester_number ASC; 
END;


