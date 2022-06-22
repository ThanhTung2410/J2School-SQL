create database studentManagement 
use studentManagement

create table student(
id int identity,
name nvarchar(50),
dateOfBirth date,
gender bit,
phoneNumber char(15)
primary key(id) 
)

insert into student(name, dateOfBirth, gender, phoneNumber)
values (N'Tuấn', '1997-06-05', 1, '0797355999'), (N'Trúc', '1996-03-21', 0, '0797377999')

select * from student
where name in (N'Tuấn', N'Trúc')

delete from student 
where id = 4

update student 
set 
name = 'Khang'
where id = 1
	
drop table student