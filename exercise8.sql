-- 1. Lấy ra các thông tin gồm 
-- Mã hoá đơn, ngày lập hoá đơn, tên khách hàng, 
-- địa chỉ khách hàng và số điện thoại.
SELECT MAHD, NGAY, TENKH, DIACHI, DT
FROM HOADON HD, KHACHHANG KH
WHERE HD.MAKH = KH.MAKH

SELECT MAHD, NGAY, TENKH, DIACHI, DT
FROM HOADON HD JOIN KHACHHANG KH
    ON HD.MAKH = KH.MAKH

-- 2. Lấy ra các thông tin gồm Mã hoá đơn, 
-- tên khách hàng, địa chỉ khách hàng 
-- và số điện thoại của ngày 25/5/2000.
SELECT MAHD, TENKH, DIACHI, DT
FROM HOADON HD, KHACHHANG KH
WHERE HD.MAKH = KH.MAKH
    AND NGAY = '2000-05-25'

-- 3. Lấy ra các thông tin gồm Mã hoá đơn, 
-- ngày lập hoá đơn, tên khách hàng, 
-- địa chỉ khách hàng và số điện thoại 
-- của những hoá đơn trong tháng 6/2000.
SELECT MAHD, TENKH, DIACHI, DT
FROM HOADON HD, KHACHHANG KH
WHERE HD.MAKH = KH.MAKH
    AND YEAR(NGAY) = 2000
    AND MONTH(NGAY) = 06

-- 4. Lấy ra danh sách những khách hàng
-- (tên khách hàng, địa chỉ, số điện thoại) 
-- đã mua hàng trong tháng 6/2000.
SELECT TENKH, DIACHI, DT
FROM KHACHHANG KH, HOADON HD
WHERE KH.MAKH = HD.MAKH
    AND YEAR(NGAY) = 2000
    AND MONTH(NGAY) = 06

-- 5. Lấy ra danh sách các mặt hàng được bán từ ngày 
-- 1/1/2000 đến ngày 1/7/2000. Thông tin
-- gồm:
-- mã vật tư, tên vật tư.
SELECT VT.MAVT, TENVT
FROM CHITIETHOADON CTHD, VATTU VT, HOADON HD
WHERE VT.MAVT = CTHD.MAVT AND HD.MAHD = CTHD.MAHD
    AND NGAY BETWEEN '2000-01-01' AND '2000-07-01'

-- 6. Lấy ra danh sách các vật tư được bán 
-- từ ngày 1/1/2000 đến ngày 1/7/2000. Thông tin gồm:
-- mã vật tư, tên vật tư, tên khách hàng đã mua, 
-- ngày mua, số lượng mua.
SELECT VT.MAVT, TENVT, KH.TENKH, HD.NGAY, SUM(CTHD.SL) AS 'SO LUONG'
FROM VATTU VT, CHITIETHOADON CTHD, HOADON HD, KHACHHANG KH
WHERE VT.MAVT = CTHD.MAVT
    AND CTHD.MAHD = HD.MAHD
    AND HD.MAKH = KH.MAKH
GROUP BY VT.MAVT, TENVT, KH.TENKH, HD.NGAY

-- 7. Lấy ra danh sách các vật tư được mua bởi những 
-- khách hàng ở Tân Bình, trong năm 2000. Thông tin lấy ra gồm:
-- mã vật tư, tên vật tư, tên khách hàng, 
-- ngày mua, số lượng mua.
SELECT VT.MAVT, VT.TENVT, KH.TENKH, HD.NGAY, SUM
(CTHD.SL) AS 'SO LUONG'
FROM VATTU VT, CHITIETHOADON CTHD, HOADON HD, KHACHHANG KH
WHERE VT.MAVT = CTHD.MAVT
    AND CTHD.MAHD = HD.MAHD
    AND HD.MAKH = KH.MAKH
    AND KH.DIACHI = 'TAN BINH'
    AND YEAR(NGAY) = 2000
GROUP BY VT.MAVT, VT.TENVT, KH.TENKH, HD.NGAY

-- 8. Lấy ra danh sách các vật tư 
-- được mua bởi những khách hàng ở Tân Bình, 
-- trong năm 2000. Thông tin lấy ra
-- gồm:
-- mã vật tư, tên vật tư.
-- GIONG CAU 7

-- 9. Lấy ra danh sách những khách hàng không mua hàng 
-- trong tháng 6/2000 gồm các thông tin 
-- tên khách hàng, địa chỉ, số điện thoại.
SELECT TENKH, DIACHI, DT
FROM KHACHHANG KH, HOADON HD
WHERE KH.MAKH = HD.MAKH
    AND HD.NGAY NOT BETWEEN '2000-06-01' AND '2000-06-30'
