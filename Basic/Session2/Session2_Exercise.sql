create database customerManagement
use customerManagement

create table customer(
id int identity,
name nvarchar(50),
phoneNumber char(15),
address text,
gender bit,
dateOfBirth date
)

-- Câu 1 
insert into customer(name, phoneNumber, address, gender, dateOfBirth)
values ('Anh', '0796366999', 'TPHCM', 1, '01-04-2005'),
(N'Ngọc', '0793559999', 'Can Tho', 0, '02-19-2003'),
(N'Trúc', '0798474999', 'Vung Tau', 0, '02-04-1992'),
(N'Đức', '0792124999', 'Nam Dinh', 1, '09-11-2004'),
(N'Minh', '0797377999', 'HaNoi', 0, '01-01-1999')

-- Câu 2
select name, phoneNumber from customer

-- Câu 3
update customer
set
name = N'Tuấn'
where id = 2

-- Câu 4
delete from customer
where id > 3 and gender = 1

-- Câu 5 
select * from customer
where DATEPART(mm, dateOfBirth) = 1

-- Câu 6
select * from customer 
where (name in (N'Anh', N'Đức', N'Minh') and gender = 1) or DATEPART(yyyy, dateOfBirth) < 2000

-- Câu 7
select * from customer 
where DATEDIFF(year, dateOfBirth, CAST(GETDATE() as DATE)) > 18

-- Câu 8
select top 3 * from customer  
order by id desc; 

-- Câu 9
select * from customer 
where SUBSTRING (name, 1, 1) = 'T' 

-- Câu 10


drop table customer