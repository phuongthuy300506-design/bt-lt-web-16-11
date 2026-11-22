package vn.iotstar.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.User;
import vn.iotstar.services.IUserService;
import vn.iotstar.services.impl.UserServiceImpl;
import vn.iotstar.util.CloudinaryUtil;
import vn.iotstar.util.Constant;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.FormValidator;

/**
 * Controller quản lý hồ sơ người dùng (User Profile)
 * Bài tập 03 - Yêu cầu 3:
 * - Update: fullname, phone, images (upload lên Cloudinary bằng multipart)
 * - Email mới -> gửi OTP đến email mới để xác nhận update thành công
 * - Quản lý giao diện bằng Sitemesh Decorator 3
 */
@WebServlet(urlPatterns = {"/profile", "/profile/update", "/profile/verify-otp", "/profile/resend-otp"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 25     // 25 MB
)
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?message=unauthorized");
            return;
        }

        // Luôn nạp lại thông tin mới nhất từ CSDL
        User currentUser = userService.findById(sessionUser.getId());
        if (currentUser == null) {
            currentUser = userService.findByUsername(sessionUser.getUsername());
        }
        if (currentUser == null) {
            currentUser = sessionUser;
        } else {
            session.setAttribute(Constant.SESSION_ACCOUNT, currentUser);
        }

        String uri = req.getRequestURI();

        if (uri.endsWith("/profile/verify-otp")) {
            String pendingEmail = (String) session.getAttribute("pendingNewEmail");
            if (pendingEmail == null) {
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;
            }
            String autoOtp = (String) session.getAttribute("pendingProfileOtp");
            req.setAttribute("pendingEmail", pendingEmail);
            req.setAttribute("autoOtp", autoOtp != null ? autoOtp : EmailUtil.lastGeneratedOtp);
            req.getRequestDispatcher("/views/web/profile-verify-otp.jsp").forward(req, resp);
            return;
        }

        // Lấy thông báo success nếu có chuyển tiếp
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            req.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }

        req.setAttribute("user", currentUser);
        req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute(Constant.SESSION_ACCOUNT);
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = userService.findById(sessionUser.getId());
        if (currentUser == null) {
            currentUser = sessionUser;
        }

        String uri = req.getRequestURI();

        // 1. Xác nhận OTP khi cập nhật email mới
        if (uri.endsWith("/profile/verify-otp")) {
            handleVerifyOtp(req, resp, session, currentUser);
            return;
        }

        // 2. Gửi lại mã OTP
        if (uri.endsWith("/profile/resend-otp")) {
            handleResendOtp(req, resp, session);
            return;
        }

        // 3. Cập nhật hồ sơ thông thường (fullname, phone, email, avatar qua Cloudinary)
        handleUpdateProfile(req, resp, session, currentUser);
    }

    /**
     * Xử lý cập nhật thông tin hồ sơ
     */
    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User currentUser)
            throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String newEmail = req.getParameter("email");

        // Đọc file ảnh đại diện multipart (hỗ trợ cả param 'avatar' và 'images')
        Part avatarPart = null;
        try {
            avatarPart = req.getPart("avatar");
            if (avatarPart == null || avatarPart.getSize() == 0) {
                avatarPart = req.getPart("images");
            }
        } catch (Exception e) {
            System.err.println("[ProfileController] Lỗi đọc Part multipart: " + e.getMessage());
        }

        // --- VALIDATION DỮ LIỆU ĐẦU VÀO (Yêu cầu 2 & 3) ---
        if (fullName == null || fullName.trim().length() < 2) {
            req.setAttribute("errorMessage", "Họ và tên không được để trống và phải có ít nhất 2 ký tự!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
            return;
        }

        if (phone != null && !phone.trim().isEmpty() && !FormValidator.isValidPhone(phone.trim())) {
            req.setAttribute("errorMessage", "Số điện thoại không hợp lệ (yêu cầu đúng 10 số di động Việt Nam)!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
            return;
        }

        if (newEmail == null || !FormValidator.isValidEmail(newEmail.trim())) {
            req.setAttribute("errorMessage", "Địa chỉ email không đúng định dạng chuẩn!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
            return;
        }

        // Upload ảnh lên Cloudinary bằng multipart nếu người dùng chọn file mới
        String newAvatarUrl = null;
        if (avatarPart != null && avatarPart.getSize() > 0) {
            newAvatarUrl = CloudinaryUtil.upload(avatarPart);
        }

        String currentEmail = currentUser.getEmail() != null ? currentUser.getEmail().trim() : "";
        boolean isEmailChanged = !newEmail.trim().equalsIgnoreCase(currentEmail);

        // --- TRƯỜNG HỢP 1: EMAIL KHÔNG ĐỔI -> Cập nhật trực tiếp ---
        if (!isEmailChanged) {
            currentUser.setFullName(fullName.trim());
            currentUser.setPhone(phone != null ? phone.trim() : "");
            if (newAvatarUrl != null && !newAvatarUrl.trim().isEmpty()) {
                currentUser.setAvatar(newAvatarUrl);
            }
            userService.update(currentUser);
            session.setAttribute(Constant.SESSION_ACCOUNT, currentUser);

            req.setAttribute("successMessage", "Cập nhật thông tin hồ sơ cá nhân thành công!"
                    + (newAvatarUrl != null && newAvatarUrl.startsWith("http") ? " (Đã tải ảnh lên Cloudinary thành công)" : ""));
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
            return;
        }

        // --- TRƯỜNG HỢP 2: EMAIL CÓ THAY ĐỔI -> Gửi OTP đến email mới để xác nhận ---
        // Kiểm tra xem email mới có bị trùng với tài khoản khác không
        User existingUserWithEmail = userService.findByEmail(newEmail.trim());
        if (existingUserWithEmail != null && existingUserWithEmail.getId() != currentUser.getId()) {
            req.setAttribute("errorMessage", "Email '" + newEmail.trim() + "' đã được sử dụng bởi một tài khoản khác trong hệ thống!");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
            return;
        }

        // Tạo đối tượng lưu tạm thông tin cập nhật chờ xác nhận OTP
        User pendingUpdate = new User();
        pendingUpdate.setId(currentUser.getId());
        pendingUpdate.setUsername(currentUser.getUsername());
        pendingUpdate.setFullName(fullName.trim());
        pendingUpdate.setPhone(phone != null ? phone.trim() : "");
        pendingUpdate.setEmail(newEmail.trim());
        pendingUpdate.setAvatar(newAvatarUrl != null ? newAvatarUrl : currentUser.getAvatar());

        // Sinh mã OTP ngẫu nhiên 6 số
        String otp = EmailUtil.generateOtp();

        // Gửi OTP đến EMAIL MỚI
        EmailUtil.sendOtpEmail(newEmail.trim(), otp, "XÁC NHẬN CẬP NHẬT EMAIL MỚI");

        // Lưu thông tin vào session chờ xác nhận
        session.setAttribute("pendingNewEmail", newEmail.trim());
        session.setAttribute("pendingProfileOtp", otp);
        session.setAttribute("pendingUserUpdate", pendingUpdate);
        session.setAttribute("autoOtp", otp);

        System.out.println("[ProfileController] Đã gửi OTP (" + otp + ") đến email mới: " + newEmail.trim());

        resp.sendRedirect(req.getContextPath() + "/profile/verify-otp");
    }

    /**
     * Xử lý xác thực OTP đổi email
     */
    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp, HttpSession session, User currentUser)
            throws ServletException, IOException {
        String enteredOtp = req.getParameter("otp");
        String pendingEmail = (String) session.getAttribute("pendingNewEmail");
        String pendingOtp = (String) session.getAttribute("pendingProfileOtp");
        User pendingUpdate = (User) session.getAttribute("pendingUserUpdate");

        if (pendingEmail == null || pendingOtp == null || pendingUpdate == null) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        if (enteredOtp == null || !enteredOtp.trim().equals(pendingOtp)) {
            req.setAttribute("errorMessage", "Mã OTP xác thực không chính xác! Vui lòng kiểm tra lại.");
            req.setAttribute("pendingEmail", pendingEmail);
            req.setAttribute("autoOtp", pendingOtp);
            req.getRequestDispatcher("/views/web/profile-verify-otp.jsp").forward(req, resp);
            return;
        }

        // OTP CHÍNH XÁC: Cập nhật email mới và các thông tin vào CSDL
        currentUser.setEmail(pendingEmail);
        currentUser.setFullName(pendingUpdate.getFullName());
        currentUser.setPhone(pendingUpdate.getPhone());
        if (pendingUpdate.getAvatar() != null) {
            currentUser.setAvatar(pendingUpdate.getAvatar());
        }

        userService.update(currentUser);

        // Cập nhật lại session
        session.setAttribute(Constant.SESSION_ACCOUNT, currentUser);

        // Dọn dẹp session pending
        session.removeAttribute("pendingNewEmail");
        session.removeAttribute("pendingProfileOtp");
        session.removeAttribute("pendingUserUpdate");

        session.setAttribute("successMessage", "Xác nhận OTP thành công! Email của bạn đã được cập nhật thành: " + pendingEmail);
        resp.sendRedirect(req.getContextPath() + "/profile");
    }

    /**
     * Gửi lại mã OTP xác thực email mới
     */
    private void handleResendOtp(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws ServletException, IOException {
        String pendingEmail = (String) session.getAttribute("pendingNewEmail");
        if (pendingEmail == null) {
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        String newOtp = EmailUtil.generateOtp();
        EmailUtil.sendOtpEmail(pendingEmail, newOtp, "GỬI LẠI MÃ XÁC NHẬN ĐỔI EMAIL");

        session.setAttribute("pendingProfileOtp", newOtp);
        session.setAttribute("autoOtp", newOtp);

        req.setAttribute("infoMessage", "Đã gửi lại mã OTP mới đến: " + pendingEmail);
        req.setAttribute("pendingEmail", pendingEmail);
        req.setAttribute("autoOtp", newOtp);
        req.getRequestDispatcher("/views/web/profile-verify-otp.jsp").forward(req, resp);
    }
}
