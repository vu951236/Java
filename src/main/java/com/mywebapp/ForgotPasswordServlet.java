package com.mywebapp;

import java.io.InputStream;
import java.io.FileNotFoundException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.UUID;

@WebServlet("/ForgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        HttpSession session = request.getSession();
        String error_message = null;
        String success_message = null;

        // Đọc thông tin cấu hình từ tệp properties
        Properties props = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new FileNotFoundException("Tệp cấu hình không tồn tại.");
            }
            props.load(input);
        } catch (IOException e) {
            error_message = "Lỗi khi đọc tệp cấu hình: " + e.getMessage();
            request.setAttribute("error_message", error_message);
            request.getRequestDispatcher("/ForgotPassword.jsp").forward(request, response);
            return;
        }

        // Thông tin kết nối cơ sở dữ liệu
        String host = props.getProperty("db.host");
        String port = props.getProperty("db.port");
        String dbname = props.getProperty("db.name");
        String dbuser = props.getProperty("db.user");
        String dbpassword = props.getProperty("db.password");

        // Thông tin gửi email
        String from = props.getProperty("email.username");
        String emailPassword = props.getProperty("email.password");
        String hostMail = props.getProperty("email.smtp.host");
        String mailPort = props.getProperty("email.smtp.port");

        Connection conn = null;

        try {
            // Kết nối cơ sở dữ liệu PostgreSQL
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, dbuser, dbpassword);

            // Kiểm tra username và email
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND email = ?");
            stmt.setString(1, username);
            stmt.setString(2, email);
            ResultSet rs = stmt.executeQuery();

            if (!rs.next()) {
                error_message = "Username hoặc email không đúng.";
            } else {
                // Tạo mã xác nhận ngẫu nhiên
                String resetCode = UUID.randomUUID().toString().substring(0, 6);
                session.setAttribute("resetUsername", username);
                session.setAttribute("resetCode", resetCode);
                session.setAttribute("resetEmail", email);

                // Gửi mã xác nhận đến email
                String to = email;

                // Thiết lập thuộc tính hệ thống cho gửi email
                Properties properties = System.getProperties();
                properties.setProperty("mail.smtp.host", hostMail);
                properties.put("mail.smtp.auth", "true");
                properties.put("mail.smtp.port", mailPort);
                properties.put("mail.smtp.starttls.enable", "true");

                // Tạo session email với xác thực
                Session mailSession = Session.getInstance(properties, new jakarta.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, emailPassword);
                    }
                });

                try {
                    // Tạo tin nhắn email
                    MimeMessage message = new MimeMessage(mailSession);
                    message.setFrom(new InternetAddress(from));
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                    message.setSubject("Mã xác nhận đặt lại mật khẩu");
                    message.setText("Mã xác nhận của bạn là: " + resetCode);

                    // Gửi email
                    Transport.send(message);
                    success_message = "Mã xác nhận đã được gửi tới email của bạn. Vui lòng kiểm tra.";
                    session.setAttribute("success_message", success_message);
                    response.sendRedirect("ConfirmResetPassword.jsp");
                    return;
                } catch (MessagingException mex) {
                    error_message = "Gửi email thất bại: " + mex.getMessage();
                }
            }
        } catch (Exception e) {
            error_message = "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        request.setAttribute("error_message", error_message);
        request.getRequestDispatcher("/ForgotPassword.jsp").forward(request, response);
    }
}
