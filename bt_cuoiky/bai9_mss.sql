ALTER PROCEDURE sp_bai9 @id VARCHAR(20), @course_id INT, @sec_id INT, @semester VARCHAR(20),
	@year VARCHAR(20), @day VARCHAR(20), @start_hr VARCHAR(20), @start_min VARCHAR(20)
AS
BEGIN
	BEGIN TRANSACTION
		SAVE TRANSACTION checkpoint
		DECLARE @bd VARCHAR(20)
		DECLARE @rn VARCHAR(20)
		SELECT @bd = building, @rn = room_number
		FROM section
		WHERE time_slot_id IN 
				(SELECT time_slot_id FROM time_slot WHERE day=@day
					AND start_hr=@start_hr AND start_min=@start_min)
			AND course_id=@course_id AND sec_id=@sec_id
			AND semester=@semester AND year=@year;
		
		IF @bd IS NOT NULL
		BEGIN
			INSERT INTO takes VALUES(@id, @course_id, @sec_id, @semester, @year, NULL)
		END
		ELSE PRINT('Khong ton tai thoi gian nay')
	COMMIT
END