<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.List" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa thông tin cá nhân</title>
    <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
    <link rel="stylesheet" type="text/css" href="styles/admin_action.css">
    <link rel="icon" type = "image/x-icon" href="logo.png">
    <title>Admin</title>
</head>
<body>
<header>
    <div class="header-content">
        <img src="logo.png" alt="Cá Koi" class="img_header-thongtin">
        <h2><a href="index.jsp" class="home-link">Trang chủ</a></h2>
    </div>
    <nav>
        <ul>
            <%
                session = request.getSession();
                String username = (String) session.getAttribute("username");
                Connection conn = null;
                int isAdmin = 0;

                if (username != null) {
                    Properties props = new Properties();
                    try (InputStream input = application.getResourceAsStream("config.properties")) {
                        if (input == null) {
                            throw new IOException("Tệp cấu hình không tồn tại.");
                        }
                        props.load(input);
                    } catch (IOException e) {
                        out.println("Lỗi đọc tệp cấu hình: " + e.getMessage());
                        return;
                    }

                    String host = props.getProperty("db.host");
                    String port = props.getProperty("db.port");
                    String dbname = props.getProperty("db.name");
                    String dbuser = props.getProperty("db.user");
                    String dbpassword = props.getProperty("db.password");

                    try {
                        Class.forName("org.postgresql.Driver");
                        String dsn = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
                        conn = DriverManager.getConnection(dsn, dbuser, dbpassword);

                        // Lấy thông tin quyền admin
                        PreparedStatement stmt = conn.prepareStatement("SELECT isadmin FROM users WHERE username = ?");
                        stmt.setString(1, username);
                        ResultSet row = stmt.executeQuery();
                        if (row.next()) {
                            // Lấy giá trị là String để kiểm tra
                            String isAdminStr = row.getString("isadmin");
                            isAdmin = "1".equals(isAdminStr) ? 1 : 0; // Chuyển đổi thành int
                        }

                        if (isAdmin == 1) {
                            out.println("<li><a href=\"admin.jsp\">Quản trị</a></li>");
                        }
                        out.println("<li><a href=\"Logout.jsp\">Đăng xuất</a></li>");
                    } catch (Exception e) {
                        out.println("Kết nối đến cơ sở dữ liệu thất bại: " + e.getMessage());
                    }
                } else {
                    out.println("<li><a href=\"Login.jsp\">Đăng nhập</a></li>");
                }
            %>
            <li><a href="Hotro.html">Hỗ trợ</a></li>
            <li><a class="text-white" href="Sanpham.jsp">Sản phẩm</a></li>
            <li><a class="text-white" href="Thongtin.jsp">Thông tin</a></li>
        </ul>
    </nav>
</header>
<div class="main">

    <h2>Thêm thông tin Cá Koi mới</h2>
    <form action="KoiServlet" method="post" enctype="multipart/form-data">
        <!-- Thêm thông tin Cá Koi -->
        <label for="name_ca">Tên cá Koi:</label>
        <input type="text" id="name_ca" name="name_ca" required><br><br>

        <label for="ghichu_ca">Ghi chú:</label>
        <input type="text" id="ghichu_ca" name="ghichu_ca" required><br><br>

        <label for="image_path1_ca">Hình ảnh 1:</label>
        <input type="file" id="image_path1_ca" name="image_pathca1" accept="image/*"><br><br>

        <label for="image_path2_ca">Hình ảnh 2:</label>
        <input type="file" id="image_path2_ca" name="image_pathca2" accept="image/*"><br><br>

        <label for="image_path3_ca">Hình ảnh 3:</label>
        <input type="file" id="image_path3_ca" name="image_pathca3" accept="image/*"><br><br>

        <label for="image_path4_ca">Hình ảnh 4:</label>
        <input type="file" id="image_path4_ca" name="image_pathca4" accept="image/*"><br><br>

        <label for="khainiem_ca">Khái niệm:</label>
        <textarea id="khainiem_ca" name="khainiem_ca" rows="4" cols="50" required></textarea><br><br>

        <label for="dacdiem_ca">Đặc điểm:</label>
        <textarea id="dacdiem_ca" name="dacdiem_ca" rows="4" cols="50" required></textarea><br><br>

        <label for="dinhduong_ca">Dinh dưỡng:</label>
        <textarea id="dinhduong_ca" name="dinhduong_ca" rows="4" cols="50" required></textarea><br><br>

        <label for="phanloai_ca">Phân loại:</label>
        <textarea id="phanloai_ca" name="phanloai_ca" rows="4" cols="50" required></textarea><br><br>

        <label for="phanbiet_ca">Phân biệt:</label>
        <textarea id="phanbiet_ca" name="phanbiet_ca" rows="4" cols="50" required></textarea><br><br>

        <input type="submit" value="Thêm Cá Koi">
    </form>

</div>
</body>
</html>
