<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lại Mật Khẩu Mới - HCMUTE</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }
        .reset-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 450px;
            padding: 35px 30px;
        }
        .form-control {
            padding: 11px 14px;
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

<div class="reset-card">
    <div class="text-center mb-3">
        <i class="fa-solid fa-lock-open text-primary fa-3x"></i>
        <h4 class="fw-bold text-dark mt-2 mb-1">Đặt Lại Mật Khẩu</h4>
        <small class="text-muted">Nhập mã OTP đã nhận qua email và mật khẩu mới</small>
    </div>

    <c:if test="${not empty smtpError}">
        <div class="alert alert-warning py-2 px-3 small d-flex align-items-center mb-3" style="background: #fffbeb; border: 1px solid #fef3c7; color: #92400e;">
            <i class="fa-solid fa-triangle-exclamation me-2 fs-5 text-warning"></i>
            <div>${smtpError}</div>
        </div>
    </c:if>
    <c:if test="${empty smtpError and not mailConfigured}">
        <div class="alert alert-warning py-2 px-3 small d-flex align-items-center mb-3" style="background: #fffbeb; border: 1px solid #fef3c7; color: #92400e;">
            <i class="fa-solid fa-circle-info me-2 fs-5 text-warning"></i>
            <div>Chưa cấu hình Mật khẩu ứng dụng Gmail trong <strong>Constant.java</strong>. Mã OTP đã được in tại cửa sổ <strong>Tomcat Console</strong>!</div>
        </div>
    </c:if>

    <c:if test="${not empty alert}">
        <div class="alert alert-danger py-2 px-3 small d-flex align-items-center mb-3">
            <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
            <div>${alert}</div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/reset-password" method="post">
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Địa chỉ Email</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-muted"></i></span>
                <input type="email" name="email" class="form-control" value="${not empty email ? email : param.email}" required readonly>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Mã xác nhận OTP (6 chữ số) <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-shield-halved text-muted"></i></span>
                <input type="text" name="otp" class="form-control fw-bold text-primary" maxlength="6" 
                       value="${not empty autoOtp ? autoOtp : ''}"
                       placeholder="Nhập 6 số OTP" required autofocus>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Mật khẩu mới <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                <input type="password" name="newPassword" class="form-control" placeholder="Nhập mật khẩu mới" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-circle-check text-muted"></i></span>
                <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới" required>
            </div>
        </div>

        <button type="submit" class="btn btn-primary w-100 btn-submit mb-3">
            <i class="fa-solid fa-key me-2"></i>Cập Nhật Mật Khẩu Mới
        </button>

        <div class="text-center small text-secondary">
            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-muted">
                Quay lại Đăng nhập
            </a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
