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
    <link rel="icon" type = "image/x-icon" href="logo.png">
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
            <li><a class="text-white" href="admin.jsp">Quản trị</a></li>
            <li><a href="Hotro.html">Hỗ trợ</a></li>
            <li><a class="text-white" href="Sanpham.jsp">Sản phẩm</a></li>
            <li><a class="text-white" href="Thongtin.jsp">Thông tin</a></li>
        </ul>
    </nav>
</header>
<div class="main">
<h2>Danh sách Đơn hàng</h2>
<table border="1">
    <thead>
    <tr>
        <th>ID Đơn hàng</th>
        <th>Tên Khách hàng</th>
        <th>Sản phẩm</th>
        <th>Số lượng</th>
        <th>Giá</th>
        <th>Ngày Đặt hàng</th>
        <th>Trạng thái</th>
        <th>Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <%
        // Kết nối cơ sở dữ liệu
        Properties props = new Properties();
        InputStream input = application.getResourceAsStream("config.properties");
        props.load(input);

        String host = props.getProperty("db.host");
        String port = props.getProperty("db.port");
        String dbname = props.getProperty("db.name");
        String dbuser = props.getProperty("db.user");
        String dbpassword = props.getProperty("db.password");

        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            String dsn = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            conn = DriverManager.getConnection(dsn, dbuser, dbpassword);

            // Truy vấn thông tin đơn hàng với JOIN để lấy tên khách hàng
            String sql = "SELECT donhang.id, users.username AS customer_name, donhang.sanpham, donhang.soluong, donhang.price, donhang.thoigian, donhang.trangthai " +
                    "FROM donhang " +
                    "JOIN users ON donhang.id_user = users.id " +
                    "WHERE donhang.trangthai != 'Đã hoàn thành'";

            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                int id = rs.getInt("id");
                String customerName = rs.getString("customer_name");
                String sanpham = rs.getString("sanpham");
                int soluong = rs.getInt("soluong");
                int gia = rs.getInt("price");
                Date orderDate = rs.getDate("thoigian");
                String status = rs.getString("trangthai");
    %>
    <tr>
        <td><%= id %></td>
        <td><%= customerName %></td>
        <td><%= sanpham %></td>
        <td><%= soluong %></td>
        <td><%= gia %></td>
        <td><%= orderDate %></td>
        <td><%= status %></td>
        <td>
            <form action="UpdateOrderServlet" method="post">
                <input type="hidden" name="order_id" value="<%= id %>">
                <% if (!"Đã hoàn thành".equals(status)) { %>
                <%
                    if ("Đang giao hàng".equals(status)) {
                %>
                <input type="submit" value="Hoàn thành" name="submit">
                <%
                } else {
                %>
                <input type="submit" value="Giao hàng" name="submit">
                <%
                    }
                %>
                <% } else { %>
                <!-- Đơn hàng đã hoàn thành, không hiển thị nút -->
                <span>Hoàn thành</span>
                <% } %>
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

