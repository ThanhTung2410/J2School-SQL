CREATE TABLE lop (
ma int identity,
ten nvarchar(50),
so_luong_sinh_vien int DEFAULT 0,
PRIMARY KEY(ma)
)

INSERT INTO lop(ten)
VALUES 
('SQL'), 
('Web')

CREATE TABLE sinh_vien (
ma int identity,
ten nvarchar(50),
ma_lop int,
FOREIGN KEY(ma_lop) REFERENCES lop(ma),
PRIMARY KEY(ma)
)

-- Cơ bản (chỉ insert, update, delete 1 sinh viên tại 1 thời điểm)
CREATE OR ALTER TRIGGER trigger_them_sinh_vien
ON sinh_vien -- trigger được kích hoạt khi có sự thay đổi đói với table sinh_vien
AFTER INSERT
AS
BEGIN
	DECLARE @ma_lop int = (SELECT ma_lop FROM inserted)

	UPDATE lop
	SET
	so_luong_sinh_vien += 1
	WHERE ma = @ma_lop
END

INSERT INTO sinh_vien
VALUES
('Long',1),

CREATE OR ALTER TRIGGER trigger_xoa_sinh_vien
ON sinh_vien
AFTER DELETE
AS
BEGIN
	DECLARE @ma_lop int = (SELECT ma_lop FROM deleted)

	UPDATE lop
	SET
	so_luong_sinh_vien -= 1
	WHERE ma = @ma_lop
END

DELETE  FROM sinh_vien WHERE ma = 1

CREATE OR ALTER TRIGGER trigger_chuyen_lop_cho_sinh_vien
ON sinh_vien
AFTER UPDATE 
AS
BEGIN
	DECLARE @ma_lop_cu INT = (SELECT ma_lop FROM deleted)
	UPDATE lop
	SET
	so_luong_sinh_vien -= 1
	WHERE ma = @ma_lop_cu

	DECLARE @ma_lop_moi INT = (SELECT ma_lop FROM inserted)
	UPDATE lop
	SET
	so_luong_sinh_vien += 1
	WHERE ma = @ma_lop_moi
END

UPDATE sinh_vien
SET 
ma_lop = 2
WHERE ma = 1

-- Nâng cao (insert, update, delete nhiều sinh viên tại 1 thời điểm)

CREATE OR ALTER TRIGGER trigger_them_nhieu_sinh_vien
ON sinh_vien
AFTER INSERT
AS
BEGIN
	UPDATE lop
	SET 
	so_luong_sinh_vien += i.so_luong_sinh_vien_them
	FROM lop
	INNER JOIN 
	(SELECT ma_lop, count(ma_lop) as so_luong_sinh_vien_them FROM inserted 
	GROUP BY ma_lop) as i
	ON lop.ma = i.ma_lop
END

INSERT INTO sinh_vien
VALUES
('Long',1),
('Tuan',2)

CREATE OR ALTER TRIGGER trigger_xoa_nhieu_sinh_vien
ON sinh_vien
AFTER DELETE
AS
BEGIN
	UPDATE lop
	SET 
	so_luong_sinh_vien -= d.so_luong_sinh_vien_xoa
	FROM lop
	INNER JOIN 
	(SELECT ma_lop, count(ma_lop) as so_luong_sinh_vien_xoa FROM deleted 
	GROUP BY ma_lop) as d
	ON lop.ma = d.ma_lop
END

DELETE FROM sinh_vien

CREATE OR ALTER TRIGGER trigger_chuyen_lop_cho_nhieu_sinh_vien
ON sinh_vien
AFTER UPDATE
AS
BEGIN
	-- trừ số lượng sinh viên muốn chuyển lớp ở lớp cũ
	UPDATE lop
	SET 
	so_luong_sinh_vien -= d.so_luong_sinh_vien_xoa
	FROM lop
	INNER JOIN 
	(SELECT ma_lop, count(ma_lop) as so_luong_sinh_vien_xoa FROM deleted 
	GROUP BY ma_lop) as d
	ON lop.ma = d.ma_lop

	-- cộng số lượng sinh viên chuyển vào lớp mới
	UPDATE lop
	SET 
	so_luong_sinh_vien += i.so_luong_sinh_vien_them
	FROM lop
	INNER JOIN 
	(SELECT ma_lop, count(ma_lop) as so_luong_sinh_vien_them FROM inserted 
	GROUP BY ma_lop) as i
	ON lop.ma = i.ma_lop
END