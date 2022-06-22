create database studentManagement 
use studentManagement

create table student(
studentName nvarchar(50),
age int,
gender bit,
phoneNumber char(15)
)

insert into student(studentName, age, gender, phoneNumber)
values (N'Tuấn', 20, 1, '0797355999')

select * from student

drop table student