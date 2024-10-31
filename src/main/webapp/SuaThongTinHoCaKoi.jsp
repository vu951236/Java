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

  <h1>Sửa Thông Tin Hồ Cá Koi</h1>
  <form action="SuaHoServlet" method="post" enctype="multipart/form-data">
    <label for="ho_suaname">Tên Hồ Cũ:</label>
    <input type="text" id="ho_suaname" name="ho_name" required>
    <br><br>

    <label for="new_ho_name">Tên Hồ Mới:</label>
    <input type="text" id="new_ho_name" name="new_ho_name">
    <br><br>

    <label for="ho_suamota">Mô Tả:</label>
    <textarea id="ho_suamota" name="ho_mota" rows="4" cols="50"></textarea>
    <br><br>

    <label for="ho_suaghichu">Ghi Chú:</label>
    <textarea id="ho_suaghichu" name="ho_ghichu" rows="4" cols="50"></textarea>
    <br><br>

    <label for="ho_sualoai">Loại Hồ:</label>
    <input type="text" id="ho_sualoai" name="ho_loai">
    <br><br>

    <label for="ho_suakichthuoc">Kích Thước:</label>
    <input type="text" id="ho_suakichthuoc" name="ho_kichthuoc">
    <br><br>

    <label for="ho_suanhungcayphu">Cây Phù Hợp:</label>
    <textarea  id="ho_suanhungcayphu" name="ho_nhungcayphu" rows="4" cols="50"></textarea>
    <br><br>

    <label for="ho_sualoaicaphuhop">Loại Cá Phù Hợp:</label>
    <textarea  id="ho_sualoaicaphuhop" name="ho_loaicaphuhop" rows="4" cols="50"></textarea>
    <br><br>

    <label for="ho_suaimage1">Hình Ảnh 1:</label>
    <input type="file" id="ho_suaimage1" name="ho_image1" accept="image/*">
    <br><br>

    <label for="ho_suaimage2">Hình Ảnh 2:</label>
    <input type="file" id="ho_suaimage2" name="ho_image2" accept="image/*">
    <br><br>

    <label for="ho_suaimage3">Hình Ảnh 3:</label>
    <input type="file" id="ho_suaimage3" name="ho_image3" accept="image/*">
    <br><br>

    <label for="ho_suaimage4">Hình Ảnh 4:</label>
    <input type="file" id="ho_suaimage4" name="ho_image4" accept="image/*">
    <br><br>

    <button type="submit">Cập Nhật Thông Tin</button>
  </form>

</div>
</body>
</html>
