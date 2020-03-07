--Ta t?m nh?ng môn h?c có tên 'Mobile Computing'
SELECT course_id FROM course WHERE title = 'Mobile Computing';
--K?t qu? 612 và 810

--Ta ch?y truy v?n t?m nh?ng môn trý?c ðó
SELECT * FROM prereq
START WITH course_id='612'
CONNECT BY PRIOR prereq_id = course_id;
--K?t qu? 123

SELECT * FROM prereq
START WITH course_id='810'
CONNECT BY PRIOR prereq_id = course_id;
--K?t qu? 966