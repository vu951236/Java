<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.mywebapp.Product" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin</title>
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
            <li><a class="text-white" href="QuanLiHoCa.jsp">Quản lí hồ</a></li>

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

<div id="notification"></div>
<%
    // Đọc thông tin cấu hình từ tệp properties
    Properties props = new Properties();
    try (InputStream input = application.getResourceAsStream("config.properties")) {
        if (input == null) {
            throw new IOException("Tệp cấu hình không tồn tại.");
        }
        props.load(input);
    }

    if (username != null) {
        // Nếu đã đăng nhập, thực hiện truy vấn cơ sở dữ liệu để lấy thông tin khách hàng
        String host = props.getProperty("db.host");
        String port = props.getProperty("db.port");
        String dbname = props.getProperty("db.name");
        String dbuser = props.getProperty("db.user");
        String dbpassword = props.getProperty("db.password");

        Connection conn = null;
        try {
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            // Tạo kết nối đến cơ sở dữ liệu PostgreSQL
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, dbuser, dbpassword);

            // Truy vấn cơ sở dữ liệu để lấy thông tin người dùng
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ?");
            stmt.setString(1, username);
            ResultSet user_info = stmt.executeQuery();

            if (user_info.next()) {
                // Hiển thị thông tin người dùng
                out.println("<div class=\"avt\" onclick=\"redirectToEditProfile()\">");

                // Kiểm tra xem avatar có null hay không
                String avatar = user_info.getString("avatar");
                if (avatar != null && !avatar.isEmpty()) {
                    out.println("<img src=\"" + avatar + "\" width=\"70px\" height=\"70px\">");
                } else {
                    out.println("<img src=\"default_avatar.jpg\" width=\"70px\" height=\"70px\">"); // Đường dẫn tới ảnh mặc định
                }

                out.println("<div class=\"thongtin\">");
                out.println("<div class=\"nickname\">" + user_info.getString("fullname") + "</div>");
                out.println("<div class=\"uid\" id=\"uidCopy\">Id: <span id=\"uidValue\">" + user_info.getInt("id") + "</span> <span class=\"copyIcon\" onclick=\"copyUID()\">📋 | </span></div>");
                out.println("<div class=\"server\">" + user_info.getString("email") + "</div>");
                out.println("</div>");
                out.println("</div>");

                // Thêm sự kiện click để chuyển hướng
                out.println("<script>");
                out.println("document.getElementById(\"personalInfo\").addEventListener(\"click\", redirectToEditProfile);");
                out.println("function redirectToEditProfile() {");
                out.println("window.location.href = \"Thongtinkhachhang.jsp\";"); // Chuyển hướng sang trang chỉnh sửa thông tin cá nhân
                out.println("}");
                out.println("</script>");
            } else {
                out.println("<div class=\"avt\">");
                out.println("<img src=\"default_avatar.jpg\" width=\"70px\" height=\"70px\">"); // Đường dẫn tới ảnh mặc định
                out.println("<div class=\"thongtin\">");
                out.println("<div class=\"nickname\">Tên</div>");
                out.println("<div class=\"idmacdinh\">Id:xxxxxx |</div>");
                out.println("<div class=\"emailmacdinh\">aaaaaa@gmail.com</div>");
                out.println("</div>");
                out.println("</div>");
            }
        } catch (SQLException | ClassNotFoundException e) {
            // In thông báo lỗi nếu kết nối thất bại hoặc truy vấn không thành công
            out.println("Lỗi: " + e.getMessage());
        } finally {
            // Đóng kết nối
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    out.println("Lỗi khi đóng kết nối: " + e.getMessage());
                }
            }
        }
    } else {
        // Nếu chưa đăng nhập, hiển thị thông tin mặc định
        out.println("<div class=\"avt\">");
        out.println("<img src=\"default_avatar.jpg\" width=\"70px\" height=\"70px\">"); // Đường dẫn tới ảnh mặc định
        out.println("<div class=\"thongtin\">");
        out.println("<div class=\"nickname\">Tên</div>");
        out.println("<div class=\"idmacdinh\">Id:xxxxxx |</div>");
        out.println("<div class=\"emailmacdinh\">aaaaaa@gmail.com</div>");
        out.println("</div>");
        out.println("</div>");
    }
%>

<%
    // Đọc thông tin cấu hình từ tệp properties
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

    List<Product> productsUnder50 = new ArrayList<>();
    List<Product> productsOver50 = new ArrayList<>();

    try {
        // Nạp driver PostgreSQL
        Class.forName("org.postgresql.Driver");

        // Kết nối đến cơ sở dữ liệu
        try (Connection conn = DriverManager.getConnection(url, dbuser, dbpassword)) {
            // Query for products under 50
            String sqlthongtinca = "SELECT * FROM thongtinca ORDER BY id ASC";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlthongtinca);
                 ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("id"));
                    product.setName(rs.getString("name"));
                    product.setghichu(rs.getString("ghichu"));
                    product.setImagePath("images/" + rs.getString("image_path1"));
                    productsUnder50.add(product);
                }
            }

            // Query for products over 50
            String sqlthongtinho = "SELECT * FROM thongtinho ORDER BY id ASC";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlthongtinho);
                 ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setId(rs.getInt("id"));
                    product.setName(rs.getString("name"));
                    product.setloai(rs.getString("loai"));
                    product.setImagePath("images/" + rs.getString("image_path1"));
                    productsOver50.add(product);
                }
            }
        }
    } catch (ClassNotFoundException e) {
        out.println("Lỗi: Driver PostgreSQL không được tìm thấy. " + e.getMessage());
    } catch (SQLException e) {
        out.println("Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
    }

    // Store product lists in request attributes
    request.setAttribute("productsUnder50", productsUnder50);
    request.setAttribute("productsOver50", productsOver50);
%>

<div class="toc">
    <a href="#Ca">Thông tin Cá</a><br/>
    <a href="#Ho">Thông tin Hồ</a><br/>
</div>

<div class="main">
    <h2 class="DPS">Thông tin Cá</h2>
    <div class="nhanvat" id="Ca">
        <%
            // Hiển thị danh sách sản phẩm dưới 50
            if (!productsUnder50.isEmpty()) {
                for (Product product : productsUnder50) {
        %>
        <div class="char2" onclick="showTooltip('<%= product.getghichu() %>', ['<%= product.getImagePath() %>'], 'tooltip<%= product.getId() %>')">
            <p><b><%= product.getName() %></b></p>
            <a onclick="updateSelectedProduct(<%= product.getId() %>)">
                <img src="<%= product.getImagePath() %>" class="avtchar" alt=""/>
            </a>
            <div class="tooltip" id="tooltip<%= product.getId() %>"></div>
        </div>
        <%
                }
            } else {
                out.println("Không tìm thấy sản phẩm.");
            }
        %>
    </div>
    <div class="chitiet">
        <a onclick="redirectToDetailPage()">Xem chi tiết<img src="block_more.f237bb12.png" class="block" alt=""/></a><br/>
    </div>

    <div class="spacer"></div> <!-- Khoảng trống -->

    <h2 class="DPS" >Thông tin Hồ</h2>
    <div class="nhanvat" id="Ho">
        <%
            // Hiển thị danh sách sản phẩm trên 50
            if (!productsOver50.isEmpty()) {
                for (Product product : productsOver50) {
        %>
        <div class="char2" onclick="showTooltip1('<%= product.getloai() %>', ['<%= product.getImagePath() %>'], 'tooltip<%= product.getId() +49%>')">
            <p><b><%= product.getName() %></b></p>
            <a onclick="updateSelectedProduct1(<%= product.getId() %>)">
                <img src="<%= product.getImagePath() %>" class="avtchar" alt=""/>
            </a>
            <div class="tooltip1" id="tooltip<%= product.getId() + 49%>"></div>
        </div>
        <%
                }
            } else {
                out.println("Không tìm thấy sản phẩm.");
            }
        %>
    </div>

    <div class="chitiet1">
        <a onclick="redirectToDetailPage1()">Xem chi tiết<img src="block_more.f237bb12.png" class="block" alt=""/></a><br/>
    </div>
</div>

<script>
    var selectedProductId;
    var selectedProductId1;

    // Function to update the selected product ID
    function updateSelectedProduct(productId) {
        selectedProductId = productId;
    }

    // Function to update the selected product ID
    function updateSelectedProduct1(productId1) {
        selectedProductId1 = productId1;
    }

    // Function to redirect to the detail page
    function redirectToDetailPage() {
        if (selectedProductId) {
            window.location.href = "Chitietca.jsp?id=" + encodeURIComponent(selectedProductId);
        } else {
            alert("Vui lòng chọn một sản phẩm để xem chi tiết.");
        }
    }

    // Function to redirect to the detail page
    function redirectToDetailPage1() {
        if (selectedProductId1) {
            window.location.href = "Chitietho.jsp?id=" + encodeURIComponent(selectedProductId1);
        } else {
            alert("Vui lòng chọn một sản phẩm để xem chi tiết.");
        }
    }

</script>

<%@ page import="java.sql.*, org.json.*" %>
<%
    // Prepare to return JSON data
    JSONArray jsonArray = new JSONArray();
    try (Connection conn = DriverManager.getConnection(url, dbuser, dbpassword);
         Statement stmt = conn.createStatement()) {

        // Truy vấn dữ liệu từ bảng thongtinca
        String sql1 = "SELECT * FROM thongtinca WHERE id = 1";
        ResultSet rs = stmt.executeQuery(sql1);

        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("id", rs.getInt("id"));
            jsonObject.put("name", rs.getString("name"));
            jsonObject.put("ghichu", rs.getString("ghichu"));
            jsonObject.put("image_path1", "images/" + rs.getString("image_path1"));
            jsonArray.put(jsonObject);
        }

        // Truy vấn dữ liệu từ bảng thongtinho
        String sql2 = "SELECT * FROM thongtinho WHERE id = 1";
        rs = stmt.executeQuery(sql2);

        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("id", rs.getObject("id") != null ? rs.getInt("id") + 49 : 49);
            jsonObject.put("name", rs.getString("name"));
            jsonObject.put("loai", rs.getString("loai"));
            jsonObject.put("image_path1", "images/" + rs.getString("image_path1"));
            jsonArray.put(jsonObject);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Trả về dữ liệu dưới dạng JSON an toàn
    String jsonData = jsonArray.toString();
%>

<div id="jsonData" data-json='<%= jsonData.replace("'", "&apos;") %>'></div>

<script src="styles/Trangchu.js"></script>
<script src="styles/Sanpham.js"></script>
<script>
    window.onload = function() {
        selectedProductId = <%= productsUnder50.get(0).getId() %>;
        selectedProductId1 = <%= productsOver50.get(0).getId() %>;
    };
</script>
</body>
</html>
