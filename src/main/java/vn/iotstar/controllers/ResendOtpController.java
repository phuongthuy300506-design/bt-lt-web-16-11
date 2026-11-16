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

@WebServlet(urlPatterns = "/resend-otp")
public class ResendOtpController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            username = (String) req.getSession().getAttribute("verify_username");
        }

        if (username != null && !username.trim().isEmpty()) {
            User user = userService.findByUsername(username.trim());
            if (user == null) {
                user = userService.findByEmail(username.trim());
            }
            if (user != null) {
                userService.sendOtpForActivation(username.trim());
                String newOtp = EmailUtil.getLatestOtp(user.getEmail());
                req.getSession().setAttribute("otp_hint", newOtp);
                req.getSession().setAttribute("verify_username", user.getUsername());
                resp.sendRedirect(req.getContextPath() + "/verify-otp?username=" + user.getUsername() + "&resent=true");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
