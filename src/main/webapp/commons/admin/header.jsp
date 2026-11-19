<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0 shadow border-bottom border-secondary">
    <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3 fs-6 fw-bold text-white d-flex align-items-center" href="${pageContext.request.contextPath}/admin/categories">
        <i class="fa-solid fa-shield-halved text-danger me-2 fs-5"></i>
        <span>HCMUTE <span class="text-danger">ADMIN</span></span>
    </a>
    <div class="navbar-nav flex-row ms-auto me-3 align-items-center">
        <span class="text-secondary small me-3 d-none d-md-inline">
            <i class="fa-solid fa-circle-user text-warning me-1"></i>
            Xin chào, <strong>${sessionScope.account != null ? sessionScope.account.username : 'Admin'}</strong>
        </span>
        <a class="btn btn-outline-info btn-sm me-2" href="${pageContext.request.contextPath}/home" target="_blank">
            <i class="fa-solid fa-arrow-up-right-from-square me-1"></i>Xem Website
        </a>
        <a class="btn btn-outline-danger btn-sm" href="${pageContext.request.contextPath}/logout">
            <i class="fa-solid fa-right-from-bracket me-1"></i>Đăng xuất
        </a>
    </div>
</header>
