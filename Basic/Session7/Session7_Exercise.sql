-- 1 lớp - n sinh viên

create table class (
id int identity,
name nvarchar(50) not null unique,
PRIMARY KEY(id)
)

-- 1. Thêm mỗi bảng số bản ghi nhất định

INSERT INTO class(name) 
VALUES
('LT'),
('ATTT')

SELECT * FROM class

create table student (
id int identity,
name nvarchar(50) not null,
gender bit not null default 0,
phoneNumber varchar(10) not null,
dateOfBirth date not null,
idClass int,
CONSTRAINT CK_valid_name CHECK (len(name) >= 2),
CONSTRAINT CK_valid_phone_number CHECK (len(phoneNumber) = 10),
FOREIGN KEY(idClass) REFERENCES class(id),
PRIMARY KEY(id)
)

-- -- 1. Thêm mỗi bảng số bản ghi nhất định

INSERT INTO student(name, gender, phoneNumber, dateOfBirth, idClass)
VALUES 
('Long', DEFAULT, '0939099721', '01-01-1997', 2),
(N'Tuấn', 1, '0939099562', '01-01-2000', 1)

SELECT * FROM student

-- n môn có n sinh viên

create table subject (
id int identity,
name nvarchar(50) not null unique,
PRIMARY KEY(id)
)

INSERT INTO subject(name)
VALUES
('SQL'),
('Java')

SELECT * FROM subject

create table transcript ( -- bảng điểm
idStudent int,
idSubject int,
score float,
CONSTRAINT CK_valid_score CHECK (score > 0),
FOREIGN KEY(idStudent) REFERENCES student(id),
FOREIGN KEY(idSubject) REFERENCES subject(id),
PRIMARY KEY(idStudent, idSubject)
)

INSERT INTO transcript(idStudent, idSubject, score)
VALUES 
(1, 1, 10),
(2, 1, 8.5),
(1, 2, 9),
(2, 2, 9.5)

SELECT * FROM transcript

-- 2. Lấy ra tất cả sinh viên kèm thông tin lớp
SELECT 
student.id,
student.name,
student.gender,
student.phoneNumber,
student.dateOfBirth,
class.name as 'className'
FROM student
inner join class
on class.id = student.idClass


-- 3. Đếm số sinh viên theo từng lớp

SELECT 
class.name,
COUNT(student.id) as 'numberOfStudents'
FROM student
inner join class
on class.id = student.idClass
GROUP BY(class.name)

-- 4. Lấy sinh viên kèm thông tin điểm và tên môn
SELECT 
student.id,
student.name,
student.gender,
student.phoneNumber,
student.dateOfBirth,
subject.name 'subject',
transcript.score as 'score'
FROM student
inner join transcript
on student.id = transcript.idStudent
inner join subject
on subject.id = transcript.idSubject

-- 5. (*) Lấy điểm trung bình của sinh viên của lớp LT

SELECT 
class.name,
AVG(score) as 'averageScore'
FROM student
inner join class 
on class.id = student.idClass
inner join transcript
on student.id = transcript.idStudent
inner join subject
on subject.id = transcript.idSubject
where class.name = 'LT'
GROUP BY(class.name)

-- 6. (*) Lấy điểm trung bình của sinh viên của môn SQL

SELECT 
subject.name,
AVG(score) as 'averageScore'
FROM student
inner join class 
on class.id = student.idClass
inner join transcript
on student.id = transcript.idStudent
inner join subject
on subject.id = transcript.idSubject
where subject.name = 'SQL'
GROUP BY(subject.name)

-- 7. (*) Lấy điểm trung bình của sinh viên theo từng lớp
SELECT 
class.name,
AVG(score) as 'averageScore'
FROM student
inner join class 
on class.id = student.idClass
inner join transcript
on student.id = transcript.idStudent
inner join subject
on subject.id = transcript.idSubject
GROUP BY(class.name)