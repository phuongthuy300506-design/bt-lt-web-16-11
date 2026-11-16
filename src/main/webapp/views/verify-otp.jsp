<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Thực OTP Kích Hoạt Tài Khoản - HCMUTE</title>
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
        .otp-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 440px;
            padding: 35px 30px;
            text-align: center;
        }
        .otp-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #eff6ff;
            color: #2563eb;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin-bottom: 20px;
        }
        .otp-input {
            letter-spacing: 12px;
            font-size: 26px;
            font-weight: 700;
            text-align: center;
            padding: 12px;
            border-radius: 8px;
            border: 2px solid #cbd5e1;
        }
        .otp-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 0.25rem rgba(37, 99, 235, 0.15);
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

<div class="otp-card">
    <div class="otp-icon">
        <i class="fa-solid fa-shield-halved"></i>
    </div>

    <h3 class="fw-bold text-dark mb-1">Xác Thực Mã OTP</h3>
    <p class="text-secondary small mb-3">
        Mã OTP xác thực gồm 6 chữ số đã được gửi qua email cho tài khoản:
        <br/><strong class="text-primary">${not empty username ? username : sessionScope.verify_username}</strong>
    </p>

    <c:if test="${not empty alert}">
        <div class="alert alert-danger py-2 px-3 small text-start d-flex align-items-center mb-3">
            <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
            <div>${alert}</div>
        </div>
    </c:if>

    <c:if test="${param.resent == 'true'}">
        <div class="alert alert-info py-2 px-3 small text-start d-flex align-items-center mb-3">
            <i class="fa-solid fa-check me-2 fs-5"></i>
            <div>Đã gửi lại mã OTP mới!</div>
        </div>
    </c:if>

    <c:if test="${not mailConfigured}">
        <div class="alert alert-warning py-2 px-3 small text-start d-flex align-items-center mb-3" style="background: #fffbeb; border: 1px solid #fef3c7; color: #92400e;">
            <i class="fa-solid fa-circle-info me-2 fs-5 text-warning"></i>
            <div>Chưa cấu hình Mật khẩu ứng dụng Gmail trong <strong>Constant.java</strong>. Mã OTP đã được in tại cửa sổ <strong>Tomcat Console</strong>!</div>
        </div>
    </c:if>

    <c:if test="${param.not_activated == 'true'}">
        <div class="alert alert-warning py-2 px-3 small text-start d-flex align-items-center mb-3">
            <i class="fa-solid fa-circle-exclamation me-2 fs-5"></i>
            <div>Tài khoản của bạn chưa kích hoạt. Vui lòng nhập mã OTP để kích hoạt!</div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/verify-otp" method="post">
        <input type="hidden" name="username" value="${not empty username ? username : sessionScope.verify_username}">

        <div class="mb-4">
            <input type="text" name="otp" class="form-control otp-input" maxlength="6" 
                   placeholder="------" required autofocus autocomplete="off">
        </div>

        <button type="submit" class="btn btn-primary w-100 btn-submit mb-3">
            <i class="fa-solid fa-circle-check me-2"></i>Kích Hoạt Tài Khoản
        </button>
    </form>

    <div class="d-flex justify-content-between align-items-center small text-secondary mt-3">
        <a href="${pageContext.request.contextPath}/resend-otp?username=${not empty username ? username : sessionScope.verify_username}" 
           class="text-decoration-none text-primary fw-semibold">
            <i class="fa-solid fa-rotate-right me-1"></i>Gửi lại mã OTP
        </a>
        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-muted">
            Quay lại Đăng nhập
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
