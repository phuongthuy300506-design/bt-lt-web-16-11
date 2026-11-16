package vn.iotstar.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.services.IUserService;
import vn.iotstar.services.impl.UserServiceImpl;
import vn.iotstar.util.EmailUtil;

@WebServlet(urlPatterns = "/verify-otp")
public class VerifyOtpController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            username = (String) req.getSession().getAttribute("verify_username");
        }
        req.setAttribute("username", username);
        boolean mailConfigured = vn.iotstar.util.Constant.SENDER_APP_PASSWORD != null 
                && !vn.iotstar.util.Constant.SENDER_APP_PASSWORD.trim().isEmpty();
        req.setAttribute("mailConfigured", mailConfigured);

        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String otp = req.getParameter("otp");

        if (username == null || username.trim().isEmpty() || otp == null || otp.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ tên tài khoản và mã OTP!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        boolean verified = userService.verifyOtp(username.trim(), otp.trim());
        if (verified) {
            HttpSession session = req.getSession();
            session.removeAttribute("verify_username");
            session.removeAttribute("verify_email");
            session.setAttribute("success_msg", "Kích hoạt tài khoản thành công! Hãy đăng nhập để trải nghiệm.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("alert", "Mã OTP không chính xác hoặc đã hết hiệu lực. Vui lòng kiểm tra lại!");
            req.setAttribute("username", username);
            boolean mailConfigured = vn.iotstar.util.Constant.SENDER_APP_PASSWORD != null 
                    && !vn.iotstar.util.Constant.SENDER_APP_PASSWORD.trim().isEmpty();
            req.setAttribute("mailConfigured", mailConfigured);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }
}
