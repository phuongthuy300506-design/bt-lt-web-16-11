package vn.iotstar.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.User;
import vn.iotstar.services.IUserService;
import vn.iotstar.services.impl.UserServiceImpl;
import vn.iotstar.util.FormValidator;

@WebServlet(urlPatterns = "/forgot-password")
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");

        // Triển khai Server-side Form Validation (Yêu cầu 2)
        if (FormValidator.isNullOrBlank(email)) {
            req.setAttribute("errorEmail", "Vui lòng nhập địa chỉ email đã đăng ký!");
            req.setAttribute("alert", "Vui lòng nhập địa chỉ email để nhận mã OTP!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        email = email.trim();
        if (!FormValidator.isValidEmail(email)) {
            req.setAttribute("errorEmail", "Địa chỉ email không đúng định dạng (Ví dụ: name@example.com)!");
            req.setAttribute("email", email);
            req.setAttribute("alert", "Địa chỉ email không hợp lệ!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        User user = userService.findByEmail(email);
        if (user == null) {
            user = userService.findByUsername(email);
        }

        if (user == null) {
            req.setAttribute("errorEmail", "Không tìm thấy tài khoản tương ứng với email '" + email + "'!");
            req.setAttribute("email", email);
            req.setAttribute("alert", "Tài khoản không tồn tại trong hệ thống!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        // Gửi mã xác nhận OTP qua email
        boolean sent = userService.sendForgotPasswordOtp(user.getEmail());
        if (sent) {
            req.getSession().setAttribute("forgot_email", user.getEmail());
            resp.sendRedirect(req.getContextPath() + "/reset-password?email=" + user.getEmail());
        } else {
            req.setAttribute("alert", "Không thể gửi mã xác nhận OTP. Vui lòng thử lại sau!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }
}
