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
        String confirmPassword = req.getParameter("confirmPassword");
        String phone = req.getParameter("phone");

        boolean hasError = false;

        // Triển khai Server-side Form Validation (Yêu cầu 2)
        // 1. Kiểm tra Username
        if (FormValidator.isNullOrBlank(username)) {
            req.setAttribute("errorUsername", "Tên đăng nhập không được để trống!");
            hasError = true;
        } else if (!FormValidator.isValidUsername(username)) {
            req.setAttribute("errorUsername", "Tên đăng nhập phải từ 3-30 ký tự, chỉ gồm chữ cái, số, dấu gạch dưới!");
            hasError = true;
        } else if (userService.checkExistUsername(username.trim())) {
            req.setAttribute("errorUsername", "Tên đăng nhập '" + username.trim() + "' đã được sử dụng!");
            hasError = true;
        }

        // 2. Kiểm tra Họ và Tên
        if (FormValidator.isNullOrBlank(fullname)) {
            req.setAttribute("errorFullname", "Họ và tên không được để trống!");
            hasError = true;
        } else if (!FormValidator.isValidFullName(fullname)) {
            req.setAttribute("errorFullname", "Họ và tên phải có tối thiểu 2 ký tự!");
            hasError = true;
        }

        // 3. Kiểm tra Email
        if (FormValidator.isNullOrBlank(email)) {
            req.setAttribute("errorEmail", "Địa chỉ Email không được để trống!");
            hasError = true;
        } else if (!FormValidator.isValidEmail(email)) {
            req.setAttribute("errorEmail", "Địa chỉ Email không đúng định dạng (Ví dụ: name@example.com)!");
            hasError = true;
        } else if (userService.checkExistEmail(email.trim())) {
            req.setAttribute("errorEmail", "Địa chỉ Email '" + email.trim() + "' đã tồn tại trong hệ thống!");
            hasError = true;
        }

        // 4. Kiểm tra Mật khẩu
        if (FormValidator.isNullOrBlank(password)) {
            req.setAttribute("errorPassword", "Mật khẩu không được để trống!");
            hasError = true;
        } else if (!FormValidator.isValidPassword(password)) {
            req.setAttribute("errorPassword", "Mật khẩu phải có độ dài tối thiểu 6 ký tự!");
            hasError = true;
        }

        // 5. Kiểm tra Nhập lại Mật khẩu
        if (confirmPassword != null && !confirmPassword.trim().isEmpty()) {
            if (!password.equals(confirmPassword)) {
                req.setAttribute("errorConfirmPassword", "Mật khẩu nhập lại không trùng khớp!");
                hasError = true;
            }
        }

        // 6. Kiểm tra Số điện thoại (nếu có nhập)
        if (!FormValidator.isNullOrBlank(phone) && !FormValidator.isValidPhone(phone)) {
            req.setAttribute("errorPhone", "Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0 (Ví dụ: 0912345678)!");
            hasError = true;
        }

        // Nếu có lỗi, giữ lại dữ liệu và trả về Form kèm thông báo lỗi
        if (hasError) {
            req.setAttribute("username", username);
            req.setAttribute("fullname", fullname);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.setAttribute("alert", "Vui lòng sửa các lỗi dữ liệu bên dưới để hoàn tất đăng ký!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        username = username.trim();
        email = email.trim();

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
            req.getSession().setAttribute("verify_username", username);
            req.getSession().setAttribute("verify_email", email);
            resp.sendRedirect(req.getContextPath() + "/verify-otp?username=" + username);
        } else {
            req.setAttribute("alert", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại!");
            req.setAttribute("username", username);
            req.setAttribute("fullname", fullname);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }
}
