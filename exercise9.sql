-- 1. Hiển danh sách các khách hàng 
-- có điện thoại là 8457895 gồm mã khách hàng, 
-- tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
SELECT TENKH, DIACHI, DT, EMAIL
FROM KHACHHANG
WHERE DT = '08457895'

-- 2. Hiển danh sách các vật tư là “DA”
-- (bao gồm các loại đá) có giá mua dưới 30000 
-- gồm mã vật tư, tên vật tư, đơn vị tính và giá mua .
SELECT MAVT, TENVT, DVT, GIAMUA
FROM VATTU
WHERE TENVT LIKE 'DA%'

-- 3.    Tạo query để lấy ra các thông tin gồm
--  Mã hoá đơn, ngày lập hoá đơn, tên khách hàng, 
--  địa chỉ khách hàng và số điện thoại, sắp xếp 
--  theo thứ tự ngày tạo hóa đơn giảm dần
SELECT HD.MAHD, NGAY, TENKH, DIACHI, DT
FROM HOADON HD, KHACHHANG KH
WHERE HD.MAKH = KH.MAKH
ORDER BY NGAY DESC

-- 4.    Lấy ra danh sách những khách hàng mua hàng 
-- trong tháng 6/2000 gồm các thông tin tên khách hàng, 
-- địa chỉ, số điện thoại.
SELECT KH.TENKH, DIACHI, DT
FROM HOADON HD, KHACHHANG KH
WHERE HD.MAKH = KH.MAKH
    AND YEAR(NGAY) = 2000 AND MONTH(NGAY) = 6

-- 5.    Tạo query để lấy ra các chi tiết hoá đơn gồm 
-- các thông tin  mã hóa đơn, ,mã vật tư, tên vật tư, 
-- giá bán, giá mua, số lượng , trị giá mua
-- (giá mua * số lượng), trị giá bán ,
-- (giá bán * số lượng), tiền lời
-- (trị giá bán – trị giá mua) mà có giá bán lớn hơn
--  hoặc bằng giá mua.
SELECT CT.MAHD, CT.MAVT, VT.TENVT, CT.GIABAN,
    VT.GIAMUA, SL, GIAMUA * SL AS TRI_GIA_MUA,
    GIABAN * SL AS TRI_GIA_BAN,
    GIABAN * SL - GIAMUA * SL AS TIEN_LOI
FROM CHITIETHOADON CT, VATTU VT
WHERE CT.MAVT = VT.MAVT
    AND GIABAN * SL >= GIAMUA * SL

-- 6.    Lấy ra hoá đơn có tổng trị giá nhỏ nhất trong 
-- số các hóa đơn năm 2000, gồm các thông tin:
-- Số hoá đơn, ngày, tên khách hàng, địa chỉ khách hàng, 
-- tổng trị giá của hoá đơn.
SELECT HD.MAHD, NGAY, TENKH, DIACHI, SUM(CT.GIABAN * SL) AS GIA_TRI_HOA_DON
FROM HOADON HD, CHITIETHOADON CT, KHACHHANG KH
WHERE HD.MAHD = CT.MAHD AND HD.MAKH = KH.MAKH
    AND YEAR(NGAY) = 2000
GROUP BY HD.MAHD, NGAY, TENKH, DIACHI
HAVING SUM(CT.GIABAN * SL) = 
(SELECT MIN(GIA_TRI_HOA_DON)
FROM (SELECT SUM(CT.GIABAN * SL) AS GIA_TRI_HOA_DON
    FROM HOADON HD, CHITIETHOADON CT
    WHERE HD.MAHD = CT.MAHD AND YEAR(NGAY) = 2000
    GROUP BY HD.MAHD) AS TEMP)

-- 7.    Lấy ra các thông tin về các khách hàng 
-- mua ít loại mặt hàng nhất.
SELECT KH.MAKH, TENKH, DIACHI, DT, EMAIL, COUNT(CTHD.MAVT) AS SL_MAT_HANG
FROM KHACHHANG KH, HOADON HD, CHITIETHOADON CTHD
WHERE KH.MAKH = HD.MAKH AND CTHD.MAHD = HD.MAHD
GROUP BY KH.MAKH, TENKH, DIACHI, DT, EMAIL
HAVING COUNT(CTHD.MAVT) =
(SELECT MIN(SL_MAT_HANG)
FROM (SELECT HD.MAKH AS MA_KH, COUNT(CTHD.MAVT) AS SL_MAT_HANG
    FROM CHITIETHOADON CTHD, HOADON HD
    WHERE CTHD.MAHD = HD.MAHD
    GROUP BY HD.MAKH) AS T)

-- 8.    Lấy ra vật tư có giá mua thấp nhất
SELECT *
FROM VATTU
WHERE GIAMUA = (SELECT MIN(GIAMUA)
FROM VATTU)

-- 9.    Lấy ra vật tư có giá bán cao nhất trong số 
-- các vật tư được bán trong năm 2000.
SELECT VT.MAVT, TENVT
FROM VATTU VT, CHITIETHOADON CT, HOADON HD
WHERE VT.MAVT = CT.MAVT AND HD.MAHD = CT.MAHD
    AND GIABAN = (SELECT MAX(GIABAN)
    FROM CHITIETHOADON)
    AND YEAR(NGAY) = 2000

-- 10.  Cho biết mỗi vật tư đã được bán tổng số 
-- bao nhiêu đơn vị (chiếc, cái,… )
-- Chú ý: Có thể có những vật tư chưa bán được đơn vị nào,
-- khi đó cần hiển thị là đã bán 0 đơn vị
SELECT VT.MAVT, ISNULL(SUM(SL),0) TONG_SL_BAN
FROM CHITIETHOADON CT RIGHT JOIN VATTU VT
ON CT.MAVT = VT.MAVT
GROUP BY VT.MAVT

SELECT *
FROM VATTU