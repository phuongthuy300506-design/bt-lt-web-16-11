<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Category - JPA Hibernate</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f8f9fa; }
        h2 { color: #2c3e50; }
        .btn-add { display: inline-block; padding: 10px 18px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px; font-weight: bold; margin-bottom: 15px; }
        .btn-add:hover { background-color: #218838; }
        table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #dee2e6; }
        th { background-color: #343a40; color: white; }
        tr:hover { background-color: #f1f1f1; }
        .img-preview { object-fit: cover; border-radius: 6px; border: 1px solid #ced4da; }
        .badge-active { padding: 5px 10px; background-color: #28a745; color: white; border-radius: 12px; font-size: 13px; font-weight: 600; }
        .badge-locked { padding: 5px 10px; background-color: #dc3545; color: white; border-radius: 12px; font-size: 13px; font-weight: 600; }
        .action-link { font-weight: 600; text-decoration: none; padding: 4px 8px; border-radius: 4px; }
        .action-edit { color: #007bff; }
        .action-edit:hover { text-decoration: underline; }
        .action-delete { color: #dc3545; }
        .action-delete:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div style="background: #212529; color: white; padding: 12px 20px; border-radius: 6px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center;">
    <div>
        <a href="<c:url value='/home'/>" style="color: #0dcaf0; text-decoration: none; font-weight: bold; margin-right: 20px;"> Trang Chủ (/home)</a>
        <a href="<c:url value='/video'/>" style="color: #ffc107; text-decoration: none; font-weight: bold; margin-right: 20px;"> Video Của Tôi (/video)</a>
        <a href="<c:url value='/admin/videos'/>" style="color: #dc3545; text-decoration: none; font-weight: bold; margin-right: 20px;"> Quản lý Videos (/admin/videos)</a>
        <a href="<c:url value='/admin/categories'/>" style="color: #fff; text-decoration: none; font-weight: bold; text-decoration: underline;"> Quản lý Category</a>
    </div>
    <div>
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <span style="color: #adb5bd; margin-right: 15px;">Xin chào, <strong>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</strong></span>
                <a href="<c:url value='/logout'/>" style="color: #ff6b6b; text-decoration: none; font-weight: bold;">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="<c:url value='/login'/>" style="color: #0dcaf0; text-decoration: none; font-weight: bold; margin-right: 15px;">Đăng nhập</a>
                <a href="<c:url value='/register'/>" style="color: #28a745; text-decoration: none; font-weight: bold;">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<h2>DANH SÁCH CATEGORY (QUẢN LÝ BẰNG JPA)</h2>
<div style="margin-bottom: 15px; display: flex; gap: 10px;">
    <a class="btn-add" href="<c:url value='/admin/category/add'/>">+ Add Category</a>
    <a class="btn-add" style="background-color: #0d6efd;" href="<c:url value='/admin/videos'/>"> Chuyển đến Quản lý Videos</a>
</div>

<table>
    <tr>
        <th style="width: 50px;">STT</th>
        <th style="width: 220px;">Images</th>
        <th>Category name</th>
        <th style="width: 120px;">Status</th>
        <th style="width: 150px;">Action</th>
    </tr>
    <c:forEach items="${listcate}" var="cate" varStatus="STT">
        <tr>
            <td>${STT.index + 1}</td>
            <td>
                <c:choose>
                    <c:when test="${cate.images != null && fn:startsWith(cate.images, 'http')}">
                        <c:set var="imgUrl" value="${cate.images}" />
                    </c:when>
                    <c:otherwise>
                        <c:url value="/image?fname=${cate.images}" var="imgUrl" />
                    </c:otherwise>
                </c:choose>
                <img class="img-preview" height="120" width="160" src="${imgUrl}" alt="${cate.categoryname}" 
                     onerror="this.onerror=null; this.src='https://placehold.co/160x120?text=No+Image';" />
            </td>
            <td><strong>${cate.categoryname}</strong> (ID: ${cate.categoryid})</td>
            <td>
                <c:if test="${cate.status == 1}">
                    <span class="badge-active">Hoạt động</span>
                </c:if>
                <c:if test="${cate.status != 1}">
                    <span class="badge-locked">Khóa</span>
                </c:if>
            </td>
            <td>
                <a class="action-link action-edit" href="<c:url value='/admin/category/edit?id=${cate.categoryid}'/>">Sửa</a> |
                <a class="action-link action-delete" href="<c:url value='/admin/category/delete?id=${cate.categoryid}'/>" onclick="return confirm('Bạn có chắc chắn muốn xóa category này?');">Xóa</a>
            </td>
        </tr>
    </c:forEach>
    <c:if test="${empty listcate}">
        <tr>
            <td colspan="5" style="text-align: center; color: #6c757d; padding: 25px;">
                Chưa có danh mục nào. Hãy bấm <strong>+ Add Category</strong> để thêm mới.
            </td>
        </tr>
    </c:if>
</table>

</body>
</html>

