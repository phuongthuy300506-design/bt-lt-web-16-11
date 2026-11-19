<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="bg-secondary-subtle py-2 border-bottom border-dark">
    <div class="container d-flex flex-wrap gap-2 align-items-center">
        <span class="text-secondary small fw-semibold me-2"><i class="fa-solid fa-layer-group me-1"></i>Chủ đề:</span>
        <a href="${pageContext.request.contextPath}/home" class="badge text-bg-danger text-decoration-none">Tất cả</a>
        <a href="${pageContext.request.contextPath}/home?category=1" class="badge text-bg-dark text-decoration-none">Công nghệ &amp; Lập trình</a>
        <a href="${pageContext.request.contextPath}/home?category=2" class="badge text-bg-dark text-decoration-none">Điện thoại &amp; Phụ kiện</a>
        <a href="${pageContext.request.contextPath}/home?category=3" class="badge text-bg-dark text-decoration-none">Laptop &amp; Máy tính</a>
        <a href="${pageContext.request.contextPath}/home?category=4" class="badge text-bg-dark text-decoration-none">Đời sống &amp; Khoa học</a>
    </div>
</div>
