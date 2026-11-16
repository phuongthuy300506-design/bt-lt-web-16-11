package vn.iotstar.email;

import vn.iotstar.util.EmailUtil;

public class SendMail {
    public boolean sendMail(String to, String subject, String message) {
        return EmailUtil.sendOtpEmail(to, message, subject);
    }
}
