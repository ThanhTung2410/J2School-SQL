-- Sửa bài tập buổi 4, offset fetch và GROUP BY

create database employeeManagement
use employeeManagement

create table employee(
id int identity,
name nvarchar(50) not null,
dateOfBirth date not null,
gender bit default 0 not null, -- giới tính mặc định là nữ (0 là nữ)
salary int not null,
dateJoined date default CAST(GETDATE() as date) not null, -- ngày vào làm mặc định là hôm nay
-- We’ll use the GETDATE() function to get the current date and time 
-- Then we’ll use the CAST() function to convert the returned datetime data type into a date data type (without time)
job nvarchar(20) not null,
constraint CK_valid_salary check (salary > 0), -- lương là số nguyên dương
constraint CK_valid_name check (len(name) >= 2), -- tên không được phép ngắn hơn 2 ký tự (len() function return the length of string)
constraint CK_valid_age check (year(GETDATE()) - year(dateOfBirth) > 18), -- tuổi phải lớn hơn 18
constraint CK_valid_job check (job in ('IT', N'kế toán', N'doanh nhân thành đạt')), -- (*) nghề nghiệp phải nằm trong danh sách ('IT','kế toán','doanh nhân thành đạt')
primary key(id) -- mã nhân viên không được phép trùng: primary key = unique + not null
-- tất cả các cột không được để trống -> not null
)

-- 1. Công ty có 5 nhân viên
insert into employee(name, dateOfBirth, gender, dateJoined, job, salary)
values
('Long','1997-01-01',1,'2022-06-01','IT',100),
(N'Tuấn','1989-06-16',default, '2021-05-01', N'doanh nhân thành đạt', 200),
(N'Anh','1999-05-26',0,default,N'kế toán', 30),
(N'Tuấn','1996-04-20',1,'2019-05-22','IT', 700)

insert into employee(name, dateOfBirth, job, salary)
values
(N'Trúc','1995-06-12',N'kế toán', 500),
(N'Quỳnh','1997-07-25',N'kế toán', 40)

-- 2. Tháng này sinh nhật sếp, sếp tăng lương cho nhân viên sinh tháng này thành 100
update employee
set
salary = 100
where MONTH(dateOfBirth) = MONTH(GETDATE())

-- (*: tăng lương cho mỗi bạn thêm 100)
update employee
set
salary += 100

-- 3. Dịch dã khó khăn, cắt giảm nhân sự, cho nghỉ việc bạn nào lương dưới 50
delete from employee
where
salary < 50

-- (*: xoá cả bạn vừa thêm 100 nếu lương cũ dưới 50)
delete from employee
where
salary - 100 < 50 and MONTH(dateOfBirth) = MONTH(GETDATE())
-- MONTH(dateOfBirth) = MONTH(GETDATE()) để xóa đúng những bạn được tăng lương (thêm 100) do sinh cùng tháng với sếp
-- lương cũ = lương mới - 100

-- (**: đuổi cả nhân viên mới vào làm dưới 2 tháng)
delete from employee
where
DATEDIFF(month, dateJoined, GETDATE()) < 2 
and 
dateJoined < GETDATE() -- trong trường hợp nhân viên đăng ký vào làm sau thời điểm hiện tại => vẫn giữ lại

-- 4. Lấy ra tổng tiền mỗi tháng sếp phải trả cho nhân viên
select sum(salary) as 'Total salary boss must pay for employee each month' from employee

-- (*: theo từng nghề)
select job, sum(salary) as 'Total salary boss must pay for job each month' from employee
GROUP BY job 

-- 5. Lấy ra trung bình lương nhân viên
select avg(salary) as 'Average salary' from employee

-- (*: theo từng nghề)
select job, avg(salary) as 'Average salary of job' from employee
GROUP BY job	

-- 6. (*) Lấy ra các bạn mới vào làm hôm nay
select * from employee 
where dateJoined = CAST(GETDATE() as date)

-- 7. (*) Lấy ra 3 bạn nhân viên cũ nhất
-- TOP clause 
select top 3 * from employee
order by dateJoined asc

-- OFFSET FETCH clauses 
-- Bỏ qua 3 bạn nhân viên cũ đầu tiên lấy 3 bạn nhân viên cũ tiếp theo
select * from employee
order by dateJoined asc
OFFSET 3 ROWS -- bỏ qua 3 dòng đầu tiên
FETCH NEXT 3 ROWS ONLY; -- lấy 3 dòng tiếp theo

select name, gender,sum(salary) from employee
group by gender,name

-- 8. (**) Tách những thông tin trên thành nhiều bảng cho dễ quản lý, lương 1 nhân viên có thể nhập nhiều lần

drop table employee