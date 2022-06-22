create database gradeManagement
use gradeManagement 

create table grade(
id int identity, 
name nvarchar(50) not null, 
-- tên không được phép ngắn hơn 2 ký tự
grade_first_time float CONSTRAINT df_grade_first_time DEFAULT(5), 
-- điểm lần 1 nếu không nhập mặc định sẽ là 5
grade_second_time float not null,
CONSTRAINT CK_valid_grade check ((grade_first_time >= 0 and grade_first_time <= 10) and (grade_second_time >= 0 and grade_second_time <= 10)),
-- điểm không được phép nhỏ hơn 0 và lớn hơn 10
primary key(id)
)

-- 1. Điền 5 sinh viên kèm điểm

insert into grade(name, grade_first_time, grade_second_time)
values 
(N'Tuấn', 2, 1.5), 
(N'Quỳnh', 6, 3),
(N'Trúc', 2.3, 8)

insert into grade(name, grade_second_time)
values
(N'Long', 9.75),
(N'Khang', 3)

-- 2. Lấy ra các bạn điểm lần 1 hoặc lần 2 lớn hơn 5
select * from grade 
where grade_first_time > 5 or grade_second_time > 5

-- 3. Lấy ra các bạn qua môn ngay từ lần 1
select * from grade 
where grade_first_time >= 5

-- 4. Lấy ra các bạn trượt môn
select * from grade 
where grade_first_time < 5 and grade_second_time < 5

-- 5. (*) Đếm số bạn qua môn sau khi thi lần 2 -> Chỉ đếm những bạn thi trượt ở lần 1 nhưng đậu ở lần 2
SELECT COUNT(*) as numberOfStudentPassedWhenTakeExamSecondTime from grade
where grade_first_time < 5 and grade_second_time >= 5

-- 6. (**) Đếm số bạn cần phải thi lần 2 (tức là thi lần 1 chưa qua nhưng chưa nhập điểm lần 2)

drop table grade