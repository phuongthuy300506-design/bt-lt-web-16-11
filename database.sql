-- =============================================================
-- TRƯỜNG ĐẠI HỌC SƯ PHẠM KỸ THUẬT TP.HCM (HCMUTE)
-- MÔN HỌC: LẬP TRÌNH WEB (WEBPR330479)
-- BÀI TẬP: CẤU HÌNH VÀ TEST JPA - CRUD CATEGORY BẰNG JPA
-- CƠ SỞ DỮ LIỆU: webst2
-- =============================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'webst2')
BEGIN
    CREATE DATABASE [webst2];
END
GO

USE [webst2];
GO

-- 1. TẠO BẢNG CATEGORIES
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='categories' and xtype='U')
BEGIN
    CREATE TABLE categories (
        [CategoryId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [CategoryName] NVARCHAR(255) NOT NULL,
        [Images] NVARCHAR(500) NULL,
        [Status] INT NOT NULL DEFAULT 1
    );
END
GO

-- 2. TẠO BẢNG VIDEOS
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='videos' and xtype='U')
BEGIN
    CREATE TABLE videos (
        [VideoId] NVARCHAR(50) NOT NULL PRIMARY KEY,
        [Active] INT NOT NULL DEFAULT 1,
        [Description] NVARCHAR(MAX) NULL,
        [Poster] NVARCHAR(500) NULL,
        [Title] NVARCHAR(500) NULL,
        [Views] INT NOT NULL DEFAULT 0,
        [CategoryId] INT NULL FOREIGN KEY REFERENCES categories([CategoryId]) ON DELETE SET NULL
    );
END
GO

-- 3. DỮ LIỆU MẪU BAN ĐẦU
IF NOT EXISTS (SELECT * FROM categories WHERE CategoryName = N'Điện thoại & Phụ kiện')
BEGIN
    INSERT INTO categories (CategoryName, Images, Status) VALUES (N'Điện thoại & Phụ kiện', 'ao_nam.png', 1);
    INSERT INTO categories (CategoryName, Images, Status) VALUES (N'Laptop & Máy tính', 'giay.png', 1);
    INSERT INTO categories (CategoryName, Images, Status) VALUES (N'Thời trang Nam Nữ', 'ao_nu.png', 1);
    INSERT INTO categories (CategoryName, Images, Status) VALUES (N'Đồng hồ & Trang sức', 'phu_kien.png', 0);
END
GO

IF NOT EXISTS (SELECT * FROM videos WHERE VideoId = 'v01')
BEGIN
    INSERT INTO videos (VideoId, Active, Description, Poster, Title, Views, CategoryId)
    VALUES ('v01', 1, N'Video giới thiệu sản phẩm', 'poster1.png', N'Đập hộp iPhone 16 Pro Max', 1500, 1);
END
GO

-- KIỂM TRA DỮ LIỆU
SELECT * FROM categories;
SELECT * FROM videos;
GO

