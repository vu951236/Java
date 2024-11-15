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
            <li><a href="Thongtin.jsp" >Thông tin</a></li>
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
                        String sql = "SELECT * FROM thongtinca WHERE id = ?";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, Integer.parseInt(productId));
                        ResultSet rs = stmt.executeQuery();

                        if (rs.next()) {
                            boolean firstBannerShown = false;
                            boolean hasImages = false;

                            out.println("<div id='banner-wrapper'>");
                            for (int i = 1; i <= 4; i++) {
                                String imageColumn = "image_path" + i;
                                String imageFileName = rs.getString(imageColumn);
                                if (imageFileName != null && !imageFileName.trim().isEmpty()) {
                                    hasImages = true;
                                    String imageSrc = "images/" + imageFileName;
                                    String displayStyle = firstBannerShown ? "display: none;" : "display: block;";
                                    out.println("<div class='banner-container' style='" + displayStyle + "'>");
                                    out.println("<img src='" + imageSrc + "' class='banner-img' alt='Banner Image " + i + "'>");
                                    out.println("<div class='arrow left-arrow' onclick='prevImagethongtin()'>&#10094;</div>");
                                    out.println("<div class='arrow right-arrow' onclick='nextImagethongtin()'>&#10095;</div>");
                                    out.println("</div>");
                                    firstBannerShown = true;
                                }
                            }
                            out.println("</div>");

                            if (!hasImages) {
                                out.println("Không có hình ảnh cho sản phẩm này.");
                            }

                            out.println("<h2 class='product-title'>" + rs.getString("name") + "</h2>");
                            out.println("<div class='product-info'>");
                            out.println("<div><strong>Khái niệm:</strong> " + rs.getString("khainiem") + "</div>");
                            out.println("<div><strong>Đặc điểm sinh học:</strong> " + rs.getString("dacdiem") + "</div>");
                            out.println("<div><strong>Dinh dưỡng:</strong> " + rs.getString("dinhduong") + "</div>");
                            out.println("<div><strong>Phân loại:</strong> " + rs.getString("phanloai") + "</div>");
                            out.println("<div><strong>Phân biệt:</strong> " + rs.getString("phanbiet") + "</div>");
                            out.println("</div>");
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
