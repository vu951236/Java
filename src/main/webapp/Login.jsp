<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<%
    // Bắt đầu session
    HttpSession currentSession = request.getSession();

    // Đọc thông tin cấu hình từ file config.properties
    Properties props = new Properties();
    InputStream input = application.getResourceAsStream("config.properties");

    String error_message = ""; // Biến lưu trữ thông báo lỗi
    Connection conn = null;

    if (input == null) {
        error_message = "Không thể tìm thấy file config.properties";
    } else {
        try {
            props.load(input);

            // Lấy thông tin kết nối từ file config.properties
            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String dbuser = props.getProperty("db.user");
            String dbpassword = props.getProperty("db.password");

            // Kết nối đến cơ sở dữ liệu
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, dbuser, dbpassword);
            System.out.println("Kết nối đến cơ sở dữ liệu thành công.");
        } catch (Exception e) {
            error_message = "Kết nối đến cơ sở dữ liệu PostgreSQL thất bại: " + e.getMessage();
            e.printStackTrace(); // Log the exception for debugging
        } finally {
            if (input != null) {
                input.close(); // Đảm bảo đóng InputStream
            }
        }
    }

    // Xử lý đăng nhập
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("username") != null && request.getParameter("password") != null) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Debugging output
        System.out.println("Trying to find user: " + username);

        // Kiểm tra xem tài khoản có tồn tại trong cơ sở dữ liệu không
        try {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ?");
            stmt.setString(1, username);
            ResultSet row = stmt.executeQuery();

            if (row.next()) {
                System.out.println("User found: " + row.getString("username")); // Log user found

                // Kiểm tra thời gian cấm
                Timestamp bannerUntil = row.getTimestamp("banned_until");
                if (bannerUntil != null && bannerUntil.after(new Timestamp(System.currentTimeMillis()))) {
                    error_message = "Bạn đã bị cấm cho đến " + bannerUntil.toString() + ".";
                } else {
                    // Kiểm tra mật khẩu
                    if (BCrypt.checkpw(password, row.getString("password"))) {
                        // Đăng nhập thành công
                        currentSession.setAttribute("username", username);
                        currentSession.setAttribute("user_id", row.getInt("id")); // Thêm ID vào session
                        currentSession.setAttribute("isadmin", row.getBoolean("isadmin"));
                        response.sendRedirect("Thongtin.jsp");
                        return;
                    } else {
                        error_message = "Sai mật khẩu. Vui lòng thử lại.";
                    }
                }
            } else {
                error_message = "Tài khoản không tồn tại.";
                System.out.println("No user found for: " + username); // Log if user not found
            }
        } catch (SQLException e) {
            error_message = "Lỗi khi thực hiện truy vấn: " + e.getMessage();
            e.printStackTrace(); // Log the exception for debugging
        } finally {
            // Đảm bảo đóng kết nối nếu có
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace(); // Log the exception (optional)
            }
        }
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Đăng nhập</title>
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

        .login-container {
            background: rgba(255, 255, 255, 0.85);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            width: 350px;
            text-align: center;
            margin: auto;
        }

        .login-container h2 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #333;
        }

        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .login-container button {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }

        .login-container button:hover {
            background-color: #218838;
        }

        .login-container p {
            margin-top: 20px;
            color: #333;
        }

        .login-container a {
            color: #007bff;
            text-decoration: none;
        }

        .login-container a:hover {
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
    <div class="login-container" style="text-align: center;">
        <h2>Đăng nhập</h2>
        <form id="loginForm" action="Login.jsp" method="post">
            <input type="text" id="username" name="username" placeholder="Tên người dùng" required><br>
            <input type="password" id="password" name="password" placeholder="Mật khẩu" required><br>
            <button id="login" name="login" type="submit">Đăng nhập</button>
        </form>
        <%
            // Hiển thị thông báo lỗi nếu có
            if (error_message != null && !error_message.isEmpty()) {
                out.println("<p class='error-message'>" + error_message + "</p>");
            }
        %>
        <p>Bạn chưa có tài khoản? <a href="Register.jsp">Đăng ký tại đây</a></p>
        <p>Bạn quên mật khẩu? <a href="ForgotPassword.jsp">Đặt lại tại đây</a></p>
    </div>
    <div class="spacer"></div> <!-- Khoảng trống -->
</div>
</body>
</html>
