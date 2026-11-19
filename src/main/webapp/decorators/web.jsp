<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">HCMUTE Video Hub</sitemesh:write></title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background-color: #0f172a;
            color: #e2e8f0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-content {
            flex: 1 0 auto;
        }
        .footer-content {
            flex-shrink: 0;
        }
    </style>
    <sitemesh:write property="head"/>
</head>
<body>

    <!-- Header / Topbar dùng chung cho toàn bộ giao diện Web -->
    <%@ include file="/common/web/topbar.jsp" %>

    <!-- Vùng hiển thị nội dung động từng trang qua Sitemesh 3 -->
    <main class="main-content">
        <sitemesh:write property="body"/>
    </main>

    <!-- Footer dùng chung cho toàn bộ giao diện Web -->
    <footer class="footer-content">
        <%@ include file="/common/web/footer.jsp" %>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
