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
                        <div class="dropdown position-relative" id="userDropdownContainer">
                            <button class="btn btn-outline-light btn-sm dropdown-toggle d-flex align-items-center" 
                                    type="button" 
                                    id="userDropdownBtn" 
                                    data-bs-toggle="dropdown" 
                                    aria-expanded="false"
                                    onclick="toggleUserDropdown(event)">
                                <i class="fa-solid fa-circle-user fs-5 text-info me-2"></i>
                                <span>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</span>
                                <c:if test="${sessionScope.account.roleid == 1}">
                                    <span class="badge bg-danger ms-2" style="font-size: 10px;">Admin</span>
                                </c:if>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-dark shadow py-2" 
                                id="userDropdownMenu"
                                aria-labelledby="userDropdownBtn"
                                style="min-width: 220px; z-index: 99999;">
                                <li class="px-3 py-2 border-bottom border-secondary mb-1">
                                    <div class="fw-bold text-white">${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</div>
                                    <small class="text-secondary">@${sessionScope.account.username}</small>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/video">
                                        <i class="fa-solid fa-folder-open me-2 text-info"></i>Video của tôi
                                    </a>
                                </li>
                                <c:if test="${sessionScope.account.roleid == 1}">
                                    <li>
                                        <a class="dropdown-item py-2 text-warning" href="${pageContext.request.contextPath}/admin/categories">
                                            <i class="fa-solid fa-gear me-2"></i>Bảng quản trị Admin
                                        </a>
                                    </li>
                                </c:if>
                                <li><hr class="dropdown-divider border-secondary my-1"></li>
                                <li>
                                    <a class="dropdown-item py-2 text-danger fw-semibold d-flex align-items-center" 
                                       href="${pageContext.request.contextPath}/logout">
                                        <i class="fa-solid fa-arrow-right-from-bracket me-2 fs-6"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <!-- Nút Đăng xuất trực tiếp cạnh avatar/tên -->
                        <a href="${pageContext.request.contextPath}/logout" 
                           class="btn btn-outline-danger btn-sm ms-2 d-flex align-items-center" 
                           title="Đăng xuất khỏi hệ thống">
                            <i class="fa-solid fa-arrow-right-from-bracket me-1"></i>Đăng xuất
                        </a>
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

<style>
#userDropdownContainer {
    position: relative !important;
}
#userDropdownMenu.show {
    display: block !important;
    position: absolute !important;
    top: 100% !important;
    right: 0 !important;
    left: auto !important;
    margin-top: 6px !important;
    background-color: #1e293b !important;
    border: 1px solid #475569 !important;
    border-radius: 8px !important;
    box-shadow: 0 10px 25px rgba(0,0,0,0.5) !important;
    z-index: 99999 !important;
}
#userDropdownMenu .dropdown-item {
    color: #cbd5e1;
    transition: all 0.2s;
}
#userDropdownMenu .dropdown-item:hover {
    background-color: #334155;
    color: #ffffff;
}
#userDropdownMenu .dropdown-item.text-danger:hover {
    background-color: #dc3545;
    color: #ffffff !important;
}
</style>

<script>
function toggleUserDropdown(e) {
    if (e) {
        e.preventDefault();
        e.stopPropagation();
    }
    var menu = document.getElementById('userDropdownMenu');
    var btn = document.getElementById('userDropdownBtn');
    if (menu) {
        if (menu.classList.contains('show')) {
            menu.classList.remove('show');
            if (btn) btn.setAttribute('aria-expanded', 'false');
        } else {
            menu.classList.add('show');
            if (btn) btn.setAttribute('aria-expanded', 'true');
        }
    }
}

document.addEventListener('click', function(e) {
    var container = document.getElementById('userDropdownContainer');
    var menu = document.getElementById('userDropdownMenu');
    var btn = document.getElementById('userDropdownBtn');
    if (container && menu && !container.contains(e.target)) {
        menu.classList.remove('show');
        if (btn) btn.setAttribute('aria-expanded', 'false');
    }
});
</script>
