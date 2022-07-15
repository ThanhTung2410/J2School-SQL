--Có 2 bảng

--Kho (mã, tên, tổng tài sản, sức chứa)

--Sản phẩm (mã, tên, số lượng, giá trị, mã kho)

--1. Tạo procedure để thêm và hiển thị lại giá trị vừa thêm ở từng bảng
--2. Tạo trigger phù hợp để:
	--Khi cập nhật sản phẩm thì cập nhật tổng tài sản tương ứng với kho
	--Khi xoá kho thì kiểm tra sản phẩm có tồn tại không, nếu không mới được xoá
	--(*: Kiểm tra sức chứa tương ứng với tổng số lượng sản phẩm, nếu còn dư mới được cập nhật vào kho đó)

CREATE TABLE kho (
ma int,
ten varchar(50),
tong_tai_san float,
suc_chua int,
PRIMARY KEY(ma)
)

CREATE TABLE san_pham (
ma int,
ten varchar(50),
gia_tri float,
so_luong int,
ma_kho int, 
FOREIGN KEY (ma_kho) REFERENCES kho(ma),
PRIMARY KEY(ma)
)

CREATE OR ALTER PROCEDURE them_va_hien_thi_gia_tri_vua_them_o_bang_kho
@ma int, 
@ten varchar(50),
@tong_tai_san float,
@suc_chua int
AS
BEGIN
	INSERT INTO kho
	VALUES 
	(@ma, @ten, @tong_tai_san, @suc_chua)

	SELECT * FROM kho 
	WHERE
	ma = @ma
END

CREATE OR ALTER PROCEDURE them_va_hien_thi_gia_tri_vua_them_o_bang_san_pham
@ma int,
@ten varchar(50),
@gia_tri float,
@so_luong int,
@ma_kho int
AS
BEGIN
	INSERT INTO san_pham
	VALUES 
	(@ma, @ten, @so_luong, @gia_tri, @ma_kho)

	SELECT * FROM san_pham
	WHERE
	ma = @ma
END

-- J2TeamNNL

-- UPDATE: INSERT + DELETE

CREATE OR ALTER TRIGGER cap_nhat_san_pham
ON san_pham
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
	UPDATE kho
	SET tong_tai_san += i.tong_tai_san_moi
	FROM kho 
	INNER JOIN (
		SELECT 
		ma_kho, 
		SUM(gia_tri * so_luong) as tong_tai_san_moi
		FROM inserted
		GROUP BY ma_kho
	) as i
	ON kho.ma = i.ma_kho

	UPDATE kho
	SET tong_tai_san -= d.tong_tai_san_cu
	FROM kho 
	INNER JOIN (
		SELECT 
		ma_kho, 
		SUM(gia_tri * so_luong) as tong_tai_san_cu
		FROM deleted
		GROUP BY ma_kho
	) as d
	ON kho.ma = d.ma_kho
END

CREATE OR ALTER TRIGGER xoa_kho
ON kho
INSTEAD OF DELETE
AS 
BEGIN
	-- chỉ xóa kho không có sản phẩm theo chỉ định chứ không phải kho nào không có sản phẩm cũng xóa
	DELETE FROM
	kho
	WHERE ma IN (SELECT ma FROM deleted 
				 WHERE ma not in (SELECT ma_kho FROM san_pham) 
				)

	SELECT 
	ma,
	N'Không xóa được vì có sản phẩm' as thong_bao
	FROM kho
	WHERE ma IN (SELECT ma FROM deleted 
				 WHERE ma in (SELECT ma_kho FROM san_pham) 
				)
END

SELECT * FROM kho
SELECT * FROM san_pham

DELETE FROM kho
DELETE FROM san_pham

INSERT INTO kho
VALUES
(1, 'A', 0, 10),
(2, 'B', 0, 20)

INSERT INTO san_pham
VALUES
(1, 'Bút', 5, 1, 1),
(2, 'Sách', 10, 2, 1),
(3, 'Vở', 20, 2, 2)

UPDATE san_pham
SET
ma_kho = 1