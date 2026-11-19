<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục (Categories) - Admin HCMUTE</title>
    <style>
        .admin-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }
        .table-dark {
            --bs-table-bg: #1e293b;
            --bs-table-border-color: #334155;
        }
        .img-preview {
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #334155;
            background: #0f172a;
        }
    </style>
</head>
<body>

<div class="container-fluid py-2">
    <div class="admin-card">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom border-secondary">
            <div>
                <h4 class="fw-bold text-white mb-1">
                    <i class="fa-solid fa-tags text-warning me-2"></i>Quản Lý Danh Mục (JPA Hibernate)
                </h4>
                <p class="text-secondary small mb-0">Xem, thêm mới, sửa và xóa danh mục phân loại video</p>
            </div>
            <div class="d-flex gap-2">
                <a class="btn btn-danger btn-sm px-3" href="<c:url value='/admin/category/add'/>">
                    <i class="fa-solid fa-plus me-1"></i>Thêm Mới Danh Mục
                </a>
                <a class="btn btn-outline-info btn-sm px-3" href="<c:url value='/admin/videos'/>">
                    <i class="fa-solid fa-clapperboard me-1"></i>Quản Lý Video
                </a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-dark table-hover align-middle mb-0">
                <thead>
                    <tr class="text-secondary small text-uppercase">
                        <th style="width: 60px;" class="text-center">STT</th>
                        <th style="width: 140px;">Hình Ảnh</th>
                        <th>Tên Danh Mục</th>
                        <th style="width: 140px;" class="text-center">Trạng Thái</th>
                        <th style="width: 160px;" class="text-center">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${listcate}" var="cate" varStatus="STT">
                        <tr>
                            <td class="text-center fw-bold text-secondary">${STT.index + 1}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${cate.images != null && fn:startsWith(cate.images, 'http')}">
                                        <c:set var="imgUrl" value="${cate.images}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="/image?fname=${cate.images}" var="imgUrl" />
                                    </c:otherwise>
                                </c:choose>
                                <img class="img-preview" height="60" width="90" src="${imgUrl}" alt="${cate.categoryname}" 
                                     onerror="this.onerror=null; this.src='https://placehold.co/90x60?text=No+Img';" />
                            </td>
                            <td>
                                <div class="fw-semibold text-white">${cate.categoryname}</div>
                                <span class="badge bg-dark border border-secondary text-secondary" style="font-size: 10px;">ID: #${cate.categoryid}</span>
                            </td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${cate.status == 1}">
                                        <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i>Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary"><i class="fa-solid fa-lock me-1"></i>Khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <a class="btn btn-outline-warning" href="<c:url value='/admin/category/edit?id=${cate.categoryid}'/>" title="Chỉnh sửa">
                                        <i class="fa-solid fa-pen-to-square"></i> Sửa
                                    </a>
                                    <a class="btn btn-outline-danger" href="<c:url value='/admin/category/delete?id=${cate.categoryid}'/>" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục \'${cate.categoryname}\' này?');" title="Xóa">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listcate}">
                        <tr>
                            <td colspan="5" class="text-center text-secondary py-5">
                                <i class="fa-solid fa-folder-open fs-2 mb-2 d-block text-muted"></i>
                                Chưa có danh mục nào trong hệ thống. Hãy bấm <strong>Thêm Mới Danh Mục</strong> để tạo mới.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
