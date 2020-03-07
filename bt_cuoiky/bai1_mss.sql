CREATE VIEW vw_bai1_ScoreToNumber AS
SELECT id, course_id, sec_id, semester, year
	CASE
		WHEN grade='A+' THEN 4.5
		WHEN grade='A ' THEN 4.0
		WHEN grade='A-' THEN 3.5
		WHEN grade='B+' THEN 3.0
		WHEN grade='B ' THEN 2.5
		WHEN grade='B-' THEN 2.0
		WHEN grade='C+' THEN 1.5
		WHEN grade='C ' THEN 1.0
		WHEN grade='C-' THEN 0.5
		ELSE 0
	END AS score
FROM takes;

CREATE VIEW vw_bai1_GetHighestScore AS
SELECT id,
    course_id,
    MAX(score) AS finalscore
FROM vw_bai1_ScoreToNumber
GROUP BY id, course_id;

CREATE VIEW vw_bai1_FullData AS
SELECT vw.id, vw.course_id, finalscore, cs.credits
FROM vw_bai1_GetHighestScore vw
JOIN course cs ON vw.course_id = cs.course_id
ORDER BY vw.id;

CREATE VIEW vw_bai1_PassedCourses AS
SELECT * FROM vw_bai1_FullData
WHERE finalscore > 0.5
ORDER BY id;

ALTER PROCEDURE sp_bai1 (@student_id VARCHAR(1000)) AS
BEGIN
	DECLARE @credits_number FLOAT;
	DECLARE @cpa FLOAT;
	DECLARE @total_score FLOAT;
	DECLARE @tctl INT;
	SELECT @credits_number = SUM(credits), @total_score = SUM(finalscore*credits)
	FROM vw_bai1_FullData
	WHERE id = @student_id;
	set @cpa = @total_score/@credits_number;
	SELECT @tctl=SUM(credits)
	FROM vw_bai1_PassedCourses
	WHERE id = @student_id;
	IF @tctl < 120
		PRINT('Sinh vien chua du dieu kien tot nghiep!');
	ELSE
	BEGIN
		IF @cpa > 1.0
			PRINT('Sinh vien du dieu kien tot nghiep');
		ELSE PRINT('Sinh vien chua du dieu kien tot nghiep!');
	END;
END;