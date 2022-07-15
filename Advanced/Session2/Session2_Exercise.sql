CREATE DATABASE studentManagement
USE studentManagement

CREATE TABLE lop (
ma int identity,
ten nvarchar(50),
PRIMARY KEY(ma)
)

INSERT INTO lop
VALUES
('KHMT'),
('ATTT'),
('KTPM')

CREATE TABLE sinh_vien (
ma int identity, 
ten nvarchar(50),
gioi_tinh bit,
ma_lop int,
FOREIGN KEY(ma_lop) REFERENCES lop(ma),
PRIMARY KEY(ma)
)

INSERT INTO sinh_vien
VALUES
('Long', 1, 1),
(N'Tuấn', 1, 2),
(N'Trúc', 0, 2)

DROP PROCEDURE xem_sinh_vien
CREATE PROCEDURE xem_sinh_vien
@ma_lop int = null, -- in this case = is set default value which is null for parameter 
@ma_sinh_vien int = null
AS 
BEGIN
	SELECT * FROM sinh_vien
	INNER JOIN lop
	ON lop.ma = sinh_vien.ma_lop
	WHERE 
	sinh_vien.ma_lop = CASE WHEN @ma_lop is null THEN sinh_vien.ma_lop ELSE @ma_lop END -- in this case = is equal operator
	and
	sinh_vien.ma = CASE WHEN @ma_sinh_vien is null THEN sinh_vien.ma ELSE @ma_sinh_vien END
END

DROP PROCEDURE lay_lop_moi_nhat
CREATE PROCEDURE lay_lop_moi_nhat 
AS
BEGIN
	RETURN (SELECT TOP 1 ma FROM lop ORDER BY ma DESC)
END

DROP PROCEDURE them_sinh_vien
CREATE PROCEDURE them_sinh_vien
@ten nvarchar(50),
@gioi_tinh bit = 1,
@ma_lop int = null
AS
BEGIN
	SET @ma_lop = (CASE WHEN @ma_lop is null THEN 
	(SELECT TOP 1 ma FROM lop ORDER BY ma DESC) -- lấy lớp mới nhất
	END)
	-- DECLARE @ma_lop int = (CASE WHEN @ma_lop is null THEN 
	-- (SELECT TOP 1 ma FROM lop ORDER BY ma DESC) => Không cần khai báo parameter ở trên

	INSERT INTO sinh_vien
	VAlUES 
	(@ten, @gioi_tinh, @ma_lop)

	-- Hiển thị thông tin sinh viên vừa thêm
	SELECT TOP 1 * FROM sinh_vien
	ORDER BY ma DESC
END

CREATE PROCEDURE sua_sinh_vien
@ma_sinh_vien int,
@ten nvarchar(50) = null,
@gioi_tinh bit = null,
@ma_lop int = null
AS
BEGIN
	EXEC xem_sinh_vien @ma_sinh_vien = @ma_sinh_vien -- pass argument to procedure xem_sinh_vien which is setting value of parameter of that procedure

	UPDATE sinh_vien 
	SET 
	ten = CASE WHEN @ten is null THEN ten ELSE @ten END,
	gioi_tinh = CASE WHEN @gioi_tinh is null THEN gioi_tinh ELSE @gioi_tinh END,
	ma_lop = CASE WHEN @ma_lop is null THEN ma_lop ELSE @ma_lop END
	WHERE ma = @ma_sinh_vien

	EXEC xem_sinh_vien @ma_sinh_vien = @ma_sinh_vien
END

DROP PROCEDURE dem_so_luong_sinh_vien
CREATE PROCEDURE dem_so_luong_sinh_vien
@ma_lop int = null
AS
BEGIN
	SELECT COUNT(ma) FROM sinh_vien
	WHERE sinh_vien.ma_lop = CASE WHEN @ma_lop is null THEN sinh_vien.ma_lop ELSE @ma_lop END
END

DROP PROCEDURE xoa_sinh_vien
CREATE PROCEDURE xoa_sinh_vien
@ma_sinh_vien int = null,
@ten nvarchar(50) = null,
@gioi_tinh bit = null
AS
BEGIN 
	EXEC dem_so_luong_sinh_vien

	DELETE FROM sinh_vien
	WHERE ma = CASE WHEN @ma_sinh_vien is null then ma ELSE @ma_sinh_vien END
	and  ten = CASE WHEN @ten is null then ten ELSE @ten END
	and gioi_tinh = CASE WHEN @gioi_tinh is null then gioi_tinh ELSE @gioi_tinh END

	EXEC dem_so_luong_sinh_vien
END

DROP PROCEDURE hien_thi_so_luong_sinh_vien_cua_lop_ma_co_sinh_vien_bi_xoa_va_xoa_sinh_vien_do
CREATE PROCEDURE hien_thi_so_luong_sinh_vien_cua_lop_ma_co_sinh_vien_bi_xoa_va_xoa_sinh_vien_do
@ma_sinh_vien int = null,
@ten nvarchar(50) = null,
@gioi_tinh bit = null
AS
BEGIN 
	DECLARE @ma_lop INT
	SET @ma_lop = 
	(SELECT TOP 1 ma_lop from sinh_vien WHERE ma = @ma_sinh_vien or ten = @ten or gioi_tinh = @gioi_tinh)
	-- hoặc DECLARE @ma_lop INT = (SELECT ma_lop from sinh_vien WHERE ma = @ma_sinh_vien or ten = @ten or gioi_tinh = @gioi_tinh)

	EXEC dem_so_luong_sinh_vien @ma_lop = @ma_lop

	DELETE FROM sinh_vien
	WHERE ma = CASE WHEN @ma_sinh_vien is null then ma ELSE @ma_sinh_vien END
	and  ten = CASE WHEN @ten is null then ten ELSE @ten END
	and gioi_tinh = CASE WHEN @gioi_tinh is null then gioi_tinh ELSE @gioi_tinh END

	EXEC dem_so_luong_sinh_vien @ma_lop = @ma_lop
END

-- ***: hiển thị số lượng sinh viên trước và sau khi xoá của các lớp mà các lớp đó chứa các sinh viên bị xoá)