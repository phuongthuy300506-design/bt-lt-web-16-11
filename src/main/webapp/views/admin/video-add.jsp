<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Video Mới - HCMUTE Multipart Upload</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background-color: #f1f5f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .form-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            border: 1px solid #e2e8f0;
            padding: 30px;
            max-width: 750px;
            margin: auto;
        }
    </style>
</head>
<body>

<jsp:include page="/views/common/topbar.jsp" />

<div class="container py-4">
    <div class="form-card">
        <div class="mb-4 pb-3 border-bottom d-flex justify-content-between align-items-center">
            <div>
                <h3 class="fw-bold text-dark mb-1">
                    <i class="fa-solid fa-cloud-arrow-up text-primary me-2"></i>Thêm Video Mới
                </h3>
                <small class="text-muted">Upload file Poster & Video bằng Multipart Servlet theo chuẩn giáo trình</small>
            </div>
            <a href="${isAdmin ? pageContext.request.contextPath.concat('/admin/videos') : pageContext.request.contextPath.concat('/video')}" 
               class="btn btn-outline-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại
            </a>
        </div>

        <!-- Form Multipart (Yêu cầu 4.1 & 4.5) -->
        <form action="${isAdmin ? pageContext.request.contextPath.concat('/admin/video/insert') : pageContext.request.contextPath.concat('/video/insert')}" 
              method="post" enctype="multipart/form-data">

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Mã Video (Video ID) <span class="text-danger">*</span></label>
                    <input type="text" name="videoId" class="form-control" placeholder="Ví dụ: v02, v03..." required autofocus>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Danh mục (Category) <span class="text-danger">*</span></label>
                    <select name="categoryId" class="form-select" required>
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.categoryid}">${c.categoryname}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Tiêu đề Video <span class="text-danger">*</span></label>
                <input type="text" name="title" class="form-control" placeholder="Nhập tiêu đề video hấp dẫn" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Chọn file Ảnh đại diện Poster (Multipart File Upload) <span class="text-danger">*</span></label>
                <input type="file" name="posterFile" class="form-control" accept="image/*">
                <small class="text-muted">Chọn file ảnh JPG, PNG, WEBP từ máy tính của bạn</small>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Đường dẫn Video hoặc File Video tải lên</label>
                <input type="text" name="videoUrl" class="form-control mb-2" 
                       placeholder="Nhập link video trực tiếp (MP4 / YouTube). Để trống sẽ dùng video mẫu.">
                <div class="text-muted small mb-1">Hoặc upload file video trực tiếp từ máy (MP4):</div>
                <input type="file" name="videoFile" class="form-control" accept="video/mp4,video/*">
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Mô tả nội dung Video</label>
                <textarea name="description" class="form-control" rows="4" placeholder="Nhập tóm tắt hoặc nội dung chi tiết của video..."></textarea>
            </div>

            <div class="mb-4">
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" name="active" value="1" id="activeCheck" checked>
                    <label class="form-check-label fw-semibold" for="activeCheck">Cho phép hiển thị công khai (Active)</label>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2">
                <a href="${isAdmin ? pageContext.request.contextPath.concat('/admin/videos') : pageContext.request.contextPath.concat('/video')}" 
                   class="btn btn-secondary px-4">Hủy</a>
                <button type="submit" class="btn btn-primary px-4">
                    <i class="fa-solid fa-cloud-arrow-up me-2"></i>Lưu & Đăng Video
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
