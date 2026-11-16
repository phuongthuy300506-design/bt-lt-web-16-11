<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Video - HCMUTE</title>
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
        .current-poster {
            width: 140px;
            height: 85px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid #e2e8f0;
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
                    <i class="fa-solid fa-pen-to-square text-warning me-2"></i>Chỉnh Sửa Video
                </h3>
                <small class="text-muted">Cập nhật thông tin và tải ảnh Poster mới nếu cần</small>
            </div>
            <a href="${isAdmin ? pageContext.request.contextPath.concat('/admin/videos') : pageContext.request.contextPath.concat('/video')}" 
               class="btn btn-outline-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại
            </a>
        </div>

        <form action="${isAdmin ? pageContext.request.contextPath.concat('/admin/video/update') : pageContext.request.contextPath.concat('/video/update')}" 
              method="post" enctype="multipart/form-data">

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Mã Video (Video ID)</label>
                    <input type="text" name="videoId" class="form-control bg-light" value="${video.videoId}" readonly>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Danh mục (Category)</label>
                    <select name="categoryId" class="form-select" required>
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.categoryid}" ${video.category.categoryid == c.categoryid ? 'selected' : ''}>
                                ${c.categoryname}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Tiêu đề Video <span class="text-danger">*</span></label>
                <input type="text" name="title" class="form-control" value="${video.title}" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Ảnh đại diện Poster hiện tại</label>
                <div class="d-flex align-items-center gap-3 mb-2">
                    <img src="${pageContext.request.contextPath}/image?fname=${video.poster}" 
                         alt="${video.title}" class="current-poster"
                         onerror="this.src='https://picsum.photos/seed/${video.videoId}/140/85'">
                    <span class="text-muted small">File hiện tại: <code>${video.poster}</code></span>
                </div>
                <label class="form-label small text-secondary">Tải lên ảnh mới thay thế (nếu muốn):</label>
                <input type="file" name="posterFile" class="form-control" accept="image/*">
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Đường dẫn Video (URL) hoặc Tải file video mới</label>
                <input type="text" name="videoUrl" class="form-control mb-2" value="${video.videoUrl}" 
                       placeholder="Nhập link video trực tiếp (MP4 / YouTube)">
                <input type="file" name="videoFile" class="form-control" accept="video/mp4,video/*">
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Mô tả nội dung</label>
                <textarea name="description" class="form-control" rows="4">${video.description}</textarea>
            </div>

            <div class="mb-4">
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" name="active" value="1" id="activeCheck" ${video.active == 1 ? 'checked' : ''}>
                    <label class="form-check-label fw-semibold" for="activeCheck">Cho phép hiển thị công khai (Active)</label>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2">
                <a href="${isAdmin ? pageContext.request.contextPath.concat('/admin/videos') : pageContext.request.contextPath.concat('/video')}" 
                   class="btn btn-secondary px-4">Hủy</a>
                <button type="submit" class="btn btn-warning px-4 text-dark fw-semibold">
                    <i class="fa-solid fa-floppy-disk me-2"></i>Cập Nhật Video
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
