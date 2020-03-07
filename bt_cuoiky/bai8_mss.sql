CREATE TABLE takes_copy AS SELECT * FROM takes;
CREATE TABLE student_copy AS SELECT * FROM student;
CREATE TABLE advisor_copy AS SELECT * FROM advisor;

CREATE INDEX idx_takes_grade ON takes_copy(grade);
CREATE INDEX idx_student_id ON student_copy(id);
CREATE INDEX idx_advisor_id ON advisor_copy(s_id);

--Testing
SET STATISTICS TIME ON
SELECT * FROM takes WHERE grade = 'A+'
SET STATISTICS TIME ON
SELECT * FROM takes_copy WHERE grade = 'A+'
