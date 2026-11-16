package vn.iotstar.controllers;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.services.IVideoService;
import vn.iotstar.services.impl.VideoServiceImpl;
import vn.iotstar.util.Constant;

@WebServlet(urlPatterns = { "/video", "/video/list" })
public class UserVideoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);

        // Đọc số trang hiện tại (mặc định trang 1)
        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (Exception ignored) {
            page = 1;
        }

        // Yêu cầu 4.3: Phân trang 6 video/trang (6sp/trang)
        int pageSize = 6;
        List<Video> videos;
        int totalVideos;

        if (currentUser != null) {
            // Hiển thị tất cả videos của user đã đăng nhập
            totalVideos = videoService.countByUserId(currentUser.getId());
            videos = videoService.findByUserIdWithPaging(currentUser.getId(), page, pageSize);
            req.setAttribute("isUserOwner", true);
        } else {
            // Nếu khách vãng lai chưa đăng nhập -> hiển thị danh sách video hệ thống phân trang 6 video/trang
            totalVideos = videoService.count();
            videos = videoService.findAll(page, pageSize);
            req.setAttribute("isUserOwner", false);
        }

        int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        req.setAttribute("videos", videos);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);

        req.getRequestDispatcher("/views/web/user-videos.jsp").forward(req, resp);
    }
}
