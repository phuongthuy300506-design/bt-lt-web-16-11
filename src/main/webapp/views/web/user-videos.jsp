<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Video Của Người Dùng - HCMUTE Video (/video)</title>
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
        .video-card {
            background: #1e293b;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #334155;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .video-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.4);
            border-color: #3b82f6;
        }
        .thumb-wrapper {
            position: relative;
            width: 100%;
            padding-top: 56.25%; /* 16:9 */
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
        }
        .play-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: rgba(37, 99, 235, 0.85);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 18px;
            opacity: 0;
            transition: opacity 0.25s ease;
        }
        .video-card:hover .play-overlay {
            opacity: 1;
        }
        .video-body {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            justify-content: space-between;
        }
        .video-title {
            font-size: 16px;
            font-weight: 600;
            color: #f1f5f9;
            text-decoration: none;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 8px;
            transition: color 0.2s;
        }
        .video-title:hover {
            color: #3b82f6;
        }
        .badge-views {
            position: absolute;
            bottom: 8px;
            right: 8px;
            background: rgba(15, 23, 42, 0.85);
            color: #e2e8f0;
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 4px;
        }
        .page-link {
            background-color: #1e293b;
            border-color: #334155;
            color: #cbd5e1;
        }
        .page-link:hover {
            background-color: #334155;
            border-color: #475569;
            color: #fff;
        }
        .page-item.active .page-link {
            background-color: #2563eb;
            border-color: #2563eb;
            color: #fff;
        }
        .page-item.disabled .page-link {
            background-color: #0f172a;
            border-color: #1e293b;
            color: #475569;
        }
    </style>
</head>
<body>

<div class="container py-4 mb-5">
    <!-- Header trang Video -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom border-secondary">
        <div>
            <h3 class="fw-bold mb-1 d-flex align-items-center">
                <i class="fa-solid fa-clapperboard text-primary me-2"></i>
                <c:choose>
                    <c:when test="${isUserOwner}">
                        Video Của Tôi (Tài khoản: @${sessionScope.account.username})
                    </c:when>
                    <c:otherwise>
                        Tất Cả Videos Hệ Thống (/video)
                    </c:otherwise>
                </c:choose>
            </h3>
            <p class="text-secondary small mb-0">
                Hiển thị phân trang <strong>6 video/trang</strong> theo đúng yêu cầu đề bài. 
                Tổng số video: <span class="badge bg-secondary">${totalVideos}</span>
            </p>
        </div>

        <div class="mt-2 mt-md-0">
            <a href="${pageContext.request.contextPath}/video/add" class="btn btn-primary">
                <i class="fa-solid fa-cloud-arrow-up me-1"></i>Thêm Video Mới (Multipart)
            </a>
        </div>
    </div>

    <!-- Thông báo nếu chưa đăng nhập -->
    <c:if test="${empty sessionScope.account}">
        <div class="alert alert-info py-2 d-flex justify-content-between align-items-center mb-4" role="alert">
            <div>
                <i class="fa-solid fa-circle-info me-2"></i>
                Bạn đang xem video ở chế độ khách. Hãy <strong>Đăng nhập</strong> để quản lý video của riêng bạn!
            </div>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary btn-sm">Đăng nhập ngay</a>
        </div>
    </c:if>

    <!-- Danh sách Video 6 video/trang (Yêu cầu 4.3) -->
    <c:choose>
        <c:when test="${empty videos}">
            <div class="text-center py-5 my-5">
                <i class="fa-solid fa-video-slash fa-4x text-secondary mb-3"></i>
                <h5 class="text-secondary">Chưa có video nào trong danh sách.</h5>
                <a href="${pageContext.request.contextPath}/video/add" class="btn btn-outline-primary btn-sm mt-2">
                    <i class="fa-solid fa-plus me-1"></i>Đăng video đầu tiên của bạn
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-5">
                <c:forEach items="${videos}" var="v">
                    <div class="col">
                        <div class="video-card">
                            <div class="thumb-wrapper">
                                <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" style="display: block; width: 100%; height: 100%;">
                                    <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" 
                                         alt="${v.title}">

                                    <span class="badge-views">
                                        <i class="fa-solid fa-eye me-1"></i>${v.views} lượt xem
                                    </span>

                                    <!-- Play overlay -->
                                    <span class="play-overlay">
                                        <i class="fa-solid fa-play"></i>
                                    </span>
                                </a>
                            </div>

                            <div class="video-body">
                                <div>
                                    <!-- Yêu cầu 4.4: Bấm chuột vào tiêu đề để xem chi tiết và play video -->
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" 
                                       class="video-title" 
                                       title="${v.title}">
                                        ${v.title}
                                    </a>

                                    <div class="small text-secondary mb-2">
                                        <c:if test="${not empty v.category}">
                                            <span class="badge bg-dark border border-secondary me-1">${v.category.categoryname}</span>
                                        </c:if>
                                        <span><i class="fa-solid fa-user me-1"></i>${not empty v.user ? v.user.fullName : 'Hệ thống'}</span>
                                    </div>

                                    <p class="small text-muted mb-3" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                        ${v.description != null ? v.description : 'Không có mô tả chi tiết'}
                                    </p>
                                </div>

                                <div class="d-flex justify-content-between align-items-center pt-2 border-top border-secondary">
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn btn-outline-info btn-sm">
                                        <i class="fa-solid fa-circle-play me-1"></i>Play Video
                                    </a>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/video/edit?id=${v.videoId}" class="btn btn-outline-warning btn-sm me-1" title="Sửa video">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/video/delete?id=${v.videoId}" class="btn btn-outline-danger btn-sm" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa video này không?');" title="Xóa video">
                                            <i class="fa-solid fa-trash"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Thanh phân trang (Pagination 6sp/trang) -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <!-- Nút Trang trước -->
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/video?page=${currentPage - 1}">
                                <i class="fa-solid fa-chevron-left me-1"></i>Trước
                            </a>
                        </li>

                        <!-- Các số trang -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/video?page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <!-- Nút Trang kế tiếp -->
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/video?page=${currentPage + 1}">
                                Sau<i class="fa-solid fa-chevron-right ms-1"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
