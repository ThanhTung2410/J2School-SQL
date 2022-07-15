CREATE DATABASE QLBV
USE QLBV

CREATE TABLE khoa (
ma varchar(10),
ten nvarchar(50) UNIQUE,
nam_thanh_lap date,
PRIMARY KEY(ma)
)

CREATE TABLE nhan_vien (
ma varchar(10),
ten nvarchar(50),
ngay_sinh date,
ma_khoa varchar(10),
FOREIGN KEY (ma_khoa) REFERENCES khoa(ma),
PRIMARY KEY(ma)
)

CREATE TABLE benh_nhan (
ma varchar(10),
ten nvarchar(50),
ngay_sinh date,
benh nvarchar(50),
ma_khoa varchar(10),
ngay_nhap date,
ngay_xuat date,
FOREIGN KEY (ma_khoa) REFERENCES khoa(ma),
PRIMARY KEY(ma)
)

INSERT INTO khoa
VALUES
('K01', N'Khoa Nội', '1989-03-23'),
('K02', N'Khoa Ngoại', '1989-03-23'),
('K03', N'Khoa Nhi', '1989-03-23'),
('K04', N'Khoa Thần kinh', '1993-06-15 ')

INSERT INTO nhan_vien 
VALUES
('N001', N'Tôn Thất Tùng', '1939-03-02', 'K01'),
('N002', N'Trần Quán Anh', '1945-06-20', 'K01'),
('N003', N'Phạm Thị Tươi', '1966-06-24', 'K02'),
('N004', N'Phạm Thanh Thảo', '1975-10-20', 'K02'),
('N005', N'Nguyễn Hà Thanh', '1977-11-02', 'K02'),
('N008', N'Tô Huy Rứa', '1950-02-13', 'K03'),
('N009', N'Vũ Thái Hà', '1960-03-15', 'K03'),
('N010', N'Phạm Văn Hùng', '1970-12-13', 'K04'),
('N011', N'Nguyễn Vũ Trường Sơn', '1965-03-15', 'K04')

INSERT INTO benh_nhan
VALUES
('B0001', N'Nguyễn Quang A', '1945-04-05', N'Đau ruột thừa', 'K01', '2009-03-12', '2009-03-18'),
('B0002', N'Trần Văn Tuất', '1946-04-15', N'Đau đầu', 'K04', '2009-03-12', '2009-03-23'),
('B0003', N'Phạm Tuấn Tú', '2003-09-15', N'Viêm họng', 'K03', '2009-03-15', '2009-03-20'),
('B0006', N'Phạm Thị Mùi', '2008-03-05', N'Đau dại dày', 'K03', '2009-03-19', '2009-04-20'),
('B0007', N'Tô Hương Linh', '1995-02-15', N'Viêm dạ dày', 'K01', '2009-04-01', '2009-04-21'),
('B0008', N'Trường Giang', '1992-02-15', N'Đau chân', 'K02', '2009-04-05', '2009-04-12'),
('B0010', N'Tăng Thanh Hà', '1987-10-15', N'Viêm họng', 'K01', '2009-04-12', '2009-04-12')

-- a)	Hãy thống kê số lượng bệnh nhân theo khoa
SELECT
khoa.ten,
COUNT(benh_nhan.ma_khoa) as so_luong_benh_nhan
FROM
benh_nhan
INNER JOIN khoa
ON khoa.ma = benh_nhan.ma_khoa
GROUP BY (khoa.ten)

-- b)	Hãy thống kê số lượng nhân viên theo khoa
SELECT
khoa.ten,
COUNT(nhan_vien.ma_khoa) as so_luong_nhan_vien
FROM
nhan_vien
INNER JOIN khoa
ON khoa.ma = nhan_vien.ma_khoa
GROUP BY (khoa.ten)

-- c)	Tạo mới một bảng ảo tên là benhnhankhoanhi gồm đầy đủ thông tin của các bệnh nhân khoa Nhi
CREATE OR ALTER VIEW benhnhankhoanhi
AS
SELECT 
benh_nhan.ma,
benh_nhan.ten,
benh_nhan.ngay_sinh,
benh_nhan.benh,
--benh_nhan.ma_khoa,
benh_nhan.ngay_nhap,
benh_nhan.ngay_xuat
FROM 
benh_nhan
INNER JOIN khoa 
ON khoa.ma = benh_nhan.ma_khoa
WHERE khoa.ten = 'Khoa Nhi'

SELECT * FROM benhnhankhoanhi

-- d)	Tạo mới một thủ tục tên là DSNV liệt kê đầy đủ thông tin về các nhân viên của một khoa nào đó. Thủ tục này có tham số truyền vào là tên một khoa
CREATE OR ALTER PROCEDURE DSNV
@ten nvarchar(50)
AS
BEGIN
	SELECT 
	nhan_vien.ma,
	nhan_vien.ten,
	nhan_vien.ngay_sinh,
	khoa.ten as ten_khoa
	FROM nhan_vien
	INNER JOIN khoa
	ON khoa.ma = nhan_vien.ma_khoa
	WHERE khoa.ten = @ten
END

EXEC DSNV @ten = N'Khoa Nội'

-- e)	Tạo thủ tục có tên là PSnhanvien với tham số đưa vào là Mã khoa, thông tin trả ra là MaNV, TenNV, Ngay sinh của nhân viên thuộc khoa đó
CREATE OR ALTER PROCEDURE PSnhanvien 
@ma_khoa varchar(10)
AS
BEGIN
	SELECT 
	nhan_vien.ma,
	nhan_vien.ten,
	nhan_vien.ngay_sinh,
	khoa.ma as ma_khoa
	FROM nhan_vien
	INNER JOIN khoa
	ON khoa.ma = nhan_vien.ma_khoa
	WHERE khoa.ma = @ma_khoa
END

EXEC PSnhanvien @ma_khoa = 'K02'

-- f)	Tạo trigger thỏa mãn điều kiện không có 2 khoa trùng tên
CREATE OR ALTER TRIGGER them_khoa
ON khoa
INSTEAD OF INSERT
AS
BEGIN
	
END