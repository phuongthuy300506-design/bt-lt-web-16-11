-- =============================================================
-- TRƯỜNG ĐẠI HỌC SƯ PHẠM KỸ THUẬT TP.HCM (HCMUTE)
-- MÔN HỌC: LẬP TRÌNH WEB (WEBPR330479)
-- BÀI TẬP: NGÀY 16/11/2026 - JPA HIBERNATE 6.6
-- CƠ SỞ DỮ LIỆU: webst2 / ShoppingServiceMVC
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

-- 1. TẠO BẢNG [User] (Hỗ trợ xác thực OTP, mã hóa mật khẩu SHA-256)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='User' and xtype='U')
BEGIN
    CREATE TABLE [User] (
        [id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [email] VARCHAR(255) NULL,
        [username] VARCHAR(255) NOT NULL UNIQUE,
        [fullname] NVARCHAR(255) NULL,
        [password] VARCHAR(255) NOT NULL,
        [avatar] VARCHAR(255) NULL,
        [roleid] INT NOT NULL DEFAULT 5, -- 1: Admin, 2: Manager, 5: User
        [phone] VARCHAR(50) NULL,
        [status] INT NOT NULL DEFAULT 1, -- 0: Chưa kích hoạt (chờ OTP), 1: Đã kích hoạt
        [code] VARCHAR(50) NULL,         -- Mã OTP kích hoạt tài khoản / đặt lại mật khẩu
        [createddate] DATE NULL
    );
END
GO

-- 2. TẠO BẢNG categories
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

-- 3. TẠO BẢNG videos VỚI MỐI LIÊN HỆ 1-N VỚI BẢNG USERS VÀ CATEGORIES
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='videos' and xtype='U')
BEGIN
    CREATE TABLE videos (
        [VideoId] NVARCHAR(50) NOT NULL PRIMARY KEY,
        [Active] INT NOT NULL DEFAULT 1,
        [Description] NVARCHAR(MAX) NULL,
        [Poster] NVARCHAR(500) NULL,
        [Title] NVARCHAR(500) NULL,
        [Views] INT NOT NULL DEFAULT 0,
        [VideoUrl] NVARCHAR(500) NULL,
        [CategoryId] INT NULL FOREIGN KEY REFERENCES categories([CategoryId]) ON DELETE SET NULL,
        [UserId] INT NULL FOREIGN KEY REFERENCES [User]([id]) ON DELETE SET NULL -- Mối quan hệ 1 - n với bảng users
    );
END
GO

-- 4. DỮ LIỆU MẪU BAN ĐẦU (SEED DATA)
-- Thêm các tài khoản người dùng mẫu (Mật khẩu '1234@a$' đã băm bằng SHA-256)
IF NOT EXISTS (SELECT * FROM [User] WHERE username = 'admin')
BEGIN
    INSERT INTO [User] (email, username, fullname, password, avatar, roleid, phone, status, code, createddate)
    VALUES ('admin@iotstar.vn', 'admin', N'Quản Trị Viên', 'fbd2a48be520754d37ebadb968d0909b91c468c99d27bbdc03d3a1df115235a9', 'admin.png', 1, '0908617108', 1, NULL, GETDATE());
END
GO

IF NOT EXISTS (SELECT * FROM [User] WHERE username = 'manager')
BEGIN
    INSERT INTO [User] (email, username, fullname, password, avatar, roleid, phone, status, code, createddate)
    VALUES ('manager@iotstar.vn', 'manager', N'Trưởng Bộ Phận', 'fbd2a48be520754d37ebadb968d0909b91c468c99d27bbdc03d3a1df115235a9', 'manager.png', 2, '0912345678', 1, NULL, GETDATE());
END
GO

IF NOT EXISTS (SELECT * FROM [User] WHERE username = 'user')
BEGIN
    INSERT INTO [User] (email, username, fullname, password, avatar, roleid, phone, status, code, createddate)
    VALUES ('user@iotstar.vn', 'user', N'Nguyễn Văn A', 'fbd2a48be520754d37ebadb968d0909b91c468c99d27bbdc03d3a1df115235a9', 'user.png', 5, '0987654321', 1, NULL, GETDATE());
END
GO

-- Thêm các danh mục mẫu
IF NOT EXISTS (SELECT * FROM categories WHERE CategoryName = N'Công nghệ & Lập trình')
BEGIN
    INSERT INTO categories (CategoryName, Images, Status) VALUES (N'Công nghệ & Lập trình', 'cong_nghe.png', 1);
    INSERT INTO categories (CategoryName, Images, Status) VALUES (N'Điện thoại & Phụ kiện', 'ao_nam.png', 1);
    INSERT INTO categories (CategoryName, Images, Status) VALUES (N'Laptop & Máy tính', 'giay.png', 1);
    INSERT INTO categories (CategoryName, Images, Status) VALUES (N'Đời sống & Khoa học', 'phu_kien.png', 1);
END
GO

-- Thêm 12 Videos mẫu để test phân trang 6sp/trang và 10 video mới nhất trên trang chủ
DECLARE @adminId INT = (SELECT TOP 1 id FROM [User] WHERE username = 'admin');
DECLARE @userId INT = (SELECT TOP 1 id FROM [User] WHERE username = 'user');
IF @userId IS NULL SET @userId = @adminId;

IF NOT EXISTS (SELECT * FROM videos WHERE VideoId = 'v01')
BEGIN
    INSERT INTO videos (VideoId, Active, Description, Poster, Title, Views, VideoUrl, CategoryId, UserId) VALUES
    ('v01', 1, N'Hướng dẫn toàn diện về kiến trúc Jakarta EE 11 và cách cấu hình Servlet 6.1 trên Apache Tomcat 11.', 'poster1.png', N'Khóa học Lập trình Web Jakarta EE 11 - Bài 1', 1850, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', 1, @userId),
    ('v02', 1, N'Tìm hiểu sâu về Hibernate ORM 6.6, quản lý EntityManagerFactory và ánh xạ quan hệ One-to-Many trong Java.', 'poster2.png', N'Làm chủ Hibernate ORM 6.6 và JPA 3.1 từ A đến Z', 1230, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4', 1, @userId),
    ('v03', 1, N'Đánh giá hiệu năng và trải nghiệm iPhone 16 Pro Max sau 1 tháng sử dụng thực tế.', 'poster3.png', N'Đập hộp & Đánh giá chi tiết iPhone 16 Pro Max', 3420, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 2, @userId),
    ('v04', 1, N'So sánh hiệu năng giữa chip M3 Max và Intel Core Ultra 9 trên các ứng dụng đồ họa.', 'poster4.png', N'Top 5 Laptop đồ họa tốt nhất năm 2026', 980, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', 3, @userId),
    ('v05', 1, N'Kỹ thuật mã hóa mật khẩu an toàn sử dụng thuật toán băm SHA-256 trong ứng dụng Java Web.', 'poster5.png', N'Bảo mật ứng dụng Web: Mã hóa mật khẩu với SHA-256', 2150, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4', 1, @userId),
    ('v06', 1, N'Tích hợp Jakarta Mail gửi mã OTP xác thực kích hoạt tài khoản người dùng tự động.', 'poster6.png', N'Xây dựng chức năng gửi Email xác thực OTP bằng Jakarta Mail', 1670, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyBlazes.mp4', 1, @userId),
    ('v07', 1, N'Phân tích giải pháp phân trang dữ liệu trong Hibernate ORM với setFirstResult và setMaxResults.', 'poster7.png', N'Kỹ thuật phân trang 6 sản phẩm/trang chuẩn MVC', 890, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4', 1, @userId),
    ('v08', 1, N'Hướng dẫn sử dụng @MultipartConfig để xử lý upload file ảnh và video trong Java Servlet.', 'poster8.png', N'Upload file bằng Multipart trong Servlet Jakarta', 2780, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4', 1, @userId),
    ('v09', 1, N'Khám phá quy trình thiết kế giao diện Bootstrap 5 responsive cho ứng dụng xem video.', 'poster9.png', N'Thiết kế giao diện Video Player hiện đại với Bootstrap 5', 1450, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackSeeTheWorld.mp4', 4, @userId),
    ('v10', 1, N'Tìm hiểu cách nhúng video player HTML5 và xử lý sự kiện xem video thời gian thực.', 'poster10.png', N'HTML5 Video Player & Tự động tăng lượt xem (Views)', 3100, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4', 4, @userId),
    ('v11', 1, N'Hướng dẫn xây dựng chức năng Quên mật khẩu và đặt lại mật khẩu với mã OTP xác nhận.', 'poster11.png', N'Quy trình Quên mật khẩu & Đặt lại mật khẩu an toàn', 1120, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4', 1, @userId),
    ('v12', 1, N'Tổng kết toàn diện đồ án Lập trình Web và những lưu ý quan trọng khi triển khai hệ thống.', 'poster12.png', N'Tổng kết Đồ án Lập trình Web HCMUTE 2026', 4500, 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4', 1, @userId);
END
GO

-- KIỂM TRA DỮ LIỆU
SELECT * FROM [User];
SELECT * FROM categories;
SELECT * FROM videos;
GO
