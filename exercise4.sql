/* Create database */
CREATE DATABASE funix_exercise4;
GO

/* Change to the Music database */
USE funix_exercise4;
GO

/* Create tables */
CREATE TABLE KHACHHANG
(
    MAKH nvarchar(5) NOT NULL PRIMARY KEY,
    TENKH nvarchar(30),
    DIACHI nvarchar(50),
    DT NVARCHAR(10),
    EMAIL NVARCHAR(30)
);

CREATE TABLE VATTU
(
    MAVT NVARCHAR(5) NOT NULL PRIMARY KEY,
    TENVT NVARCHAR(30),
    DVT NVARCHAR(20),
    GIAMUA INT,
    SLTON INT
);

CREATE TABLE HOADON
(
    MAHD NVARCHAR(10) NOT NULL PRIMARY KEY,
    NGAY DATETIME,
    MAKH NVARCHAR(5),
    TONGTG INT
);

CREATE TABLE CHITIETHOADON
(
    MAHD NVARCHAR(10) NOT NULL,
    MAVT NVARCHAR(5) NOT NULL,
    SL INT,
    KHUYENMAI INT,
    GIABAN INT,
    PRIMARY KEY (MAHD, MAVT)
)

GO