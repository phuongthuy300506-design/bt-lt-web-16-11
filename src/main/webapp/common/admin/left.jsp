<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="position-sticky pt-3">
    <div class="px-3 mb-3 text-secondary text-uppercase small fw-bold">
        <i class="fa-solid fa-bars me-1"></i>Menu Quản Trị
    </div>
    <ul class="nav flex-column mb-auto">
        <li class="nav-item mb-1">
            <a class="nav-link text-white-50 px-3 py-2 rounded ${pageContext.request.requestURI.contains('/category') ? 'active bg-danger text-white fw-bold' : ''}" 
               href="${pageContext.request.contextPath}/admin/categories">
                <i class="fa-solid fa-tags me-2 text-warning"></i>Quản Lý Danh Mục
            </a>
        </li>
        <li class="nav-item mb-1">
            <a class="nav-link text-white-50 px-3 py-2 rounded ${pageContext.request.requestURI.contains('/video') ? 'active bg-danger text-white fw-bold' : ''}" 
               href="${pageContext.request.contextPath}/admin/videos">
                <i class="fa-solid fa-clapperboard me-2 text-info"></i>Quản Lý Videos
            </a>
        </li>
        <li class="nav-item mb-1">
            <a class="nav-link text-white-50 px-3 py-2 rounded" 
               href="${pageContext.request.contextPath}/admin/category/add">
                <i class="fa-solid fa-plus-circle me-2 text-success"></i>Thêm Danh Mục Mới
            </a>
        </li>
        <li class="nav-item mb-1">
            <a class="nav-link text-white-50 px-3 py-2 rounded" 
               href="${pageContext.request.contextPath}/admin/video/add">
                <i class="fa-solid fa-cloud-arrow-up me-2 text-primary"></i>Đăng Video Mới
            </a>
        </li>
    </ul>

    <hr class="border-secondary my-3 mx-3">

    <div class="px-3 mb-2 text-secondary text-uppercase small fw-bold">
        <i class="fa-solid fa-compass me-1"></i>Điều Hướng
    </div>
    <ul class="nav flex-column px-2">
        <li class="nav-item mb-1">
            <a class="nav-link text-white-50 px-2 py-1 small" href="${pageContext.request.contextPath}/profile">
                <i class="fa-solid fa-id-card me-2 text-warning"></i>Hồ Sơ Cá Nhân
            </a>
        </li>
        <li class="nav-item mb-1">
            <a class="nav-link text-white-50 px-2 py-1 small" href="${pageContext.request.contextPath}/home">
                <i class="fa-solid fa-house me-2"></i>Trang Chủ Website
            </a>
        </li>
        <li class="nav-item mb-1">
            <a class="nav-link text-white-50 px-2 py-1 small" href="${pageContext.request.contextPath}/video">
                <i class="fa-solid fa-video me-2"></i>Video Của Tôi
            </a>
        </li>
    </ul>
</div>
