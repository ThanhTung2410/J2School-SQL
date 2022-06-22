-- Sửa bài tập buổi 3 và hàm cơ bản 

create table grade(
id int identity, 
name nvarchar(50), 
grade_first_time float default 5, 
grade_second_time float,
primary key(id),
constraint CK_valid_grade check ((grade_first_time >= 0 and grade_first_time <= 10) and (grade_second_time >= 0 and grade_second_time <= 10))
)

-- (*) điểm lần 2 không được nhập khi mà điểm lần 1 lớn hơn hoặc bằng 5
alter table grade
add constraint CK_input_grade_second_time check ((grade_first_time >= 5 and grade_second_time is null) or grade_first_time < 5) 

-- (**) tên không được phép ngắn hơn 2 ký tự
alter table grade 
add constraint CK_valid_name check (len(name) > 2)

-- 1. Điền 5 sinh viên kèm điểm
insert into grade(name, grade_first_time, grade_second_time)
values 
(N'Trúc', 7, null),
('Long', 1, 3),
(N'Tuấn', 3, 7),
('Anh', 6, null)

select * from grade

-- 2. Lấy ra các bạn điểm lần 1 hoặc lần 2 lớn hơn 5
select * from grade 
where 
grade_first_time > 5 or grade_second_time > 5

-- 3. Lấy ra các bạn qua môn ngay từ lần 1
select * from grade 
where 
grade_first_time >= 5

-- 4. Lấy ra các bạn trượt môn (điểm lần 1 và lần 2 đều dưới 5)
select * from grade 
where
grade_first_time < 5 and grade_second_time < 5

-- 5. (*) Đếm số bạn qua môn
select count(*) as numberOfStudentPassed from grade
where 
grade_first_time >= 5 or grade_second_time >= 5

-- Đếm số bạn trượt lần 1 và qua môn sau lần 2
select count(*) as numberOfStudentPassedWhenTakeExamSecondTime from grade
where
grade_second_time >= 5

--(**) Đếm số bạn cần phải thi lần 2 (tức là thi lần 1 chưa qua nhưng chưa nhập điểm lần 2)
insert into grade(name, grade_first_time, grade_second_time)
values 
(N'Minh', 3, null)
select * from grade 
where grade_first_time < 5 and grade_second_time is null

update grade
set 
grade_second_time = 3 
where
id = 7

-- Lấy ra các bạn có điểm lần 2
select * from grade 
where 
grade_second_time is not null

-- Đếm số bạn có điểm lần 2
select count(*) from grade 
where 
grade_second_time is not null
-- tương đương với
select count(grade_second_time) from grade 

select grade_second_time from grade
select sum(grade_second_time) as sum_grade_second_time from grade
select count(grade_second_time) as num_student_have_grade_second_time from grade
select avg(grade_second_time) as average_grade_second_time from grade

select * from grade 
insert into grade(name, grade_first_time, grade_second_time)
values 
('Long', 7, null)


-- đếm có bao nhiêu họ tên (lọc trùng)
select name from grade
select distinct name as name_remove_duplicate from grade -- distinct: lọc trùng (sắp xếp lại để so sánh)
select count(distinct name) as count_name from grade

-- Sắp xếp tên
select name from grade
order by name asc

drop table grade