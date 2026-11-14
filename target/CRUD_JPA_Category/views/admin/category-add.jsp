<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Mới Category - JPA Hibernate</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f8f9fa; }
        .form-container { max-width: 500px; background: white; padding: 25px 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; margin-top: 0; }
        label { font-weight: 600; color: #495057; display: block; margin-top: 15px; margin-bottom: 5px; }
        input[type="text"], input[type="file"] { width: 100%; padding: 8px 12px; box-sizing: border-box; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; }
        .radio-group { margin-top: 5px; }
        .radio-group label { display: inline; font-weight: normal; margin-right: 15px; }
        .btn-submit { margin-top: 20px; padding: 10px 20px; background-color: #007bff; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 15px; }
        .btn-submit:hover { background-color: #0056b3; }
        .btn-back { display: inline-block; margin-top: 15px; color: #6c757d; text-decoration: none; }
        .btn-back:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>THÊM MỚI CATEGORY</h2>

    <form action="<c:url value="/admin/category/insert"/>" method="post" enctype="multipart/form-data">
        <label for="categoryname">Category name:</label>
        <input type="text" id="categoryname" name="categoryname" required placeholder="Nhập tên danh mục..."><br>

        <label for="images">Link images:</label>
        <input type="text" id="images" name="images" placeholder="https://example.com/image.jpg hoặc để trống"><br>

        <label for="images1">Upload images:</label>
        <input type="file" id="images1" name="images1"><br>

        <label>Status:</label>
        <div class="radio-group">
            <input type="radio" id="ston" name="status" value="1" checked>
            <label for="ston">Hoạt động</label>
            <input type="radio" id="stoff" name="status" value="0">
            <label for="stoff">Khóa</label>
        </div>

        <br>
        <input type="submit" class="btn-submit" value="Insert">
    </form>
    <br>
    <a class="btn-back" href="<c:url value='/admin/categories'/>">&larr; Quay lại danh sách Category</a>
</div>

</body>
</html>

