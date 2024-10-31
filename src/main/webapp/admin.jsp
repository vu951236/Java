<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa thông tin cá nhân</title>
    <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
    <link rel="icon" type="image/x-icon" href="logo.png">
    <style>
        .alert {
            margin-top: 10px;
        }
        .main a {
            color: blue; /* Màu sắc cho liên kết chưa được nhấp */
            text-decoration: none; /* Không có gạch chân */
        }

        .main a:visited {
            color: blue; /* Màu sắc cho liên kết đã được nhấp */
        }

        .main a:hover {
            color: darkblue; /* Màu sắc khi di chuột lên liên kết */
        }

        .main a:active {
            color: red; /* Màu sắc khi nhấp vào liên kết */
        }
        /* CSS cho thông báo thành công */
        .alert {
            margin-top: 70px;
        }

        .alert-success {
            color: #155724;
            top: 150px;
            background-color: #d4edda;
            border-color: #c3e6cb;
            border-radius: 5px;
            padding: 15px;
            font-size: 16px;
            margin-bottom: 0px;
        }

        .alert-dismissible .close {
            position: absolute;
            top: 65px;
            right: 10px;
            padding: 15px;
            color: inherit;
            background: none;
            border: none;
            cursor: pointer;
        }

        /* CSS cho thông báo lỗi */
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
            border-radius: 5px;
            padding: 15px;
            font-size: 16px;
            margin-bottom: 0px;
        }

        /* CSS cho nút đóng trong thông báo */
        .alert-dismissible .close {
            position: absolute;
            top: 65px;
            right: 10px;
            padding: 15px;
            color: inherit;
            background: none;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

<header>
    <div class="header-content">
        <img src="logo.png" alt="Cá Koi" class="img_header-thongtin">
        <h2><a href="index.jsp" class="home-link">Trang chủ</a></h2>
    </div>
    <nav>
        <ul class="nav">
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
                            String isAdminStr = row.getString("isadmin");
                            isAdmin = "1".equals(isAdminStr) ? 1 : 0; // Chuyển đổi thành int
                        }

                        if (isAdmin == 1) {
                            out.println("<li class='nav-item'><a class='nav-link' href=\"admin.jsp\">Quản trị</a></li>");
                        }
                        out.println("<li class='nav-item'><a class='nav-link' href=\"Logout.jsp\">Đăng xuất</a></li>");
                    } catch (Exception e) {
                        out.println("Kết nối đến cơ sở dữ liệu thất bại: " + e.getMessage());
                    }
                } else {
                    out.println("<li class='nav-item'><a class='nav-link' href=\"Login.jsp\">Đăng nhập</a></li>");
                }
            %>
            <li class="nav-item"><a class="nav-link" href="Hotro.html">Hỗ trợ</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="Sanpham.jsp">Sản phẩm</a></li>
            <li class="nav-item"><a class="nav-link text-white" href="Thongtin.jsp">Thông tin</a></li>
        </ul>
    </nav>
</header>

<%
    String success = request.getParameter("success");
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
%>

<!-- Hiển thị thông báo thành công -->
<% if ("true".equals(success) && successMessage != null) { %>
<div class="alert alert-success alert-dismissible fade show" role="alert">
    <strong>Thành công!</strong> <%= successMessage %>
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>
<% session.removeAttribute("successMessage"); } %>

<!-- Hiển thị thông báo lỗi -->
<% if ("false".equals(success) && errorMessage != null) { %>
<div class="alert alert-danger alert-dismissible fade show" role="alert">
    <strong>Lỗi!</strong> <%= errorMessage %>
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>

<% session.removeAttribute("errorMessage"); } %>

<div class="main">
    <h2><a href="ThemThongTinCaKoi.jsp">Thêm thông tin Cá Koi</a></h2>
    <h2><a href="ThemThongTinHoCa.jsp">Thêm thông tin Hồ Cá</a></h2>
    <h2><a href="ThemThongTinThuocDieuTri.jsp">Thêm thông tin Thuốc điều trị Cá</a></h2>
    <h2><a href="ThemThongTinThuocDieuChinhNuoc.jsp">Thêm thông tin Thuốc điều chỉnh nước</a></h2>

    <h2><a href="SuaThongTinCaKoi.jsp">Sửa thông tin cá Koi</a></h2>
    <h2><a href="SuaThongTinHoCaKoi.jsp">Sửa Thông Tin Hồ Cá Koi</a></h2>
    <h2><a href="SuaThongTinThuocDieuTri.jsp">Sửa thông tin Thuốc điều trị Cá</a></h2>
    <h2><a href="SuaThongTinThuocDieuChinhNuoc.jsp">Sửa thông tin Thuốc điều chỉnh nước</a></h2>

    <h2><a href="XoaThongTinCaKoi.jsp">Xóa thông tin cá Koi</a></h2>
    <h2><a href="XoaThongTinHoCaKoi.jsp">Xóa Thông Tin Hồ Cá Koi</a></h2>
    <h2><a href="XoaThongTinThuocDieuTri.jsp">Xóa thông tin Thuốc điều trị Cá</a></h2>
    <h2><a href="XoaThongTinThuocDieuChinhNuoc.jsp">Xóa thông tin Thuốc điều chỉnh Nước</a></h2>

    <h2><a href="QuanLiDonHang.jsp">Quản lí đơn hàng</a></h2>

    <h2><a href="QuanLiUsers.jsp">Quản lí người dùng</a></h2>

    <h2><a href="TaoIdAdmin.jsp">Tạo id Admin</a></h2>

</div>

<!-- Chỉ bao gồm các tệp JS cần thiết -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
