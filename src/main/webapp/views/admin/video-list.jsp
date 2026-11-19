<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Videos - Admin HCMUTE</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background-color: #f1f5f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .admin-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            border: 1px solid #e2e8f0;
            padding: 24px;
        }
        .thumb-preview {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 6px;
        }
    </style>
</head>
<body>

<div class="container-fluid py-2">
    <div class="admin-card">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <h3 class="fw-bold text-dark mb-1 d-flex align-items-center">
                    <i class="fa-solid fa-clapperboard text-danger me-2"></i>Quản Lý Bảng Videos (Admin CRUD)
                </h3>
                <span class="text-muted small">Yêu cầu 4.1: Thực hiện đầy đủ các chức năng CRUD cho bảng Videos</span>
            </div>
            <div class="mt-2 mt-md-0 d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-danger">
                    <i class="fa-solid fa-plus me-1"></i>Thêm Video Mới (Multipart)
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-tags me-1"></i>Quản lý Danh mục
                </a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th style="width: 100px;">Mã Video</th>
                        <th style="width: 100px;">Poster</th>
                        <th>Tiêu Đề</th>
                        <th>Danh Mục</th>
                        <th>Người Đăng (User)</th>
                        <th>Lượt Xem</th>
                        <th>Trạng Thái</th>
                        <th style="width: 180px;" class="text-center">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${listVideos}" var="v">
                        <tr>
                            <td><code>${v.videoId}</code></td>
                            <td>
                                <img src="${pageContext.request.contextPath}/image?fname=${v.poster}" 
                                     alt="${v.title}" class="thumb-preview"
                                     onerror="this.src='https://picsum.photos/seed/${v.videoId}/80/50'">
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" 
                                   class="text-decoration-none fw-semibold text-dark" target="_blank" title="Bấm để xem video">
                                    ${v.title} <i class="fa-solid fa-arrow-up-right-from-square text-muted small ms-1"></i>
                                </a>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty v.category}">
                                        <span class="badge bg-primary">${v.category.categoryname}</span>
                                    </c:when>
                                    <c:otherwise><span class="text-muted small">Chưa phân loại</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty v.user}">
                                        <span class="fw-semibold text-secondary">
                                            <i class="fa-solid fa-user me-1"></i>${not empty v.user.fullName ? v.user.fullName : v.user.username}
                                        </span>
                                    </c:when>
                                    <c:otherwise><span class="text-muted small">Hệ thống</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><span class="badge bg-secondary">${v.views} views</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.active == 1}">
                                        <span class="badge bg-success">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/admin/video/edit?id=${v.videoId}" 
                                   class="btn btn-warning btn-sm me-1" title="Chỉnh sửa">
                                    <i class="fa-solid fa-pen-to-square"></i> Sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/video/delete?id=${v.videoId}" 
                                   class="btn btn-danger btn-sm" 
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa video [${v.videoId}] này không?');" title="Xóa">
                                    <i class="fa-solid fa-trash"></i> Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listVideos}">
                        <tr>
                            <td colspan="8" class="text-center py-4 text-muted">Chưa có video nào trong cơ sở dữ liệu.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
