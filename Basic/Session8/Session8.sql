-- 1 lớp - n sinh viên => 1 sinh viên chỉ được thuộc 1 lớp

create table class (
id int identity,
name nvarchar(50) not null unique,
PRIMARY KEY(id)
)

insert into class(name)
values ('LT'),
('ATTT'),
('BTMT')

SELECT * FROM class

create table student (
id int identity,
name nvarchar(50) not null,
idClass int,
FOREIGN KEY(idClass) REFERENCES class(id),
CONSTRAINT CK_valid_name CHECK (len(name) >= 2),
PRIMARY KEY(id)
)

insert into student(name, idClass)
values
('Long',1),
(N'Tuấn',1),
(N'Anh',2)

insert into student(name, idClass)
values
('Long sky',null)

create table subject (
id int identity,
name nvarchar(50) not null unique,
PRIMARY KEY(id)
)

insert into subject(name)
values ('SQL'),
('PHP'),
('HTML')

create table score(
idSubject int not null,
idStudent int not null,
mark float,
CONSTRAINT CK_valid_mark CHECK (mark >= 0 and mark <= 10),
FOREIGN KEY(idSubject) REFERENCES subject(id),
FOREIGN KEY(idStudent) REFERENCES student(id),
PRIMARY KEY(idSubject, idStudent)
)

insert into score
values 
(1,1,3),
(1,2,5)

insert into score
values (2,1,10)

-- Lấy ra tất cả sinh viên kèm thông tin lớp (nếu có)
SELECT * FROM student
LEFT JOIN class
ON student.idClass = class.id

-- Đếm số sinh viên theo từng lớp
select * from class
select * from student

select  
class.id,
class.name,
count(student.idClass) number_of_students
from student
right join class 
on class.id = student.idClass
group by class.id, class.name

-- Lấy sinh viên có điểm kèm tên môn
select  
student.name,
score.mark,
subject.name
from student
join score on score.idStudent = student.id
join subject on subject.id = score.idSubject

-- Lấy tất cả sinh viên (kèm điểm nếu có)
select  
student.name,
score.mark,
subject.name
from student
left join score on score.idStudent = student.id
left join subject on subject.id = score.idSubject

--(*) Lấy điểm trung bình của sinh viên của từng lớp
select  
class.id,
avg(mark)
from student
join score on score.idStudent = student.id
right join class on class.id = student.idClass
group by class.id

--(*) Lấy điểm trung bình của sinh viên của lớp LT
select  
avg(mark)
from student
join score on score.idStudent = student.id
right join class on class.id = student.idClass
where class.name = 'LT'

--(*) Lấy điểm trung bình của sinh viên của môn SQL
select
avg(mark)
from student
inner join score on score.idStudent = student.id
right join subject on subject.id = score.idSubject
where
subject.name = 'SQL'

select
avg(mark)
from subject
left join score on score.idSubject = subject.id
where
subject.name = 'SQL'