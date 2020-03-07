CREATE OR REPLACE PROCEDURE sp_bai9
    (student_id VARCHAR, course_id VARCHAR, sec_id VARCHAR, semester VARCHAR, year NUMBER,
    day VARCHAR, start_hr VARCHAR, start_min VARCHAR)
AS
bd VARCHAR2(15);
rn VARCHAR2(7);
BEGIN
    SELECT building, room_number INTO bd, rn
    FROM section
    WHERE time_slot_id IN
        (SELECT time_slot_id
        FROM time_slot
        WHERE day=day
            AND start_hr=start_hr
            AND start_min=start_min)
        AND course_id=course_id
        AND sec_id=sec_id
        AND semester=semester
        AND year=year;
    IF bd IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Khong ton tai lop hoc');
    RETURN;
    END IF;
    SET TRANSACTION READ WRITE NAME 'Insert takes';
    INSERT INTO takes_copy (id, course_id, sec_id, semester, year)
    VALUES (student_id, course_id, sec_id, semester, year);
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Da co loi, thuc hien Rollback');
        ROLLBACK;
END;
