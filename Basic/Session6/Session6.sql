-- Sửa bài tập buổi 5, split table, foreign key, join

create database animalManagement
use animalManagement 

create table animal (
id int identity,
name nvarchar(50) not null UNIQUE, -- unique 
numberOfLegs int default 0 not null,
longevity int not null, -- tuổi thọ
livingEnvironment nvarchar(50) not null,
CONSTRAINT CK_valid_name CHECK (len(name) >= 2),
CONSTRAINT CK_valid_number_of_legs CHECK (numberOfLegs >= 0 and numberOfLegs < 100 and numberOfLegs % 2 = 0),
CONSTRAINT CK_valid_longevity CHECK (longevity > 0),
PRIMARY KEY(id)
)

-- 1. Sở thú hiện có 7 con
insert into animal(name, numberOfLegs, longevity, livingEnvironment)
values 
(N'cún', 4, 20, N'trong nhà'),
(N'mèo', 4, 9, N'trong nhà'),
(N'cá cược', default, 10, N'dưới nước')

-- 2. Thống kê có bao nhiêu con 4 chân
SELECT count(*) AS 'numberOfAnimalsHave4Legs' 
FROM animal
WHERE numberOfLegs = 4

-- 3. Thống kê số con tương ứng với số chân
select numberOfLegs,
count(*) as 'numberOfAnimals' 
from animal
GROUP BY numberOfLegs

-- 4. Thống kê số con theo môi trường sống
select livingEnvironment,
count(*) as 'Number of animals live in that environment' 
from animal
GROUP BY livingEnvironment

-- 5. Thống kê tuổi thọ trung bình theo môi trường sống
select livingEnvironment,
avg(longevity) as 'averageLongevity' 
from animal
GROUP BY livingEnvironment

-- 6. Lấy ra 3 con có tuổi thọ cao nhất
select top 3 * from animal
order by longevity desc

select * from animal
order by longevity desc
OFFSET 1 ROW
FETCH FIRST 1 ROW ONLY

-- 7. (*) Tách những thông tin trên thành 2 bảng cho dễ quản lý (1 môi trường sống gồm nhiều con)
-- 1 môi trường - n động vật
create table livingEnvironment (
id int identity,
name nvarchar(50) not null unique,
PRIMARY KEY(id)
)

-- Có cha trước thì mới có con => Phải insert giá trị cho bảng cha trước
insert into livingEnvironment(name)
values
(N'trong nhà'),
(N'ngoài trời')

select * from livingEnvironment
-- identity -> nếu xóa đi row thì vẫn tự động tăng
		--  -> insert sai chương trình báo lỗi thì vẫn tự động tăng

create table animal (
id int identity,
name nvarchar(50) not null UNIQUE, -- unique 
numberOfLegs int default 0 not null,
longevity int not null, -- tuổi thọ
idLivingEnvironment int not null, -- theo quy tắc: kiểu dữ liệu của id trong table livingEnvironment là int 
								  -- thì kiểu dữ liệu của idLivingEnvironment trong table animal cũng phải là int
CONSTRAINT CK_valid_name CHECK (len(name) >= 2),
CONSTRAINT CK_valid_number_of_legs CHECK (numberOfLegs >= 0 and numberOfLegs < 100 and numberOfLegs % 2 = 0),
CONSTRAINT CK_valid_longevity CHECK (longevity > 0),
FOREIGN KEY (idLivingEnvironment) references livingEnvironment(id), -- references (nối tới) table livingEnvironment tại field id
																	-- constraint để kiểm tra idLivingEnvironment bắt buộc phải tồn tại trong table livingEnvironment
PRIMARY KEY(id)
)

insert into animal(name, numberOfLegs, longevity, idLivingEnvironment)
values 
(N'cún', 4, 20, 1),
(N'mèo', 4, 9, 1),
(N'đại bàng', 2, 10, 2)

select 
animal.id,
animal.name,
animal.numberOfLegs,
animal.longevity,
livingEnvironment.name as 'livingEnvironment'
from animal
join livingEnvironment -- nối bảng 
on livingEnvironment.id = animal.idLivingEnvironment -- nối với nhau dựa trên 2 cột 
-- table livingEnvironment hiển thị bên phải

drop table livingEnvironment
drop table animal