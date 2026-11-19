<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - HCMUTE Video Sharing Platform</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background-color: #0f172a;
            color: #f8fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }
        .hero-banner {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            border-bottom: 1px solid #334155;
            padding: 50px 0;
            margin-bottom: 35px;
        }
        .video-card {
            background: #1e293b;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #334155;
            transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .video-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.45);
            border-color: #ef4444;
        }
        .thumb-wrapper {
            position: relative;
            width: 100%;
            padding-top: 56.25%; /* 16:9 ratio */
            background: #020617;
            overflow: hidden;
        }
        .thumb-wrapper img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .video-card:hover .thumb-wrapper img {
            transform: scale(1.05);
        }
        .play-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: rgba(239, 68, 68, 0.85);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 20px;
            opacity: 0;
            transition: opacity 0.25s ease;
        }
        .video-card:hover .play-overlay {
            opacity: 1;
        }
        .badge-views {
            position: absolute;
            bottom: 8px;
            right: 8px;
            background: rgba(15, 23, 42, 0.85);
            color: #e2e8f0;
            font-size: 11px;
            padding: 4px 8px;
            border-radius: 6px;
        }
        .badge-category {
            position: absolute;
            top: 8px;
            left: 8px;
            background: rgba(13, 110, 253, 0.9);
            color: #fff;
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 4px;
        }
        .video-body {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            justify-content: space-between;
        }
        .video-title {
            font-size: 15px;
            font-weight: 600;
            color: #f1f5f9;
            text-decoration: none;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 8px;
            transition: color 0.2s;
        }
        .video-title:hover {
            color: #ef4444;
        }
        .video-meta {
            font-size: 12px;
            color: #94a3b8;
        }
        .category-pill {
            background: #1e293b;
            border: 1px solid #334155;
            color: #cbd5e1;
            border-radius: 20px;
            padding: 8px 18px;
            margin: 4px;
            display: inline-block;
            text-decoration: none;
            transition: all 0.2s;
        }
        .category-pill:hover {
            background: #ef4444;
            color: #fff;
            border-color: #ef4444;
        }
    </style>
</head>
<body>

<!-- Hero Banner -->
<section class="hero-banner">
    <div class="container text-center">
        <h1 class="display-6 fw-bold mb-2">
            Nền Tảng Đăng Tải & Xem Video Trực Tuyến
        </h1>
        <p class="text-secondary lead mx-auto" style="max-width: 650px; font-size: 16px;">
            Hệ thống bài tập Lập trình Web HCMUTE - Hỗ trợ đăng ký kích hoạt mã OTP qua Email, 
            mã hóa mật khẩu an toàn SHA-256 và quản lý Videos quan hệ 1 - n với User.
        </p>
        <div class="d-flex justify-content-center gap-3 mt-3">
            <a href="${pageContext.request.contextPath}/video" class="btn btn-danger px-4 py-2 fw-semibold">
                <i class="fa-solid fa-play me-2"></i>Xem Video (/video)
            </a>
            <a href="${pageContext.request.contextPath}/video/add" class="btn btn-outline-light px-4 py-2">
                <i class="fa-solid fa-cloud-arrow-up me-2"></i>Tải lên Video Mới
            </a>
        </div>
    </div>
</section>

<!-- Nội dung chính -->
<div class="container mb-5">

    <!-- Mục 1: Hiển thị 10 Video mới nhất (Yêu cầu 4.2) -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1 d-flex align-items-center">
                <i class="fa-solid fa-fire text-danger me-2"></i>10 Video Mới Nhất
            </h4>
            <span class="text-secondary small">Cập nhật những video vừa được đăng tải lên hệ thống</span>
        </div>
        <a href="${pageContext.request.contextPath}/video" class="btn btn-outline-secondary btn-sm text-light">
            Xem tất cả video <i class="fa-solid fa-arrow-right ms-1"></i>
        </a>
    </div>

    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-5 g-4 mb-5">
        <c:forEach items="${top10Videos}" var="v" varStatus="loop">
            <div class="col">
                <div class="video-card">
                    <div class="thumb-wrapper">
                        <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" style="display: block; width: 100%; height: 100%;">
                            <!-- Poster thumbnail -->
                            <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" 
                                 alt="${v.title}">
                            
                            <!-- Lượt xem -->
                            <span class="badge-views">
                                <i class="fa-solid fa-eye me-1"></i>${v.views}
                            </span>

                            <!-- Danh mục -->
                            <c:if test="${not empty v.category}">
                                <span class="badge-category">${v.category.categoryname}</span>
                            </c:if>

                            <!-- Play icon khi hover -->
                            <span class="play-overlay">
                                <i class="fa-solid fa-play"></i>
                            </span>
                        </a>
                    </div>

                    <div class="video-body">
                        <!-- Yêu cầu 4.4: Bấm chuột vào tiêu đề để xem chi tiết và play video -->
                        <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" 
                           class="video-title" 
                           title="${v.title}">
                            ${v.title}
                        </a>

                        <div class="video-meta d-flex justify-content-between align-items-center mt-2">
                            <span>
                                <i class="fa-solid fa-user-circle me-1"></i>
                                ${not empty v.user ? (not empty v.user.fullName ? v.user.fullName : v.user.username) : 'Hệ thống'}
                            </span>
                            <span class="text-danger fw-semibold">#${loop.index + 1}</span>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Mục 2: Danh mục chủ đề -->
    <div class="mb-4 mt-5">
        <h5 class="fw-bold mb-3 d-flex align-items-center">
            <i class="fa-solid fa-layer-group text-primary me-2"></i>Khám Phá Theo Danh Mục
        </h5>
        <div>
            <c:forEach items="${categories}" var="c">
                <a href="${pageContext.request.contextPath}/video" class="category-pill">
                    <i class="fa-solid fa-tag me-1 text-danger"></i>${c.categoryname}
                </a>
            </c:forEach>
        </div>
    </div>

</div>

</body>
</html>
