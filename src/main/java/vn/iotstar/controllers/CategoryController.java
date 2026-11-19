package vn.iotstar.controllers;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.services.ICategoryService;
import vn.iotstar.services.impl.CategoryServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.FormValidator;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
@WebServlet(urlPatterns = { "/admin/categories", "/admin/category/add", "/admin/category/insert",
        "/admin/category/edit", "/admin/category/update", "/admin/category/delete" })
public class CategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ICategoryService cateService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String url = req.getRequestURI();

        if (url.contains("/admin/categories")) {
            List<Category> list = cateService.findAll();
            req.setAttribute("listcate", list);
            req.getRequestDispatcher("/views/admin/category-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/add")) {
            req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/edit")) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Category category = cateService.findById(id);
                if (category != null) {
                    req.setAttribute("cate", category);
                    req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/categories");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
            }
        } else if (url.contains("/admin/category/delete")) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                cateService.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String url = req.getRequestURI();

        if (url.contains("/admin/category/insert")) {
            String categoryname = req.getParameter("categoryname");
            int status = 1;
            try {
                status = Integer.parseInt(req.getParameter("status"));
            } catch (Exception ignored) {
            }
            String images = req.getParameter("images");

            // Triển khai Server-side Form Validation cho Thêm Danh Mục (Yêu cầu 2)
            boolean hasError = false;
            if (FormValidator.isNullOrBlank(categoryname)) {
                req.setAttribute("errorName", "Tên danh mục không được để trống!");
                hasError = true;
            } else if (!FormValidator.isValidCategoryName(categoryname)) {
                req.setAttribute("errorName", "Tên danh mục phải có độ dài từ 2 đến 100 ký tự!");
                hasError = true;
            }

            Part part = null;
            try {
                part = req.getPart("images1");
            } catch (Exception ignored) {
            }

            if (part != null && part.getSize() > 0 && !FormValidator.isImageFile(part)) {
                req.setAttribute("errorImage", "File tải lên phải là định dạng hình ảnh (.jpg, .jpeg, .png, .webp, .gif)!");
                hasError = true;
            }

            if (!FormValidator.isNullOrBlank(images) && !FormValidator.isValidImageUrl(images)) {
                req.setAttribute("errorImage", "URL hình ảnh online phải bắt đầu bằng http:// hoặc https://!");
                hasError = true;
            }

            if (hasError) {
                req.setAttribute("categoryname", categoryname);
                req.setAttribute("images", images);
                req.setAttribute("status", status);
                req.setAttribute("alert", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại các trường báo lỗi!");
                req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
                return;
            }

            Category category = new Category();
            category.setCategoryname(categoryname.trim());
            category.setStatus(status);

            String fname = "";
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try {
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null
                        && !part.getSubmittedFileName().trim().isEmpty()) {
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = index >= 0 ? filename.substring(index + 1) : "png";
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + File.separator + fname);
                    category.setImages(fname);
                } else if (!FormValidator.isNullOrBlank(images)) {
                    category.setImages(images.trim());
                } else {
                    category.setImages("default.png");
                }
            } catch (Exception e) {
                e.printStackTrace();
                category.setImages("default.png");
            }

            cateService.insert(category);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");

        } else if (url.contains("/admin/category/update")) {
            int categoryid = 0;
            try {
                categoryid = Integer.parseInt(req.getParameter("categoryid"));
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }

            String categoryname = req.getParameter("categoryname");
            int status = 1;
            try {
                status = Integer.parseInt(req.getParameter("status"));
            } catch (Exception ignored) {
            }
            String images = req.getParameter("images");

            // Triển khai Server-side Form Validation cho Sửa Danh Mục (Yêu cầu 2)
            boolean hasError = false;
            if (FormValidator.isNullOrBlank(categoryname)) {
                req.setAttribute("errorName", "Tên danh mục không được để trống!");
                hasError = true;
            } else if (!FormValidator.isValidCategoryName(categoryname)) {
                req.setAttribute("errorName", "Tên danh mục phải có độ dài từ 2 đến 100 ký tự!");
                hasError = true;
            }

            Part part = null;
            try {
                part = req.getPart("images1");
            } catch (Exception ignored) {
            }

            if (part != null && part.getSize() > 0 && !FormValidator.isImageFile(part)) {
                req.setAttribute("errorImage", "File tải lên phải là định dạng hình ảnh (.jpg, .jpeg, .png, .webp, .gif)!");
                hasError = true;
            }

            if (!FormValidator.isNullOrBlank(images) && !FormValidator.isValidImageUrl(images)) {
                req.setAttribute("errorImage", "URL hình ảnh online phải bắt đầu bằng http:// hoặc https://!");
                hasError = true;
            }

            Category category = cateService.findById(categoryid);
            if (category == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }

            if (hasError) {
                category.setCategoryname(categoryname);
                category.setStatus(status);
                req.setAttribute("cate", category);
                req.setAttribute("alert", "Dữ liệu chỉnh sửa không hợp lệ. Vui lòng kiểm tra lại!");
                req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
                return;
            }

            category.setCategoryname(categoryname.trim());
            category.setStatus(status);

            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try {
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null
                        && !part.getSubmittedFileName().trim().isEmpty()) {
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = index >= 0 ? filename.substring(index + 1) : "png";
                    String fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + File.separator + fname);
                    category.setImages(fname);
                } else if (!FormValidator.isNullOrBlank(images)) {
                    category.setImages(images.trim());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            cateService.update(category);
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }
}
