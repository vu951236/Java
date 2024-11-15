<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Trang chi tiết</title>
    <link rel="icon" type = "image/x-icon" href="logo.png">
    <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
    <link rel="stylesheet" type="text/css" href="styles/product_detail.css">
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
                String username = (String) session.getAttribute("username");
                Boolean isAdmin = (Boolean) session.getAttribute("isadmin");

                if (username != null) {
                    if (isAdmin != null && isAdmin) {
            %>
            <li><a class="text-white" href="admin.jsp">Quản trị</a></li>
            <%
                }
            %>
            <li><a class="text-white" href="Logout.jsp">Đăng xuất</a></li>
            <%
                // If the user is not an admin
                if (isAdmin == null || !isAdmin) {
            %>

            <%
                }
            } else {
            %>
            <li><a class="text-white" href="Login.jsp">Đăng nhập</a></li>
            <%
                }
            %>
            <li><a class="text-white" href="Sanpham.jsp">Sản phẩm</a></li>
            <li><a class="text-white" href="Hotro.jsp">Hỗ trợ</a></li>
        </ul>
    </nav>
</header>

<div style="text-align: center;">
    <div class="main">
        <h1 class="DPS" id="Chitiet">Chi tiết</h1>
        <div class="product-details">
            <%
                String productId = request.getParameter("id");
                if (productId != null) {
                    Connection conn = null;
                    try {
                        // Đọc thông tin cấu hình từ tệp properties
                        Properties props = new Properties();
                        try (InputStream input = application.getResourceAsStream("config.properties")) {
                            if (input == null) {
                                throw new IOException("Tệp cấu hình không tồn tại.");
                            }
                            props.load(input);
                        }

                        // Lấy thông tin kết nối cơ sở dữ liệu từ tệp cấu hình
                        String host = props.getProperty("db.host");
                        String port = props.getProperty("db.port");
                        String dbname = props.getProperty("db.name");
                        String dbuser = props.getProperty("db.user");
                        String dbpassword = props.getProperty("db.password");
                        String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;

                        Class.forName("org.postgresql.Driver");
                        conn = DriverManager.getConnection(url, dbuser, dbpassword);

                        // Truy vấn chi tiết sản phẩm
                        String sql = "SELECT * FROM productsnuoc WHERE id = ?";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, Integer.parseInt(productId));
                        ResultSet rs = stmt.executeQuery();

                        if (rs.next()) {
                            boolean hasImage = false;

                            out.println("<div id='banner-wrapper'>");

                            // Lấy cột image_path để hiển thị hình ảnh
                            String imageFileName = rs.getString("image_path");
                            if (imageFileName != null && !imageFileName.trim().isEmpty()) {
                                hasImage = true;
                                String imageSrc = "images/" + imageFileName;
                                out.println("<div class='banner-container'>");
                                out.println("<img src='" + imageSrc + "' class='banner-img' alt='Product Image'>");
                                out.println("</div>");
                            }
                            out.println("</div>");

                            if (!hasImage) {
                                out.println("Không có hình ảnh cho sản phẩm này.");
                            }

                            // Hiển thị thông tin sản phẩm
                            out.println("<h2 class='product-title'>" + rs.getString("name") + "</h2>");
                            out.println("<div class='product-info'>");
                            out.println("<div><strong>Ghi chú:</strong> " + rs.getString("ghichu") + "</div>");
                            out.println("<div><strong>Hạn sử dụng:</strong> " + rs.getString("hansudung") + "</div>");
                            out.println("<div><strong>Số lượng có sẵn:</strong> " + rs.getInt("soluong") + "</div>");
                            out.println("<div><strong>Giá:</strong> " + rs.getDouble("price") + "</div>");
                            out.println("</div>");

                            // Kiểm tra nếu người dùng đã đăng nhập và không phải là admin
                            String username1 = (String) session.getAttribute("username"); // Giả sử bạn lưu thông tin người dùng trong session
                            boolean isAdmin1 = (session.getAttribute("isadmin") != null && (boolean) session.getAttribute("isadmin"));

                            if (username1 != null && !isAdmin1) { // Nếu người dùng đã đăng nhập và không phải là admin
                                out.println("<div class='purchase-section'>");
                                out.println("<form method='post' action='PurchasenuocServlet'>"); // Truyền form tới servlet xử lý việc mua hàng
                                out.println("<label for='quantity'>Nhập số lượng mua:</label>");
                                out.println("<input type='number' id='quantity' name='quantity' min='1' max='" + rs.getInt("soluong") + "' required>");
                                out.println("<input type='hidden' name='productId' value='" + productId + "'>"); // Truyền ID sản phẩm
                                out.println("<button id='buyNowButton' type='submit' class='buy-button'>Mua ngay</button>");
                                out.println("</form>");
                                out.println("</div>");
                            }

                        } else {
                            out.println("Không tìm thấy sản phẩm.");
                        }
                    } catch (Exception e) {
                        out.println("Lỗi: " + e.getMessage());
                    } finally {
                        if (conn != null) {
                            try {
                                conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                } else {
                    out.println("Không tìm thấy ID sản phẩm.");
                }
            %>
        </div>
    </div>
</div>
<script src="styles/Sanpham.js"></script>
<script src="styles/Trangchu.js"></script>
</body>
</html>
