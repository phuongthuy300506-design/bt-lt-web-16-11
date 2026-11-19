<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu - HCMUTE Video</title>
    <style>
        .forgot-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 440px;
            padding: 35px 30px;
            margin: 40px auto;
        }
        .forgot-icon {
            width: 65px;
            height: 65px;
            border-radius: 50%;
            background: #fef2f2;
            color: #ef4444;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 15px;
        }
        .form-control {
            padding: 12px 14px;
            border-radius: 8px;
        }
        .btn-submit {
            padding: 12px;
            font-weight: 600;
            font-size: 16px;
            border-radius: 8px;
        }
    </style>
</head>
<body>

<div class="forgot-card text-center">
    <div class="forgot-icon">
        <i class="fa-solid fa-key"></i>
    </div>

    <h3 class="fw-bold text-dark mb-1">Quên Mật Khẩu?</h3>
    <p class="text-secondary small mb-3">
        Nhập địa chỉ email tài khoản của bạn để nhận mã OTP xác thực đặt lại mật khẩu mới.
    </p>

    <c:if test="${not empty alert}">
        <div class="alert alert-danger py-2 px-3 small text-start d-flex align-items-center mb-3">
            <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
            <div>${alert}</div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="text-start needs-validation" novalidate>
        <!-- Email Validation -->
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Địa chỉ Email đăng ký <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-muted"></i></span>
                <input type="email" name="email" class="form-control ${not empty errorEmail ? 'is-invalid' : ''}" 
                       placeholder="Ví dụ: your_email@gmail.com" value="${email}" required autofocus>
                <c:if test="${not empty errorEmail}">
                    <div class="invalid-feedback d-block">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorEmail}
                    </div>
                </c:if>
                <div class="invalid-feedback">
                    Vui lòng nhập địa chỉ email hợp lệ.
                </div>
            </div>
        </div>

        <button type="submit" class="btn btn-danger w-100 btn-submit mb-3">
            <i class="fa-solid fa-paper-plane me-2"></i>Gửi Mã Xác Nhận OTP
        </button>

        <div class="text-center small text-secondary">
            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-muted">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại trang Đăng nhập
            </a>
        </div>
    </form>
</div>

</body>
</html>
