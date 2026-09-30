create database sql project2
use sql project2;

show tables;

BASIC:
select * from student
select student_name , Email, Gender from student
select * from student where gender = 'Female'
select *  from student where Date_of_Birth < '2005-01-01'
select * from subjects
select Subject_name , Subject_code from subjects
SELECT *
FROM subjects
WHERE Subject_name LIKE '%a%';
SELECT *
FROM `questions students`
WHERE Difficulty = 'Easy';
select * from `questions students`
select * from `questions students` where Marks > 50
select * from exam_attempts where Attempt_Number > 1
select * from result where Score > 70
select * from student where Student_name LIKE 'a%'
select * from `questions students` where Marks between 30 and 60

INTERMEDIATE
select count(*) as total_students from student
select count(*) as genders from student group by Gender
select count(*) as questions from `questions students` group by Difficulty
select count(*) as questions from exams group by Exam_id
select avg(total_marks) from exams
select s.Student_name, e.Attempt_id from student s join exam_attempts e where s.Student_id = e.Student_id
select t.Teacher_name, s.Subject_name from teachers t join subjects s where t.Subject_id = s.Subject_id
select q.Question_id , q.Question_text, o.option_text from `questions students` q join options o where q.Question_id = o.Question_id
select Student_id , count(*) from exam_attempts group by Student_id having count(*) > 2
SELECT *
FROM result
WHERE Score > (
    SELECT AVG(Score)
    FROM result
);
select Exam_id, max(Score) AS Maximum_Score
from result
group by Exam_id
select s.Student_id,s.Student_Name,r.Score
from Student s
join result r
on s.Student_id = r.Student_id

ADVANCED:
select Student_id,Student_Name,Registeration_date,
ROW_NUMBER() OVER (ORDER BY Registeration_date ASC) AS `Row_Number`
FROM Student
select Student_id, Exam_id, Score, RANK() OVER (ORDER BY Score DESC) AS Score_Rank
from result
select Student_id, Exam_id,Score, DENSE_RANK() OVER ( 
				PARTITION BY Exam_id
                ORDER BY Score DESC
               ) AS Score_Rank
 From result    
 select Student_id, Attempt_Number, LAG(Attempt_Number) OVER (
			PARTITION BY Student_id
            ORDER BY Attempt_Number
		) AS Previous_Attempt_Number
 FROM Exam_Attempts       
WITH Exam_Average AS (
    SELECT
        Exam_id,
        AVG(Score) AS Average_Score
    FROM Result
    GROUP BY Exam_id
)
SELECT
    Exam_id,
    Average_Score
FROM Exam_Average
WHERE Average_Score > 70;
WITH Ranked_Results AS (
    SELECT
        Student_id,
        Exam_id,
        Score,
        RANK() OVER (
            ORDER BY Score DESC
        ) AS Score
    FROM result
)
SELECT
    Student_id,
    Exam_id,
    Score AS `Rank`
FROM result;

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAttempts`(IN p_Student_id INT)
BEGIN
	SELECT *
    FROM exam_attempts
    WHERE Student_id = p_Student_id;

END



CALL GetAttempts(1);

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetExam`(IN p_Exam_id INT)
BEGIN
	SELECT 
		s.Student_id,
        s.Student_name,
        r.Exam_id,
        r.Score
    FROM Student s
    JOIN result r
		ON s.Student_id = r.Student_id
    WHERE r.Exam_id = p_Exam_id;    

END
CALL GetExam(1);

DELIMITER //

CREATE TRIGGER Set_Result_Status
BEFORE INSERT ON result
FOR EACH ROW
BEGIN
    IF NEW.Score >= 50 THEN
        SET NEW.Result_Status = 'Pass';
    ELSE
        SET NEW.Result_Status = 'Fail';
    END IF;
END //

DELIMITER ;

INSERT INTO result
(Student_id, Exam_id, Score)
VALUES
(1, 1, 75);
select * from result

ALTER TABLE `questions students`
ADD COLUMN Answer_Date DATETIME;

DELIMITER //

CREATE TRIGGER Set_Answer_Date
BEFORE INSERT ON `questions students`
FOR EACH ROW
BEGIN
    SET NEW.Answer_Date = CURRENT_TIMESTAMP;
END //

DELIMITER ;

INSERT INTO `questions students`
(Question_id, Exam_id, Question_text, Question_type, Marks, Difficulty)
VALUES
(101, 1, 'What is SQL?', 'MCQ', 10, 'Easy');

select * from `questions students`

show triggers

SELECT
    Exam_id,
    AVG(Score) AS Average_Score
FROM result
GROUP BY Exam_id
HAVING AVG(Score) > 75;

SELECT
    Student_id,
    Score,
    SUM(Score) OVER () AS Total_Score
FROM result;






