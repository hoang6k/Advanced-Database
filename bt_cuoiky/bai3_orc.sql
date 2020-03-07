--T?o Object m?i ch?a field_name và field_value và table m?i c?a object
CREATE OR REPLACE TYPE varfilter AS
OBJECT (field_name varchar(50),
        field_value varchar(50));
/
CREATE OR REPLACE TYPE tablefilter
IS TABLE OF varfilter;
/

--T?o th? t?c ð? l?c d? li?u
CREATE OR REPLACE PROCEDURE sp_bai3(i_table tablefilter)
AS
cur sys_refcursor;
query varchar(1000) := 'SELECT * FROM vw_bai2 WHERE 1=1 ';
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
    FOR i IN 1..i_table.LAST
    LOOP
    IF i_table(i).field_name IN
    ('MASV','HOTENSV','NAMHOC','KYHOC','KHOAHOC','THOIGIAN','PHONGHOC','GIANGVIEN','KHOAVIEN')
    THEN
    query := query ||' AND '|| i_table(i).field_name || '=''' || i_table(i).field_value || '''';
    ELSE
    DBMS_OUTPUT.PUT_LINE('NHAP KHONG DUNG');
    END IF;
    END LOOP;
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
END;

/*
-- DEMO
DECLARE
    test tablefilter := tablefilter(varfilter('MASV','10033'),varfilter('HOTENSV','Zelty'));
BEGIN
    sp_bai3(test);
END;
*/