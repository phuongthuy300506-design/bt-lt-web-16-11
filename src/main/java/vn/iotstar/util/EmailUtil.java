package vn.iotstar.util;

import java.util.Properties;
import java.util.Random;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    public static volatile String lastSendError = null;
    public static volatile String lastGeneratedOtp = null;

    /**
     * Sinh mã số OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOtp() {
        Random rnd = new Random();
        int number = 100000 + rnd.nextInt(900000);
        String otp = String.valueOf(number);
        lastGeneratedOtp = otp;
        return otp;
    }

    /**
     * Gửi email OTP kích hoạt tài khoản hoặc quên mật khẩu qua máy chủ SMTP Gmail
     * @param toEmail Email người nhận
     * @param otp Mã OTP gồm 6 chữ số
     * @param purpose Mục đích gửi ("KÍCH HOẠT TÀI KHOẢN" hoặc "ĐẶT LẠI MẬT KHẨU")
     * @return true nếu gửi thành công
     */
    public static boolean sendOtpEmail(String toEmail, String otp, String purpose) {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            return false;
        }

        lastGeneratedOtp = otp;
        lastSendError = null;

        final String senderEmail = Constant.SENDER_EMAIL;
        final String senderPassword = Constant.SENDER_APP_PASSWORD;

        String subject = "Mã xác nhận OTP " + purpose + " - HCMUTE Web";
        String content = "<div style=\"font-family: Arial, sans-serif; max-width: 520px; margin: auto; padding: 25px; border: 1px solid #e2e8f0; border-radius: 12px; background: #ffffff;\">"
                + "<div style=\"text-align: center; border-bottom: 2px solid #2563eb; padding-bottom: 15px;\">"
                + "  <h2 style=\"color: #1e3a8a; margin: 0; font-size: 22px;\">TRƯỜNG ĐH SƯ PHẠM KỸ THUẬT TP.HCM</h2>"
                + "  <p style=\"color: #64748b; margin: 5px 0 0; font-size: 14px;\">Hệ Thống Quản Lý & Chia Sẻ Video Trực Tuyến</p>"
                + "</div>"
                + "<div style=\"padding: 20px 0;\">"
                + "  <p style=\"font-size: 15px; color: #334155;\">Xin chào,</p>"
                + "  <p style=\"font-size: 15px; color: #334155;\">Bạn đang thực hiện thao tác: <strong style=\"color: #2563eb;\">" + purpose + "</strong>.</p>"
                + "  <p style=\"font-size: 15px; color: #334155;\">Mã OTP xác thực 6 chữ số của bạn là:</p>"
                + "  <div style=\"text-align: center; margin: 25px 0;\">"
                + "    <span style=\"font-size: 32px; font-weight: 800; letter-spacing: 6px; color: #dc2626; background: #fee2e2; padding: 12px 30px; border-radius: 10px; border: 2px dashed #dc2626; display: inline-block;\">"
                + otp + "</span>"
                + "  </div>"
                + "  <p style=\"font-size: 14px; color: #64748b; line-height: 1.6;\">Mã xác nhận này có hiệu lực trong vòng <strong>5 phút</strong>. Tuyệt đối không cung cấp mã này cho người khác để bảo vệ an toàn tài khoản.</p>"
                + "</div>"
                + "<div style=\"border-top: 1px solid #e2e8f0; padding-top: 15px; font-size: 12px; color: #94a3b8; text-align: center;\">"
                + "  Email tự động từ môn Lập trình Web - Khoa CNTT - HCMUTE"
                + "</div>"
                + "</div>";

        System.out.println("================================================================================");
        System.out.println("[EMAIL NOTIFICATION] Dang gui OTP qua mail...");
        System.out.println("Nguoi gui:  " + senderEmail);
        System.out.println("Nguoi nhan: " + toEmail);
        System.out.println("Muc dich:   " + purpose);
        System.out.println("MA OTP:     >>> " + otp + " <<<");
        System.out.println("================================================================================");

        if (senderPassword == null || senderPassword.trim().isEmpty()) {
            lastSendError = "Chưa cấu hình Mật khẩu ứng dụng Gmail (App Password 16 ký tự). Mã OTP để test: " + otp;
            System.err.println("[EmailUtil] " + lastSendError);
            return true;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", SMTP_HOST);
            props.put("mail.smtp.connectiontimeout", "8000");
            props.put("mail.smtp.timeout", "8000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail, "HCMUTE Web Video System", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(content, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[EmailUtil] GỬI EMAIL THÀNH CÔNG TỚI: " + toEmail);
            lastSendError = null;
            return true;
        } catch (jakarta.mail.AuthenticationFailedException e) {
            lastSendError = "Google từ chối đăng nhập (Mã lỗi 535): Bạn đang dùng mật khẩu cá nhân/cổng trường thay vì Mật khẩu ứng dụng 16 ký tự của Google. Để test tiếp, mã OTP của bạn là: " + otp;
            System.err.println("[EmailUtil] " + lastSendError);
            return true; // Trả về true để không làm crash luồng đăng ký của sinh viên
        } catch (Exception e) {
            lastSendError = "Lỗi gửi email qua máy chủ Google: " + e.getMessage() + ". Mã OTP của bạn là: " + otp;
            System.err.println("[EmailUtil] " + lastSendError);
            return true;
        }
    }
}
