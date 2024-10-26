package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import java.io.InputStream;

@WebServlet("/BanUserServlet")
public class BanUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("user_id");
        String banDurationStr = request.getParameter("ban_duration");
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Load cấu hình database từ file config.properties
            Properties props = new Properties();
            InputStream input = getServletContext().getResourceAsStream("config.properties");
            props.load(input);

            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String dbuser = props.getProperty("db.user");
            String dbpassword = props.getProperty("db.password");

            // Kết nối cơ sở dữ liệu PostgreSQL
            Class.forName("org.postgresql.Driver");
            String dsn = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            conn = DriverManager.getConnection(dsn, dbuser, dbpassword);

            // Nếu thời gian cấm được cung cấp
            if (banDurationStr != null && !banDurationStr.isEmpty()) {
                int banDuration = Integer.parseInt(banDurationStr);
                // Tính toán thời gian cấm đến
                Timestamp banUntil = new Timestamp(System.currentTimeMillis() + banDuration * 60 * 1000);

                // Cập nhật trạng thái cấm trong bảng users
                String sql = "UPDATE users SET banned_until = ? WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setTimestamp(1, banUntil);
                stmt.setInt(2, Integer.parseInt(userId));
                stmt.executeUpdate();
            } else {
                // Nếu không có thời gian cấm, gỡ bỏ lệnh cấm
                String sql = "UPDATE users SET banned_until = NULL WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(userId));
                stmt.executeUpdate();
            }

            // Điều hướng lại trang quản lý người dùng
            response.sendRedirect("QuanLiUsers.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
