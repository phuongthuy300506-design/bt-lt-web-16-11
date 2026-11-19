<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">Quản Trị Hệ Thống - HCMUTE</sitemesh:write></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background-color: #0b1120;
            color: #e2e8f0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-admin-layout {
            flex: 1 0 auto;
            display: flex;
            min-height: calc(100vh - 110px);
        }
        .admin-sidebar {
            width: 250px;
            background: #111827;
            border-right: 1px solid #1f2937;
            flex-shrink: 0;
        }
        .admin-main-body {
            flex-grow: 1;
            padding: 24px;
            background: #0b1120;
            overflow-x: auto;
        }
        .footer-content {
            flex-shrink: 0;
        }
    </style>
    <sitemesh:write property="head"/>
</head>
<body>

    <!-- Header dùng chung cho Admin -->
    <%@ include file="/common/admin/header.jsp" %>

    <div class="main-admin-layout">
        <!-- Sidebar Menu trái Admin -->
        <aside class="admin-sidebar">
            <%@ include file="/common/admin/left.jsp" %>
        </aside>

        <!-- Vùng hiển thị nội dung động Admin qua Sitemesh 3 -->
        <section class="admin-main-body">
            <sitemesh:write property="body"/>
        </section>
    </div>

    <!-- Footer dùng chung cho Admin -->
    <footer class="footer-content">
        <%@ include file="/common/admin/footer.jsp" %>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
