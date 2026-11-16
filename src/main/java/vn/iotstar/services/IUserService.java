package vn.iotstar.services;

import java.util.List;
import vn.iotstar.entity.User;

public interface IUserService {
    User login(String username, String rawPassword);

    boolean register(User user);

    boolean verifyOtp(String usernameOrEmail, String otp);

    boolean sendOtpForActivation(String usernameOrEmail);

    boolean sendForgotPasswordOtp(String email);

    boolean resetPassword(String email, String otp, String newPassword);

    User findById(int id);

    User findByUsername(String username);

    User findByEmail(String email);

    void insert(User user);

    void update(User user);

    void delete(int id) throws Exception;

    List<User> findAll();

    boolean checkExistUsername(String username);

    boolean checkExistEmail(String email);
}
