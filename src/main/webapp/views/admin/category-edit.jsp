<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập Nhật Danh Mục #${cate.categoryid} - Admin HCMUTE</title>
    <style>
        .form-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 14px;
            max-width: 600px;
            margin: 0 auto;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
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
        .form-label {
            color: #cbd5e1;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 6px;
        }
        .img-preview {
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #334155;
        }
    </style>
</head>
<body>

<div class="container py-4">
    <div class="form-card">
        <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom border-secondary">
            <div>
                <h4 class="fw-bold text-white mb-1">
                    <i class="fa-solid fa-pen-to-square text-warning me-2"></i>Cập Nhật Danh Mục
                </h4>
                <p class="text-secondary small mb-0">Chỉnh sửa thông tin danh mục ID #${cate.categoryid}</p>
            </div>
            <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại
            </a>
        </div>

        <c:if test="${not empty alert}">
            <div class="alert alert-danger py-2 px-3 small d-flex align-items-center mb-3">
                <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
                <div>${alert}</div>
            </div>
        </c:if>

        <form action="<c:url value='/admin/category/update'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
            <!-- ID ẩn -->
            <input type="hidden" name="categoryid" value="${cate.categoryid}">

            <!-- Tên Danh Mục Validation -->
            <div class="mb-3">
                <label class="form-label">Tên Danh Mục <span class="text-danger">*</span></label>
                <input type="text" name="categoryname" class="form-control ${not empty errorName ? 'is-invalid' : ''}" 
                       value="${cate.categoryname}" minlength="2" maxlength="100" required autofocus>
                <c:if test="${not empty errorName}">
                    <div class="invalid-feedback d-block">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorName}
                    </div>
                </c:if>
                <div class="invalid-feedback">
                    Vui lòng nhập tên danh mục (từ 2 đến 100 ký tự).
                </div>
            </div>

            <!-- Xem trước hình ảnh hiện tại -->
            <div class="mb-3">
                <label class="form-label d-block">Hình Ảnh Hiện Tại</label>
                <c:choose>
                    <c:when test="${cate.images != null && fn:startsWith(cate.images, 'http')}">
                        <c:set var="curImg" value="${cate.images}" />
                    </c:when>
                    <c:otherwise>
                        <c:url value="/image?fname=${cate.images}" var="curImg" />
                    </c:otherwise>
                </c:choose>
                <img class="img-preview mb-2" height="70" width="100" src="${curImg}" alt="${cate.categoryname}"
                     onerror="this.onerror=null; this.src='https://placehold.co/100x70?text=No+Img';" />
                <input type="hidden" name="images" value="${cate.images}">
            </div>

            <!-- Tải ảnh mới thay thế -->
            <div class="mb-3">
                <label class="form-label">Chọn File Ảnh Mới Thay Thế</label>
                <input type="file" name="images1" class="form-control ${not empty errorImage ? 'is-invalid' : ''}" 
                       accept="image/png, image/jpeg, image/jpg, image/webp, image/gif">
                <c:if test="${not empty errorImage}">
                    <div class="invalid-feedback d-block">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorImage}
                    </div>
                </c:if>
                <small class="text-secondary" style="font-size: 11px;">Để trống nếu muốn giữ nguyên ảnh hiện tại</small>
            </div>

            <!-- Trạng Thái -->
            <div class="mb-4">
                <label class="form-label">Trạng Thái Hoạt Động</label>
                <select name="status" class="form-select">
                    <option value="1" ${cate.status == 1 ? 'selected' : ''}>Hoạt động (Hiển thị cho người dùng)</option>
                    <option value="0" ${cate.status == 0 ? 'selected' : ''}>Khóa / Tạm ẩn</option>
                </select>
            </div>

            <div class="d-flex justify-content-end gap-2 pt-2 border-top border-secondary">
                <a href="<c:url value='/admin/categories'/>" class="btn btn-secondary px-4">Hủy</a>
                <button type="submit" class="btn btn-danger px-4 fw-semibold">
                    <i class="fa-solid fa-floppy-disk me-1"></i>Lưu Thay Đổi
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
