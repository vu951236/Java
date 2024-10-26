package com.mywebapp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username != null) {
            try {
                Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement("SELECT isadmin FROM users WHERE username = ?");
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();

                boolean isAdmin = false;
                if (rs.next()) {
                    isAdmin = rs.getBoolean("isadmin");
                }

                request.setAttribute("isAdmin", isAdmin);
                request.setAttribute("username", username);

                // Get user info
                PreparedStatement userStmt = conn.prepareStatement("SELECT * FROM users WHERE username = ?");
                userStmt.setString(1, username);
                ResultSet userRs = userStmt.executeQuery();

                if (userRs.next()) {
                    request.setAttribute("userInfo", userRs);
                }

                userRs.close();
                userStmt.close();
                rs.close();
                stmt.close();
                conn.close();

                request.getRequestDispatcher("Trangchu.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            response.sendRedirect("Login.jsp");
        }
    }

    private Connection getConnection() throws SQLException {
        Properties props = new Properties();
        // Đọc thông tin cấu hình từ tệp properties
        try (InputStream input = getServletContext().getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new SQLException("Tệp cấu hình không tồn tại.");
            }
            props.load(input);
        } catch (IOException e) {
            throw new SQLException("Không thể đọc tệp cấu hình: " + e.getMessage(), e);
        }

        // Lấy thông tin kết nối cơ sở dữ liệu từ tệp cấu hình
        String host = props.getProperty("db.host");
        String port = props.getProperty("db.port");
        String dbname = props.getProperty("db.name");
        String user = props.getProperty("db.user");
        String password = props.getProperty("db.password");

        String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
        return DriverManager.getConnection(url, user, password);
    }
}
