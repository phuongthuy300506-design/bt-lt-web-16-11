<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="bg-dark text-white-50 py-4 mt-auto border-top border-secondary">
    <div class="container">
        <div class="row g-4 align-items-center">
            <div class="col-md-6 text-center text-md-start">
                <div class="d-flex align-items-center justify-content-center justify-content-md-start mb-2">
                    <i class="fa-solid fa-play-circle text-danger fs-4 me-2"></i>
                    <span class="fw-bold text-white fs-5">HCMUTE <span class="text-danger">VIDEO</span></span>
                </div>
                <p class="small mb-0 text-secondary">
                    Hệ thống Nền Tảng Video &amp; Quản Trị Trực Tuyến - Khoa Công Nghệ Thông Tin<br>
                    Trường Đại Học Sư Phạm Kỹ Thuật TP. Hồ Chí Minh (HCMUTE)
                </p>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <div class="small text-secondary mb-1">
                    Môn học: <strong>Lập trình Web (WEBPR330479)</strong>
                </div>
                <div class="small text-secondary mb-2">
                    Sinh viên thực hiện: <span class="text-white fw-semibold">Lê Phương Thùy</span> (MSSV: <strong>24110058</strong>)
                </div>
                <div class="d-flex justify-content-center justify-content-md-end gap-3 text-white-50 small">
                    <a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-white-50">Trang chủ</a>
                    <span>•</span>
                    <a href="${pageContext.request.contextPath}/video" class="text-decoration-none text-white-50">Video</a>
                    <span>•</span>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="text-decoration-none text-white-50">Quản trị</a>
                </div>
            </div>
        </div>
        <hr class="border-secondary my-3">
        <div class="text-center small text-secondary">
            &copy; 2026 HCMUTE Video Platform. Thiết kế với Bootstrap 5 &amp; Sitemesh Decorator 3.
        </div>
    </div>
</footer>
