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

  <h2>Xóa thông tin Thuốc điều chỉnh Nước</h2>
  <form action="XoaThuocNuocServlet" method="post">
    <label for="old_name_xoatnc">Tên thuốc cần xóa:</label>
    <input type="text" id="old_name_xoatnc" name="old_name" required><br><br>

    <input type="submit" value="Xóa Thuốc Điều Chỉnh Nước">
  </form>

</div>
</body>
</html>
