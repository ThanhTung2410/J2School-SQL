-- Sửa bài tập buổi 6

create table khach_hang (
ma int identity,
ho nvarchar(20) not null,
ten nvarchar(20) not null,
sdt varchar(15) not null,
gioi_tinh bit not null,
ngay_sinh date not null,
email varchar(50) not null,
PRIMARY KEY(ma)
)

create table mat_hang_san_pham (
ma int identity,
ten nvarchar(50) not null,
mo_ta nvarchar(100) not null,
gia float not null,
PRIMARY KEY(ma)
)

create table hoa_don (
ma int identity,
ma_khach_hang int not null,
ngay date not null,
FOREIGN KEY(ma_khach_hang) REFERENCES khach_hang(ma),
PRIMARY KEY(ma)
)

-- n hóa đơn - n mặt hàng sản phẩm
-- => Tạo bảng trung gian

create table hoa_don_chi_tiet (
ma_hoa_don int not null,
ma_mat_hang_san_pham int not null,
so_luong int not null,
FOREIGN KEY(ma_hoa_don) REFERENCES hoa_don(ma),
FOREIGN KEY(ma_mat_hang_san_pham) REFERENCES mat_hang_san_pham(ma),
PRIMARY KEY(ma_hoa_don, ma_mat_hang_san_pham)
)

-- Buổi 7 

-- 1 lớp - n sinh viên
create table lop (
ma int identity,
ten nvarchar(50) not null unique,
PRIMARY KEY (ma)
)

INSERT INTO lop(ten) 
VALUES 
('LT'),
('ATTT')

insert into lop(ten)
values ('hacker mu trang')

SELECT * FROM lop

create table sinh_vien (
ma int identity,
ten nvarchar(50) not null,
gioi_tinh bit not null default 0,
ma_lop int,
FOREIGN KEY(ma_lop) REFERENCES lop(ma),
PRIMARY KEY (ma)
)

INSERT INTO sinh_vien(ten, gioi_tinh, ma_lop)
VALUES
('Long', default, 1),
(N'Tuấn', 1, 1),
(N'Tuấn hacker', 1, 2)

insert into sinh_vien(ten)
values ('Longsky')

SELECT * FROM sinh_vien

-- Lấy ra thông tin sinh viên kèm lớp học của họ
SELECT *
FROM sinh_vien
inner join lop
on lop.ma = sinh_vien.ma_lop

-- Lấy ra thông tin sinh viên kèm thông tin lớp (nếu có)
SELECT *
FROM sinh_vien
left join lop
on sinh_vien.ma_lop = lop.ma

-- Lấy ra thông tin sinh viên không thuộc lớp nào
SELECT *
FROM sinh_vien
left join lop
on sinh_vien.ma_lop = lop.ma
where sinh_vien.ma_lop is null

-- Đếm số lượng sinh viên trong lớp LT
SELECT COUNT(*) as N'số sinh viên'
FROM sinh_vien
inner join lop
on sinh_vien.ma_lop = lop.ma
where lop.ten = 'LT'

SELECT 
lop.ma, 
COUNT(sinh_vien.ma_lop) as N'số sinh viên'
FROM sinh_vien
right join lop
on sinh_vien.ma_lop = lop.ma
GROUP BY (lop.ma)

-- Lấy ra thông tin lớp học kèm theo thông tin sinh viên học lớp đó (nếu có)
select *
from sinh_vien
right join lop 
on sinh_vien.ma_lop = lop.ma

-- -- Đếm số lượng sinh viên không thuộc lớp nào
SELECT COUNT(*) as 's'
FROM sinh_vien
left join lop
on sinh_vien.ma_lop = lop.ma
where sinh_vien.ma_lop is null