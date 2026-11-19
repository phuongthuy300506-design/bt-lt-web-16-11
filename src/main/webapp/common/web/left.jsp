<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="card bg-dark text-white border-secondary mb-3">
    <div class="card-header bg-secondary text-white fw-bold">
        <i class="fa-solid fa-list me-2"></i>Danh Mục Phổ Biến
    </div>
    <ul class="list-group list-group-flush bg-dark">
        <li class="list-group-item bg-dark text-white border-secondary">
            <a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-light">
                <i class="fa-solid fa-fire text-danger me-2"></i>Tất Cả Video
            </a>
        </li>
        <li class="list-group-item bg-dark text-white border-secondary">
            <a href="${pageContext.request.contextPath}/video" class="text-decoration-none text-light">
                <i class="fa-solid fa-folder-open text-primary me-2"></i>Video Của Tôi
            </a>
        </li>
        <li class="list-group-item bg-dark text-white border-secondary">
            <a href="${pageContext.request.contextPath}/video/add" class="text-decoration-none text-light">
                <i class="fa-solid fa-plus-circle text-success me-2"></i>Đăng Video Mới
            </a>
        </li>
    </ul>
</div>
