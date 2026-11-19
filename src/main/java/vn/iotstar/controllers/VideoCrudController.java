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
import vn.iotstar.util.FormValidator;

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
            List<Video> listVideos = videoService.findAll();
            req.setAttribute("listVideos", listVideos);
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
        } else if (uri.contains("/video/add") || uri.contains("/admin/video/add")) {
            List<Category> categories = categoryService.findAll();
            req.setAttribute("categories", categories);
            req.setAttribute("isAdmin", uri.contains("/admin/"));
            req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
        } else if (uri.contains("/video/edit") || uri.contains("/admin/video/edit")) {
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
            String id = req.getParameter("id");
            if (id != null) {
                try {
                    videoService.delete(id);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + (uri.contains("/admin/") ? "/admin/videos" : "/video"));
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();
        boolean isAdmin = uri.contains("/admin/");

        if (uri.contains("/video/insert") || uri.contains("/admin/video/insert")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String categoryIdStr = req.getParameter("categoryId");
            String activeStr = req.getParameter("active");
            int active = "1".equals(activeStr) ? 1 : 0;

            boolean hasError = false;

            // Triển khai Server-side Form Validation cho Thêm Video (Yêu cầu 2)
            if (FormValidator.isNullOrBlank(videoId)) {
                req.setAttribute("errorVideoId", "Mã video không được để trống!");
                hasError = true;
            } else if (!FormValidator.isValidVideoId(videoId)) {
                req.setAttribute("errorVideoId", "Mã video phải từ 2 đến 50 ký tự!");
                hasError = true;
            } else if (videoService.findById(videoId.trim()) != null) {
                req.setAttribute("errorVideoId", "Mã video '" + videoId.trim() + "' đã tồn tại!");
                hasError = true;
            }

            if (FormValidator.isNullOrBlank(title)) {
                req.setAttribute("errorTitle", "Tiêu đề video không được để trống!");
                hasError = true;
            } else if (!FormValidator.isValidVideoTitle(title)) {
                req.setAttribute("errorTitle", "Tiêu đề video phải có tối thiểu 3 ký tự!");
                hasError = true;
            }

            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (Exception e) {
                req.setAttribute("errorCategory", "Vui lòng chọn danh mục hợp lệ!");
                hasError = true;
            }

            Part posterPart = null;
            try {
                posterPart = req.getPart("poster");
            } catch (Exception ignored) {
            }

            if (posterPart != null && posterPart.getSize() > 0 && !FormValidator.isImageFile(posterPart)) {
                req.setAttribute("errorPoster", "File poster phải là định dạng hình ảnh (.jpg, .jpeg, .png, .webp, .gif)!");
                hasError = true;
            }

            if (hasError) {
                req.setAttribute("videoId", videoId);
                req.setAttribute("title", title);
                req.setAttribute("description", description);
                req.setAttribute("categoryId", categoryId);
                req.setAttribute("active", active);
                req.setAttribute("categories", categoryService.findAll());
                req.setAttribute("isAdmin", isAdmin);
                req.setAttribute("alert", "Thông tin video không hợp lệ. Vui lòng kiểm tra lại các trường báo lỗi!");
                req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
                return;
            }

            videoId = videoId.trim();
            title = title.trim();

            Video video = new Video();
            video.setVideoId(videoId);
            video.setTitle(title);
            video.setDescription(description != null ? description.trim() : "");
            video.setActive(active);
            video.setViews(0);

            Category category = categoryService.findById(categoryId);
            video.setCategory(category);

            // Gán User đăng video
            HttpSession session = req.getSession();
            User sessionUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
            if (sessionUser != null) {
                video.setUser(sessionUser);
            } else {
                User defaultUser = userService.findById(1);
                if (defaultUser == null) {
                    List<User> allUsers = userService.findAll();
                    defaultUser = !allUsers.isEmpty() ? allUsers.get(0) : null;
                }
                video.setUser(defaultUser);
            }

            // Xử lý upload file Poster
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            if (posterPart != null && posterPart.getSize() > 0 && posterPart.getSubmittedFileName() != null) {
                String submittedName = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                if (!submittedName.trim().isEmpty()) {
                    String ext = submittedName.contains(".") ? submittedName.substring(submittedName.lastIndexOf(".")) : ".png";
                    String posterFileName = "poster_" + System.currentTimeMillis() + ext;
                    posterPart.write(uploadPath + File.separator + posterFileName);
                    video.setPoster(posterFileName);
                } else {
                    video.setPoster("poster1.png");
                }
            } else {
                video.setPoster("poster1.png");
            }

            videoService.insert(video);
            resp.sendRedirect(req.getContextPath() + (isAdmin ? "/admin/videos" : "/video"));

        } else if (uri.contains("/video/update") || uri.contains("/admin/video/update")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String categoryIdStr = req.getParameter("categoryId");
            String activeStr = req.getParameter("active");
            int active = "1".equals(activeStr) ? 1 : 0;

            Video video = videoService.findById(videoId);
            if (video == null) {
                resp.sendRedirect(req.getContextPath() + (isAdmin ? "/admin/videos" : "/video"));
                return;
            }

            boolean hasError = false;

            // Triển khai Server-side Form Validation cho Sửa Video (Yêu cầu 2)
            if (FormValidator.isNullOrBlank(title)) {
                req.setAttribute("errorTitle", "Tiêu đề video không được để trống!");
                hasError = true;
            } else if (!FormValidator.isValidVideoTitle(title)) {
                req.setAttribute("errorTitle", "Tiêu đề video phải có tối thiểu 3 ký tự!");
                hasError = true;
            }

            int categoryId = 0;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (Exception e) {
                req.setAttribute("errorCategory", "Vui lòng chọn danh mục hợp lệ!");
                hasError = true;
            }

            Part posterPart = null;
            try {
                posterPart = req.getPart("poster");
            } catch (Exception ignored) {
            }

            if (posterPart != null && posterPart.getSize() > 0 && !FormValidator.isImageFile(posterPart)) {
                req.setAttribute("errorPoster", "File poster phải là định dạng hình ảnh (.jpg, .jpeg, .png, .webp, .gif)!");
                hasError = true;
            }

            if (hasError) {
                video.setTitle(title);
                video.setDescription(description);
                video.setActive(active);
                req.setAttribute("video", video);
                req.setAttribute("categories", categoryService.findAll());
                req.setAttribute("isAdmin", isAdmin);
                req.setAttribute("alert", "Dữ liệu chỉnh sửa không hợp lệ. Vui lòng kiểm tra lại các trường báo lỗi!");
                req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
                return;
            }

            video.setTitle(title.trim());
            video.setDescription(description != null ? description.trim() : "");
            video.setActive(active);

            Category category = categoryService.findById(categoryId);
            if (category != null) {
                video.setCategory(category);
            }

            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            if (posterPart != null && posterPart.getSize() > 0 && posterPart.getSubmittedFileName() != null) {
                String submittedName = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                if (!submittedName.trim().isEmpty()) {
                    String ext = submittedName.contains(".") ? submittedName.substring(submittedName.lastIndexOf(".")) : ".png";
                    String posterFileName = "poster_" + System.currentTimeMillis() + ext;
                    posterPart.write(uploadPath + File.separator + posterFileName);
                    video.setPoster(posterFileName);
                }
            }

            videoService.update(video);
            resp.sendRedirect(req.getContextPath() + (isAdmin ? "/admin/videos" : "/video"));
        }
    }
}
