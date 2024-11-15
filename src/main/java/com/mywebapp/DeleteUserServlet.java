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

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("user_id");
        Connection conn = null;
        PreparedStatement stmtDeleteUser = null;
        PreparedStatement stmtDeleteDonhang = null;
        PreparedStatement stmtDeleteHocacanhan = null;

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

            // Xóa người dùng theo ID trong bảng users
            String sqlDeleteUser = "DELETE FROM users WHERE id = ?";
            stmtDeleteUser = conn.prepareStatement(sqlDeleteUser);
            stmtDeleteUser.setInt(1, Integer.parseInt(userId));
            stmtDeleteUser.executeUpdate();

            // Xóa các đơn hàng có id_user trùng với ID
            String sqlDeleteDonhang = "DELETE FROM donhang WHERE id_user = ?";
            stmtDeleteDonhang = conn.prepareStatement(sqlDeleteDonhang);
            stmtDeleteDonhang.setInt(1, Integer.parseInt(userId));
            stmtDeleteDonhang.executeUpdate();

            // Xóa các hàng trong hocacanhan có user_id trùng với ID
            String sqlDeleteHocacanhan = "DELETE FROM hocacanhan WHERE user_id = ?";
            stmtDeleteHocacanhan = conn.prepareStatement(sqlDeleteHocacanhan);
            stmtDeleteHocacanhan.setInt(1, Integer.parseInt(userId));
            stmtDeleteHocacanhan.executeUpdate();

            // Điều hướng lại trang quản lý người dùng
            response.sendRedirect("QuanLiUsers.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmtDeleteUser != null) stmtDeleteUser.close();
                if (stmtDeleteDonhang != null) stmtDeleteDonhang.close();
                if (stmtDeleteHocacanhan != null) stmtDeleteHocacanhan.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

