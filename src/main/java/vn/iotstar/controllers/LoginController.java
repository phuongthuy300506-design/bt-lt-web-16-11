package vn.iotstar.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.services.IUserService;
import vn.iotstar.services.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        if (session.getAttribute(Constant.SESSION_ACCOUNT) != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Đọc Cookie nếu đã chọn Remember Me trước đó
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (Constant.COOKIE_REMEMBER.equals(c.getName())) {
                    req.setAttribute("remember_username", c.getValue());
                    break;
                }
            }
        }

        String successMsg = (String) session.getAttribute("success_msg");
        if (successMsg != null) {
            req.setAttribute("success_msg", successMsg);
            session.removeAttribute("success_msg");
        }

        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("alert", "Tài khoản hoặc mật khẩu không được rỗng!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        username = username.trim();

        // 1. Kiểm tra tài khoản & mật khẩu đã được mã hóa băm SHA-256
        User user = userService.login(username, password);

        if (user == null) {
            req.setAttribute("alert", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        // 2. Yêu cầu 1: Kiểm tra trạng thái kích hoạt tài khoản bằng OTP
        if (user.getStatus() == 0) {
            // Chưa kích hoạt tài khoản
            req.getSession().setAttribute("verify_username", user.getUsername());
            req.getSession().setAttribute("verify_email", user.getEmail());
            userService.sendOtpForActivation(user.getUsername());
            resp.sendRedirect(req.getContextPath() + "/verify-otp?username=" + user.getUsername() + "&not_activated=true");
            return;
        }

        // 3. Đăng nhập thành công -> Lưu Session
        HttpSession session = req.getSession();
        session.setAttribute(Constant.SESSION_ACCOUNT, user);

        // 4. Xử lý ghi nhớ tài khoản (Remember Me) bằng Cookie
        if ("on".equals(remember) || "true".equals(remember)) {
            Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, user.getUsername());
            cookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
            cookie.setPath(req.getContextPath());
            resp.addCookie(cookie);
        } else {
            Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, "");
            cookie.setMaxAge(0);
            cookie.setPath(req.getContextPath());
            resp.addCookie(cookie);
        }

        // 5. Điều hướng theo phân quyền: Admin -> /admin/categories, User -> /home
        if (user.getRoleid() == 1) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
