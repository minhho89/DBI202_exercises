-- 1. Viết procedure sp_Cau1 cập nhật thông tin TONGGT 
-- trong bảng hóa đơn theo dữ liệu thực tế của bảng CHITIETHOADON
IF OBJECT_ID('sp_Cau1', 'P') IS NOT NULL
DROP PROC sp_Cau1
GO


CREATE PROC sp_Cau1
AS
DECLARE @max as int
SET @max = (SELECT COUNT(*)
FROM HOADON)
DECLARE @count as int
SET @count = 1

BEGIN
    WHILE @count <= @max
        BEGIN
        UPDATE HOADON
            SET [TONGTG] = 
            (
                SELECT SUM(SL * GIABAN)
        FROM CHITIETHOADON CTHD
        WHERE HOADON.MAHD = CTHD.MAHD
            )
        WHERE @count =  (
                        SELECT ROW_NUMBER() OVER(ORDER BY MAHD))
        SET @count = @count + 1
    END
END
GO

EXEC SP_CAU1 
GO

-- 2. Viết procedure sp_Cau2 có đầu vào là số điện thoại, 
-- kiểm tra xem đã có khách hàng có số điện thoại này trong CSDL chưa? 
-- Hiện thông báo (bằng lệnh print) để nêu rõ đã có/ chưa
-- có khách hàng này.
IF OBJECT_ID('sp_Cau2', 'P') IS NOT NULL
DROP PROC sp_Cau2
GO

CREATE PROC sp_Cau2(@SDT nvarchar(10))
AS
BEGIN
    print(@SDT)
    IF EXISTS (SELECT *
    FROM KHACHHANG
    WHERE DT = @SDT)
        BEGIN
        print('Khach hang co dt nay')
    END
    ELSE
        BEGIN
        print('Khach hang khong co sdt nay')
    END
END
GO

EXEC sp_Cau2 '08457895'
EXEC sp_Cau2 '34454456'

SELECT *
FROM KHACHHANG
WHERE DT = '08457895'
GO

-- 3. Viết procedure sp_Cau3 có đầu vào là mã khách hàng, 
-- hãy tính tổng số tiền mà khách hàng này đã mua trong toàn hệ thống, 
-- kết quả trả về trong một tham số kiểu output.
IF OBJECT_ID('sp_Cau3', 'P') IS NOT NULL 
DROP PROC sp_Cau3
GO

CREATE PROC sp_Cau3(@maKH nvarchar(5),
    @tongTien int OUTPUT)
AS
BEGIN
    SET @tongTien =(
    SELECT SUM(SL * GIABAN)
    FROM CHITIETHOADON CTHD, HOADON HD
    WHERE CTHD.MAHD = HD.MAHD AND MAKH = @maKH
    )
END
GO

DECLARE @result int
EXEC sp_Cau3 'KH02', @result output
select @result as result
GO

SELECT SUM(SL * GIABAN)
FROM CHITIETHOADON CTHD, HOADON HD
WHERE CTHD.MAHD = HD.MAHD AND MAKH = 'KH02'
GO

-- 4. Viết procedure sp_Cau4 có hai tham số kiểu output 
-- là @mavt nvarchar(5) và @tenvt nvarchar(30) 
-- để trả về mã và tên của vật tư đã bán được nhiều nhất
-- (được tổng tiền nhiều nhất).
IF OBJECT_ID('sp_Cau4', 'P') IS NOT NULL
DROP PROC sp_Cau4
GO

CREATE PROC sp_Cau4(@mavt nvarchar(5) OUTPUT,
    @tenvt nvarchar(30) OUTPUT)
AS
BEGIN
    SET @mavt = (
        SELECT MAVT
    FROM CHITIETHOADON
    GROUP BY MAVT
    HAVING SUM(SL * GIABAN) = (
        SELECT MAX(TONGGT)
    FROM (
            SELECT SUM(SL * GIABAN) AS TONGGT
        FROM CHITIETHOADON
        GROUP BY MAVT) AS A)
    )


    SET @tenvt = (
        SELECT TENVT
    FROM VATTU
    WHERE MAVT = @mavt
    )
END
GO

DECLARE @mavt nvarchar (5),@tenvt nvarchar (30)
EXEC sp_Cau4 @mavt OUTPUT, @tenvt OUTPUT
SELECT @MAVT AS MAVT
SELECT @TENVT AS TENVT
GO


