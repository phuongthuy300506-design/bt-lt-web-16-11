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

@WebServlet(urlPatterns = "/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");

        // Kiểm tra dữ liệu đầu vào
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ Tên đăng nhập, Mật khẩu và Email!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        username = username.trim();
        email = email.trim();

        if (userService.checkExistUsername(username)) {
            req.setAttribute("alert", "Tên đăng nhập '" + username + "' đã được sử dụng. Vui lòng chọn tên khác!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistEmail(email)) {
            req.setAttribute("alert", "Email '" + email + "' đã tồn tại trong hệ thống!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Tạo đối tượng người dùng mới
        User user = new User();
        user.setUsername(username);
        user.setFullName(fullname != null ? fullname.trim() : username);
        user.setEmail(email);
        user.setPassword(password); // Sẽ được băm SHA-256 trong userService.register()
        user.setPhone(phone != null ? phone.trim() : "");
        user.setRoleid(5); // Phân quyền User thông thường

        boolean success = userService.register(user);
        if (success) {
            String testOtp = EmailUtil.getLatestOtp(email);
            req.getSession().setAttribute("verify_username", username);
            req.getSession().setAttribute("verify_email", email);
            req.getSession().setAttribute("otp_hint", testOtp);
            resp.sendRedirect(req.getContextPath() + "/verify-otp?username=" + username);
        } else {
            req.setAttribute("alert", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }
}
