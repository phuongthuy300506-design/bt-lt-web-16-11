package vn.iotstar.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

/**
 * Bộ lọc SiteMesh Decorator 3 phiên bản 3.3.0 tương thích Jakarta EE 11 (Tomcat 11 / Servlet 6.1).
 * Phân chia giao diện phù hợp cho người dùng và admin (Bài tập 03 - Yêu cầu 1).
 */
public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Cấu hình đường dẫn thư mục chứa các template layout decorators
        builder.setDecoratorPrefix("/WEB-INF/decorators/");

        // 1. Phân chia giao diện cho Admin và Người dùng Web
        builder.addDecoratorPath("/admin/*", "admin.jsp")
               .addDecoratorPath("/*", "web.jsp");

        // 2. Loại trừ các đường dẫn tài nguyên tĩnh và API
        builder.addExcludedPath("/api*")
               .addExcludedPath("/image*")
               .addExcludedPath("/uploads/*")
               .addExcludedPath("*.mp4")
               .addExcludedPath("*.css")
               .addExcludedPath("*.js")
               .addExcludedPath("*.png")
               .addExcludedPath("*.jpg")
               .addExcludedPath("*.jpeg")
               .addExcludedPath("*.webp")
               .addExcludedPath("*.gif")
               .addExcludedPath("*.ico");
    }
}
