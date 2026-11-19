<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2 border-bottom border-secondary">
    <div class="container">
        <!-- Brand Logo -->
        <a class="navbar-brand fw-bold d-flex align-items-center text-white" href="${pageContext.request.contextPath}/home">
            <i class="fa-solid fa-play-circle text-danger fs-3 me-2"></i>
            <span>HCMUTE <span class="text-danger">VIDEO</span></span>
        </a>

        <!-- Mobile Toggle Button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <!-- Navigation Links -->
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
                        <i class="fa-solid fa-video me-1"></i>Video Của Tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/video/add">
                        <i class="fa-solid fa-cloud-arrow-up me-1"></i>Đăng Video
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

            <!-- Search Form -->
            <form action="${pageContext.request.contextPath}/home" method="get" class="d-flex me-3">
                <div class="input-group input-group-sm">
                    <input type="text" name="search" class="form-control bg-secondary text-white border-secondary" 
                           placeholder="Tìm kiếm video..." value="${param.search}">
                    <button class="btn btn-danger" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </div>
            </form>

            <!-- User Auth Section -->
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${sessionScope.account != null}">
                        <div class="dropdown">
                            <button class="btn btn-outline-light btn-sm dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                                <i class="fa-solid fa-circle-user fs-5 text-info me-2"></i>
                                <span>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</span>
                                <c:if test="${sessionScope.account.roleid == 1}">
                                    <span class="badge bg-danger ms-2" style="font-size: 10px;">Admin</span>
                                </c:if>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark shadow">
                                <li><h6 class="dropdown-header text-secondary">Tài khoản: @${sessionScope.account.username}</h6></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/video"><i class="fa-solid fa-folder-open me-2"></i>Video của tôi</a></li>
                                <c:if test="${sessionScope.account.roleid == 1}">
                                    <li><a class="dropdown-item text-warning" href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-gear me-2"></i>Bảng quản trị</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm px-3">
                                <i class="fa-solid fa-right-to-bracket me-1"></i>Đăng nhập
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-danger btn-sm px-3">
                                <i class="fa-solid fa-user-plus me-1"></i>Đăng ký
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
