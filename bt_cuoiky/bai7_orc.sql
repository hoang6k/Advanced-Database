--T?o th? t?c ki?m tra s? d?ng view vw_PassedCourses và vw_FullData ? bài 1
CREATE OR REPLACE PROCEDURE sp_bai7(student_id IN VARCHAR)
AS
credits_number NUMBER;
cpa NUMBER;
tctl NUMBER;
BEGIN
    SELECT SUM(credits), ROUND(SUM(finalscore)/SUM(credits), 2) INTO credits_number, cpa
    FROM vw_bai1_FullData
    WHERE id = student_id;
    SELECT SUM(credits) INTO tctl
    FROM vw_bai1_PassedCourses
    WHERE id = student_id;
    IF tctl < 32 THEN DBMS_OUTPUT.PUT_LINE('Trinh do nam nhat');
    ELSIF tctl < 64 THEN DBMS_OUTPUT.PUT_LINE('Trinh do nam hai');
    ELSIF tctl < 96 THEN DBMS_OUTPUT.PUT_LINE('Trinh do nam ba');
    ELSIF tctl < 128 THEN DBMS_OUTPUT.PUT_LINE('Trinh do nam bon');
    ELSIF tctl < 32 THEN DBMS_OUTPUT.PUT_LINE('Trinh do nam nhat');
    ELSE DBMS_OUTPUT.PUT_LINE('Trinh do nam nhat');
    END IF;
    IF cpa < 1.0 THEN DBMS_OUTPUT.PUT_LINE('Hoc luc kem');
    ELSIF cpa < 2.0 THEN DBMS_OUTPUT.PUT_LINE('Hoc luc yeu');
    ELSIF cpa < 2.5 THEN DBMS_OUTPUT.PUT_LINE('Hoc luc trung binh');
    ELSIF cpa < 3.2 THEN DBMS_OUTPUT.PUT_LINE('Hoc luc kha');
    ELSIF cpa < 3.6 THEN DBMS_OUTPUT.PUT_LINE('Hoc luc gioi');
    ELSE DBMS_OUTPUT.PUT_LINE('Hoc luc xuat sac');
    END IF;
END;