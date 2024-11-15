package com.mywebapp;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;


@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchName = request.getParameter("searchName");
        List<String> results = new ArrayList<>();

        // Kết nối đến cơ sở dữ liệu
        Connection conn = null;
        try {
            Properties props = new Properties();
            InputStream input = getServletContext().getResourceAsStream("config.properties");
            props.load(input);

            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String dbuser = props.getProperty("db.user");
            String dbpassword = props.getProperty("db.password");

            Class.forName("org.postgresql.Driver");
            String dsn = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            conn = DriverManager.getConnection(dsn, dbuser, dbpassword);

            // Tìm kiếm trong các bảng
            String[] tables = {"thongtinca", "thongtinho", "productsca", "productsnuoc"};
            for (String table : tables) {
                String query = "SELECT id, name FROM " + table + " WHERE name ILIKE ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setString(1, "%" + searchName + "%");
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        results.add("ID: " + id + ", Tên: " + name + " - Tìm thấy trong bảng: " + table);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        // Gửi kết quả tìm kiếm về trang admin.jsp
        request.setAttribute("searchResults", results);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}
