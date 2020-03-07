--T?o view chuy?n to�n b? �i?m t? ch? sang s? v?i d? li?u l?y t? b?ng takes
CREATE OR REPLACE VIEW vw_bai1_ScoreToNumber AS
SELECT id,
    course_id,
    sec_id,
    semester,
    year,
    DECODE(grade,
            'A+', 4.5,
            'A', 4.0,
            'B+', 3.5,
            'B', 3.0,
            'B-', 2.0,
            'C+',  1.5,
            'C', 1.0,
            0.5) AS score
FROM takes;

--T?o view l?y ra �i?m cao nh?t c?a c�c h?c ph?n m� sinh vi�n c� th? �? h?c nhi?u l?n
CREATE OR REPLACE VIEW vw_bai1_GetHighestScore AS
SELECT id,
    course_id,
    MAX(score) AS finalscore
FROM vw_bai1_ScoreToNumber
GROUP BY id, course_id;

--T?o view l?y ra s? t�n ch? c?a t?ng h?c ph?n trong view v?a t?o
CREATE OR REPLACE VIEW vw_bai1_FullData AS
SELECT vw.id, vw.course_id, finalscore, cs.credits
FROM vw_bai1_GetHighestScore vw
JOIN course cs ON vw.course_id = cs.course_id
ORDER BY vw.id;

--T?o view l?y ra nh?ng b?n ghi c� �i?m t? 1.0
CREATE OR REPLACE VIEW vw_bai1_PassedCourses AS
SELECT * FROM vw_bai1_FullData
WHERE finalscore > 0.5
ORDER BY id;

--Th? t?c ki?m tra m?t sinh vi�n c� �? �i?u ki?n t?t nghi?p kh�ng v?i s? t�n ch? c?n �?t m?c �?nh l� 120
--Input l� m? sinh vi�n
CREATE OR REPLACE PROCEDURE sp_bai1(student_id IN VARCHAR) AS
credits_number NUMBER;
cpa NUMBER;
total_score NUMBER;
tctl NUMBER;
BEGIN
    SELECT SUM(credits), SUM(finalscore*credits) INTO credits_number, total_score
    FROM vw_bai1_FullData
    WHERE id = student_id;
    cpa := total_score / credits_number;
    SELECT SUM(credits) INTO tctl
    FROM vw_bai1_PassedCourses
    WHERE id = student_id;
    IF tctl < 120 THEN
    DBMS_OUTPUT.PUT_LINE('Sinh vien chua du dieu kien tot nghiep!');
    ELSE
    BEGIN
        IF cpa > 1 THEN
        DBMS_OUTPUT.PUT_LINE('Sinh vien du dieu kien tot nghiep');
        ELSE DBMS_OUTPUT.PUT_LINE('Sinh vien chua du dieu kien tot nghiep!');
        END IF;
    END;
    END IF;
    DBMS_OUTPUT.PUT_LINE(cpa);
END;






