--T?o 3 b?ng copy ð? test
CREATE TABLE takes_copy AS SELECT * FROM takes;
CREATE TABLE student_copy AS SELECT * FROM student;
CREATE TABLE advisor_copy AS SELECT * FROM advisor;

CREATE INDEX idx_takes_grade ON takes_copy(grade);
CREATE INDEX idx_student_id ON student_copy(id);
CREATE INDEX idx_advisor_id ON advisor_copy(s_id);

--Testing
SELECT * FROM takes WHERE grade='A+';
SELECT * FROM takes_copy WHERE grade='A+';
SELECT * FROM student WHERE id='10033';
SELECT * FROM student_copy WHERE id='10033';
SELECT * FROM advisor WHERE s_id='10033';
SELECT * FROM advisor_copy WHERE s_id='10033';