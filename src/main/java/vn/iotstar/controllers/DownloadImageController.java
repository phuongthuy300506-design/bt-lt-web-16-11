package vn.iotstar.controllers;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;
import vn.iotstar.util.Constant;

@WebServlet(urlPatterns = "/image")
public class DownloadImageController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.trim().isEmpty()) {
            fileName = "default.png";
        }

        File file = new File(Constant.DIR + File.separator + fileName);
        if (!file.exists()) {
            file = new File(Constant.DIR + File.separator + "category" + File.separator + fileName);
        }
        if (!file.exists()) {
            // Kiểm tra thư mục uploads tương đối trong webapp
            String realUploads = req.getServletContext().getRealPath("/uploads");
            if (realUploads != null) {
                file = new File(realUploads + File.separator + fileName);
            }
        }

        if (file != null && file.exists() && file.isFile()) {
            if (fileName.toLowerCase().endsWith(".jpg") || fileName.toLowerCase().endsWith(".jpeg")) {
                resp.setContentType("image/jpeg");
            } else if (fileName.toLowerCase().endsWith(".png")) {
                resp.setContentType("image/png");
            } else if (fileName.toLowerCase().endsWith(".gif")) {
                resp.setContentType("image/gif");
            } else if (fileName.toLowerCase().endsWith(".webp")) {
                resp.setContentType("image/webp");
            } else if (fileName.toLowerCase().endsWith(".mp4")) {
                resp.setContentType("video/mp4");
            } else {
                resp.setContentType("application/octet-stream");
            }

            resp.setContentLengthLong(file.length());
            try (FileInputStream in = new FileInputStream(file);
                 OutputStream out = resp.getOutputStream()) {
                IOUtils.copy(in, out);
            }
        } else {
            // Trả về ảnh SVG đẹp mắt thay thế nếu file chưa có trên đĩa cứng
            resp.setContentType("image/svg+xml;charset=UTF-8");
            String label = fileName.length() > 20 ? fileName.substring(0, 17) + "..." : fileName;
            String svg = "<svg xmlns='http://www.w3.org/2000/svg' width='400' height='260' viewBox='0 0 400 260'>"
                    + "<rect width='100%' height='100%' fill='#1a2a44'/>"
                    + "<circle cx='200' cy='110' r='45' fill='#0d6efd' opacity='0.8'/>"
                    + "<polygon points='190,95 220,110 190,125' fill='#ffffff'/>"
                    + "<text x='50%' y='185' font-family='Arial, sans-serif' font-size='16' fill='#e2e8f0' font-weight='bold' text-anchor='middle'>"
                    + label + "</text>"
                    + "<text x='50%' y='210' font-family='Arial, sans-serif' font-size='12' fill='#94a3b8' text-anchor='middle'>HCMUTE Web Video</text>"
                    + "</svg>";
            resp.getOutputStream().write(svg.getBytes("UTF-8"));
        }
    }
}
