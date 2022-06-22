create database animalManagement
use animalManagement 
	
create table animal(
name nvarchar(50) not null,
numberOfLegs int default 2 not null,
livingEnvironment nvarchar(50) not null,
dateOfBirth date not null,
constraint CK_valid_name check (len(name) >= 2),
constraint CK_valid_living_environment check (livingEnvironment in (N'Trên cạn', N'Dưới nước', N'Trên không'))
)

-- 1. Sở thú hiện có 7 con
insert into animal(name, numberOfLegs, livingEnvironment, dateOfBirth)
values 
(N'Hổ', 4, N'Trên cạn', '2018-02-13'),
(N'Cá diêu hồng', 0, N'Dưới nước', '2020-02-03'),
(N'Đại bàng', default, N'Trên không', '2021-04-29'),
(N'Sư tử', 4, N'Trên cạn', '2017-06-19'),
(N'Voi', 4, N'Trên cạn', '2015-05-21'),
(N'Chim cánh cụt', default, N'Dưới nước', '2017-07-06'),
(N'Chim ưng', 4, N'Trên không', '2019-03-17')

-- 2. Thống kê có bao nhiêu con 4 chân
select count(numberOfLegs) as 'Number of animals have 4 legs' 
from animal
where numberOfLegs = 4

-- 3. Thống kê số con tương ứng với số chân
select numberOfLegs, count(numberOfLegs) as 'Number of animals have that number of legs' 
from animal
GROUP BY numberOfLegs

-- 4. Thống kê số con theo môi trường sống
select livingEnvironment, count(livingEnvironment) as 'Number of animals live in that environment' 
from animal
GROUP BY livingEnvironment

-- 5. Thống kê tuổi thọ trung bình theo môi trường sống
select livingEnvironment, avg(DATEDIFF(year, dateOfBirth, GETDATE())) as 'Average age' 
from animal
GROUP BY livingEnvironment

-- 6. Lấy ra 3 con có tuổi thọ cao nhất
select top 3 * from animal
order by DATEDIFF(year, dateOfBirth, GETDATE()) desc

-- 7. (*) Tách những thông tin trên thành 2 bảng cho dễ quản lý (1 môi trường sống gồm nhiều con)

drop table animal