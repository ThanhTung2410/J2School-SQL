CREATE TABLE lop (
ma int,
ten varchar(50),
so_cho_trong int,
PRIMARY KEY(ma)
)

CREATE TABLE sinh_vien (
ma int,
ten varchar(50),
ma_lop int,
FOREIGN KEY(ma_lop) REFERENCES lop(ma),
PRIMARY KEY(ma)
)

-- Cơ bản

CREATE OR ALTER TRIGGER them_sinh_vien
ON sinh_vien
INSTEAD OF INSERT
AS 
BEGIN
	DECLARE @ma_lop int = (SELECT ma_lop FROM inserted)
	DECLARE @so_cho_trong int = (SELECT so_cho_trong FROM lop WHERE ma = @ma_lop)

	IF (@so_cho_trong = 0) 
		BEGIN
			PRINT(N'Lớp đã đủ sĩ số')
		END
	ELSE 
		BEGIN
			DECLARE @ma int = (SELECT ma FROM inserted)
			DECLARE @ten varchar(50) = (SELECT ten FROM inserted)

			INSERT INTO sinh_vien
			VALUES
			(@ma, @ten, @ma_lop) 

			UPDATE lop
			SET
			so_cho_trong -= 1
			WHERE ma = @ma_lop

			PRINT(N'Thêm sinh viên thành công')
		END
END

--CREATE OR ALTER TRIGGER xoa_sinh_vien
--ON sinh_vien
--INSTEAD OF DELETE
--AS 
--BEGIN
--	DECLARE @ma int = (SELECT ma FROM deleted)
--	DECLARE @ma_lop int = (SELECT ma_lop FROM deleted)

--	DELETE FROM sinh_vien
--	WHERE ma = @ma

--	PRINT(N'Xóa sinh viên thành công')

--	UPDATE lop
--	SET 
--	so_cho_trong += 1
--	WHERE ma = @ma_lop
--END

-- J2TeamNNL
-- Không cần phải kiểm tra điều kiện => Dùng trigger after không cần dùng trigger instead of
CREATE OR ALTER TRIGGER xoa_sinh_vien
ON sinh_vien
AFTER DELETE
AS 
BEGIN
	DECLARE @ma_lop int = (SELECT ma_lop FROM deleted)

	UPDATE lop
	SET 
	so_cho_trong += 1
	WHERE ma = @ma_lop
END

--CREATE OR ALTER TRIGGER sua_sinh_vien
--ON sinh_vien
--INSTEAD OF UPDATE
--AS 
--BEGIN
--	DECLARE @ma_lop_moi int = (SELECT ma_lop FROM inserted)
--	DECLARE @ma_lop_cu int = (SELECT ma_lop FROM deleted)
--	DECLARE @so_cho_trong_lop_moi int = (SELECT so_cho_trong FROM lop WHERE ma = @ma_lop_moi)

--	IF (@so_cho_trong_lop_moi = 0)
--		BEGIN
--			PRINT(N'Lớp này đã sĩ số sinh viên không được phép chuyển vào')
--		END
--	ELSE
--		BEGIN
--			-- Cập nhật lại số chỗ trống của lớp sinh viên chuyển đi
--			UPDATE lop 
--			SET
--			so_cho_trong += 1
--			WHERE ma = @ma_lop_cu

--			-- Cập nhật lại mã lớp cho sinh viên
--			DECLARE @ma int = (SELECT ma FROM inserted)
--			UPDATE sinh_vien 
--			SET
--			ma_lop = @ma_lop_moi
--			WHERE ma = @ma

--			-- Cập nhật lại số chỗ trống của lớp sinh viên chuyển vào 
--			UPDATE lop 
--			SET
--			so_cho_trong -= 1
--			WHERE ma = @ma_lop_moi

--			PRINT(N'Sinh viên đã chuyển lớp thành công')
--		END
--END

-- J2TeamNNL
CREATE OR ALTER TRIGGER sua_sinh_vien
ON sinh_vien
INSTEAD OF UPDATE
AS 
BEGIN
	-- Lấy mã lớp mới từ bảng inserted
	DECLARE @ma_lop_moi int = (SELECT ma_lop FROM inserted)

	-- Lấy số chỗ trống từ lớp theo mã lớp mới
	DECLARE @so_cho_trong_lop_moi int = (SELECT so_cho_trong FROM lop WHERE ma = @ma_lop_moi)

	IF (@so_cho_trong_lop_moi = 0)
		BEGIN
			PRINT(N'Lớp này đã sĩ số sinh viên không được phép chuyển vào')
		END
	ELSE
		BEGIN
			-- Cập nhật số chỗ trống - 1 theo mã lớp mới 
			UPDATE lop 
			SET
			so_cho_trong -= 1
			WHERE ma = @ma_lop_moi

			-- Lấy mã lớp củ từ bảng deleted
			DECLARE @ma_lop_cu int = (SELECT ma_lop FROM deleted)

			-- Cập nhật số chỗ trống + 1 theo mã lớp cũ 
			UPDATE lop 
			SET
			so_cho_trong += 1
			WHERE ma = @ma_lop_cu

			-- Xóa sinh viên theo mã
			DECLARE @ma_sinh_vien int = (SELECT ma FROM inserted)
			DELETE FROM sinh_vien
			WHERE ma = @ma_sinh_vien

			-- Insert lại sinh viên theo toàn bộ dữ liệu từ bảng inserted
			DECLARE @ten varchar(50) = (SELECT ten FROM inserted)
			INSERT INTO sinh_vien
			VALUES
			(@ma_sinh_vien, @ten, @ma_lop_moi)
		END
END

INSERT INTO sinh_vien
VALUES
(1, 'Long', 1)

DELETE FROM sinh_vien
WHERE ma = 1

UPDATE sinh_vien
SET 
ma_lop = 2
WHERE ma = 1

-- Nâng cao

-- Số lượng sinh viên sẽ thêm vào 1 lớp
--SELECT
--ma_lop, 
--COUNT(ma_lop) as so_luong_sinh_vien_se_them
--FROM inserted
--GROUP BY ma_lop

-- How to insert all data from table inserted to specified table without declaring variable 
--INSERT INTO sinh_vien 
--SELECT * FROM inserted

CREATE OR ALTER TRIGGER them_nhieu_sinh_vien
ON sinh_vien
INSTEAD OF INSERT
AS
BEGIN
	-- Lấy các lớp thỏa mãn khi insert thêm sinh viên
	--SELECT 
	--lop.ma
	--FROM 
	--lop 
	--INNER JOIN 
	--(SELECT
	--ma_lop, 
	--COUNT(ma_lop) as so_luong_sinh_vien_se_them
	--FROM inserted
	--GROUP BY ma_lop) AS i
	--ON lop.ma = i.ma_lop
	--WHERE lop.so_cho_trong >= i.so_luong_sinh_vien_se_them

	INSERT INTO sinh_vien
	SELECT * FROM inserted 
	WHERE ma_lop in (
		SELECT 
		lop.ma
		FROM 
		lop 
		INNER JOIN 
		(SELECT
		ma_lop, 
		COUNT(ma_lop) as so_luong_sinh_vien_se_them
		FROM inserted
		GROUP BY ma_lop) AS i
		ON lop.ma = i.ma_lop
		WHERE lop.so_cho_trong >= i.so_luong_sinh_vien_se_them
	)

	UPDATE lop
	SET
	so_cho_trong -= i.so_luong_sinh_vien_se_them
	FROM 
	lop 
	INNER JOIN 
	(SELECT
	ma_lop, 
	COUNT(ma_lop) as so_luong_sinh_vien_se_them
	FROM inserted
	GROUP BY ma_lop) AS i
	ON lop.ma = i.ma_lop
	WHERE so_cho_trong >= i.so_luong_sinh_vien_se_them
END

-- nếu số lượng sinh viên chuyển vào lớp mới > số chỗ trống của lớp đó => Giữ nguyên
CREATE OR ALTER TRIGGER sua_nhieu_sinh_vien
ON sinh_vien
INSTEAD OF UPDATE
AS
BEGIN
	-- Bảng số lượng sinh viên chuyển vào lớp mới (SAI)
	-- ĐẾM NHƯ NÀY LÀ ĐẾM NHỮNG SINH VIÊN CHUYỂN VÀO LỚP MỚI VÀ ĐẾM LUÔN NHỮNG SINH VIÊN ĐÃ CÓ SẴN TRONG LỚP ĐÓ  
	--SELECT
	--ma_lop,
	--COUNT(ma_lop) as so_luong_sinh_vien_se_chuyen
	--FROM inserted
	--GROUP BY ma_lop

	-- Nối bảng lớp với bảng số lượng sinh viên chuyển vào lớp mới
	--SELECT 
	--*
	--FROM 
	--lop
	--INNER JOIN
	--	(SELECT
	--	ma_lop,
	--	COUNT(ma_lop) as so_luong_sinh_vien_se_chuyen
	--	FROM inserted
	--	GROUP BY ma_lop) as i
	--ON lop.ma = i.ma_lop

	-- Lấy ra những lớp sinh viên có thể chuyển vào
	--SELECT 
	--ma_lop
	--FROM 
	--lop
	--INNER JOIN
	--	(SELECT
	--	ma_lop,
	--	COUNT(ma_lop) as so_luong_sinh_vien_se_chuyen
	--	FROM inserted
	--	GROUP BY ma_lop) as i
	--ON lop.ma = i.ma_lop
	--WHERE so_luong_sinh_vien_se_chuyen <= so_cho_trong

	-- Phải delete các sinh viên chuyển vào lớp mới thỏa mãn điều kiện số lượng sinh viên chuyển vào lớp <= số chỗ trống của lớp đó trong bảng sinh_vien 
	-- trước khi insert vào để cập nhật mã lớp nếu không sẽ bị báo lỗi do PRIMARY KEY ở cột mã

	-- DEBUG - START

	--SELECT * FROM deleted
	--SELECT * FROM inserted

	--SELECT
	--*
	--FROM inserted
	--WHERE ma not in (SELECT ma FROM deleted WHERE ma_lop = inserted.ma_lop)

	--SELECT
	--*
	--FROM deleted
	--WHERE ma not in (SELECT ma FROM inserted WHERE ma_lop = deleted.ma_lop)

	-- DEBUG - END
	
	-- Khi nối bảng thì phải chọn bảng cụ thể để xóa
	DELETE sinh_vien
	FROM sinh_vien
	JOIN inserted
	ON sinh_vien.ma = inserted.ma
	WHERE inserted.ma_lop in (
		SELECT 
		ma_lop
		FROM 
		lop
		INNER JOIN
			(SELECT
			ma_lop,
			COUNT(ma_lop) as so_luong_sinh_vien_se_chuyen
			FROM inserted
			WHERE ma not in (SELECT ma FROM deleted WHERE ma_lop = inserted.ma_lop) -- WHERE theo mã sinh viên không nằm sẵn trong lớp đó (chuyển lớp)
			-- SELECT ma FROM deleted WHERE ma_lop = inserted.ma_lop lấy các mã sinh viên đã nằm sẵn trong lớp đó
			GROUP BY ma_lop) as i
			-- những sinh viên đã nằm sẵn trong lớp đó thì giữ nguyên chỉ đếm những sinh viên chuyển lớp
		ON lop.ma = i.ma_lop
		WHERE so_luong_sinh_vien_se_chuyen <= so_cho_trong
	)

	-- Phải cập nhật số chỗ trống cho lớp cũ trước khi cập nhật số chỗ trống cho lớp mới nếu không sẽ ra sai kết quả (ở chỗ exists) 
	-- Cập nhật lại số chỗ trống cho lớp cũ
	UPDATE lop
	SET so_cho_trong += d.so_luong_sinh_vien_se_chuyen
	FROM lop
	JOIN
	-- join đến table deleted để lấy mã lớp cũ của các sinh viên chuyển sang lớp mới và số lượng các sinh viên sẽ chuyển
	-- để cập nhật lại số chỗ trống cho các lớp đó
		(SELECT
			ma_lop,
			COUNT(ma_lop) as so_luong_sinh_vien_se_chuyen
			FROM deleted
			WHERE ma not in (SELECT ma FROM inserted WHERE ma_lop = deleted.ma_lop)
			GROUP BY ma_lop
		) as d
	ON lop.ma = d.ma_lop
	WHERE 
	-- Kiểm tra lớp các sinh viên muốn chuyển vào có được thêm sinh viên vào hay không, nếu được thì mới cho cập nhật
	EXISTS (
		SELECT 
		* 
		FROM lop
		INNER JOIN
			(SELECT
			ma_lop,
			COUNT(ma_lop) as so_luong_sinh_vien_se_chuyen
			FROM inserted
			WHERE ma not in (SELECT ma FROM deleted WHERE ma_lop = inserted.ma_lop)
			GROUP BY ma_lop) as i
		ON lop.ma = i.ma_lop
		WHERE so_luong_sinh_vien_se_chuyen <= so_cho_trong
	)

	-- Cập nhật mã lớp cho các sinh viên khi lớp thỏa mãn điều kiện số lượng sinh viên chuyển vào lớp <= số chỗ trống của lớp đó
	INSERT INTO sinh_vien
	SELECT * FROM inserted
	WHERE ma_lop in (
		SELECT 
		ma_lop
		FROM 
		lop
		INNER JOIN
			(SELECT
			ma_lop,
			COUNT(ma_lop) as so_luong_sinh_vien_se_chuyen
			FROM inserted
			WHERE ma not in (SELECT ma FROM deleted WHERE ma_lop = inserted.ma_lop)
			GROUP BY ma_lop) as i
		ON lop.ma = i.ma_lop
		WHERE so_luong_sinh_vien_se_chuyen <= so_cho_trong
	)

	-- Cập nhật lại số chỗ trống cho lớp các sinh viên mới chuyển vào
	UPDATE lop
	SET so_cho_trong -= i.so_luong_sinh_vien_se_chuyen
	FROM lop
	JOIN
		(SELECT
			ma_lop,
			COUNT(ma_lop) as so_luong_sinh_vien_se_chuyen
			FROM inserted
			WHERE ma not in (SELECT ma FROM deleted WHERE ma_lop = inserted.ma_lop)
			GROUP BY ma_lop
		) as i
	ON lop.ma = i.ma_lop
	WHERE so_luong_sinh_vien_se_chuyen <= so_cho_trong
END

SELECT * FROM lop
SELECT * FROM sinh_vien

UPDATE sinh_vien
SET
ma_lop = 1
WHERE ma = 1

DELETE FROM lop
DELETE FROM sinh_vien

INSERT INTO lop
VALUES 
(1, 'PHP', 3),
(2, 'Web', 1),
(3, 'Test', 0)

INSERT INTO sinh_vien
VALUES
(1, 'Long', 1), 
(2, 'Tuan', 1)

INSERT INTO sinh_vien
VALUES
(3, 'Long', 3), 
(4, 'Tuan', 3),
(5, 'Tuan', 3)