<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Video - ${video.videoId}</title>
    <style>
        .form-card {
            background: #1e293b;
            border-radius: 14px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
            border: 1px solid #334155;
            padding: 30px;
            max-width: 750px;
            margin: auto;
            color: #e2e8f0;
        }
        .form-control, .form-select {
            background-color: #0f172a;
            border: 1px solid #334155;
            color: #f8fafc;
            padding: 10px 14px;
            border-radius: 8px;
        }
        .form-control:focus, .form-select:focus {
            background-color: #0f172a;
            border-color: #ef4444;
            color: #ffffff;
            box-shadow: 0 0 0 0.25rem rgba(239, 68, 68, 0.2);
        }
        .poster-preview {
            max-height: 120px;
            border-radius: 8px;
            border: 1px solid #334155;
            object-fit: cover;
        }
    </style>
</head>
<body>

<div class="container py-4">
    <div class="form-card">
        <div class="mb-4 pb-3 border-bottom border-secondary d-flex justify-content-between align-items-center">
            <div>
                <h3 class="fw-bold text-white mb-1">
                    <i class="fa-solid fa-pen-to-square text-warning me-2"></i>Chỉnh Sửa Video
                </h3>
                <small class="text-secondary">Cập nhật thông tin cho video có mã ID: <strong>${video.videoId}</strong></small>
            </div>
            <a href="${isAdmin ? pageContext.request.contextPath.concat('/admin/videos') : pageContext.request.contextPath.concat('/video')}" 
               class="btn btn-outline-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại
            </a>
        </div>

        <c:if test="${not empty alert}">
            <div class="alert alert-danger py-2 px-3 small d-flex align-items-center mb-3">
                <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
                <div>${alert}</div>
            </div>
        </c:if>

        <form action="${isAdmin ? pageContext.request.contextPath.concat('/admin/video/update') : pageContext.request.contextPath.concat('/video/update')}" 
              method="post" enctype="multipart/form-data" class="needs-validation" novalidate>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Mã Video (Khóa chính - Không thay đổi)</label>
                    <input type="text" name="videoId" class="form-control" value="${video.videoId}" readonly style="background-color: #1e293b; opacity: 0.8;">
                </div>

                <!-- Tiêu đề Video Validation -->
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Tiêu Đề Video <span class="text-danger">*</span></label>
                    <input type="text" name="title" class="form-control ${not empty errorTitle ? 'is-invalid' : ''}" 
                           value="${video.title}" minlength="3" required autofocus>
                    <c:if test="${not empty errorTitle}">
                        <div class="invalid-feedback d-block">
                            <i class="fa-solid fa-circle-exclamation me-1"></i>${errorTitle}
                        </div>
                    </c:if>
                    <div class="invalid-feedback">
                        Vui lòng nhập tiêu đề video (tối thiểu 3 ký tự).
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Danh mục Video Validation -->
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Danh Mục (Category) <span class="text-danger">*</span></label>
                    <select name="categoryId" class="form-select ${not empty errorCategory ? 'is-invalid' : ''}" required>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.categoryid}" ${cat.categoryid == video.category.categoryid ? 'selected' : ''}>
                                ${cat.categoryname}
                            </option>
                        </c:forEach>
                    </select>
                    <c:if test="${not empty errorCategory}">
                        <div class="invalid-feedback d-block">
                            <i class="fa-solid fa-circle-exclamation me-1"></i>${errorCategory}
                        </div>
                    </c:if>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Trạng Thái Kích Hoạt</label>
                    <select name="active" class="form-select">
                        <option value="1" ${video.active == 1 ? 'selected' : ''}>Công khai (Active)</option>
                        <option value="0" ${video.active == 0 ? 'selected' : ''}>Tạm ẩn (Inactive)</option>
                    </select>
                </div>
            </div>

            <div class="row align-items-center mb-3">
                <div class="col-md-4 text-center">
                    <label class="form-label fw-semibold d-block">Poster Hiện Tại</label>
                    <c:choose>
                        <c:when test="${video.poster != null && fn:startsWith(video.poster, 'http')}">
                            <c:set var="curPoster" value="${video.poster}" />
                        </c:when>
                        <c:otherwise>
                            <c:url value="/image?fname=${video.poster}" var="curPoster" />
                        </c:otherwise>
                    </c:choose>
                    <img src="${curPoster}" alt="${video.title}" class="poster-preview img-fluid mb-2"
                         onerror="this.onerror=null; this.src='https://placehold.co/180x100?text=No+Poster';">
                </div>
                <div class="col-md-8">
                    <!-- File Poster Validation -->
                    <label class="form-label fw-semibold">Chọn File Poster Mới Thay Thế</label>
                    <input type="file" name="poster" class="form-control ${not empty errorPoster ? 'is-invalid' : ''}" 
                           accept="image/png, image/jpeg, image/jpg, image/webp">
                    <c:if test="${not empty errorPoster}">
                        <div class="invalid-feedback d-block">
                            <i class="fa-solid fa-circle-exclamation me-1"></i>${errorPoster}
                        </div>
                    </c:if>
                    <small class="text-secondary" style="font-size: 11px;">Để trống nếu muốn giữ nguyên poster hiện tại.</small>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-semibold">Mô Tả Chi Tiết Video</label>
                <textarea name="description" class="form-control" rows="4">${video.description}</textarea>
            </div>

            <div class="d-flex justify-content-end gap-2 pt-3 border-top border-secondary">
                <a href="${isAdmin ? pageContext.request.contextPath.concat('/admin/videos') : pageContext.request.contextPath.concat('/video')}" 
                   class="btn btn-secondary px-4">Hủy Bỏ</a>
                <button type="submit" class="btn btn-warning px-4 fw-semibold">
                    <i class="fa-solid fa-floppy-disk me-2"></i>Lưu Thay Đổi
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
