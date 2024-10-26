package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;

@WebServlet("/TaoIdAdmin")
public class TaoIdAdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String adminId = request.getParameter("adminId"); // Lấy ID từ form
        String errorMessage = ""; // Biến lưu trữ thông báo lỗi

        // Đọc thông tin cấu hình từ file config.properties
        Properties props = new Properties();
        InputStream input = getServletContext().getResourceAsStream("config.properties");
        if (input == null) {
            errorMessage = "Không thể tìm thấy file config.properties2";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("TaoIdAdmin.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            props.load(input);
            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String dbuser = props.getProperty("db.user");
            String dbpassword = props.getProperty("db.password");

            // Kết nối đến cơ sở dữ liệu
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, dbuser, dbpassword);

            // Kiểm tra ID admin đã tồn tại chưa
            PreparedStatement checkIdStmt = conn.prepareStatement("SELECT * FROM Idadmin WHERE id = ?");
            checkIdStmt.setString(1, adminId);
            if (checkIdStmt.executeQuery().next()) {
                errorMessage = "ID admin đã tồn tại.";
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("TaoIdAdmin.jsp").forward(request, response);
                return;
            }

            // Thêm ID admin vào cơ sở dữ liệu với thời gian hết hạn 5 phút
            String insertIdStmt = "INSERT INTO Idadmin (id, expiration_time) VALUES (?, NOW() + INTERVAL '5 minutes')";
            PreparedStatement insertStmt = conn.prepareStatement(insertIdStmt);
            insertStmt.setString(1, adminId);
            insertStmt.executeUpdate();

            response.sendRedirect("TaoIdAdmin.jsp"); // Chuyển hướng đến trang thành công

        } catch (Exception e) {
            errorMessage = "Lỗi khi xử lý: " + e.getMessage();
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("TaoIdAdmin.jsp").forward(request, response);
        } finally {
            // Đảm bảo đóng kết nối
            try {
                if (conn != null) conn.close();
                if (input != null) input.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
