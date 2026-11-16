<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${video.title} - HCMUTE Video Player</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background-color: #0f172a;
            color: #f8fafc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }
        .player-container {
            background: #000;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6);
            margin-bottom: 24px;
        }
        .video-player {
            width: 100%;
            max-height: 540px;
            display: block;
        }
        .video-info-box {
            background: #1e293b;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid #334155;
            margin-bottom: 30px;
        }
        .suggest-card {
            background: #1e293b;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #334155;
            transition: transform 0.2s;
            margin-bottom: 12px;
            display: flex;
        }
        .suggest-card:hover {
            transform: translateX(4px);
            border-color: #3b82f6;
        }
        .suggest-thumb {
            width: 130px;
            min-width: 130px;
            height: 80px;
            position: relative;
            background: #020617;
        }
        .suggest-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .suggest-body {
            padding: 8px 12px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .suggest-title {
            color: #f1f5f9;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.3;
        }
        .suggest-title:hover {
            color: #ef4444;
        }
    </style>
</head>
<body>

<!-- Thanh điều hướng Topbar -->
<jsp:include page="/views/common/topbar.jsp" />

<div class="container py-4 mb-5">
    <div class="row">
        <!-- Cột Trái: Trình phát Video (Player) & Thông tin chi tiết (Yêu cầu 4.4) -->
        <div class="col-lg-8">
            <!-- Video Player Box -->
            <div class="player-container">
                <c:choose>
                    <c:when test="${not empty video.videoUrl && fn:contains(video.videoUrl, 'youtube.com')}">
                        <div class="ratio ratio-16x9">
                            <iframe src="${video.videoUrl}" title="${video.title}" allowfullscreen></iframe>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- HTML5 Video Player -->
                        <video class="video-player" controls autoplay 
                               poster="${pageContext.request.contextPath}/image?fname=${video.poster}">
                            <source src="${not empty video.videoUrl ? video.videoUrl : 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'}" 
                                    type="video/mp4">
                            Trình duyệt của bạn không hỗ trợ phát thẻ video HTML5.
                        </video>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Video Information Box -->
            <div class="video-info-box">
                <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-2">
                    <h3 class="fw-bold text-white mb-0" style="line-height: 1.3;">
                        ${video.title}
                    </h3>
                    <c:if test="${not empty video.category}">
                        <span class="badge bg-primary px-3 py-2 fs-6">
                            <i class="fa-solid fa-tag me-1"></i>${video.category.categoryname}
                        </span>
                    </c:if>
                </div>

                <div class="d-flex flex-wrap align-items-center gap-3 text-secondary small py-2 border-bottom border-secondary mb-3">
                    <span class="text-info fw-semibold">
                        <i class="fa-solid fa-eye me-1"></i>${video.views} lượt xem
                    </span>
                    <span>
                        <i class="fa-solid fa-user-circle me-1 text-light"></i>
                        Người đăng: <strong class="text-light">${not empty video.user ? (not empty video.user.fullName ? video.user.fullName : video.user.username) : 'Hệ thống'}</strong>
                    </span>
                    <span>
                        <i class="fa-solid fa-hashtag me-1"></i>Mã video: <code>${video.videoId}</code>
                    </span>
                </div>

                <div class="mb-3">
                    <h6 class="fw-bold text-light mb-2">Mô tả video:</h6>
                    <div class="text-secondary" style="white-space: pre-line; line-height: 1.6;">
                        ${not empty video.description ? video.description : 'Chưa có thông tin mô tả chi tiết cho video này.'}
                    </div>
                </div>

                <div class="d-flex gap-2 pt-2">
                    <a href="${pageContext.request.contextPath}/video" class="btn btn-outline-light btn-sm">
                        <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách video
                    </a>
                    <a href="${pageContext.request.contextPath}/video/edit?id=${video.videoId}" class="btn btn-outline-warning btn-sm">
                        <i class="fa-solid fa-pen-to-square me-1"></i>Chỉnh sửa video này
                    </a>
                </div>
            </div>
        </div>

        <!-- Cột Phải: Video Gợi Ý Xem Tiếp -->
        <div class="col-lg-4">
            <h5 class="fw-bold mb-3 d-flex align-items-center">
                <i class="fa-solid fa-list-play text-danger me-2"></i>Video Đề Xuất
            </h5>

            <div class="suggestion-list">
                <c:forEach items="${relatedVideos}" var="r">
                    <c:if test="${r.videoId != video.videoId}">
                        <div class="suggest-card">
                            <div class="suggest-thumb">
                                <img src="${pageContext.request.contextPath}/image?fname=${r.poster}" 
                                     alt="${r.title}" 
                                     onerror="this.src='https://picsum.photos/seed/${r.videoId}/200/120'">
                            </div>
                            <div class="suggest-body">
                                <a href="${pageContext.request.contextPath}/video/detail?id=${r.videoId}" class="suggest-title">
                                    ${r.title}
                                </a>
                                <small class="text-secondary mt-1">
                                    <i class="fa-solid fa-eye me-1"></i>${r.views} lượt xem
                                </small>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
