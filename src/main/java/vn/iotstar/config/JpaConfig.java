package vn.iotstar.config;

import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.util.PasswordUtil;

public class JpaConfig {
    private static EntityManagerFactory factory;
    private static boolean dataInitialized = false;

    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (factory == null || !factory.isOpen()) {
            try {
                // 1. Thử kết nối unit chính jpa-hibernate-mysql (SQL Server)
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
                EntityManager testEm = factory.createEntityManager();
                testEm.close();
            } catch (Exception e) {
                System.err.println("JpaConfig: Ket noi SQL Server [1234567@a$] chua san sang: " + e.getMessage());
                try {
                    // Thử mật khẩu 1234@a$
                    Map<String, Object> props = new HashMap<>();
                    props.put("jakarta.persistence.jdbc.password", "1234@a$");
                    factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql", props);
                    EntityManager testEm = factory.createEntityManager();
                    testEm.close();
                } catch (Exception e2) {
                    System.err.println("JpaConfig: Chuyen sang che do du phong (jpa-hibernate-h2) de chay on dinh...");
                    try {
                        factory = Persistence.createEntityManagerFactory("jpa-hibernate-h2");
                    } catch (Exception e3) {
                        System.err.println("JpaConfig: Loi khoi tao persistence-unit: " + e3.getMessage());
                    }
                }
            }

            // Tự động khởi tạo dữ liệu mẫu nếu database đang trống
            initDefaultData();
        }
        return factory;
    }

    public static EntityManager getEntityManager() {
        EntityManagerFactory emf = getEntityManagerFactory();
        if (emf != null && emf.isOpen()) {
            return emf.createEntityManager();
        }
        return null;
    }

    private static synchronized void initDefaultData() {
        if (dataInitialized || factory == null || !factory.isOpen()) {
            return;
        }
        EntityManager em = null;
        EntityTransaction trans = null;
        try {
            em = factory.createEntityManager();
            trans = em.getTransaction();
            trans.begin();

            // 1. Kiểm tra tài khoản User
            List<User> users = em.createQuery("SELECT u FROM User u", User.class).getResultList();
            User adminUser = null;
            User regularUser = null;

            if (users.isEmpty()) {
                String hashedPassword = PasswordUtil.hash("1234@a$");

                adminUser = new User("admin@iotstar.vn", "admin", "Quản Trị Viên", hashedPassword, "admin.png", 1,
                        "0908617108", 1, null, new Date(System.currentTimeMillis()));
                em.persist(adminUser);

                User managerUser = new User("manager@iotstar.vn", "manager", "Trưởng Bộ Phận", hashedPassword,
                        "manager.png", 2, "0912345678", 1, null, new Date(System.currentTimeMillis()));
                em.persist(managerUser);

                regularUser = new User("user@iotstar.vn", "user", "Nguyễn Văn A", hashedPassword, "user.png", 5,
                        "0987654321", 1, null, new Date(System.currentTimeMillis()));
                em.persist(regularUser);
            } else {
                for (User u : users) {
                    if ("admin".equals(u.getUsername())) adminUser = u;
                    if ("user".equals(u.getUsername())) regularUser = u;
                }
                if (regularUser == null && !users.isEmpty()) regularUser = users.get(0);
            }

            // 2. Kiểm tra Danh mục Categories
            List<Category> categories = em.createQuery("SELECT c FROM Category c", Category.class).getResultList();
            Category c1 = null, c2 = null, c3 = null, c4 = null;
            if (categories.isEmpty()) {
                c1 = new Category(0, "Công nghệ & Lập trình", "cong_nghe.png", 1);
                c2 = new Category(0, "Điện thoại & Phụ kiện", "ao_nam.png", 1);
                c3 = new Category(0, "Laptop & Máy tính", "giay.png", 1);
                c4 = new Category(0, "Đời sống & Khoa học", "phu_kien.png", 1);
                em.persist(c1);
                em.persist(c2);
                em.persist(c3);
                em.persist(c4);
            } else {
                c1 = categories.get(0);
                c2 = categories.size() > 1 ? categories.get(1) : c1;
                c3 = categories.size() > 2 ? categories.get(2) : c1;
                c4 = categories.size() > 3 ? categories.get(3) : c1;
            }

            // 3. Kiểm tra Videos
            List<Video> videos = em.createQuery("SELECT v FROM Video v", Video.class).getResultList();
            if (videos.isEmpty()) {
                User owner = regularUser != null ? regularUser : adminUser;

                String sampleMp4 = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

                em.persist(new Video("v01", 1, "Hướng dẫn toàn diện kiến trúc Jakarta EE 11 và cấu hình Servlet 6.1.", "poster1.png", "Khóa học Lập trình Web Jakarta EE 11 - Bài 1", 1850, sampleMp4, c1, owner));
                em.persist(new Video("v02", 1, "Tìm hiểu sâu Hibernate ORM 6.6, quản lý EntityManagerFactory và ánh xạ One-to-Many.", "poster2.png", "Làm chủ Hibernate ORM 6.6 và JPA 3.1 từ A đến Z", 1230, sampleMp4, c1, owner));
                em.persist(new Video("v03", 1, "Đánh giá chi tiết hiệu năng và camera iPhone 16 Pro Max sau thời gian trải nghiệm.", "poster3.png", "Đập hộp & Đánh giá chi tiết iPhone 16 Pro Max", 3420, sampleMp4, c2, owner));
                em.persist(new Video("v04", 1, "Top 5 laptop phục vụ đồ họa và lập trình tối ưu nhất phân khúc sinh viên kỹ thuật.", "poster4.png", "Top 5 Laptop đồ họa tốt nhất năm 2026", 980, sampleMp4, c3, owner));
                em.persist(new Video("v05", 1, "Kỹ thuật mã hóa mật khẩu an toàn sử dụng thuật toán băm SHA-256 trong Java Web.", "poster5.png", "Bảo mật ứng dụng Web: Mã hóa mật khẩu với SHA-256", 2150, sampleMp4, c1, owner));
                em.persist(new Video("v06", 1, "Tích hợp Jakarta Mail gửi mã xác thực OTP kích hoạt tài khoản người dùng tự động.", "poster6.png", "Xây dựng chức năng gửi Email xác thực OTP bằng Jakarta Mail", 1670, sampleMp4, c1, owner));
                em.persist(new Video("v07", 1, "Phân tích kỹ thuật phân trang 6 video/trang trong Hibernate ORM với setFirstResult.", "poster7.png", "Kỹ thuật phân trang 6 sản phẩm/trang chuẩn MVC", 890, sampleMp4, c1, owner));
                em.persist(new Video("v08", 1, "Hướng dẫn sử dụng @MultipartConfig để xử lý upload file ảnh và video trong Java Servlet.", "poster8.png", "Upload file bằng Multipart trong Servlet Jakarta", 2780, sampleMp4, c1, owner));
                em.persist(new Video("v09", 1, "Quy trình thiết kế giao diện Bootstrap 5 responsive cho ứng dụng chia sẻ video hiện đại.", "poster9.png", "Thiết kế giao diện Video Player hiện đại với Bootstrap 5", 1450, sampleMp4, c4, owner));
                em.persist(new Video("v10", 1, "Nhúng video player HTML5 và tự động tăng lượt xem (views) khi người dùng bấm chuột vào tiêu đề.", "poster10.png", "HTML5 Video Player & Tự động tăng lượt xem (Views)", 3100, sampleMp4, c4, owner));
                em.persist(new Video("v11", 1, "Hướng dẫn quy trình Quên mật khẩu gửi mã xác nhận OTP qua email và đặt lại mật khẩu mới.", "poster11.png", "Quy trình Quên mật khẩu & Đặt lại mật khẩu an toàn", 1120, sampleMp4, c1, owner));
                em.persist(new Video("v12", 1, "Tổng kết toàn diện đồ án Lập trình Web và những lưu ý quan trọng khi triển khai hệ thống.", "poster12.png", "Tổng kết Đồ án Lập trình Web HCMUTE 2026", 4500, sampleMp4, c1, owner));
            }

            trans.commit();
            dataInitialized = true;
            System.out.println("JpaConfig: Khoi tao du lieu mau thanh cong (Users, Categories, 12 Videos)!");
        } catch (Exception e) {
            if (trans != null && trans.isActive()) {
                trans.rollback();
            }
            System.err.println("JpaConfig: Loi khi khoi tao du lieu mau: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    public static synchronized void shutdown() {
        if (factory != null && factory.isOpen()) {
            factory.close();
            factory = null;
        }
    }
}
