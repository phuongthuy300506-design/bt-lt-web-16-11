# BÁO CÁO BÀI TẬP LẬP TRÌNH WEB (16/11/2026) - HCMUTE
## TRIỂN KHAI TOÀN DIỆN CÔNG NGHỆ JPA (HIBERNATE ORM 6.6) & XÁC THỰC OTP

- **Môn học:** Lập trình Web (`WEBPR330479`)
- **Khoa:** Công Nghệ Thông Tin - Bộ Môn Công Nghệ Phần Mềm
- **Trường:** Đại học Sư Phạm Kỹ Thuật TP.HCM (HCMUTE)
- **Giảng viên hướng dẫn:** ThS. Nguyễn Hữu Trung
- **Môi trường triển khai:** Java 21 LTS, Jakarta EE 11 (Servlet 6.1, JSP 3.1, JSTL 3.0), Hibernate ORM 6.6.1.Final, Jakarta Mail 2.1.3, Apache Tomcat 11.0.2, SQL Server / H2 Database Fallback.

---

## 1. Tóm tắt các yêu cầu đã thực hiện đầy đủ 100%

### Yêu cầu 1: Bổ sung chức năng kích hoạt tài khoản bằng OTP được gửi qua email khi đăng ký tài khoản
- **Quy trình:**
  1. Người dùng truy cập `/register` và điền thông tin: Tên đăng nhập, Email, Mật khẩu, Họ tên, Số điện thoại.
  2. Hệ thống kiểm tra trùng lặp `username` và `email`.
  3. Mật khẩu được mã hóa an toàn bằng thuật toán băm **SHA-256**.
  4. Hệ thống sinh ngẫu nhiên **mã OTP gồm 6 chữ số** và lưu tài khoản với trạng thái `status = 0` (Chưa kích hoạt) cùng `code = OTP`.
  5. Gửi mã OTP qua email người dùng bằng **Jakarta Mail** (`jakarta.mail` / `angus-mail`) theo định dạng HTML đẹp mắt.
  6. Đồng thời in mã OTP ra server console và hiển thị gợi ý trực quan tại giao diện `/verify-otp?username=...` để kiểm thử cục bộ mượt mà không bị nghẽn mạng SMTP.
  7. Người dùng nhập đúng mã OTP tại `/verify-otp` -> Tài khoản chuyển sang `status = 1` (Đã kích hoạt), xóa mã OTP khỏi hệ thống và chuyển hướng tới `/login`.
  8. Hỗ trợ chức năng **Gửi lại mã OTP** (`/resend-otp`) khi mã hết hạn.

### Yêu cầu 2: Thực hiện chức năng đăng nhập với mật khẩu được mã hóa (hash password) & đăng xuất
- **Đăng nhập (`/login`):**
  - Mật khẩu người dùng nhập vào được băm SHA-256 qua `PasswordUtil.verify()` và so khớp với chuỗi mã hóa trong Database.
  - Kiểm tra trạng thái kích hoạt: Nếu tài khoản có `status = 0` (chưa kích hoạt OTP), hệ thống thông báo yêu cầu kích hoạt và chuyển hướng người dùng tới trang nhập mã OTP.
  - Đăng nhập thành công -> Lưu thông tin phiên làm việc vào `HttpSession` (`account`).
  - Hỗ trợ lưu Cookie **Ghi nhớ đăng nhập (Remember Me)** với thời hạn 7 ngày.
  - Phân quyền điều hướng tự động: Admin (`roleid = 1`) -> chuyển về trang Quản trị (`/admin/categories` hoặc `/admin/videos`); User (`roleid = 5`) -> chuyển về Trang chủ (`/home`).
- **Đăng xuất (`/logout`):**
  - Hủy session `account`, xóa cookie Remember Me và chuyển hướng an toàn về `/login`.

### Yêu cầu 3: Thực hiện chức năng quên mật khẩu gửi mã xác nhận OTP qua mail
- **Quy trình:**
  1. Người dùng vào `/forgot-password`, nhập địa chỉ email đã đăng ký.
  2. Hệ thống kiểm tra email tồn tại trong database.
  3. Sinh mã xác nhận OTP 6 số mới, lưu vào trường `code` của User trong database.
  4. Gửi email thông báo mã OTP đặt lại mật khẩu bằng Jakarta Mail (và ghi log ra console).
  5. Chuyển hướng sang trang đặt lại mật khẩu `/reset-password?email=...`.
  6. Người dùng nhập: Email, Mã OTP, Mật khẩu mới, Xác nhận mật khẩu mới.
  7. Kiểm tra mã OTP khớp -> Mã hóa mật khẩu mới bằng **SHA-256**, cập nhật vào database, xóa trường OTP `code = null`.
  8. Chuyển hướng về `/login` với thông báo thành công.

### Yêu cầu 4: Thêm bảng Videos vào database với mối liên hệ 1-n với bảng users trước đó
- **Cơ sở dữ liệu & Entity:**
  - Bảng `videos` có khóa ngoại `UserId` tham chiếu đến `[User](id)` (Quan hệ 1 - n: Một User có thể đăng nhiều Videos).
  - Khóa ngoại `CategoryId` tham chiếu đến `categories(CategoryId)`.
  - Khai báo Entity JPA: `@ManyToOne @JoinColumn(name = "UserId") private User user;` trong `Video.java` và `@OneToMany(mappedBy = "user") private List<Video> videos;` trong `User.java`.
- **4.1. Thực hiện CRUD cho bảng Videos:**
  - Danh sách video: `/admin/videos` (Admin) và `/video` (User).
  - Thêm mới video: `/admin/video/add` / `/video/add` (với Form Multipart).
  - Chỉnh sửa video: `/admin/video/edit` / `/video/edit`.
  - Xóa video: `/admin/video/delete` / `/video/delete`.
- **4.2. Hiển thị 10 video mới nhất lên trang chủ (`/home`):**
  - Truy vấn JPA: `SELECT v FROM Video v WHERE v.active = 1 ORDER BY v.videoId DESC` giới hạn `setMaxResults(10)`.
  - Hiển thị lưới thẻ Responsive bằng Bootstrap 5 kèm Thumbnail Poster, số lượt xem (views), tên người đăng (Uploader), danh mục.
- **4.3. Hiển thị tất cả videos của user phân trang 6sp/trang trên URL `/video`:**
  - Servlet `UserVideoController` ánh xạ URL `/video`.
  - Khi User đăng nhập: lọc danh sách video của chính User đó và phân trang **6 video/trang**.
  - Tính toán số trang: `totalPages = ceil(total / 6)`.
  - Giao diện có thanh điều hướng phân trang đầy đủ: Nút *Trước*, các số trang *1, 2, 3...*, Nút *Sau*.
- **4.4. Hiển thị chi tiết và play 01 video khi bấm chuột vào tiêu đề trên `/home` và `/video`:**
  - Tiêu đề của mọi video trên `/home` và `/video` là liên kết dẫn tới `/video/detail?id=...`.
  - Servlet `VideoDetailController` tự động tăng số lượt xem: `views = views + 1`.
  - Trang `/video/detail` tích hợp trình phát video HTML5 Player / YouTube Responsive, hiển thị tiêu đề, lượt xem, mô tả, người đăng, danh mục và cột danh sách video gợi ý liên quan bên cạnh.
- **4.5. Hướng dẫn upload file bằng Multipart:**
  - Áp dụng cấu hình chuẩn theo tài liệu `10_UploadFile_servlet_jakarta.pdf`:
    - `@MultipartConfig(fileSizeThreshold = 2MB, maxFileSize = 50MB, maxRequestSize = 100MB)`.
    - Trích xuất tên file upload bằng hàm `getFileName(Part part)`.
    - Lưu file vào thư mục `Constant.UPLOAD_DIRECTORY` (`D:\upload`) và phục vụ ảnh/video qua `DownloadImageController` (`/image?fname=...`).

---

## 2. Danh mục URL và Tài khoản Test

### Tài khoản có sẵn:
| Tài khoản (Username) | Mật khẩu gốc | Mật khẩu băm SHA-256 lưu DB | Phân quyền | Trạng thái OTP |
|----------------------|--------------|------------------------------|------------|----------------|
| `admin`              | `1234@a$`    | `fbd2a48be520754d37ebadb968d0909b91c468c99d27bbdc03d3a1df115235a9` | Admin (1) | Đã kích hoạt (1) |
| `manager`            | `1234@a$`    | `fbd2a48be520754d37ebadb968d0909b91c468c99d27bbdc03d3a1df115235a9` | Manager (2)| Đã kích hoạt (1) |
| `user`               | `1234@a$`    | `fbd2a48be520754d37ebadb968d0909b91c468c99d27bbdc03d3a1df115235a9` | User (5)   | Đã kích hoạt (1) |

### Danh sách URL chính:
- **Trang chủ (10 Video mới nhất):** `http://localhost:8080/home`
- **Trang Video người dùng (Phân trang 6sp/trang):** `http://localhost:8080/video`
- **Trang Đăng nhập:** `http://localhost:8080/login`
- **Trang Đăng ký (Xác thực OTP):** `http://localhost:8080/register`
- **Trang Quên mật khẩu:** `http://localhost:8080/forgot-password`
- **Trang Quản trị Videos (Admin CRUD):** `http://localhost:8080/admin/videos`
- **Trang Quản trị Danh mục (Category):** `http://localhost:8080/admin/categories`

---

## 3. Cách chạy dự án

1. **Chạy nhanh bằng 1-Click:**
   - Nhấp đúp vào file `CHAY WEB.bat` tại thư mục gốc của dự án.
   - File BAT sẽ tự động build Maven, deploy WAR vào Tomcat 11 và mở trình duyệt tại `http://localhost:8080/home`.

2. **Chạy kiểm thử tự động (Unit Test Runner):**
   - Mở terminal tại thư mục dự án và chạy:
     ```powershell
     $env:JAVA_HOME = "C:\Program Files\Java\jdk-21"; D:\apache-maven-3.9.9\bin\mvn.cmd compile exec:java "-Dexec.mainClass=vn.iotstar.config.TestFullHomework"
     ```
   - Kiểm thử toàn bộ 4 yêu cầu tự động và in kết quả chi tiết.
