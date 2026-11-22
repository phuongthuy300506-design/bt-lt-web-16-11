package vn.iotstar.util;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.Map;
import jakarta.servlet.http.Part;
import org.apache.commons.io.IOUtils;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

/**
 * Tiện ích hỗ trợ Upload file ảnh lên Cloudinary bằng multipart
 * Bài tập 03 - Yêu cầu 3 (HCMUTE - ThS. Nguyễn Hữu Trung)
 */
public class CloudinaryUtil {

    private static Cloudinary cloudinary;

    public static synchronized Cloudinary getCloudinary() {
        if (cloudinary == null) {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", Constant.CLOUDINARY_CLOUD_NAME,
                "api_key", Constant.CLOUDINARY_API_KEY,
                "api_secret", Constant.CLOUDINARY_API_SECRET,
                "secure", true
            ));
        }
        return cloudinary;
    }

    /**
     * Upload file Part từ multipart request lên Cloudinary
     * @param part Part nhận từ request.getPart("avatar") hoặc request.getPart("images")
     * @return URL ảnh từ Cloudinary (https://res.cloudinary.com/...) hoặc tên file cục bộ fallback
     */
    public static String upload(Part part) {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        if (submittedFileName == null || submittedFileName.trim().isEmpty()) {
            return null;
        }

        System.out.println("================================================================================");
        System.out.println("[CLOUDINARY MULTIPART UPLOAD] Đang xử lý tải file: " + submittedFileName + " (Size: " + part.getSize() + " bytes)");

        byte[] fileBytes;
        try (InputStream in = part.getInputStream();
             ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {
            IOUtils.copy(in, buffer);
            fileBytes = buffer.toByteArray();
        } catch (Exception e) {
            System.err.println("[CloudinaryUtil] Không thể đọc dữ liệu file: " + e.getMessage());
            return null;
        }

        // 1. Thử tải lên Cloudinary
        try {
            Cloudinary c = getCloudinary();
            @SuppressWarnings("rawtypes")
            Map uploadResult = c.uploader().upload(fileBytes, ObjectUtils.asMap(
                "folder", "hcmute_user_profiles",
                "resource_type", "image",
                "use_filename", true,
                "unique_filename", true
            ));

            if (uploadResult != null && uploadResult.containsKey("secure_url")) {
                String secureUrl = (String) uploadResult.get("secure_url");
                System.out.println("[CLOUDINARY MULTIPART UPLOAD] >>> Upload Cloudinary THÀNH CÔNG! URL: " + secureUrl);
                System.out.println("================================================================================");
                return secureUrl;
            }
        } catch (Exception e) {
            System.err.println("[CloudinaryUtil] Tải lên Cloudinary thất bại (" + e.getMessage() + "), chuyển sang lưu cục bộ dự phòng...");
        }

        // 2. Fallback lưu cục bộ dự phòng nếu mạng bị chặn hoặc không có internet
        try {
            String extension = "";
            int dotIndex = submittedFileName.lastIndexOf(".");
            if (dotIndex > 0) {
                extension = submittedFileName.substring(dotIndex);
            }
            String uniqueName = "avatar_" + System.currentTimeMillis() + extension;
            File uploadDir = new File(Constant.UPLOAD_DIRECTORY);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            File destFile = new File(uploadDir, uniqueName);
            try (FileOutputStream fos = new FileOutputStream(destFile)) {
                fos.write(fileBytes);
            }
            System.out.println("[CloudinaryUtil Fallback] Đã lưu ảnh cục bộ: " + destFile.getAbsolutePath());
            System.out.println("================================================================================");
            return uniqueName;
        } catch (Exception ex) {
            System.err.println("[CloudinaryUtil Fallback Error] " + ex.getMessage());
            return null;
        }
    }
}
