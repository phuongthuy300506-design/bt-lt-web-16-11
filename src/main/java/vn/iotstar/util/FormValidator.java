package vn.iotstar.util;

import java.util.regex.Pattern;
import jakarta.servlet.http.Part;

/**
 * Tiện ích kiểm tra tính hợp lệ dữ liệu (Server-side Form Validation)
 * cho các Form: Login, Register, Forgot Password, Category (Insert/Edit), Video (Insert/Edit).
 * Yêu cầu 2 - Bài tập 03.
 */
public class FormValidator {

    // Biểu thức chính quy kiểm tra định dạng email tiêu chuẩn RFC 5322
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );

    // Biểu thức kiểm tra tên đăng nhập: chữ cái, số, dấu gạch dưới, từ 3 đến 30 ký tự
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_.]{3,30}$");

    // Biểu thức kiểm tra số điện thoại Việt Nam: bắt đầu bằng 0, gồm 10 chữ số
    private static final Pattern PHONE_PATTERN = Pattern.compile("^0[0-9]{9}$");

    /**
     * Kiểm tra chuỗi có bị rỗng hoặc chỉ chứa khoảng trắng hay không
     */
    public static boolean isNullOrBlank(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Kiểm tra tên đăng nhập hợp lệ (3 - 30 ký tự, không chứa ký tự đặc biệt)
     */
    public static boolean isValidUsername(String username) {
        if (isNullOrBlank(username)) {
            return false;
        }
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    /**
     * Kiểm tra mật khẩu (tối thiểu 6 ký tự)
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.trim().length() >= 6;
    }

    /**
     * Kiểm tra định dạng địa chỉ Email
     */
    public static boolean isValidEmail(String email) {
        if (isNullOrBlank(email)) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Kiểm tra số điện thoại (10 chữ số bắt đầu bằng 0). Có thể để trống.
     */
    public static boolean isValidPhone(String phone) {
        if (isNullOrBlank(phone)) {
            return true; // Cho phép để trống
        }
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Kiểm tra họ và tên (tối thiểu 2 ký tự)
     */
    public static boolean isValidFullName(String fullName) {
        return fullName != null && fullName.trim().length() >= 2;
    }

    /**
     * Kiểm tra tên danh mục Category (từ 2 đến 100 ký tự)
     */
    public static boolean isValidCategoryName(String categoryName) {
        return categoryName != null && categoryName.trim().length() >= 2 && categoryName.trim().length() <= 100;
    }

    /**
     * Kiểm tra mã video (từ 2 đến 50 ký tự)
     */
    public static boolean isValidVideoId(String videoId) {
        return videoId != null && videoId.trim().length() >= 2 && videoId.trim().length() <= 50;
    }

    /**
     * Kiểm tra tiêu đề video (tối thiểu 3 ký tự)
     */
    public static boolean isValidVideoTitle(String title) {
        return title != null && title.trim().length() >= 3;
    }

    /**
     * Kiểm tra định dạng file hình ảnh hợp lệ (jpg, jpeg, png, webp, gif)
     */
    public static boolean isImageFile(Part part) {
        if (part == null || part.getSize() == 0) {
            return true; // Không upload file thì coi như hợp lệ (dùng ảnh mặc định hoặc link)
        }
        String fileName = part.getSubmittedFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            return true;
        }
        String lower = fileName.trim().toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")
                || lower.endsWith(".webp") || lower.endsWith(".gif");
    }

    /**
     * Kiểm tra URL hình ảnh online hợp lệ (bắt đầu bằng http:// hoặc https://)
     */
    public static boolean isValidImageUrl(String url) {
        if (isNullOrBlank(url)) {
            return true; // Cho phép để trống
        }
        String lower = url.trim().toLowerCase();
        return lower.startsWith("http://") || lower.startsWith("https://");
    }
}
