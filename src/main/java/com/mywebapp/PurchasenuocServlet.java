package com.mywebapp;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/PurchasenuocServlet")
public class PurchasenuocServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy các tham số từ form
        String productId = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");

        // Chuyển đổi quantity sang số nguyên
        int quantity = Integer.parseInt(quantityStr);

        // Thiết lập định dạng trả về là HTML
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        Connection conn = null;

        try {
            // Đọc thông tin cấu hình từ tệp properties
            Properties props = new Properties();
            try (InputStream input = getServletContext().getResourceAsStream("config.properties")) {
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

            // Kết nối cơ sở dữ liệu PostgreSQL
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, dbuser, dbpassword);

            // Lấy thông tin user từ session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("user_id");

            // Truy vấn để lấy thông tin sản phẩm
            String sql = "SELECT name, soluong, price FROM productsnuoc WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(productId));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int availableQuantity = rs.getInt("soluong");
                String productName = rs.getString("name");
                double pricegoc = rs.getDouble("price");

                // Kiểm tra nếu số lượng yêu cầu <= số lượng có sẵn
                if (quantity <= availableQuantity) {
                    // Cập nhật số lượng trong cơ sở dữ liệu
                    String updateSql = "UPDATE productsnuoc SET soluong = soluong - ? WHERE id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setInt(1, quantity);
                    updateStmt.setInt(2, Integer.parseInt(productId));
                    int rowsUpdated = updateStmt.executeUpdate();

                    if (rowsUpdated > 0) {
                        // Thêm thông tin vào bảng donhang
                        String insertOrderSql = "INSERT INTO donhang (id_user, sanpham, soluong, thoigian, price) VALUES (?, ?, ?, ?, ?)";
                        PreparedStatement orderStmt = conn.prepareStatement(insertOrderSql);
                        orderStmt.setInt(1, userId);  // ID người dùng
                        orderStmt.setString(2, productName);  // Tên sản phẩm
                        orderStmt.setInt(3, quantity);  // Số lượng mua
                        orderStmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));  // Thời gian hiện tại
                        orderStmt.setDouble(5, pricegoc*quantity);  // Số lượng mua

                        int orderInserted = orderStmt.executeUpdate();

                        if (orderInserted > 0) {
                            // Thông báo mua hàng thành công
                            out.println("<h2>Mua hàng thành công!</h2>");
                            out.println("<p>Bạn đã mua " + quantity + " sản phẩm: " + productName + ".</p>");
                        } else {
                            out.println("<h2>Đã có lỗi xảy ra khi lưu đơn hàng.</h2>");
                        }
                    } else {
                        out.println("<h2>Đã có lỗi xảy ra khi cập nhật số lượng sản phẩm.</h2>");
                    }
                } else {
                    // Thông báo nếu số lượng mua lớn hơn số lượng có sẵn
                    out.println("<h2>Số lượng yêu cầu vượt quá số lượng có sẵn.</h2>");
                    out.println("<p>Số lượng sản phẩm còn lại: " + availableQuantity + "</p>");
                }
            } else {
                out.println("<h2>Không tìm thấy sản phẩm.</h2>");
            }

            // Thêm nút quay lại trang sản phẩm
            out.println("<br><a href='Sanpham.jsp'>Quay lại trang sản phẩm</a>");

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<h2>Có lỗi xảy ra trong quá trình mua hàng.</h2>");
        } finally {
            // Đóng kết nối
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
