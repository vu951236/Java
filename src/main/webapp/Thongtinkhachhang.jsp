<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.Properties" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.StandardCopyOption" %>
<%@ page import="java.io.FileOutputStream" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Chỉnh sửa thông tin cá nhân</title>
  <link rel="stylesheet" type="text/css" href="styles/profile.css">
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
      <li><a class="text-white" href="Sanpham.jsp">Sản phẩm</a></li>
      <li><a class="text-white" href="Thongtin.jsp">Thông tin</a></li>
      <li><a href="Hotro.html">Hỗ trợ</a></li>
    </ul>
  </nav>
</header>

<%
  if (username == null) {
    response.sendRedirect("Login.jsp");
    return;
  }

  String fullname = null;
  String email = null;
  String address = null;
  String avatar = null;
  ResultSet userInfo = null;
  int userId = 0;

  try {
    String query = "SELECT * FROM users WHERE username = ?";
    PreparedStatement stmt = conn.prepareStatement(query);
    stmt.setString(1, username);
    userInfo = stmt.executeQuery();

    if (!userInfo.next()) {
      out.println("Không tìm thấy thông tin cá nhân.");
      return;
    }

    // Lưu trữ thông tin người dùng
    fullname = userInfo.getString("fullname");
    email = userInfo.getString("email");
    avatar = userInfo.getString("avatar");
    address = userInfo.getString("address");
    userId = userInfo.getInt("id"); // Lấy ID người dùng

  } catch (SQLException e) {
    out.println("Lỗi: " + e.getMessage());
  }
%>


<div class="main">
  <h2>Thông tin cá nhân</h2>
  <p><strong>Full Name:</strong> <%=fullname%></p>
  <p><strong>Username:</strong> <%=username%></p>
  <p><strong>Email:</strong> <%=email%></p>
  <p><strong>Address:</strong> <%=address%></p>
  <p><img src="<%=avatar != null ? avatar : "default_avatar.jpg"%>" width="70px" alt="Avatar"></p>

  <h2>Chỉnh sửa thông tin cá nhân</h2>
  <form method="post" action="UserProfileServlet" enctype="multipart/form-data">
    <input type="hidden" name="userId" value="<%=userId%>">
    <label for="avatar">Chọn ảnh đại diện:</label>
    <input type="file" name="avatar" id="avatar"><br><br>
    <label for="email">Email:</label>
    <input type="email" name="email" id="email" value="<%=email%>"><br><br>
    <label for="password">Password:</label>
    <input type="password" name="password" id="password"><br><br>
    <label for="address">Address:</label>
    <input type="text" name="address" id="address" value="<%=address%>"><br><br>
    <input type="submit" value="Cập nhật thông tin">
  </form>

  <h2>Lịch sử mua hàng</h2>
  <%
    // Lịch sử mua hàng (trong khối try-catch)
    try {
      if (userInfo != null && isAdmin != 1) {
        PreparedStatement historyStmt = conn.prepareStatement("SELECT sanpham, soluong, thoigian, price, trangthai FROM donhang WHERE id_user = ?");
        historyStmt.setInt(1, userId);
        ResultSet history = historyStmt.executeQuery();

        out.println("<table border='1'>");
        out.println("<tr><th>Tên sản phẩm</th><th>Số lượng</th><th>Giá</th><th>Thời gian</th><th>Trạng thái</th></tr>");

        while (history.next()) {
          out.println("<tr>");
          out.println("<td>" + history.getString("sanpham") + "</td>");
          out.println("<td>" + history.getInt("soluong") + "</td>");
          out.println("<td>" + history.getDouble("price") + "</td>");
          out.println("<td>" + history.getTimestamp("thoigian") + "</td>");
          out.println("<td>" + history.getString("trangthai") + "</td>");
          out.println("</tr>");
        }
        out.println("</table>");
      }
    } catch (SQLException e) {
      out.println("Lỗi khi lấy lịch sử mua hàng: " + e.getMessage());
    }
  %>
</div>

<%
  // Đóng kết nối ở cuối trang
  if (conn != null) {
    try {
      conn.close();
    } catch (SQLException e) {
      out.println("Lỗi khi đóng kết nối: " + e.getMessage());
    }
  }
%>
</body>
</html>
