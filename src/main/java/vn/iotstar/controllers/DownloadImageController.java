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
            fileName = "avatar.png";
        }

        File file = new File(Constant.DIR + File.separator + fileName);
        if (!file.exists()) {
            file = new File(Constant.DIR + File.separator + "category" + File.separator + fileName);
        }

        if (file.exists() && file.isFile()) {
            if (fileName.toLowerCase().endsWith(".jpg") || fileName.toLowerCase().endsWith(".jpeg")) {
                resp.setContentType("image/jpeg");
            } else if (fileName.toLowerCase().endsWith(".png")) {
                resp.setContentType("image/png");
            } else if (fileName.toLowerCase().endsWith(".gif")) {
                resp.setContentType("image/gif");
            } else {
                resp.setContentType("application/octet-stream");
            }

            resp.setContentLengthLong(file.length());
            try (FileInputStream in = new FileInputStream(file);
                 OutputStream out = resp.getOutputStream()) {
                IOUtils.copy(in, out);
            }
        } else {
            // Trả về ảnh mặc định nếu không tìm thấy
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}

