<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Properties" %>

<%
    // Bắt đầu session
    request.getSession();

    // Kiểm tra xem trang này đã được gọi bằng phương thức POST hay chưa
    String error_message = null;
    // Đọc thông tin cấu hình từ file config.properties
    Properties props = new Properties();
    InputStream input = application.getResourceAsStream("config.properties");

    if (input == null) {
        out.println("Không thể tìm thấy file config.properties");
        return;
    }

    props.load(input);

    // Lấy thông tin kết nối từ file config.properties
    String host = props.getProperty("db.host");
    String port = props.getProperty("db.port");
    String dbname = props.getProperty("db.name");
    String dbuser = props.getProperty("db.user");
    String dbpassword = props.getProperty("db.password");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Connection conn = null;
        try {
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, dbuser, dbpassword);
        } catch (Exception e) {
            error_message = "Kết nối đến cơ sở dữ liệu PostgreSQL thất bại: " + e.getMessage();
        }

        // Kiểm tra tồn tại của các trường POST trước khi sử dụng
        String username = request.getParameter("username") != null ? request.getParameter("username") : "";
        String password = request.getParameter("password") != null ? request.getParameter("password") : "";
        String email = request.getParameter("email") != null ? request.getParameter("email") : "";
        String fullname = request.getParameter("fullname") != null ? request.getParameter("fullname") : "";
        String address = request.getParameter("address") != null ? request.getParameter("address") : "";

        String admin_code = request.getParameter("admin_code"); // Nhận mã admin từ form
        int is_admin = 0; // Mặc định người dùng không phải là admin

        // Kiểm tra tính hợp lệ của các trường thông tin và xử lý lỗi
        if (error_message == null) {
            if (username.length() < 6 || username.length() > 12) {
                error_message = "Tên người dùng phải có từ 6 đến 12 ký tự.";
            } else if (password.length() < 6 || password.length() > 12) {
                error_message = "Mật khẩu phải có từ 6 đến 12 ký tự.";
            } else if (email.isEmpty() || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                error_message = "Email không hợp lệ.";
            } else if (fullname.isEmpty()) {
                error_message = "Họ và tên không được trống.";
            } else if (address.isEmpty()) {
                error_message = "Địa chỉ không được trống.";
            }
        }

        // Kiểm tra tên người dùng đã tồn tại
        if (error_message == null && conn != null) {
            try {
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ?");
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    error_message = "Tên người dùng đã tồn tại. Vui lòng chọn tên khác.";
                }
            } catch (SQLException e) {
                error_message = "Lỗi khi kiểm tra tên người dùng: " + e.getMessage();
            }
        }

        // Kiểm tra mã admin từ bảng Idadmin
        if (error_message == null && admin_code != null && !admin_code.trim().isEmpty()) {
            try {
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Idadmin WHERE id = ?");
                stmt.setString(1, admin_code);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    is_admin = 1; // Nếu mã tồn tại trong bảng, đặt is_admin là 1
                }
            } catch (SQLException e) {
                error_message = "Lỗi khi kiểm tra mã admin: " + e.getMessage();
            }
        }

        if (error_message == null) {
            // Tiến hành tạo tài khoản
            int current_id = 1;
            boolean existing_id = true;

            try {
                while (existing_id && conn != null) {
                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
                    stmt.setInt(1, current_id);
                    ResultSet row = stmt.executeQuery();

                    if (!row.next()) {
                        existing_id = false;
                    } else {
                        current_id++;
                    }
                }

                // Thêm tài khoản vào cơ sở dữ liệu
                String hashed_password = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt());
                PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO users (id, username, password, email, fullname, address, isadmin) VALUES (?, ?, ?, ?, ?, ?, ?)"
                );
                stmt.setInt(1, current_id);
                stmt.setString(2, username);
                stmt.setString(3, hashed_password);
                stmt.setString(4, email);
                stmt.setString(5, fullname);
                stmt.setString(6, address);
                stmt.setBoolean(7, is_admin == 1);
                stmt.executeUpdate();

                // Xóa mã admin khỏi bảng Idadmin nếu người dùng là admin
                if (is_admin == 1) {
                    try {
                        PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM Idadmin WHERE id = ?");
                        deleteStmt.setString(1, admin_code);
                        deleteStmt.executeUpdate();
                        System.out.println("Mã admin đã được xóa khỏi bảng Idadmin.");
                    } catch (SQLException e) {
                        error_message = "Lỗi khi xóa mã admin: " + e.getMessage();
                    }
                }

                // Chuyển hướng người dùng đến trang đăng nhập
                response.sendRedirect("Login.jsp");
                return;
            } catch (SQLException e) {
                error_message = "Lỗi khi tạo tài khoản: " + e.getMessage();
            }
        }
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Đăng ký tài khoản</title>
    <link rel="icon" type = "image/x-icon" href="logo.png">
    <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('styles/1.jpg');
            background-size: cover;
            margin: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .register-container {
            background: rgba(255, 255, 255, 0.85);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            width: 350px;
            text-align: center;
            margin: auto;
        }

        .register-container h2 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #333;
        }

        .register-container input[type="text"],
        .register-container input[type="password"],
        .register-container input[type="email"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .register-container button {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }

        .register-container button:hover {
            background-color: #218838;
        }

        .register-container p {
            margin-top: 20px;
            color: #333;
        }

        .register-container a {
            color: #007bff;
            text-decoration: none;
        }

        .register-container a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 10px;
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
        <ul>
            <li><a class="text-white" href="Hotro.jsp">Hỗ trợ</a></li>
        </ul>
    </nav>
</header>

<div class="main" style="text-align: center;">
    <div class="spacer"></div> <!-- Khoảng trống -->
    <div class="register-container">
        <h2>Đăng ký tài khoản mới</h2>

        <form method="post" action="Register.jsp">
            <input type="text" id="username" name="username" placeholder="Tên người dùng" required><br>
            <input type="password" id="password" name="password" placeholder="Mật khẩu" required><br>
            <input type="email" id="email" name="email" placeholder="Email" required><br>
            <input type="text" id="fullname" name="fullname" placeholder="Họ và tên" required><br>
            <input type="text" id="address" name="address" placeholder="Địa chỉ" required><br>
            <input type="text" id="admin_code" name="admin_code" placeholder="Mã Admin" ><br><br>
            <button type="submit" name="register">Đăng ký</button>
        </form>

        <p>Đã có tài khoản? <a href="Login.jsp">Đăng nhập</a></p>

        <%
            // Hiển thị thông báo lỗi ngoài form
            if (error_message != null && !error_message.isEmpty()) {
                out.println("<p class='error-message'>" + error_message + "</p>");
            }
        %>
    </div>
    <div class="spacer"></div> <!-- Khoảng trống -->
</div>
</body>
</html>

