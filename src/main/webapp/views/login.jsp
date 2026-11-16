<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Hệ Thống Video HCMUTE</title>
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
        .login-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 440px;
            padding: 35px 30px;
        }
        .login-title {
            color: #0f172a;
            font-weight: 700;
            font-size: 24px;
            text-align: center;
            margin-bottom: 20px;
        }
        .form-control {
            padding: 12px 14px;
            border-radius: 8px;
        }
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
            border-color: #0d6efd;
        }
        .btn-submit {
            padding: 12px;
            font-weight: 600;
            font-size: 16px;
            border-radius: 8px;
            transition: all 0.3s;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="text-center mb-3">
        <a href="${pageContext.request.contextPath}/home" class="text-decoration-none">
            <i class="fa-solid fa-play-circle text-danger fa-3x"></i>
            <h5 class="fw-bold text-dark mt-2 mb-0">HCMUTE <span class="text-danger">VIDEO</span></h5>
        </a>
        <small class="text-muted">Đăng nhập với mật khẩu được mã hóa SHA-256</small>
    </div>

    <h2 class="login-title">Đăng Nhập Tài Khoản</h2>

    <c:if test="${not empty alert}">
        <div class="alert alert-danger py-2 px-3 small d-flex align-items-center" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
            <div>${alert}</div>
        </div>
    </c:if>

    <c:if test="${not empty success_msg}">
        <div class="alert alert-success py-2 px-3 small d-flex align-items-center" role="alert">
            <i class="fa-solid fa-circle-check me-2 fs-5"></i>
            <div>${success_msg}</div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Tên đăng nhập hoặc Email</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                <input type="text" name="username" class="form-control" placeholder="Nhập username hoặc email" 
                       value="${not empty remember_username ? remember_username : username}" required autofocus>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Mật khẩu</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" name="remember" id="rememberMe" ${not empty remember_username ? 'checked' : ''}>
                <label class="form-check-label small text-secondary" for="rememberMe">
                    Ghi nhớ tài khoản
                </label>
            </div>
            <a href="${pageContext.request.contextPath}/forgot-password" class="small text-decoration-none text-primary fw-semibold">
                Quên mật khẩu?
            </a>
        </div>

        <button type="submit" class="btn btn-primary w-100 btn-submit mb-3">
            <i class="fa-solid fa-right-to-bracket me-2"></i>Đăng Nhập
        </button>

        <div class="text-center small text-secondary">
            Chưa có tài khoản? 
            <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-semibold text-primary">
                Đăng ký ngay
            </a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
