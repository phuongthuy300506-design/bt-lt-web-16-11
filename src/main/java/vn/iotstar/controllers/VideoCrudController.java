package vn.iotstar.controllers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.services.ICategoryService;
import vn.iotstar.services.IUserService;
import vn.iotstar.services.IVideoService;
import vn.iotstar.services.impl.CategoryServiceImpl;
import vn.iotstar.services.impl.UserServiceImpl;
import vn.iotstar.services.impl.VideoServiceImpl;
import vn.iotstar.util.Constant;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 100   // 100MB
)
@WebServlet(urlPatterns = {
    "/admin/videos",
    "/admin/video/add",
    "/admin/video/insert",
    "/admin/video/edit",
    "/admin/video/update",
    "/admin/video/delete",
    "/video/add",
    "/video/insert",
    "/video/edit",
    "/video/update",
    "/video/delete"
})
public class VideoCrudController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IVideoService videoService = new VideoServiceImpl();
    private final ICategoryService categoryService = new CategoryServiceImpl();
    private final IUserService userService = new UserServiceImpl();

    /**
     * Phương thức trích xuất tên file upload theo Slide 9 tài liệu Multipart
     */
    private String getFileName(Part part) {
        if (part == null) {
            return Constant.DEFAULT_FILENAME;
        }
        String header = part.getHeader("content-disposition");
        if (header != null) {
            for (String content : header.split(";")) {
                if (content.trim().startsWith("filename")) {
                    String name = content.substring(content.indexOf("=") + 2, content.length() - 1);
                    return Paths.get(name).getFileName().toString();
                }
            }
        }
        return Constant.DEFAULT_FILENAME;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();

        if (uri.contains("/admin/videos")) {
            // Danh sách Video trong trang Quản trị Admin
            List<Video> listVideos = videoService.findAll();
            req.setAttribute("listVideos", listVideos);
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
        } else if (uri.contains("/video/add") || uri.contains("/admin/video/add")) {
            // Trang Thêm mới Video
            List<Category> categories = categoryService.findAll();
            req.setAttribute("categories", categories);
            req.setAttribute("isAdmin", uri.contains("/admin/"));
            req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
        } else if (uri.contains("/video/edit") || uri.contains("/admin/video/edit")) {
            // Trang Chỉnh sửa Video
            String id = req.getParameter("id");
            Video video = videoService.findById(id);
            if (video != null) {
                List<Category> categories = categoryService.findAll();
                req.setAttribute("video", video);
                req.setAttribute("categories", categories);
                req.setAttribute("isAdmin", uri.contains("/admin/"));
                req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + (uri.contains("/admin/") ? "/admin/videos" : "/video"));
            }
        } else if (uri.contains("/video/delete") || uri.contains("/admin/video/delete")) {
            // Xóa Video
            String id = req.getParameter("id");
            try {
                videoService.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (uri.contains("/admin/")) {
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
            } else {
                resp.sendRedirect(req.getContextPath() + "/video");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/video");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);

        // Chuẩn bị thư mục lưu trữ Upload
        String uploadPath = Constant.UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        if (uri.contains("/insert")) {
            // --- THÊM MỚI VIDEO ---
            String videoId = req.getParameter("videoId");
            if (videoId == null || videoId.trim().isEmpty()) {
                videoId = "v" + System.currentTimeMillis() % 100000;
            } else {
                videoId = videoId.trim();
            }

            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String videoUrl = req.getParameter("videoUrl");
            int active = "1".equals(req.getParameter("active")) ? 1 : 0;
            int categoryId = 1;
            try {
                categoryId = Integer.parseInt(req.getParameter("categoryId"));
            } catch (Exception ignored) {}

            Video video = new Video();
            video.setVideoId(videoId);
            video.setTitle(title != null ? title.trim() : "Video " + videoId);
            video.setDescription(description);
            video.setActive(active);
            video.setViews(0);

            // Gán danh mục Category
            Category category = categoryService.findById(categoryId);
            video.setCategory(category);

            // Gán người tạo (User - Yêu cầu 4: mối quan hệ 1 - n)
            if (currentUser != null) {
                video.setUser(currentUser);
            } else {
                List<User> users = userService.findAll();
                if (!users.isEmpty()) {
                    video.setUser(users.get(0));
                }
            }

            // Xử lý Upload Poster bằng Multipart
            Part posterPart = req.getPart("posterFile");
            if (posterPart != null && posterPart.getSize() > 0) {
                String originalName = getFileName(posterPart);
                String ext = originalName.contains(".") ? originalName.substring(originalName.lastIndexOf(".")) : ".png";
                String posterName = "poster_" + System.currentTimeMillis() + ext;
                posterPart.write(uploadPath + File.separator + posterName);
                video.setPoster(posterName);
            } else {
                String existingPoster = req.getParameter("posterText");
                video.setPoster(existingPoster != null && !existingPoster.trim().isEmpty() ? existingPoster.trim() : "poster1.png");
            }

            // Xử lý Upload file Video bằng Multipart nếu có
            Part videoPart = req.getPart("videoFile");
            if (videoPart != null && videoPart.getSize() > 0) {
                String originalVideoName = getFileName(videoPart);
                String ext = originalVideoName.contains(".") ? originalVideoName.substring(originalVideoName.lastIndexOf(".")) : ".mp4";
                String videoFileName = "video_" + System.currentTimeMillis() + ext;
                videoPart.write(uploadPath + File.separator + videoFileName);
                video.setVideoUrl(req.getContextPath() + "/image?fname=" + videoFileName);
            } else if (videoUrl != null && !videoUrl.trim().isEmpty()) {
                video.setVideoUrl(videoUrl.trim());
            } else {
                // Link video MP4 mẫu trực quan
                video.setVideoUrl("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
            }

            videoService.insert(video);

            if (uri.contains("/admin/")) {
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
            } else {
                resp.sendRedirect(req.getContextPath() + "/video");
            }

        } else if (uri.contains("/update")) {
            // --- CẬP NHẬT VIDEO ---
            String videoId = req.getParameter("videoId");
            Video video = videoService.findById(videoId);
            if (video != null) {
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String videoUrl = req.getParameter("videoUrl");
                int active = "1".equals(req.getParameter("active")) ? 1 : 0;
                int categoryId = 1;
                try {
                    categoryId = Integer.parseInt(req.getParameter("categoryId"));
                } catch (Exception ignored) {}

                video.setTitle(title != null ? title.trim() : video.getTitle());
                video.setDescription(description);
                video.setActive(active);

                Category category = categoryService.findById(categoryId);
                video.setCategory(category);

                // Xử lý Upload Poster mới nếu người dùng chọn
                Part posterPart = req.getPart("posterFile");
                if (posterPart != null && posterPart.getSize() > 0) {
                    String originalName = getFileName(posterPart);
                    String ext = originalName.contains(".") ? originalName.substring(originalName.lastIndexOf(".")) : ".png";
                    String posterName = "poster_" + System.currentTimeMillis() + ext;
                    posterPart.write(uploadPath + File.separator + posterName);
                    video.setPoster(posterName);
                }

                // Xử lý Upload file Video mới nếu có
                Part videoPart = req.getPart("videoFile");
                if (videoPart != null && videoPart.getSize() > 0) {
                    String originalVideoName = getFileName(videoPart);
                    String ext = originalVideoName.contains(".") ? originalVideoName.substring(originalVideoName.lastIndexOf(".")) : ".mp4";
                    String videoFileName = "video_" + System.currentTimeMillis() + ext;
                    videoPart.write(uploadPath + File.separator + videoFileName);
                    video.setVideoUrl(req.getContextPath() + "/image?fname=" + videoFileName);
                } else if (videoUrl != null && !videoUrl.trim().isEmpty()) {
                    video.setVideoUrl(videoUrl.trim());
                }

                videoService.update(video);
            }

            if (uri.contains("/admin/")) {
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
            } else {
                resp.sendRedirect(req.getContextPath() + "/video");
            }
        }
    }
}
