<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">
    <div class="container">
        <a class="navbar-brand fw-bold d-flex align-items-center text-white" href="${pageContext.request.contextPath}/home">
            <i class="fa-solid fa-play-circle text-danger fs-3 me-2"></i>
            <span>HCMUTE <span class="text-danger">VIDEO</span></span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.endsWith('/home') ? 'active fw-bold' : ''}" 
                       href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-house me-1"></i>Trang Chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.endsWith('/video') ? 'active fw-bold' : ''}" 
                       href="${pageContext.request.contextPath}/video">
                        <i class="fa-solid fa-video me-1"></i>Video của tôi (/video)
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/video/add">
                        <i class="fa-solid fa-cloud-arrow-up me-1"></i>Đăng Video Mới
                    </a>
                </li>
                <c:if test="${sessionScope.account != null && sessionScope.account.roleid == 1}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-warning fw-semibold" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fa-solid fa-shield-halved me-1"></i>Quản trị Admin
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/videos"><i class="fa-solid fa-clapperboard me-2"></i>Quản lý Video</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags me-2"></i>Quản lý Danh mục</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>

            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${sessionScope.account != null}">
                        <div class="dropdown">
                            <button class="btn btn-outline-light btn-sm dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                                <i class="fa-solid fa-circle-user fs-5 text-info me-2"></i>
                                <span>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow">
                                <li><h6 class="dropdown-header">Tài khoản: @${sessionScope.account.username}</h6></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/video"><i class="fa-solid fa-folder-open me-2"></i>Video của tôi</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm me-2">
                            <i class="fa-solid fa-right-to-bracket me-1"></i>Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-danger btn-sm">
                            <i class="fa-solid fa-user-plus me-1"></i>Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
