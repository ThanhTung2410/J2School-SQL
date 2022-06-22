-- Sửa bài tập buổi 2 + học về những ràng buộc (not null,...)

create database customerManagement
use customerManagement

create table customer(
id int identity,
name nvarchar(50) not null, 
phoneNumber char(15) unique not null, -- unique => không được phép trùng
address ntext not null, -- ntext => unicode (có dấu), không hỗ trợ unique
gender bit not null,
dateOfBirth date not null,
primary key(id)
)

-- Thêm 5 khách hàng
insert into customer(name, phoneNumber, address, gender, dateOfBirth)
values 
(N'Long', '123', 'HN', 1, '1997-01-01'),
(N'Tuấn', '234', 'HP', 0, '2000-02-01'),
(N'Anh', '135', 'HCM', 1, '1996-05-01'),
(N'Minh','246','VT', 1,'1998-03-01')

-- Hiển thị chỉ họ tên và số điện thoại của tất cả khách hàng
select name, phoneNumber
from customer

-- Cập nhật khách có mã là 2 sang tên Tuấn
update customer set name = N'Tuấn' where id = 2

-- Xoá khách hàng có mã lớn hơn 3 và giới tính là Nam
delete from customer where id > 3 and gender = 1

-- (*) Lấy ra khách hàng sinh tháng 1
select * from customer
where MONTH(dateOfBirth) = 1

-- (*) Lấy ra khách hàng có họ tên trong danh sách (Anh,Minh,Đức) và giới tính Nam hoặc chỉ cần năm sinh trước 2000
select * from customer 
where (name in ('Anh', 'Minh', N'Đức') and gender = 1) or YEAR(dateOfBirth) < 2000

--  (**) Lấy ra khách hàng có tuổi lớn hơn 18
select * from customer
where YEAR(GETDATE()) - YEAR(dateOfBirth) > 18 -- YEAR(GETDATE()) -> get current year

-- (**) Lấy ra 3 khách hàng mới nhất
select top 3 *
from customer
order by id desc

-- (**) Lấy ra khách hàng có tên chứa chữ T
select *
from customer
where name like '%T%'

-- (***) Thay đổi bảng sao cho chỉ nhập được ngày sinh bé hơn ngày hiện tại
alter table customer
add CONSTRAINT CK_valid_dateOfBirth check(dateOfBirth < GETDATE())

-- (***) Thay đổi bảng sao cho chỉ nhập được giới tính nam với bạn tên Long
alter table customer
add CONSTRAINT CK_gender_with_name_Long check((gender = 1 and name = 'Long') or name != 'Long')

insert into customer(name, phoneNumber, address, gender, dateOfBirth)
values 
(N'Long', '1234', 'HN', 0, '1997-01-01')

alter table customer 
add CONSTRAINT gender_default_value
default 1 for gender

drop table customer