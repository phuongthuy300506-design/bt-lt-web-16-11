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
import vn.iotstar.util.EmailUtil;

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
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập địa chỉ email đã đăng ký!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        email = email.trim();
        User user = userService.findByEmail(email);
        if (user == null) {
            user = userService.findByUsername(email);
        }

        if (user == null) {
            req.setAttribute("alert", "Không tìm thấy tài khoản tương ứng với thông tin '" + email + "'!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        // Gửi mã xác nhận OTP qua email
        boolean sent = userService.sendForgotPasswordOtp(user.getEmail());
        if (sent) {
            String otp = EmailUtil.getLatestOtp(user.getEmail());
            req.getSession().setAttribute("forgot_email", user.getEmail());
            req.getSession().setAttribute("otp_hint", otp);
            resp.sendRedirect(req.getContextPath() + "/reset-password?email=" + user.getEmail());
        } else {
            req.setAttribute("alert", "Không thể gửi mã xác nhận OTP. Vui lòng thử lại sau!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }
}
