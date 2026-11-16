package vn.iotstar.util;

import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    // Cấu hình tài khoản gửi Email (Có thể cấu hình App Password của Gmail)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SENDER_EMAIL = "system.hcmute.web@gmail.com";
    private static final String SENDER_PASSWORD = "app_password_here"; // Cấu hình khi có App Password Gmail

    // Bộ nhớ tạm lưu mã OTP gần nhất để hỗ trợ test nhanh nếu SMTP ngoại tuyến
    private static final Map<String, String> LATEST_OTP_CACHE = new ConcurrentHashMap<>();

    /**
     * Sinh mã số OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOtp() {
        Random rnd = new Random();
        int number = 100000 + rnd.nextInt(900000);
        return String.valueOf(number);
    }

    /**
     * Lấy mã OTP vừa sinh của tài khoản/email để hỗ trợ test
     */
    public static String getLatestOtp(String key) {
        if (key == null) return null;
        return LATEST_OTP_CACHE.get(key.trim().toLowerCase());
    }

    /**
     * Lưu mã OTP vào bộ nhớ đệm
     */
    public static void cacheOtp(String key, String otp) {
        if (key != null && otp != null) {
            LATEST_OTP_CACHE.put(key.trim().toLowerCase(), otp);
        }
    }

    /**
     * Gửi email OTP kích hoạt tài khoản hoặc quên mật khẩu
     * @param toEmail Email người nhận
     * @param otp Mã OTP gồm 6 chữ số
     * @param purpose Mục đích gửi ("KÍCH HOẠT TÀI KHOẢN" hoặc "ĐẶT LẠI MẬT KHẨU")
     * @return true nếu gửi thành công hoặc đã xử lý log an toàn
     */
    public static boolean sendOtpEmail(String toEmail, String otp, String purpose) {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            return false;
        }

        cacheOtp(toEmail, otp);

        String subject = "Mã xác nhận OTP " + purpose + " - HCMUTE Web";
        String content = "<div style=\"font-family: Arial, sans-serif; max-width: 500px; margin: auto; padding: 25px; border: 1px solid #e0e0e0; border-radius: 10px;\">"
                + "<h2 style=\"color: #0d47a1; text-align: center;\">HCMUTE - LẬP TRÌNH WEB</h2>"
                + "<p>Xin chào,</p>"
                + "<p>Bạn đã yêu cầu <strong>" + purpose + "</strong> trên hệ thống Web.</p>"
                + "<p>Mã OTP xác thực của bạn là:</p>"
                + "<div style=\"text-align: center; margin: 25px 0;\">"
                + "  <span style=\"font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #d32f2f; background: #ffebee; padding: 10px 25px; border-radius: 8px; border: 1px dashed #d32f2f;\">"
                + otp + "</span>"
                + "</div>"
                + "<p style=\"color: #555;\">Mã OTP này có hiệu lực trong vòng <strong>5 phút</strong>. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                + "<hr style=\"border: none; border-top: 1px solid #eee; margin: 20px 0;\" />"
                + "<p style=\"font-size: 12px; color: #888; text-align: center;\">Trường Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)<br/>Bộ môn Công nghệ Phần mềm</p>"
                + "</div>";

        // In thông tin OTP ra console để giáo viên / sinh viên test trực tiếp mà không bị gián đoạn nếu mạng chặn SMTP
        System.out.println("================================================================================");
        System.out.println("[EMAIL NOTIFICATION]");
        System.out.println("Gửi đến: " + toEmail);
        System.out.println("Mục đích: " + purpose);
        System.out.println("MÃ OTP XÁC THỰC: >>> " + otp + " <<<");
        System.out.println("================================================================================");

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.connectiontimeout", "3000");
            props.put("mail.smtp.timeout", "3000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "HCMUTE Web System", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(content, "text/html; charset=UTF-8");

            // Chỉ cố gắng gửi qua socket nếu đã cấu hình mật khẩu thực tế
            if (!"app_password_here".equals(SENDER_PASSWORD)) {
                Transport.send(message);
                System.out.println("[EmailUtil] Đã gửi email thành công qua SMTP tới " + toEmail);
            } else {
                System.out.println("[EmailUtil] Chế độ phát triển (Development Mode): Đã xuất mã OTP ra log/giao diện!");
            }
            return true;
        } catch (Exception e) {
            System.err.println("[EmailUtil] Không thể kết nối tới máy chủ SMTP: " + e.getMessage());
            System.out.println("[EmailUtil] Sử dụng mã OTP in trên màn hình/console để tiếp tục quy trình.");
            return true;
        }
    }
}
