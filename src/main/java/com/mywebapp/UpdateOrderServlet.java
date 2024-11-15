package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;

@WebServlet("/UpdateOrderServlet")
public class UpdateOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("order_id"));
        String newStatus;

        // Kiểm tra trạng thái hiện tại và đặt trạng thái mới
        if (request.getParameter("submit").equals("Giao hàng")) {
            newStatus = "Đang giao hàng";
        } else {
            newStatus = "Đã hoàn thành";
        }

        // Kết nối cơ sở dữ liệu
        Properties props = new Properties();
        InputStream input = getServletContext().getResourceAsStream("config.properties");
        props.load(input);

        String host = props.getProperty("db.host");
        String port = props.getProperty("db.port");
        String dbname = props.getProperty("db.name");
        String dbuser = props.getProperty("db.user");
        String dbpassword = props.getProperty("db.password");

        String dsn = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;

        try (Connection conn = DriverManager.getConnection(dsn, dbuser, dbpassword)) {
            // Cập nhật trạng thái đơn hàng
            String sql = "UPDATE donhang SET trangthai = ? WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, newStatus);
                pstmt.setInt(2, orderId);
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Chuyển hướng về trang danh sách đơn hàng
        response.sendRedirect("QuanLiDonHang.jsp");
    }
}
