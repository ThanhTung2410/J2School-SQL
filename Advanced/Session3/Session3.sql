CREATE TABLE sinh_vien (
ma int identity,
ten varchar(50),
gioi_tinh bit,
ngay_sinh date,
PRIMARY KEY(ma)
)

INSERT INTO sinh_vien
VALUES
('Long',1,'1997-01-01'),
('Tuan',0,'2000-01-01')

SELECT 
ma,
ten,
(dbo.function_ten_gioi_tinh(gioi_tinh)) AS ten_gioi_tinh,
(dbo.function_lay_tuoi(ngay_sinh)) AS tuoi 
FROM sinh_vien

CREATE FUNCTION function_ten_gioi_tinh (@gioi_tinh bit) -- PARAMETER
RETURNS nvarchar(50) -- DECLARE THE RETURN TYPE FOR FUNCTION
AS 
BEGIN
	RETURN CASE WHEN @gioi_tinh = 1 THEN 'Nam' ELSE N'Nữ' END
END

CREATE FUNCTION function_lay_tuoi (@ngay_sinh date) 
RETURNS int
AS
BEGIN
	RETURN DATEDIFF(year,@ngay_sinh,GETDATE())
END

CREATE FUNCTION func_xem_sinh_vien (@ma int)
RETURNS table
RETURN 
	(SELECT * FROM sinh_vien
	WHERE ma = @ma)

SELECT * FROM dbo.func_xem_sinh_vien(1) AS T1
JOIN sinh_vien 
ON sinh_vien.ma = T1.ma

CREATE FUNCTION func_kiem_tra_tuoi_tren_18 (@ngay_sinh date)
RETURNS bit
AS 
BEGIN
	RETURN CASE WHEN dbo.function_lay_tuoi (@ngay_sinh) > 18 then 1 ELSE 0 END
END

SELECT * FROM sinh_vien
where dbo.func_kiem_tra_tuoi_tren_18(ngay_sinh) = 1