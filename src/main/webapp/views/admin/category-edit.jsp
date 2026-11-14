<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cập nhật Category - JPA Hibernate</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f8f9fa; }
        .form-container { max-width: 500px; background: white; padding: 25px 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; margin-top: 0; }
        label { font-weight: 600; color: #495057; display: block; margin-top: 15px; margin-bottom: 5px; }
        input[type="text"], input[type="file"] { width: 100%; padding: 8px 12px; box-sizing: border-box; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; }
        .radio-group { margin-top: 5px; }
        .radio-group label { display: inline; font-weight: normal; margin-right: 15px; }
        .btn-submit { margin-top: 20px; padding: 10px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 15px; }
        .btn-submit:hover { background-color: #218838; }
        .btn-back { display: inline-block; margin-top: 15px; color: #6c757d; text-decoration: none; }
        .btn-back:hover { text-decoration: underline; }
        .preview-box { margin-top: 10px; margin-bottom: 10px; }
        .preview-box img { border: 1px solid #ced4da; border-radius: 6px; object-fit: cover; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>CẬP NHẬT CATEGORY</h2>

    <form action="<c:url value="/admin/category/update"/>" method="post" enctype="multipart/form-data">
        <input type="hidden" name="categoryid" value="${cate.categoryid}">

        <label for="categoryname">Category name:</label>
        <input type="text" id="categoryname" name="categoryname" value="${cate.categoryname}" required><br>

        <label for="images">Link images:</label>
        <input type="text" id="images" name="images" value="${cate.images}"><br>

        <label>Ảnh hiện tại:</label>
        <div class="preview-box">
            <c:choose>
                <c:when test="${cate.images != null && fn:startsWith(cate.images, 'http')}">
                    <c:set var="imgUrl" value="${cate.images}" />
                </c:when>
                <c:otherwise>
                    <c:url value="/image?fname=${cate.images}" var="imgUrl" />
                </c:otherwise>
            </c:choose>
            <img height="150" width="200" src="${imgUrl}" alt="${cate.categoryname}"
                 onerror="this.onerror=null; this.src='https://placehold.co/200x150?text=No+Image';" />
        </div>

        <label for="images1">Upload ảnh mới (nếu muốn thay đổi):</label>
        <input type="file" id="images1" name="images1"><br>

        <label>Status:</label>
        <div class="radio-group">
            <input type="radio" id="ston" name="status" value="1" ${cate.status == 1 ? 'checked' : ''}>
            <label for="ston">Hoạt động</label>
            <input type="radio" id="stoff" name="status" value="0" ${cate.status != 1 ? 'checked' : ''}>
            <label for="stoff">Khóa</label>
        </div>

        <br>
        <input type="submit" class="btn-submit" value="Update">
    </form>
    <br>
    <a class="btn-back" href="<c:url value='/admin/categories'/>">&larr; Quay lại danh sách Category</a>
</div>

</body>
</html>

