package vn.iotstar.services.impl;

import java.sql.Date;
import java.util.List;
import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.UserDao;
import vn.iotstar.entity.User;
import vn.iotstar.services.IUserService;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

public class UserServiceImpl implements IUserService {

    private final IUserDao userDao = new UserDao();

    @Override
    public User login(String username, String rawPassword) {
        if (username == null || rawPassword == null) {
            return null;
        }
        User user = userDao.findByUsername(username.trim());
        if (user == null) {
            user = userDao.findByEmail(username.trim());
        }
        if (user == null) {
            return null;
        }

        // Kiểm tra mật khẩu (đã băm bằng SHA-256)
        if (PasswordUtil.verify(rawPassword, user.getPassword())) {
            return user;
        }
        return null;
    }

    @Override
    public boolean register(User user) {
        if (user == null || user.getUsername() == null || user.getEmail() == null) {
            return false;
        }
        if (checkExistUsername(user.getUsername()) || checkExistEmail(user.getEmail())) {
            return false;
        }

        // 1. Mã hóa mật khẩu bằng SHA-256
        user.setPassword(PasswordUtil.hash(user.getPassword()));

        // 2. Tạo mã OTP 6 số và đặt trạng thái chưa kích hoạt (status = 0)
        String otp = EmailUtil.generateOtp();
        user.setCode(otp);
        user.setStatus(0);

        if (user.getCreatedDate() == null) {
            user.setCreatedDate(new Date(System.currentTimeMillis()));
        }
        if (user.getAvatar() == null || user.getAvatar().trim().isEmpty()) {
            user.setAvatar("default-avatar.png");
        }

        // 3. Lưu vào cơ sở dữ liệu
        userDao.insert(user);

        // 4. Gửi mã OTP qua email
        EmailUtil.sendOtpEmail(user.getEmail(), otp, "KÍCH HOẠT TÀI KHOẢN");

        return true;
    }

    @Override
    public boolean verifyOtp(String usernameOrEmail, String otp) {
        if (usernameOrEmail == null || otp == null) {
            return false;
        }
        User user = userDao.findByUsername(usernameOrEmail.trim());
        if (user == null) {
            user = userDao.findByEmail(usernameOrEmail.trim());
        }
        if (user == null || user.getCode() == null) {
            return false;
        }

        if (user.getCode().trim().equals(otp.trim())) {
            user.setStatus(1); // Kích hoạt thành công
            user.setCode(null); // Xóa OTP sau khi sử dụng
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean sendOtpForActivation(String usernameOrEmail) {
        if (usernameOrEmail == null) {
            return false;
        }
        User user = userDao.findByUsername(usernameOrEmail.trim());
        if (user == null) {
            user = userDao.findByEmail(usernameOrEmail.trim());
        }
        if (user == null) {
            return false;
        }

        String otp = EmailUtil.generateOtp();
        user.setCode(otp);
        userDao.update(user);
        return EmailUtil.sendOtpEmail(user.getEmail(), otp, "KÍCH HOẠT TÀI KHOẢN");
    }

    @Override
    public boolean sendForgotPasswordOtp(String email) {
        if (email == null) {
            return false;
        }
        User user = userDao.findByEmail(email.trim());
        if (user == null) {
            user = userDao.findByUsername(email.trim());
        }
        if (user == null) {
            return false;
        }

        String otp = EmailUtil.generateOtp();
        user.setCode(otp);
        userDao.update(user);
        return EmailUtil.sendOtpEmail(user.getEmail(), otp, "ĐẶT LẠI MẬT KHẨU");
    }

    @Override
    public boolean resetPassword(String email, String otp, String newPassword) {
        if (email == null || otp == null || newPassword == null) {
            return false;
        }
        User user = userDao.findByEmail(email.trim());
        if (user == null) {
            user = userDao.findByUsername(email.trim());
        }
        if (user == null || user.getCode() == null) {
            return false;
        }

        if (user.getCode().trim().equals(otp.trim())) {
            // Mã hóa mật khẩu mới và xóa mã OTP
            user.setPassword(PasswordUtil.hash(newPassword));
            user.setCode(null);
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public User findById(int id) {
        return userDao.findById(id);
    }

    @Override
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public void insert(User user) {
        userDao.insert(user);
    }

    @Override
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    public void delete(int id) throws Exception {
        userDao.delete(id);
    }

    @Override
    public List<User> findAll() {
        return userDao.findAll();
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }
}
