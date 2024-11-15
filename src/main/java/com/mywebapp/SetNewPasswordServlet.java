package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.InputStream;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;

@WebServlet("/SetNewPassword")
public class SetNewPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("resetUsername");
        String email = (String) session.getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");

        String errorMessage = null;
        String successMessage = null;

        if (email == null || newPassword == null || newPassword.isEmpty()) {
            errorMessage = "Vui lòng nhập đầy đủ thông tin.";
            System.out.println(errorMessage);
            request.setAttribute("error_message", errorMessage);
            request.getRequestDispatcher("/SetNewPassword.jsp").forward(request, response);
            return;
        }

        // Đọc thông tin cấu hình từ tệp properties
        Properties props = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new FileNotFoundException("Tệp cấu hình không tồn tại.");
            }
            props.load(input);
        } catch (IOException e) {
            errorMessage = "Lỗi khi đọc tệp cấu hình: " + e.getMessage();
            request.setAttribute("error_message", errorMessage);
            request.getRequestDispatcher("/SetNewPassword.jsp").forward(request, response);
            return;
        }

        // Thông tin kết nối cơ sở dữ liệu
        String host = props.getProperty("db.host");
        String port = props.getProperty("db.port");
        String dbname = props.getProperty("db.name");
        String dbuser = props.getProperty("db.user");
        String dbpassword = props.getProperty("db.password");

        Connection conn = null;

        try {
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, dbuser, dbpassword);

            // Cập nhật mật khẩu mới trong cơ sở dữ liệu
            String hashed_password = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt());
            String sql = "UPDATE users SET password = ? WHERE username = ? AND email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, hashed_password);
            stmt.setString(3, email);
            stmt.setString(2, username);

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                successMessage = "Mật khẩu đã được cập nhật thành công!";
                System.out.println(successMessage);
            } else {
                errorMessage = "Không tìm thấy người dùng với email đã cho.";
                System.out.println(errorMessage);
                System.out.println("Email: " + email);
                System.out.println("Username: " + username);
            }
        } catch (Exception e) {
            errorMessage = "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage();
            System.out.println(errorMessage);
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
                errorMessage = "Lỗi đóng kết nối: " + e.getMessage();
                System.out.println(errorMessage);
            }
        }

        // Thiết lập thông báo và chuyển hướng
        if (errorMessage != null) {
            request.setAttribute("error_message", errorMessage);
            request.getRequestDispatcher("/SetNewPassword.jsp").forward(request, response);
        } else {
            request.setAttribute("success_message", successMessage);
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
        }
    }
}
