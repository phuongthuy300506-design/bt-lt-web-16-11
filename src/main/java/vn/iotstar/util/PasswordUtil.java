package vn.iotstar.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    /**
     * Băm mật khẩu bằng thuật toán SHA-256 an toàn
     * @param password Mật khẩu gốc dạng plain-text
     * @return Chuỗi băm Hex 64 ký tự
     */
    public static String hash(String password) {
        if (password == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi thuật toán mã hóa SHA-256: " + e.getMessage(), e);
        }
    }

    /**
     * Kiểm tra mật khẩu người dùng nhập vào so với mật khẩu đã lưu trong database
     * Hỗ trợ cả mật khẩu băm SHA-256 và plain-text dự phòng
     */
    public static boolean verify(String rawPassword, String storedPassword) {
        if (rawPassword == null || storedPassword == null) {
            return false;
        }
        String hashedInput = hash(rawPassword);
        if (hashedInput.equalsIgnoreCase(storedPassword)) {
            return true;
        }
        // Fallback so khớp mật khẩu nguyên bản nếu database đang lưu plain text
        return rawPassword.equals(storedPassword);
    }
}
