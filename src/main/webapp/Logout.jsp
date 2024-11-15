<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.FileNotFoundException" %> // Thêm dòng này
<%@ page import="java.io.IOException" %> // Thêm dòng này nếu chưa có

<%
    // Sử dụng biến session đã được định nghĩa sẵn
    HttpSession currentSession = request.getSession();

    // Đọc thông tin cấu hình từ file config.properties
    Properties props = new Properties();
    InputStream input = application.getResourceAsStream("config.properties");

    String deleteQuery = "DELETE FROM gio_hang";

    // Sử dụng try-with-resources để tự động đóng kết nối và statement
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
        Class.forName("org.postgresql.Driver"); // Đảm bảo driver được tải
        try (Connection conn = DriverManager.getConnection("jdbc:postgresql://" + host + ":" + port + "/" + dbname, user, password);
             PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {

            // Xóa hết dữ liệu trong bảng gio_hang
            deleteStmt.executeUpdate();
        }

    } catch (SQLException e) {
        // Xử lý lỗi nếu có
        out.println("Error: " + e.getMessage());
    } catch (ClassNotFoundException e) {
        // Xử lý lỗi nếu không tìm thấy driver
        out.println("Driver not found: " + e.getMessage());
    } catch (IOException e) {
        // Xử lý lỗi khi đọc file
        out.println("Error reading config file: " + e.getMessage());
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

    // Hủy bỏ tất cả dữ liệu phiên
    if (currentSession != null) {
        currentSession.invalidate(); // Hủy bỏ session nếu nó không null
    }

    // Chuyển hướng đến trang chính hoặc trang mong muốn
    response.sendRedirect("index.jsp");
%>
