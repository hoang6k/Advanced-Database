DROP VIEW vw_bai2
CREATE VIEW vw_bai2
AS
SELECT st.ID AS 'MASV',
	   st.name AS 'HOTENSV',
	   co.title AS 'KHOAHOC',
	   se.semester AS 'KYHOC',
	   se.year AS 'NAMHOC',
	   se.time_slot_id AS 'THOIGIAN',
	   se.room_number AS 'PHONGHOC',
	   i.name AS 'GIANGVIEN',
	   co.dept_name AS 'KHOAVIEN'
FROM student st INNER JOIN takes t ON st.id = t.id
				INNER JOIN section se ON se.course_id = t.course_id
				INNER JOIN teaches te ON te.course_id = t.course_id
				INNER JOIN course co ON co.course_id = te.course_id
				INNER JOIN instructor i ON i.id = te.id
GO

CREATE PROC sp_bai2
	@FieldName VARCHAR(20),
	@Value VARCHAR(1000)
AS
BEGIN
	DECLARE @query NVARCHAR(1000)
	SET @query = 'SELECT * FROM vw_bai2 WHERE ' + @FieldName + ' = ''' + @Value + ''''
	EXEC(@query)
END