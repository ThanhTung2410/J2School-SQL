CREATE DATABASE quanLySinhVien
use quanLySinhVien

CREATE TABLE lop (
ma int identity,
ten nvarchar(50),
PRIMARY KEY(ma)
)

INSERT INTO lop 
VALUES
('LT'),
('ATTT')

CREATE TABLE sinh_vien (
ma int identity,
ten nvarchar(50),
gioi_tinh bit,
ngay_sinh date,
ma_lop int,
FOREIGN KEY(ma_lop) REFERENCES lop(ma),
PRIMARY KEY(ma)
)

INSERT INTO sinh_vien
VALUES
('Long',1,'1997-01-01',1),
('Tuấn',0,'2000-01-01',2)

SELECT 
ma,
ten,
dbo.func_ten_gioi_tinh(gioi_tinh) as ten_gioi_tinh,
dbo.func_lay_tuoi(ngay_sinh) as tuoi,
ma_lop
FROM sinh_vien


CREATE FUNCTION func_ten_gioi_tinh (@gioi_tinh bit)
RETURNS nvarchar(50)
AS
BEGIN
	RETURN CASE WHEN @gioi_tinh = 1 THEN 'Nam' ELSE N'Nữ' END
END

CREATE FUNCTION func_lay_tuoi (@ngay_sinh date)
RETURNS int
AS
BEGIN
	RETURN DATEDIFF(year, @ngay_sinh, GETDATE())
END

CREATE FUNCTION func_join_2_bang_va_hien_thi_toan_bo_thong_tin_sv (@ma int)
RETURNS TABLE
RETURN 
	(SELECT 
	sinh_vien.ma,
	sinh_vien.ten,
	dbo.func_ten_gioi_tinh(sinh_vien.gioi_tinh) as ten_gioi_tinh,
	dbo.func_lay_tuoi(sinh_vien.ngay_sinh) as tuoi,
	lop.ten as ten_lop
	FROM sinh_vien
	INNER JOIN lop
	ON lop.ma = sinh_vien.ma_lop
	WHERE sinh_vien.ma = @ma)

SELECT * FROM dbo.func_join_2_bang_va_hien_thi_toan_bo_thong_tin_sv(2)