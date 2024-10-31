<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
    <link rel="icon" type="image/x-icon" href="logo.png">
</head>
<body>
<header>
    <div class="header-content">
        <img src="logo.png" alt="Cá Koi" class="img_header-thongtin">
        <h2><a href="index.jsp" class="home-link">Trang chủ</a></h2>
    </div>
    <nav>
        <ul>
            <li><a href="admin.jsp">Quản trị</a></li>
            <li><a href="Logout.jsp">Đăng xuất</a></li>
        </ul>
    </nav>
</header>
<div class="main">
    <h2>Danh sách Người dùng</h2>
    <table border="1">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên người dùng</th>
            <th>Email</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <%
            Properties props = new Properties();
            InputStream input = application.getResourceAsStream("config.properties");
            props.load(input);

            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String dbuser = props.getProperty("db.user");
            String dbpassword = props.getProperty("db.password");

            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("org.postgresql.Driver");
                String dsn = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
                conn = DriverManager.getConnection(dsn, dbuser, dbpassword);

                // Truy vấn thông tin người dùng không phải admin
                String sql = "SELECT id, username, email, banned_until FROM users WHERE isadmin = false";
                stmt = conn.createStatement();
                rs = stmt.executeQuery(sql);

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String username = rs.getString("username");
                    String email = rs.getString("email");
                    Timestamp bannedUntil = rs.getTimestamp("banned_until");
                    String status = (bannedUntil != null && bannedUntil.after(new java.util.Date())) ? "Đang bị cấm đến " + bannedUntil : "Hoạt động";
        %>
        <tr>
            <td><%= id %></td>
            <td><%= username %></td>
            <td><%= email %></td>
            <td><%= status %></td>
            <td>
                <form action="BanUserServlet" method="post">
                    <input type="hidden" name="user_id" value="<%= id %>">
                    <% if (bannedUntil == null || bannedUntil.before(new java.util.Date())) { %>
                    <label for="ban_duration">Thời gian cấm (phút):</label>
                    <input id = "ban_duration" type="number" name="ban_duration" required>
                    <input type="submit" value="Cấm" name="submit">
                    <% } else { %>
                    <input type="submit" value="Dừng cấm" name="submit">
                    <% } %>
                </form>
                <form action="DeleteUserServlet" method="post">
                    <input type="hidden" name="user_id" value="<%= id %>">
                    <input type="submit" value="Xóa" name="submit">
                </form>
            </td>
        </tr>
        <%
                }
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace(); // Ghi lỗi ra console
            } finally {
                // Đóng kết nối và các tài nguyên
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace(); // Ghi lỗi ra console
                }
            }
        %>
        </tbody>
    </table>

</div>
</body>
</html>
