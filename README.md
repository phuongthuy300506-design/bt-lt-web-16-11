# BÁO CÁO BÀI TẬP 03 - LẬP TRÌNH WEB (HCMUTE)
## SITEMESH DECORATOR 3 (3.3.0) & FORM VALIDATION TOÀN DIỆN
- **Môn học:** Lập trình Web (`WEBPR330479`)
- **Khoa:** Công Nghệ Thông Tin - Bộ Môn Công Nghệ Phần Mềm
- **Trường:** Đại học Sư Phạm Kỹ Thuật TP.HCM (HCMUTE)
- **Giảng viên hướng dẫn:** ThS. Nguyễn Hữu Trung
- **Sinh viên thực hiện:** Lê Phương Thùy (MSSV: **24110058**)
- **Môi trường:** Java 21 LTS, Jakarta EE 11, Tomcat 11.0.2, Sitemesh 3.3.0, Bootstrap 5.3.3, Hibernate ORM 6.6.1.
- **Thời hạn nộp:** Trước 16g00 ngày 19/11/2026.

---

## TỔNG HỢP CÁC YÊU CẦU BÀI TẬP 03 ĐÃ HOÀN THÀNH 100%

### YÊU CẦU 1: Cấu hình Sitemesh Decorator 3 (3.3.0) với Bootstrap Template
*(Hoàn thành trước 16g00 ngày 19/11/2026)*

1. **Dependency Sitemesh 3:**
   - Cấu hình trong `pom.xml`:
     ```xml
     <dependency>
         <groupId>org.sitemesh</groupId>
         <artifactId>sitemesh-webfilter</artifactId>
         <version>3.3.0</version>
     </dependency>
     ```

2. **Cấu hình `web.xml`:**
   - Đăng ký filter Sitemesh hỗ trợ đầy đủ cả `REQUEST` và `FORWARD` trên Tomcat 11:
     ```xml
     <filter>
         <filter-name>sitemesh</filter-name>
         <filter-class>vn.iotstar.filter.CustomSiteMeshFilter</filter-class>
     </filter>
     <filter-mapping>
         <filter-name>sitemesh</filter-name>
         <url-pattern>/*</url-pattern>
         <dispatcher>REQUEST</dispatcher>
         <dispatcher>FORWARD</dispatcher>
     </filter-mapping>
     ```

3. **Cấu hình `sitemesh3.xml` trong `WEB-INF`:**
   - Phân chia giao diện cho người dùng và quản trị viên:
     ```xml
     <sitemesh>
         <mapping path="/admin/*" name="admin" decorator="admin.jsp" />
         <mapping path="/views/admin/*" name="admin" decorator="admin.jsp" />
         <mapping path="/*" name="web" decorator="web.jsp" />
         <mapping path="/api*" exclude="true" />
         <mapping path="*.mp4" exclude="true" />
         <mapping path="*.css" exclude="true" />
         <mapping path="*.js" exclude="true" />
         <mapping path="*.png" exclude="true" />
         <mapping path="*.jpg" exclude="true" />
     </sitemesh>
     ```

4. **Cấu trúc thư mục trong `webapp` chuẩn 100% theo slide:**
   ```text
   webapp/
   ├── common/
   │   ├── admin/
   │   │   ├── footer.jsp
   │   │   ├── header.jsp
   │   │   └── left.jsp
   │   ├── web/
   │   │   ├── footer.jsp
   │   │   ├── header.jsp
   │   │   ├── left.jsp
   │   │   ├── navbar.jsp
   │   │   └── topbar.jsp
   │   ├── info.jsp
   │   └── taglib.jsp
   ├── info.jsp
   ├── taglib.jsp
   ├── templates/
   ├── uploads/
   ├── views/
   └── WEB-INF/
       ├── decorators/
       │   ├── admin.jsp
       │   ├── login.jsp
       │   └── web.jsp
       ├── beans.xml
       ├── sitemesh3.xml
       └── web.xml
   ```

5. **Xây dựng Template Layout:**
   - `web.jsp`: Layout người dùng dùng Bootstrap 5, Dark theme, Navbar tìm kiếm, Topbar hiển thị tài khoản, Slider video, Sidebar lọc danh mục, Footer.
   - `admin.jsp`: Layout quản trị viên với Sidebar chức năng, Header quản trị, Bảng danh mục & video.

---

### YÊU CẦU 2: Thực hiện Validation cho các chức năng có FORM
*(Hoàn thành trước 16g00 ngày 19/11/2026)*

Xây dựng bộ kiểm tra dữ liệu đầu vào [FormValidator.java](src/main/java/vn/iotstar/util/FormValidator.java) kết hợp giao diện Bootstrap 5 (`is-invalid`, `invalid-feedback`, alert cảnh báo) và giữ lại dữ liệu đã nhập (`sticky form`):

1. **Form Đăng nhập (`/login`):**
   - Kiểm tra để trống Tên đăng nhập và Mật khẩu.
   - Kiểm tra định dạng độ dài mật khẩu tối thiểu 6 ký tự.
   - Xác thực mật khẩu băm SHA-256 khớp CSDL, kiểm tra tài khoản đã kích hoạt OTP.

2. **Form Đăng ký (`/register`):**
   - **Tên đăng nhập:** 4–30 ký tự, chỉ chứa chữ, số, gạch dưới; kiểm tra không trùng lặp trong CSDL.
   - **Họ và tên:** Tối thiểu 2 ký tự, không được để trống.
   - **Email:** Định dạng RFC regex chuẩn; kiểm tra không trùng lặp email.
   - **Số điện thoại:** Định dạng chuẩn 10 số di động Việt Nam.
   - **Mật khẩu & Nhập lại mật khẩu:** Tối thiểu 6 ký tự, 2 ô mật khẩu bắt buộc phải trùng khớp nhau.
   - Sau khi đăng ký thành công -> Gửi OTP và **tự động điền mã OTP** tại `/verify-otp` để thuận tiện kiểm thử trực tiếp.

3. **Form Quên mật khẩu (`/forgot-password` & `/reset-password`):**
   - Kiểm tra tài khoản và email có tồn tại và khớp với nhau trong CSDL.
   - Tự động điền mã OTP tại `/reset-password`, kiểm tra mật khẩu mới và xác nhận mật khẩu mới khớp nhau.

4. **Form Quản lý Danh mục (Insert & Edit Category):**
   - Đường dẫn: `/admin/category/add` và `/admin/category/edit`.
   - Kiểm tra tên danh mục bắt buộc nhập, độ dài từ 2–100 ký tự.
   - Giữ lại hình ảnh cũ khi chỉnh sửa nếu không tải file mới.

5. **Form Quản lý Video (Insert & Edit Video):**
   - Đường dẫn: `/admin/video/add` và `/admin/video/edit`.
   - **Mã Video:** 2–20 ký tự, chỉ gồm chữ cái, số, gạch ngang/dưới. Khi thêm mới kiểm tra không trùng mã video đã có.
   - **Tiêu đề:** Tối thiểu 5 ký tự.
   - **Danh mục:** Bắt buộc chọn danh mục cha hợp lệ.
   - **Poster & Video:** Bắt buộc có poster và file video hoặc link video.

---

### LỊCH SỬ COMMIT QUÁ TRÌNH LÀM BÀI TRÊN GITHUB
- `ad729b5`: *fix*
- `b96aeb5`: *Bo sung info.jsp va taglib.jsp tai goc webapp dong bo 100% theo slide*
- `42731cf`: *Bat lai tinh nang tu dong dien ma OTP tren giao dien de tien test*
- `9d92678`: *Fix Sitemesh 3 decoration dispatching on Tomcat 11 for forwarded controller routes*
- `5755431`: *Bo sung thu muc templates va file beans.xml dong bo cau truc thu muc Sitemesh theo slide*
- `78b06b9`: **Bai tap 03 - Yeu cau 2: Trien khai Form Validation cho Login, Register, Forgot Password, Insert va Edit (Category va Video)**
- `408344a`: **Bai tap 03 - Yeu cau 1: Cau hinh Sitemesh Decorator 3 (3.3.0) voi Bootstrap Template dung chung toan bo website**
