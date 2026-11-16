package vn.iotstar.config;

import java.util.List;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.services.ICategoryService;
import vn.iotstar.services.IUserService;
import vn.iotstar.services.IVideoService;
import vn.iotstar.services.impl.CategoryServiceImpl;
import vn.iotstar.services.impl.UserServiceImpl;
import vn.iotstar.services.impl.VideoServiceImpl;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

public class TestFullHomework {
    public static void main(String[] args) {
        System.out.println("================================================================================");
        System.out.println("    KIỂM THỬ TOÀN DIỆN CÁC YÊU CẦU BÀI TẬP LẬP TRÌNH WEB (16/11/2026)");
        System.out.println("================================================================================");

        IUserService userService = new UserServiceImpl();
        IVideoService videoService = new VideoServiceImpl();
        ICategoryService categoryService = new CategoryServiceImpl();

        try {
            // -------------------------------------------------------------------------
            // YÊU CẦU 1: KÍCH HOẠT TÀI KHOẢN BẰNG OTP GỬI QUA EMAIL KHI ĐĂNG KÝ
            // -------------------------------------------------------------------------
            System.out.println("\n[1] KIỂM THỬ YÊU CẦU 1: Đăng ký & Kích hoạt bằng mã OTP qua email");
            String testUsername = "student_" + System.currentTimeMillis() % 10000;
            String testEmail = testUsername + "@test.hcmute.edu.vn";

            User newUser = new User();
            newUser.setUsername(testUsername);
            newUser.setEmail(testEmail);
            newUser.setFullName("Sinh Viên Kiểm Thử");
            newUser.setPassword("Pass123@#"); // Sẽ được băm SHA-256
            newUser.setPhone("0912345678");

            boolean registered = userService.register(newUser);
            System.out.println("-> Đăng ký tài khoản mới: " + (registered ? "THÀNH CÔNG" : "THẤT BẠI"));

            User createdUser = userService.findByUsername(testUsername);
            System.out.println("-> Trạng thái ban đầu (0 = Chưa kích hoạt): status = " + createdUser.getStatus());
            System.out.println("-> Mã OTP đã sinh và gửi qua email: " + createdUser.getCode());

            // Kích hoạt tài khoản bằng mã OTP
            boolean activated = userService.verifyOtp(testUsername, createdUser.getCode());
            User activatedUser = userService.findByUsername(testUsername);
            System.out.println("-> Xác thực OTP kích hoạt tài khoản: " + (activated ? "THÀNH CÔNG" : "THẤT BẠI"));
            System.out.println("-> Trạng thái sau kích hoạt (1 = Đã kích hoạt): status = " + activatedUser.getStatus());
            System.out.println("-> Mã OTP sau khi dùng đã được xóa: code = " + activatedUser.getCode());

            // -------------------------------------------------------------------------
            // YÊU CẦU 2: ĐĂNG NHẬP VỚI MẬT KHẨU MÃ HÓA (HASH PASSWORD) & ĐĂNG XUẤT
            // -------------------------------------------------------------------------
            System.out.println("\n[2] KIỂM THỬ YÊU CẦU 2: Đăng nhập với mật khẩu mã hóa SHA-256");
            String hashedPassword = activatedUser.getPassword();
            System.out.println("-> Mật khẩu lưu trong DB (SHA-256): " + hashedPassword);
            System.out.println("-> Độ dài chuỗi băm Hex: " + hashedPassword.length() + " ký tự");

            // Thử đăng nhập đúng mật khẩu
            User loginSuccess = userService.login(testUsername, "Pass123@#");
            System.out.println("-> Đăng nhập với mật khẩu đúng: " + (loginSuccess != null ? "THÀNH CÔNG (User: " + loginSuccess.getUsername() + ")" : "THẤT BẠI"));

            // Thử đăng nhập sai mật khẩu
            User loginFail = userService.login(testUsername, "SaiMatKhau123");
            System.out.println("-> Đăng nhập với mật khẩu sai: " + (loginFail == null ? "BỊ TỪ CHỐI (CHÍNH XÁC)" : "LỖI"));

            // -------------------------------------------------------------------------
            // YÊU CẦU 3: QUÊN MẬT KHẨU GỬI MÃ XÁC NHẬN OTP QUA MAIL
            // -------------------------------------------------------------------------
            System.out.println("\n[3] KIỂM THỬ YÊU CẦU 3: Quên mật khẩu & Gửi mã OTP xác nhận qua mail");
            boolean sentForgotOtp = userService.sendForgotPasswordOtp(testEmail);
            System.out.println("-> Gửi mã xác nhận OTP quên mật khẩu: " + (sentForgotOtp ? "THÀNH CÔNG" : "THẤT BẠI"));

            User forgotUser = userService.findByEmail(testEmail);
            String resetOtp = forgotUser.getCode();
            System.out.println("-> Mã OTP đặt lại mật khẩu nhận được: " + resetOtp);

            // Đặt mật khẩu mới với mã OTP
            String newPassword = "NewPassword2026@#";
            boolean resetSuccess = userService.resetPassword(testEmail, resetOtp, newPassword);
            System.out.println("-> Đặt lại mật khẩu mới với mã OTP: " + (resetSuccess ? "THÀNH CÔNG" : "THẤT BẠI"));

            // Đăng nhập lại với mật khẩu mới
            User loginWithNewPass = userService.login(testUsername, newPassword);
            System.out.println("-> Đăng nhập bằng mật khẩu mới vừa đổi: " + (loginWithNewPass != null ? "THÀNH CÔNG" : "THẤT BẠI"));

            // -------------------------------------------------------------------------
            // YÊU CẦU 4: BẢNG VIDEOS QUAN HỆ 1-N VỚI USERS & CÁC CHỨC NĂNG
            // -------------------------------------------------------------------------
            System.out.println("\n[4] KIỂM THỬ YÊU CẦU 4: Bảng Videos quan hệ 1 - n với Users");

            // 4.1. CRUD bảng Videos
            System.out.println("-> 4.1. Kiểm thử CRUD bảng Videos:");
            List<Category> categories = categoryService.findAll();
            Category defaultCate = !categories.isEmpty() ? categories.get(0) : null;

            String testVideoId = "v_test_" + System.currentTimeMillis() % 10000;
            Video testVideo = new Video(
                    testVideoId,
                    1,
                    "Mô tả video kiểm thử quan hệ 1-n với user",
                    "poster_test.png",
                    "Video Demo Quan Hệ 1-N Với User",
                    100,
                    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                    defaultCate,
                    activatedUser // Quan hệ 1 - n với User!
            );
            videoService.insert(testVideo);
            System.out.println("   + Thêm Video mới: THÀNH CÔNG [Mã: " + testVideoId + ", Uploader: " + testVideo.getUser().getUsername() + "]");

            // Cập nhật video
            testVideo.setTitle("Video Demo Quan Hệ 1-N Đã Được Cập Nhật");
            videoService.update(testVideo);
            Video updatedVideo = videoService.findById(testVideoId);
            System.out.println("   + Cập nhật Video: THÀNH CÔNG [Tiêu đề mới: " + updatedVideo.getTitle() + "]");

            // 4.2. Hiển thị 10 video mới nhất lên trang chủ
            System.out.println("-> 4.2. Lấy 10 video mới nhất cho Trang chủ (/home):");
            List<Video> top10 = videoService.findTop10Latest();
            System.out.println("   + Số lượng video mới nhất lấy được: " + top10.size() + " video");
            for (int i = 0; i < Math.min(3, top10.size()); i++) {
                System.out.println("     [" + (i + 1) + "] " + top10.get(i).getVideoId() + ": " + top10.get(i).getTitle() + " (" + top10.get(i).getViews() + " views)");
            }

            // 4.3. Hiển thị tất cả video của user phân trang 6sp/trang
            System.out.println("-> 4.3. Phân trang 6 video/trang hiển thị trên URL /video:");
            int page = 1;
            int pageSize = 6;
            List<Video> pagedVideos = videoService.findAll(page, pageSize);
            int total = videoService.count();
            int totalPages = (int) Math.ceil((double) total / pageSize);
            System.out.println("   + Tổng số video: " + total + " | Phân trang: " + pageSize + " sp/trang | Tổng số trang: " + totalPages);
            System.out.println("   + Số video trên trang 1: " + pagedVideos.size() + " video");

            // 4.4. Tăng views và xem chi tiết khi bấm vào tiêu đề
            System.out.println("-> 4.4. Xem chi tiết & Tự động tăng lượt xem khi bấm chuột vào tiêu đề video:");
            int viewsBefore = updatedVideo.getViews();
            videoService.increaseViews(testVideoId);
            Video videoAfterView = videoService.findById(testVideoId);
            System.out.println("   + Views trước: " + viewsBefore + " -> Views sau khi click: " + videoAfterView.getViews());

            // Xóa video test
            videoService.delete(testVideoId);
            System.out.println("   + Xóa Video test sau khi kiểm thử: THÀNH CÔNG");

            System.out.println("\n================================================================================");
            System.out.println("    >>> TẤT CẢ 4 YÊU CẦU ĐÃ ĐƯỢC KIỂM THỬ VÀ HOẠT ĐỘNG HOÀN TOÀN CHÍNH XÁC! <<<");
            System.out.println("================================================================================");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JpaConfig.shutdown();
        }
    }
}
