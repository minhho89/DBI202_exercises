-- 1. Giá bán của một vật tư bất kỳ cần lớn hơn hoặc bằng 
-- giá mua của sản phẩm đó.

CREATE TRIGGER check_price ON CHITIETHOADON
AFTER INSERT, UPDATE
AS
IF EXISTS
(
    SELECT CTHD.MAVT
FROM CHITIETHOADON CTHD, VATTU VT
WHERE CTHD.MAVT = VT.MAVT
    AND GIABAN < GIAMUA
)
BEGIN
    RAISERROR('Giá bán vật tư phải lớn hơn hoặc bằng giá mua vật tư', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
END
GO
-- 2. Mỗi khi một vật tư được bán ra với một số lượng nào đó, 
-- thì thuộc tính SLTon trong bảng VATTU cần giảm đi tương ứng.

CREATE TRIGGER trg_DatHang_2 ON CHITIETHOADON
AFTER INSERT
AS BEGIN
    UPDATE VATTU
    SET SLTON = SLTON - (
        SELECT SUM(SL)
    FROM inserted
    WHERE MAVT = VATTU.MAVT
    )
    FROM VATTU JOIN inserted
        ON VATTU.MAVT = inserted.MAVT
END
GO

BEGIN TRAN
SELECT *
FROM VATTU

INSERT INTO CHITIETHOADON
    (MAHD, MAVT, SL, GIABAN)
VALUES('HD20', 'VT01', 100, 100000)

SELECT *
FROM VATTU

ROLLBACK TRAN
GO

-- 3. Đảm bảo giá bán của một sản phẩm bất kỳ, 
-- chỉ có thể cập nhật tăng, không thể cập nhật giảm.
CREATE TRIGGER trg_price_only_raises ON CHITIETHOADON
AFTER UPDATE
AS BEGIN
    IF EXISTS
    (
        SELECT inserted.GIABAN
    FROM inserted, deleted
    WHERE inserted.MAVT = deleted.MAVT
        AND inserted.GIABAN < deleted.GIABAN
    )
    RAISERROR('Giá bán mới cập nhật chỉ tăng, không giảm!', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
END
GO

-- 4. Mỗi khi có sự thay đổi về vật tư được bán trong một hóa đơn nào đó, 
-- thuộc tính TONGGT trong bảng HOADON được cập nhật tương ứng.
CREATE TRIGGER trg_insert_tongGT ON HOADON
AFTER INSERT
AS BEGIN
    UPDATE HOADON
    SET TONGTG = (
        SELECT SUM(GIABAN*SL)
    FROM HOADON, CHITIETHOADON
    WHERE HOADON.MAHD = CHITIETHOADON.MAHD
    )
    FROM HOADON, inserted
    WHERE HOADON.MAHD = INSERTED.MAHD
END
GO

CREATE TRIGGER trg_del_update_tongGT ON HOADON
AFTER DELETE, UPDATE
AS BEGIN
    UPDATE HOADON
    SET TONGTG = (
        SELECT SUM(GIABAN*SL)
    FROM HOADON, CHITIETHOADON
    WHERE HOADON.MAHD = CHITIETHOADON.MAHD
    )
    FROM HOADON, deleted
    WHERE HOADON.MAHD = deleted.MAHD
END
GO