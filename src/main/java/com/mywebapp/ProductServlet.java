package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Product> productsUnder50 = getProducts("SELECT * FROM products WHERE id < 50 ORDER BY id ASC");
            List<Product> productsOver50 = getProducts("SELECT * FROM products WHERE id >= 50 ORDER BY id ASC");

            request.setAttribute("productsUnder50", productsUnder50);
            request.setAttribute("productsOver50", productsOver50);

            request.getRequestDispatcher("Trangchu.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private List<Product> getProducts(String query) throws SQLException {
        List<Product> products = new ArrayList<>();
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Product product = new Product();
                // Giả sử bạn có các trường như id, name, price trong bảng products
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getDouble("price"));
                products.add(product);
            }
        }
        return products;
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
