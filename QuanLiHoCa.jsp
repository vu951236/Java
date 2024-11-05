<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý hồ cá</title>
    <link rel="stylesheet" type="text/css" href="styles/quanliho.css">
    <link rel="stylesheet" type="text/css" href="styles/Trangchu.css">
    <link rel="stylesheet" type="text/css" href="styles/index.css">
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
                String username = (String) session.getAttribute("username");
                Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

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
<div id="notification"></div>
<div class="main">

<h2>Quản lý hồ cá của bạn</h2>

    <%
        boolean hasHoCa = false;
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Đọc thông tin cấu hình từ file config.properties
        Properties props = new Properties();
        InputStream input = application.getResourceAsStream("config.properties");

        String deleteQuery = "DELETE FROM gio_hang";

        try {
            // Kiểm tra xem InputStream có null không
            if (input == null) {
                throw new FileNotFoundException("Không thể tìm thấy file config.properties");
            }

            // Tải thông tin cấu hình từ file
            props.load(input);

            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String user = props.getProperty("db.user");
            String password = props.getProperty("db.password");

            // Kết nối đến cơ sở dữ liệu PostgreSQL
            try (Connection conn = DriverManager.getConnection("jdbc:postgresql://" + host + ":" + port + "/" + dbname, user, password);
                 PreparedStatement stmt = conn.prepareStatement("SELECT * FROM hocacanhan WHERE user_id = ?")) {

                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    hasHoCa = true;
                    int hoLength = rs.getInt("ho_length");
                    int hoWidth = rs.getInt("ho_width");
                    int hoHeight = rs.getInt("ho_height");
                    int fishCount = rs.getInt("fish_count");

                    request.setAttribute("hoCaName", rs.getString("ho_name"));
                    request.setAttribute("hoLength", hoLength);
                    request.setAttribute("hoWidth", hoWidth);
                    request.setAttribute("hoHeight", hoHeight);
                    request.setAttribute("fishCount", fishCount);
                    request.setAttribute("plantCount", rs.getInt("plant_count"));
                    request.setAttribute("hoImage", rs.getString("ho_image"));

                    // Tính thể tích nước (cm^3 -> lít)
                    double waterVolume = (hoLength * hoWidth * hoHeight) / 1000.0;  // đổi từ cm^3 sang lít

                    // Tính lượng oxy cần thiết (mg)
                    double oxygenNeeded = waterVolume * 5;  // ví dụ 18 mg O2/lít cho mỗi con cá

                    // Tính số lượng cá tối đa (giả sử mỗi con cá cần 100 lít nước)
                    int maxFishCount = (int) (waterVolume / 100);

                    // Mực nước cần thiết (cm)
                    double requiredWaterLevel = (double) (fishCount * 100 * 1000) / (hoLength * hoWidth); // cm

                    // Giả sử công suất bơm oxy (mg/phút)
                    double pumpCapacity = 50; // ví dụ: bơm 50 mg O2/phút
                    // Thời gian cần thiết để bơm đủ oxy (phút)
                    double pumpTime = oxygenNeeded / pumpCapacity;

                    // Đưa ra lời khuyên nếu số lượng cá lớn hơn khả năng của hồ
                    String advice = "";
                    if (fishCount > maxFishCount) {
                        advice = "Số lượng cá quá lớn. Bạn nên giảm số cá hoặc xây dựng hồ lớn hơn.";
                    } else if (fishCount < maxFishCount) {
                        advice = "Hồ có thể chứa thêm cá.";
                    } else {
                        advice = "Số lượng cá hiện tại phù hợp với kích thước hồ.";
                    }

                    request.setAttribute("waterVolume", waterVolume);
                    request.setAttribute("oxygenNeeded", oxygenNeeded);
                    request.setAttribute("maxFishCount", maxFishCount);
                    request.setAttribute("requiredWaterLevel", requiredWaterLevel);
                    request.setAttribute("pumpTime", pumpTime);
                    request.setAttribute("advice", advice);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (IOException e) {
            e.printStackTrace(); // Xử lý lỗi khi đọc file
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Đảm bảo đóng InputStream nếu có
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace(); // Log lỗi đóng InputStream
                }
            }
        }

        if (hasHoCa) {
    %>
    <h3>Thông tin hồ cá hiện tại</h3>
    <img src="<%= request.getAttribute("hoImage") %>" alt=""/>
    <p>Tên hồ: <%= request.getAttribute("hoCaName") %></p>
    <p>Kích thước: <%= request.getAttribute("hoLength") %> x <%= request.getAttribute("hoWidth") %> x <%= request.getAttribute("hoHeight") %> cm</p>
    <p>Số lượng cá: <%= request.getAttribute("fishCount") %> con</p>
    <p>Số lượng cây cảnh: <%= request.getAttribute("plantCount") %> cây</p>

    <h3>Thông tin chi tiết</h3>
    <p>Thể tích nước: <%= request.getAttribute("waterVolume") %> lít</p>
    <p>Lượng oxy cần thiết: <%= request.getAttribute("oxygenNeeded") %> mg</p>
    <p>Số lượng cá tối đa có thể chứa: <%= request.getAttribute("maxFishCount") %> con</p>
    <p>Mực nước cần thiết: <%= request.getAttribute("requiredWaterLevel") %> cm</p>
    <p>Thời gian cần thiết để bơm đủ oxy: <%= request.getAttribute("pumpTime") %> phút</p>
    <p><strong>Lời khuyên:</strong> <%= request.getAttribute("advice") %></p>
    <h3>Sửa thông tin hồ cá</h3>
    <form action="SuaHoCa" method="post" enctype="multipart/form-data">
        <label for="hoName">Tên hồ:</label>
        <input type="text" id="hoNamemoi" name="hoName" value="<%= request.getParameter("hoName") != null ? request.getParameter("hoName") : "" %>" required><br>

        <label for="hoLength">Chiều dài (cm):</label>
        <input type="number" id="hoLengthmoi" name="hoLength" value="<%= request.getParameter("hoLength") != null ? request.getParameter("hoLength") : "" %>" required><br>

        <label for="hoWidth">Chiều rộng (cm):</label>
        <input type="number" id="hoWidthmoi" name="hoWidth" value="<%= request.getParameter("hoWidth") != null ? request.getParameter("hoWidth") : "" %>" required><br>

        <label for="hoHeight">Chiều cao (cm):</label>
        <input type="number" id="hoHeightmoi" name="hoHeight" value="<%= request.getParameter("hoHeight") != null ? request.getParameter("hoHeight") : "" %>" required><br>

        <label for="fishCount">Số lượng cá:</label>
        <input type="number" id="fishCountmoi" name="fishCount" value="<%= request.getParameter("fishCount") != null ? request.getParameter("fishCount") : "" %>" required><br>

        <label for="plantCount">Số lượng cây cảnh:</label>
        <input type="number" id="plantCountmoi" name="plantCount" value="<%= request.getParameter("plantCount") != null ? request.getParameter("plantCount") : "" %>" required><br>

        <label for="hoImage">Hình ảnh hồ cá:</label>
        <input type="file" id="hoImagemoi" name="hoImage" accept="image/*" required><br>

        <button type="submit" name="action" value="luuthongtin">Lưu thông tin hồ cá</button>
    </form>
    <h3>Kiểm tra thông số nước</h3>
    <form id="waterParametersForm">
        <label for="temperature">Nhiệt độ (°C):</label>
        <input type="number" id="temperature" name="temperature" step="0.1" required><br>

        <label for="salinity">Muối (g/l):</label>
        <input type="number" id="salinity" name="salinity" step="0.1" required><br>

        <label for="ph">pH:</label>
        <input type="number" id="ph" name="ph" step="0.1" required><br>

        <label for="oxygen">O₂ (mg/l):</label>
        <input type="number" id="oxygen" name="oxygen" step="0.1" required><br>

        <label for="nitrite">NO₂ (mg/l):</label>
        <input type="number" id="nitrite" name="nitrite" step="0.1" required><br>

        <label for="nitrate">NO₃ (mg/l):</label>
        <input type="number" id="nitrate" name="nitrate" step="0.1" required><br>

        <label for="phosphate">PO₄ (mg/l):</label>
        <input type="number" id="phosphate" name="phosphate" step="0.1" required><br>

        <button type="submit" onclick="checkWaterParameters(event)">Kiểm tra</button>
    </form>

    <div id="waterQualityNotification"></div>

    <h3>Tính Lượng Thức Ăn</h3>
    <br>

    <label for="youngQuantity">Số lượng cá con:</label>
    <input type="number" id="youngQuantity" min="0" value="0" required>
    <br>

    <label for="juvenileQuantity">Số lượng cá giống:</label>
    <input type="number" id="juvenileQuantity" min="0" value="0" required>
    <br>

    <label for="adultQuantity">Số lượng cá trưởng thành:</label>
    <input type="number" id="adultQuantity" min="0" value="0" required>
    <br>

    <button type="button" onclick="calculateFood()">Tính Lượng Thức Ăn</button>

    <div id="foodNotification"></div>


    <h3>Tính Lượng Muối</h3>
    <label for="tankVolume">Thể tích hồ (lít):</label>
    <input type="number" id="tankVolume" required>
    <br>
    <button type="button" onclick="calculateSalt()">Tính Lượng Muối</button>

    <div id="saltNotification"></div>

    <%
} else {
%>
<h3>Thêm thông tin hồ cá mới</h3>
<form action="SaveHoCa" method="post" enctype="multipart/form-data">
    <label for="hoName">Tên hồ:</label>
    <input type="text" id="hoName" name="hoName" value="<%= request.getParameter("hoName") != null ? request.getParameter("hoName") : "" %>" required><br>

    <label for="hoLength">Chiều dài (cm):</label>
    <input type="number" id="hoLength" name="hoLength" value="<%= request.getParameter("hoLength") != null ? request.getParameter("hoLength") : "" %>" required><br>

    <label for="hoWidth">Chiều rộng (cm):</label>
    <input type="number" id="hoWidth" name="hoWidth" value="<%= request.getParameter("hoWidth") != null ? request.getParameter("hoWidth") : "" %>" required><br>

    <label for="hoHeight">Chiều cao (cm):</label>
    <input type="number" id="hoHeight" name="hoHeight" value="<%= request.getParameter("hoHeight") != null ? request.getParameter("hoHeight") : "" %>" required><br>

    <label for="fishCount">Số lượng cá:</label>
    <input type="number" id="fishCount" name="fishCount" value="<%= request.getParameter("fishCount") != null ? request.getParameter("fishCount") : "" %>" required><br>

    <label for="plantCount">Số lượng cây cảnh:</label>
    <input type="number" id="plantCount" name="plantCount" value="<%= request.getParameter("plantCount") != null ? request.getParameter("plantCount") : "" %>" required><br>

    <label for="hoImage">Hình ảnh hồ cá:</label>
    <input type="file" id="hoImage" name="hoImage" accept="image/*" required><br>

    <button type="submit" name="action" value="luuthongtin">Lưu thông tin hồ cá</button>
</form>

<%
    }
%>
</div>

<script>
    function checkWaterParameters(event) {

        event.preventDefault(); // Ngăn chặn trang tải lại

        const temperature = parseFloat(document.getElementById('temperature').value);
        const salinity = parseFloat(document.getElementById('salinity').value);
        const ph = parseFloat(document.getElementById('ph').value);
        const oxygen = parseFloat(document.getElementById('oxygen').value);
        const nitrite = parseFloat(document.getElementById('nitrite').value);
        const nitrate = parseFloat(document.getElementById('nitrate').value);
        const phosphate = parseFloat(document.getElementById('phosphate').value);

        let message = "Các thông số nước không đạt chuẩn:\n";
        let hasIssues = false;

        // Kiểm tra các thông số theo tiêu chuẩn
        if (temperature < 22 || temperature > 28) {
            message += "- Nhiệt độ nên từ 22°C đến 28°C.\n";
            hasIssues = true;
        }
        if (salinity < 0.5 || salinity > 2.0) {
            message += "- Nồng độ muối nên từ 0.5 g/l đến 2.0 g/l.\n";
            hasIssues = true;
        }
        if (ph < 6.5 || ph > 7.5) {
            message += "- pH nên từ 6.5 đến 7.5.\n";
            hasIssues = true;
        }
        if (oxygen < 5 || oxygen > 18) {
            message += "- Lượng O₂ nên từ 5 mg/l đến 18 mg/l.\n";
            hasIssues = true;
        }
        if (nitrite > 0.5) {
            message += "- Nồng độ NO₂ không nên vượt quá 0.5 mg/l.\n";
            hasIssues = true;
        }
        if (nitrate > 20) {
            message += "- Nồng độ NO₃ không nên vượt quá 20 mg/l.\n";
            hasIssues = true;
        }
        if (phosphate > 0.5) {
            message += "- Nồng độ PO₄ không nên vượt quá 0.5 mg/l.\n";
            hasIssues = true;
        }

        const notificationDiv = document.getElementById('waterQualityNotification');
        if (hasIssues) {
            notificationDiv.innerText = message;
        } else {
            notificationDiv.innerText = "Tất cả các thông số nước đều đạt chuẩn.";
        }
    }

    function calculateFood() {
        const youngQuantity = parseInt(document.getElementById('youngQuantity').value);
        const juvenileQuantity = parseInt(document.getElementById('juvenileQuantity').value);
        const adultQuantity = parseInt(document.getElementById('adultQuantity').value);

        let totalFoodAmount = 0;

        // Tính lượng thức ăn cho cá con
        if (youngQuantity > 0) {
            totalFoodAmount += youngQuantity * (0.8 * 0.05); // 5% trọng lượng
        }

        // Tính lượng thức ăn cho cá giống
        if (juvenileQuantity > 0) {
            totalFoodAmount += juvenileQuantity * (5 * 0.03); // 3% trọng lượng
        }

        // Tính lượng thức ăn cho cá trưởng thành
        if (adultQuantity > 0) {
            totalFoodAmount += adultQuantity * (20 * 0.02); // 2% trọng lượng
        }

        const foodNotificationDiv = document.getElementById('foodNotification');
        foodNotificationDiv.innerText = 'Tổng lượng thức ăn cần thiết: ' + totalFoodAmount.toFixed(2) + ' kg/ngày.';
    }


    function calculateSalt() {
        const volume = parseFloat(document.getElementById('tankVolume').value);
        const saltAmount = (volume / 1000) * 1.5; // Giả sử 1.5 kg muối cho 1000 lít nước

        const saltNotificationDiv = document.getElementById('saltNotification');
        saltNotificationDiv.innerText = 'Lượng muối cần thiết: ' + saltAmount.toFixed(2) + ' kg.';
    }

</script>

</body>
</html>
