--T?o trigger ki?m tra s? lý?ng sinh viên t? b?ng takes
CREATE OR REPLACE TRIGGER CAPACITY_CHECK
BEFORE INSERT ON takes FOR EACH ROW
DECLARE
current_student number(4,0);
room_number varchar(40);
max_student number(4,0);
exception_text varchar(100);
building varchar(40);
CURSOR c(bd varchar, rn varchar) IS
    SELECT capacity FROM classroom
    WHERE building = bd AND room_number = rn;
BEGIN
    --Ð?m s? lý?ng sinh viên hi?n t?i có trong l?p ðó
    SELECT COUNT(id) INTO current_student
    FROM (SELECT DISTINCT id
            FROM takes
            WHERE course_id = :NEW.course_id
                AND semester = :NEW.semester
                AND year = :NEW.year
                AND sec_id = :NEW.sec_id);
    --L?y ra ph?ng h?c c?a l?p ðó
    SELECT room_number INTO room_number
    FROM section
    WHERE course_id = :NEW.course_id
        AND sec_id = :NEW.sec_id
        AND semester = :NEW.semester
        AND year = :NEW.year ;
    --L?y ra toà nhà c?a l?p ðó
    SELECT building INTO building
    FROM section
    WHERE course_id = :NEW.course_id
        AND sec_id = :NEW.sec_id
        AND semester = :NEW.semester
        AND year = :NEW.year ;
    --L?y ra s?c ch?a t?i ða c?a ph?ng s? room_number trong t?a nhà building
    OPEN c(building, room_number);
    FETCH c INTO max_student;
    --Ki?m tra l?p c?n ch? tr?ng hay không
    IF (current_student >= max_student) THEN
    exception_text := 'HET CHO TRONG';
    RAISE_APPLICATION_ERROR(-20001, exception_text);
    END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('KHONG TON TAI LOP NAY');
END;
/
--T?o th? t?c ðãng k? l?p ð? l?p nghi?m
CREATE OR REPLACE PROCEDURE sp_bai5
    (t_studentID varchar,t_courseID varchar,t_secID varchar,t_semester varchar,t_YEAR number)
AS
MAX_CLASSROOM_CAPACITY EXCEPTION;
PRAGMA EXCEPTION_INIT(MAX_CLASSROOM_CAPACITY,-20001);
BEGIN
    INSERT INTO takes(id, course_id, sec_id, semester, YEAR)
    VALUES (t_studentID, t_courseID, t_secID, t_semester, t_YEAR);
    DBMS_OUTPUT.PUT_LINE('DANG KY THANH CONG');
    EXCEPTION
    WHEN MAX_CLASSROOM_CAPACITY THEN
    DBMS_OUTPUT.PUT_LINE('LOP HET CHO TRONG');
    ROLLBACK;
END;

/*
--Demo
EXEC sp_bai5('24201','571','1','Spring',2004);
*/