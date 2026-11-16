<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - HCMUTE Video</title>
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
            padding: 25px 20px;
        }
        .register-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 480px;
            padding: 35px 30px;
        }
        .register-title {
            color: #0f172a;
            font-weight: 700;
            font-size: 24px;
            text-align: center;
            margin-bottom: 20px;
        }
        .form-control {
            padding: 11px 14px;
            border-radius: 8px;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.15);
            border-color: #dc3545;
        }
        .btn-submit {
            padding: 12px;
            font-weight: 600;
            font-size: 16px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .otp-notice {
            background: #eef2ff;
            border-left: 4px solid #4f46e5;
            padding: 10px 14px;
            border-radius: 6px;
            font-size: 13px;
            color: #3730a3;
        }
    </style>
</head>
<body>

<div class="register-card">
    <div class="text-center mb-3">
        <a href="${pageContext.request.contextPath}/home" class="text-decoration-none">
            <i class="fa-solid fa-play-circle text-danger fa-3x"></i>
            <h5 class="fw-bold text-dark mt-2 mb-0">HCMUTE <span class="text-danger">VIDEO</span></h5>
        </a>
        <small class="text-muted">Đăng ký thành viên hệ thống chia sẻ video</small>
    </div>

    <h2 class="register-title">Đăng Ký Tài Khoản</h2>

    <div class="otp-notice mb-3">
        <i class="fa-solid fa-envelope-open-text me-1"></i>
        Sau khi đăng ký, hệ thống sẽ gửi <strong>mã OTP gồm 6 chữ số</strong> qua email để bạn kích hoạt tài khoản.
    </div>

    <c:if test="${not empty alert}">
        <div class="alert alert-danger py-2 px-3 small d-flex align-items-center" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
            <div>${alert}</div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Tên đăng nhập (Username) <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                <input type="text" name="username" class="form-control" placeholder="Ví dụ: nguyenvana" required autofocus>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Họ và tên</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-id-card text-muted"></i></span>
                <input type="text" name="fullname" class="form-control" placeholder="Ví dụ: Nguyễn Văn A">
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Địa chỉ Email (Nhận OTP) <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-muted"></i></span>
                <input type="email" name="email" class="form-control" placeholder="Ví dụ: your_email@gmail.com" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Mật khẩu <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu an toàn" required>
            </div>
            <small class="text-muted" style="font-size: 11px;">Mật khẩu sẽ được mã hóa an toàn bằng SHA-256</small>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Số điện thoại</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-phone text-muted"></i></span>
                <input type="text" name="phone" class="form-control" placeholder="Ví dụ: 0912345678">
            </div>
        </div>

        <button type="submit" class="btn btn-danger w-100 btn-submit mb-3">
            <i class="fa-solid fa-paper-plane me-2"></i>Đăng Ký & Nhận Mã OTP
        </button>

        <div class="text-center small text-secondary">
            Đã có tài khoản? 
            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-semibold text-primary">
                Đăng nhập ngay
            </a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
