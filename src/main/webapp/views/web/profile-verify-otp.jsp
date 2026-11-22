<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Thực OTP Đổi Email - HCMUTE Video Platform</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .otp-container {
            max-width: 540px;
            margin: 50px auto;
            padding: 0 15px;
        }
        .otp-card {
            background-color: #1e293b;
            border: 1px solid #334155;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
            padding: 35px 30px;
            color: #f8fafc;
            text-align: center;
        }
        .otp-icon {
            width: 76px;
            height: 76px;
            border-radius: 50%;
            background: rgba(239, 68, 68, 0.15);
            color: #ef4444;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            margin-bottom: 20px;
        }
        .otp-input {
            letter-spacing: 8px;
            font-size: 26px;
            font-weight: 700;
            text-align: center;
            background-color: #0f172a;
            border: 2px solid #475569;
            color: #ef4444;
            border-radius: 10px;
            padding: 12px;
        }
        .otp-input:focus {
            background-color: #0f172a;
            border-color: #ef4444;
            box-shadow: 0 0 0 0.25rem rgba(239, 68, 68, 0.25);
            color: #ffffff;
        }
        .btn-confirm {
            background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
            border: none;
            color: white;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.4);
            color: white;
        }
        .email-highlight {
            color: #38bdf8;
            font-weight: 700;
            word-break: break-all;
        }
    </style>
</head>
<body>

<div class="otp-container">
    <div class="otp-card">
        <div class="otp-icon">
            <i class="fa-solid fa-envelope-circle-check"></i>
        </div>

        <h3 class="fw-bold mb-2">Xác Thực Email Mới</h3>
        <p class="text-secondary small mb-4">
            Theo <strong>Yêu cầu 3</strong>, hệ thống đã gửi mã OTP xác nhận gồm 6 chữ số đến địa chỉ email mới của bạn:
            <br>
            <span class="email-highlight fs-6">${pendingEmail}</span>
        </p>

        <!-- Thông báo lỗi nếu OTP sai -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 mb-3 text-start small">
                <i class="fa-solid fa-circle-exclamation me-1"></i>${errorMessage}
            </div>
        </c:if>

        <!-- Thông báo khi gửi lại mã OTP -->
        <c:if test="${not empty infoMessage}">
            <div class="alert alert-info py-2 mb-3 text-start small">
                <i class="fa-solid fa-circle-info me-1"></i>${infoMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/profile/verify-otp" method="post" class="needs-validation" novalidate>
            <div class="mb-4 text-start">
                <label class="form-label text-secondary small fw-semibold text-center w-100">
                    Nhập mã xác thực OTP (6 chữ số):
                </label>
                <!-- Tự động điền mã OTP để thuận tiện test trực tiếp không cần mở email -->
                <input type="text" name="otp" class="form-control otp-input" 
                       value="${not empty autoOtp ? autoOtp : ''}" 
                       maxlength="6" minlength="6" required autofocus placeholder="------">
                <div class="invalid-feedback text-center">
                    Vui lòng nhập đầy đủ mã OTP gồm 6 chữ số.
                </div>
            </div>

            <button type="submit" class="btn btn-confirm w-100 mb-3">
                <i class="fa-solid fa-check-circle me-2"></i>Xác Nhận Cập Nhật Email
            </button>
        </form>

        <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top border-secondary small">
            <a href="${pageContext.request.contextPath}/profile" class="text-secondary text-decoration-none">
                <i class="fa-solid fa-arrow-left me-1"></i>Hủy &amp; Quay lại
            </a>
            <form action="${pageContext.request.contextPath}/profile/resend-otp" method="post" class="d-inline">
                <button type="submit" class="btn btn-link text-info p-0 small text-decoration-none fw-semibold">
                    <i class="fa-solid fa-rotate-right me-1"></i>Gửi lại mã OTP
                </button>
            </form>
        </div>
    </div>
</div>

<script>
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
