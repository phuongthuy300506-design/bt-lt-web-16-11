package vn.iotstar.controllers;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Video;
import vn.iotstar.services.IVideoService;
import vn.iotstar.services.impl.VideoServiceImpl;

@WebServlet(urlPatterns = "/video/detail")
public class VideoDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String videoId = req.getParameter("id");
        if (videoId == null || videoId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        videoId = videoId.trim();

        // Yêu cầu 4.4: Tăng số lượt xem (views) khi người dùng bấm vào xem video
        videoService.increaseViews(videoId);

        // Lấy thông tin chi tiết video
        Video video = videoService.findById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Lấy danh sách video gợi ý khác để xem tiếp
        List<Video> relatedVideos = videoService.findTop10Latest();

        req.setAttribute("video", video);
        req.setAttribute("relatedVideos", relatedVideos);

        req.getRequestDispatcher("/views/web/video-detail.jsp").forward(req, resp);
    }
}
