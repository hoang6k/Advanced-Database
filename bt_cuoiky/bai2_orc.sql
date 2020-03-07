--T?o view hi?n th? ð?y ð? các trý?ng thông tin ð? bài yêu c?u
CREATE OR REPLACE VIEW vw_bai2
    (masv,hotensv,namhoc,kyhoc,khoahoc,thoigianhoc,phonghoc,giangvien,khoavien)
AS
SELECT student.ID, student.NAME, section.YEAR, section.SEMESTER, course.TITLE,
        section.SEC_ID, section.BUILDING, instructor.NAME, instructor.DEPT_NAME
FROM student,takes,course,section,teaches,instructor
WHERE student.ID = takes.ID
        AND takes.COURSE_ID = course.COURSE_ID
        AND takes.SEC_ID = section.SEC_ID
        AND takes.COURSE_ID = section.COURSE_ID
        AND takes.SEMESTER = section.SEMESTER
        AND takes.YEAR = section.YEAR
        AND teaches.SEC_ID = section.SEC_ID
        AND teaches.COURSE_ID = section.COURSE_ID
        AND teaches.SEMESTER = section.SEMESTER
        AND teaches.YEAR = section.YEAR
        AND teaches.ID = instructor.ID;

--T?o th? t?c ch?y v?i field_name và field_value
CREATE OR REPLACE PROCEDURE sp_bai2(field_name IN varchar, field_value IN varchar)
AS
query varchar(1000):= 'SELECT * FROM vw_bai2 WHERE ';
cur sys_refcursor;
o_masv varchar(50);
o_hotensv varchar(50);
o_namhoc varchar(50);
o_kyhoc varchar(50);
o_khoahoc varchar(50);
o_thoigian varchar(50);
o_phonghoc varchar(50);
o_giangvien varchar(50);
o_khoavien varchar(50);
BEGIN
    DBMS_OUTPUT.PUT_LINE(field_name);
    DBMS_OUTPUT.PUT_LINE(field_value);
    IF field_name IN
    ('MASV','HOTENSV','NAMHOC','KYHOC','KHOAHOC','THOIGIAN','PHONGHOC','GIANGVIEN','KHOAVIEN')
    THEN
    query := query || field_name || '=''' || field_value ||'''';
    DBMS_OUTPUT.PUT_LINE(query);
    OPEN cur FOR query;
    DBMS_OUTPUT.PUT_LINE(rpad('MASV',8,' ')||rpad('HOTENSV',20,'')||rpad('NAMHOC',10,' ')
    ||rpad('KYHOC',10,'')||rpad('KHOAHOC',35,' ')||rpad('THOIGIANHOC',12,' ')
    ||rpad('PHONGHOC',12,'')||rpad('GIANGVIEN',15,' ')||rpad('KHOAVIEN',15,' '));
    DBMS_OUTPUT.PUT_LINE(rpad('-',140,'-'));
    LOOP
    FETCH cur INTO
    o_masv,o_hotensv,o_namhoc,o_kyhoc,o_khoahoc,o_thoigian,o_phonghoc,o_giangvien,o_khoavien;
    EXIT WHEN cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(rpad(o_masv,8,' ')||rpad(o_hotensv,20,'')||rpad(o_namhoc,10,' ')
    ||rpad(o_kyhoc,10,' ')||rpad(o_khoahoc,35,' ')||rpad(o_thoigian,12,' ')
    ||rpad(o_phonghoc,12,' ')||rpad(o_giangvien,15,'')||rpad(o_khoavien,15,' '));
    END LOOP;
    CLOSE cur;
    ELSE
    DBMS_OUTPUT.PUT_LINE('NHAP KHONG DUNG');
    END IF;
END;

/*
'MASV'
10033
*/
