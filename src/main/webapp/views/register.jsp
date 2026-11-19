<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - HCMUTE Video</title>
    <style>
        .register-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 500px;
            padding: 35px 30px;
            margin: 40px auto;
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
        <div class="alert alert-danger py-2 px-3 small d-flex align-items-center mb-3" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
            <div>${alert}</div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
        <!-- Username Validation -->
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Tên đăng nhập (Username) <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-user text-muted"></i></span>
                <input type="text" name="username" class="form-control ${not empty errorUsername ? 'is-invalid' : ''}" 
                       placeholder="Ví dụ: nguyenvana" value="${username}" minlength="3" maxlength="30" required autofocus>
                <c:if test="${not empty errorUsername}">
                    <div class="invalid-feedback d-block text-start">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorUsername}
                    </div>
                </c:if>
                <div class="invalid-feedback text-start">
                    Tên đăng nhập từ 3 - 30 ký tự, chỉ gồm chữ cái, số hoặc dấu gạch dưới.
                </div>
            </div>
        </div>

        <!-- Full Name Validation -->
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Họ và tên <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-id-card text-muted"></i></span>
                <input type="text" name="fullname" class="form-control ${not empty errorFullname ? 'is-invalid' : ''}" 
                       placeholder="Ví dụ: Nguyễn Văn A" value="${fullname}" minlength="2" maxlength="100" required>
                <c:if test="${not empty errorFullname}">
                    <div class="invalid-feedback d-block text-start">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorFullname}
                    </div>
                </c:if>
                <div class="invalid-feedback text-start">
                    Vui lòng nhập họ và tên (tối thiểu 2 ký tự).
                </div>
            </div>
        </div>

        <!-- Email Validation -->
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Địa chỉ Email (Nhận OTP) <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-envelope text-muted"></i></span>
                <input type="email" name="email" class="form-control ${not empty errorEmail ? 'is-invalid' : ''}" 
                       placeholder="Ví dụ: your_email@gmail.com" value="${email}" required>
                <c:if test="${not empty errorEmail}">
                    <div class="invalid-feedback d-block text-start">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorEmail}
                    </div>
                </c:if>
                <div class="invalid-feedback text-start">
                    Vui lòng nhập đúng định dạng email (Ví dụ: name@example.com).
                </div>
            </div>
        </div>

        <!-- Password Validation -->
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Mật khẩu <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                <input type="password" name="password" class="form-control ${not empty errorPassword ? 'is-invalid' : ''}" 
                       placeholder="Nhập mật khẩu an toàn (tối thiểu 6 ký tự)" minlength="6" required>
                <c:if test="${not empty errorPassword}">
                    <div class="invalid-feedback d-block text-start">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorPassword}
                    </div>
                </c:if>
                <div class="invalid-feedback text-start">
                    Mật khẩu phải có độ dài tối thiểu 6 ký tự.
                </div>
            </div>
        </div>

        <!-- Confirm Password Validation -->
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Xác nhận mật khẩu <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-lock text-muted"></i></span>
                <input type="password" name="confirmPassword" class="form-control ${not empty errorConfirmPassword ? 'is-invalid' : ''}" 
                       placeholder="Nhập lại đúng mật khẩu phía trên" minlength="6" required>
                <c:if test="${not empty errorConfirmPassword}">
                    <div class="invalid-feedback d-block text-start">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorConfirmPassword}
                    </div>
                </c:if>
                <div class="invalid-feedback text-start">
                    Vui lòng nhập lại mật khẩu xác nhận trùng khớp.
                </div>
            </div>
        </div>

        <!-- Phone Validation -->
        <div class="mb-3">
            <label class="form-label fw-semibold text-secondary">Số điện thoại</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="fa-solid fa-phone text-muted"></i></span>
                <input type="tel" name="phone" class="form-control ${not empty errorPhone ? 'is-invalid' : ''}" 
                       placeholder="Ví dụ: 0912345678" value="${phone}">
                <c:if test="${not empty errorPhone}">
                    <div class="invalid-feedback d-block text-start">
                        <i class="fa-solid fa-circle-exclamation me-1"></i>${errorPhone}
                    </div>
                </c:if>
                <div class="invalid-feedback text-start">
                    Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0.
                </div>
            </div>
        </div>

        <button type="submit" class="btn btn-danger w-100 btn-submit mb-3">
            <i class="fa-solid fa-paper-plane me-2"></i>Đăng Ký &amp; Nhận Mã OTP
        </button>

        <div class="text-center small text-secondary">
            Đã có tài khoản? 
            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-semibold text-primary">
                Đăng nhập ngay
            </a>
        </div>
    </form>
</div>

</body>
</html>
