<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân - HCMUTE Video Platform</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .profile-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 15px;
        }
        .profile-card {
            background-color: #1e293b;
            border: 1px solid #334155;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            overflow: hidden;
        }
        .profile-header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            padding: 35px 25px 25px;
            text-align: center;
            color: #ffffff;
            position: relative;
        }
        .avatar-wrapper {
            position: relative;
            display: inline-block;
            margin-bottom: 15px;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #ffffff;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
            background-color: #0f172a;
        }
        .badge-role {
            font-size: 12px;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 600;
        }
        .form-label {
            color: #cbd5e1;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .form-control, .form-select {
            background-color: #0f172a;
            border: 1px solid #475569;
            color: #f8fafc;
            border-radius: 8px;
            padding: 10px 14px;
        }
        .form-control:focus {
            background-color: #0f172a;
            border-color: #3b82f6;
            color: #ffffff;
            box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.25);
        }
        .form-control:disabled, .form-control[readonly] {
            background-color: #1e293b;
            color: #94a3b8;
            border-color: #334155;
        }
        .btn-update {
            background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
            border: none;
            color: white;
            font-weight: 600;
            padding: 12px 28px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.4);
            color: white;
        }
        .info-pill {
            background: rgba(15, 23, 42, 0.6);
            border-radius: 8px;
            padding: 10px 15px;
            margin-bottom: 12px;
            border: 1px solid #334155;
        }
        .cloudinary-badge {
            background: linear-gradient(135deg, #0284c7 0%, #06b6d4 100%);
            color: white;
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 6px;
            display: inline-block;
        }
    </style>
</head>
<body>

<div class="profile-container">

    <!-- Thông báo thành công -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center shadow-sm mb-4" role="alert">
            <i class="fa-solid fa-circle-check fs-4 me-3 text-success"></i>
            <div>
                <strong>Thành công!</strong> ${successMessage}
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Thông báo lỗi -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center shadow-sm mb-4" role="alert">
            <i class="fa-solid fa-circle-exclamation fs-4 me-3 text-danger"></i>
            <div>
                <strong>Lỗi cập nhật!</strong> ${errorMessage}
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="profile-card">
        <!-- Header thông tin người dùng -->
        <div class="profile-header">
            <div class="avatar-wrapper">
                <c:choose>
                    <c:when test="${not empty user.avatar && user.avatar.startsWith('http')}">
                        <img src="${user.avatar}" alt="Avatar" class="profile-avatar" id="avatarPreview">
                    </c:when>
                    <c:when test="${not empty user.avatar}">
                        <img src="${pageContext.request.contextPath}/image?fname=${user.avatar}" 
                             alt="Avatar" class="profile-avatar" id="avatarPreview"
                             onerror="this.src='${pageContext.request.contextPath}/uploads/user.png'">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/uploads/user.png" 
                             alt="Avatar" class="profile-avatar" id="avatarPreview">
                    </c:otherwise>
                </c:choose>
            </div>
            <h4 class="fw-bold mb-1">${not empty user.fullName ? user.fullName : user.username}</h4>
            <p class="text-white-50 mb-2">@${user.username} • ${user.email}</p>
            <div>
                <c:choose>
                    <c:when test="${user.roleid == 1}">
                        <span class="badge bg-danger badge-role"><i class="fa-solid fa-shield me-1"></i>Quản trị viên (Admin)</span>
                    </c:when>
                    <c:when test="${user.roleid == 2}">
                        <span class="badge bg-warning text-dark badge-role"><i class="fa-solid fa-user-tie me-1"></i>Trưởng bộ phận</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-primary badge-role"><i class="fa-solid fa-user me-1"></i>Thành viên</span>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty user.avatar && user.avatar.startsWith('http')}">
                    <span class="cloudinary-badge ms-2"><i class="fa-solid fa-cloud me-1"></i>Ảnh Cloudinary</span>
                </c:if>
            </div>
        </div>

        <!-- Form chỉnh sửa thông tin Profile -->
        <div class="p-4 p-md-5">
            <h5 class="fw-bold mb-4 text-white d-flex align-items-center">
                <i class="fa-solid fa-user-pen text-danger me-2"></i>Cập Nhật Thông Tin Hồ Sơ
            </h5>

            <form action="${pageContext.request.contextPath}/profile" 
                  method="post" enctype="multipart/form-data" class="needs-validation" novalidate>

                <div class="row g-4">
                    <!-- Tên đăng nhập (Readonly) -->
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-user-tag me-1 text-secondary"></i>Tên Đăng Nhập</label>
                        <input type="text" class="form-control" value="${user.username}" readonly>
                        <small class="text-secondary" style="font-size: 11px;">Tên đăng nhập là định danh cố định không thể thay đổi.</small>
                    </div>

                    <!-- Vai trò (Readonly) -->
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-shield-halved me-1 text-secondary"></i>Vai Trò Hệ Thống</label>
                        <input type="text" class="form-control" 
                               value="${user.roleid == 1 ? 'Quản Trị Viên (Admin)' : (user.roleid == 2 ? 'Quản Lý (Manager)' : 'Người Dùng (User)')}" readonly>
                    </div>

                    <!-- Họ và tên (Editable with validation) -->
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-signature me-1 text-primary"></i>Họ và Tên <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control" 
                               value="${user.fullName}" minlength="2" required placeholder="Nhập họ và tên đầy đủ...">
                        <div class="invalid-feedback">Vui lòng nhập họ và tên (tối thiểu 2 ký tự).</div>
                    </div>

                    <!-- Số điện thoại (Editable with validation) -->
                    <div class="col-md-6">
                        <label class="form-label"><i class="fa-solid fa-phone me-1 text-success"></i>Số Điện Thoại</label>
                        <input type="tel" name="phone" class="form-control" 
                               value="${user.phone}" pattern="0[0-9]{9}" placeholder="Ví dụ: 0908617108">
                        <small class="text-secondary" style="font-size: 11px;">Định dạng: 10 chữ số di động (bắt đầu bằng 0).</small>
                        <div class="invalid-feedback">Số điện thoại phải gồm đúng 10 chữ số (bắt đầu bằng số 0).</div>
                    </div>

                    <!-- Email mới (Có xác thực OTP theo Yêu cầu 3) -->
                    <div class="col-12">
                        <label class="form-label"><i class="fa-solid fa-envelope me-1 text-danger"></i>Địa Chỉ Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" 
                               value="${user.email}" required placeholder="Nhập địa chỉ email...">
                        <div class="p-2 mt-2 rounded bg-dark border border-secondary" style="font-size: 12px; color: #94a3b8;">
                            <i class="fa-solid fa-circle-info text-warning me-1"></i>
                            <strong>Quy định Yêu cầu 3:</strong> Nếu bạn đổi sang địa chỉ email mới, hệ thống sẽ tự động gửi mã xác thực <strong>OTP</strong> đến email mới đó để xác nhận cập nhật thành công.
                        </div>
                        <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ.</div>
                    </div>

                    <!-- Tải ảnh đại diện lên Cloudinary bằng multipart -->
                    <div class="col-12">
                        <label class="form-label"><i class="fa-solid fa-cloud-arrow-up me-1 text-info"></i>Ảnh Đại Diện (Upload lên Cloudinary bằng Multipart)</label>
                        <input type="file" name="avatar" id="avatarInput" class="form-control" 
                               accept="image/png, image/jpeg, image/jpg, image/webp" onchange="previewImage(event)">
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <small class="text-secondary" style="font-size: 11px;">
                                Hỗ trợ: .jpg, .jpeg, .png, .webp (Tối đa 10 MB). File sẽ được tải trực tiếp lên kho lưu trữ đám mây <strong>Cloudinary</strong>.
                            </small>
                            <span class="badge bg-secondary" style="font-size: 11px;">Multipart / Cloudinary</span>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-5 pt-3 border-top border-secondary">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4">
                        <i class="fa-solid fa-arrow-left me-1"></i>Trang Chủ
                    </a>
                    <button type="submit" class="btn btn-update d-flex align-items-center">
                        <i class="fa-solid fa-floppy-disk me-2"></i>Lưu Thay Đổi Hồ Sơ
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// Xem trước ảnh đại diện khi chọn file
function previewImage(event) {
    var input = event.target;
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var preview = document.getElementById('avatarPreview');
            if (preview) {
                preview.src = e.target.result;
            }
        };
        reader.readAsDataURL(input.files[0]);
    }
}

// Bootstrap 5 client-side validation
(function () {
    'use strict';
    var forms = document.querySelectorAll('.needs-validation');
    Array.prototype.slice.call(forms).forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
})();
</script>

</body>
</html>
