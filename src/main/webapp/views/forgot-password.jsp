<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu - HCMUTE Video</title>
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
        .forgot-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 440px;
            padding: 35px 30px;
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

    <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="text-start">
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Địa chỉ Email đăng ký</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-muted"></i></span>
                <input type="email" name="email" class="form-control" placeholder="Ví dụ: your_email@gmail.com" required autofocus>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
