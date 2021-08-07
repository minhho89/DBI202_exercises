-- 1. Viết hàm fc_Cau1 có kiểu dữ liệu trả về là int, 
-- nhập vào 1 mã vật tư, tìm xem giá mua 
-- của vật tư này là bao nhiêu. 
-- Kết quả trả về cho hàm là giá mua tìm được.

IF exists (SELECT *
FROM SYS.objects
WHERE NAME ='fc_Cau1')
DROP FUNCTION fc_Cau1
GO

CREATE FUNCTION fc_Cau1 (@MAVT NVARCHAR(5))
RETURNS int
AS
BEGIN
    DECLARE @result int
    SELECT @result = GIAMUA
    FROM VATTU
    WHERE MAVT = @MAVT

    RETURN @result
END
GO

DECLARE @gia int
EXEC @gia = dbo.fc_Cau1 "VT01"
SELECT @gia
GO

-- 2. Viết hàm fc_Cau2 có kiểu dữ liệu 
-- trả về là nvarchar(30), nhập vào 1 mã khách hàng, 
-- tìm xem khách hàng này 
-- có tên là gì. Kết quả trả về cho hàm 
-- là tên khách hàng tìm được.
if exists (SELECT *
FROM SYS.objects
WHERE NAME = 'fc_Cau2')
DROP FUNCTION fc_Cau2
GO

CREATE FUNCTION fc_Cau2(@MAKH NVARCHAR(5))
RETURNS nvarchar(30)
AS
BEGIN
    DECLARE @result nvarchar(30)
    SELECT @result = TENKH
    FROM KHACHHANG
    WHERE MAKH = @MAKH
    RETURN @RESULT
END
GO

DECLARE @myValue NVARCHAR(30)
EXEC @myValue = dbo.fc_Cau2 "KH01"
SELECT @myValue

-- 3. Viết hàm fc_Cau3 có kiểu dữ liệu trả về là int, 
-- nhập vào 1 mã khách hàng rồi đếm xem khách hàng này 
-- đã mua tổng cộng bao nhiêu tiền. 
-- Kết quả trả về cho hàm là tổng số tiền mà khách hàng đã mua.
if exists (SELECT *
FROM sys.objects
WHERE NAME ='fc_Cau3')
DROP FUNCTION fc_Cau3
GO

CREATE FUNCTION fc_Cau3(@MAKH NVARCHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @RESULT INT
    SELECT @RESULT = SL * GIABAN
    FROM CHITIETHOADON CT, HOADON HD
    WHERE CT.MAHD = HD.MAHD AND HD.MAKH = @MAKH
    RETURN @RESULT
END
GO

SELECT MAKH, TENKH, DBO.fc_Cau3(MAKH) AS TONGTIENMUA
FROM KHACHHANG

-- 4. Viết hàm fc_Cau4 có kiểu dữ liệu trả về 
-- là nvarchar(5), tìm xem vật tư nào là vật tư bán được nhiều nhất
-- (nhiều tiền nhất). 
-- Kết quả trả về cho hàm là mã của vật tư này
-- (trường hợp có nhiều vật tư cùng bán được nhiều nhất, 
-- chỉ cần trả về 1 mã bất kỳ trong số đó).
IF EXISTS(SELECT *
FROM sys.objects
WHERE NAME = 'fc_Cau4')
DROP FUNCTION fc_Cau4
GO

CREATE FUNCTION fc_Cau4()
RETURNS NVARCHAR(5)
AS
BEGIN
    DECLARE @RESULT NVARCHAR(5)
    SELECT @RESULT = MAVT
    FROM CHITIETHOADON
    WHERE SL * GIABAN = (
        SELECT MAX(SL * GIABAN)
    FROM CHITIETHOADON
    )
    GROUP BY MAVT
    RETURN @RESULT
END
GO

DECLARE @MYVALUE NVARCHAR(5)
EXEC @MYVALUE = DBO.fc_Cau4
SELECT @MYVALUE