-- 1. Transaction thựC hiện:
-- Chèn thông tin hóa đơn có nội dung như sau:
-- (MaHD, Ngay, MaKH) có giá trị
-- ('HD20', '2 Dec 2019', 'KH01') và hóa đơn này bao gồm các sản
-- phẩm:
-- - VT01, 10 đơn vị, giá bán 55000
-- - VT01, 2 đơn vị, giá bán 47000

BEGIN TRAN
INSERT INTO HOADON
    (MAHD, NGAY, MAKH)
VALUES
    ('HD20', '2019-12-02', 'KH01')
INSERT INTO CHITIETHOADON
    (MAHD, MAVT, SL, GIABAN)
VALUES('HD20', 'VT01', 10, 55000),
    ('HD20', 'VT01', 2, 47000)

COMMIT TRAN

-- 2.Transaction thực hiện xóa thông tin về hóa đơn HD008 trong CSDL
BEGIN TRAN

DELETE FROM CHITIETHOADON
    WHERE MAHD = 'HD008'

DELETE FROM HOADON
    WHERE MAHD = 'HD008'
COMMIT TRAN

