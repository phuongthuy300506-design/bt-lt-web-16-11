package vn.iotstar.filter;

import java.io.IOException;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

/**
 * Bộ lọc SiteMesh Decorator 3 phiên bản 3.3.0 tương thích Jakarta EE 11 (Tomcat 11 / Servlet 6.1).
 * Phân chia giao diện phù hợp cho người dùng và admin (Bài tập 03 - Yêu cầu 1).
 */
public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        DispatcherType dispatcherType = req.getDispatcherType();

        // Trong Tomcat 11, khi Servlet Controller forward sang JSP:
        // - Nếu Sitemesh buffer ở tầng REQUEST của Servlet, lệnh forward() của Tomcat
        //   sẽ commit response sớm khiến Sitemesh không thể ghi nội dung đã decorate ra output.
        // - Do đó, với các REQUEST đến Servlet (không phải trực tiếp file .jsp), ta cho đi thẳng
        //   để Sitemesh bắt và decorate ở tầng FORWARD của trang JSP bên trong.
        if (dispatcherType == DispatcherType.REQUEST && !req.getRequestURI().endsWith(".jsp")) {
            chain.doFilter(request, response);
            return;
        }

        super.doFilter(request, response, chain);
    }

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Cấu hình đường dẫn thư mục chứa các template layout decorators
        builder.setDecoratorPrefix("/WEB-INF/decorators/");

        // 1. Phân chia giao diện cho Admin và Người dùng Web
        builder.addDecoratorPath("/admin/*", "admin.jsp")
               .addDecoratorPath("/views/admin/*", "admin.jsp")
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
