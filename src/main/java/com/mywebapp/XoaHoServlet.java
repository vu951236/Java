package com.mywebapp;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import java.sql.SQLException;
import java.util.Properties;
import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.sql.ResultSet;

@WebServlet("/XoaHoServlet")
public class XoaHoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String hoName = request.getParameter("ho_name");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Kết nối đến cơ sở dữ liệu
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

            // Truy vấn thông tin hình ảnh của hồ để xóa
            String selectSql = "SELECT id, image_path1, image_path2, image_path3, image_path4 FROM thongtinho WHERE name = ?";
            stmt = conn.prepareStatement(selectSql);
            stmt.setString(1, hoName);
            ResultSet rs = stmt.executeQuery();

            String[] imagePaths = new String[4];
            int hoId = -1;
            if (rs.next()) {
                hoId = rs.getInt("id");
                for (int i = 0; i < 4; i++) {
                    imagePaths[i] = rs.getString("image_path" + (i + 1));
                }
            } else {
                System.out.println("Không tìm thấy hồ với tên: " + hoName);
                request.getSession().setAttribute("errorMessage", "Không tìm thấy hồ với tên: " + hoName);
                response.sendRedirect("admin.jsp?success=false");
                return;
            }

            // Xóa ảnh trên server và local
            String serverBasePath = request.getServletContext().getRealPath("");
            File serverImagesDir = new File(serverBasePath + File.separator + "images");
            String localImagesDirPath = "C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images";

            for (String imagePath : imagePaths) {
                if (imagePath != null && !imagePath.isEmpty()) {
                    String modifiedImagePath = imagePath.replace("images/", "");

                    // Xóa ảnh cũ trên server
                    File oldServerFile = new File(serverImagesDir + File.separator + modifiedImagePath);
                    if (oldServerFile.exists()) {
                        oldServerFile.delete();
                    }

                    // Xóa ảnh cũ trên thư mục local
                    File oldLocalFile = new File(localImagesDirPath + File.separator + modifiedImagePath);
                    if (oldLocalFile.exists()) {
                        oldLocalFile.delete();
                    }
                }
            }

            // Xóa thông tin hồ cá Koi khỏi cơ sở dữ liệu
            String deleteSql = "DELETE FROM thongtinho WHERE id = ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setInt(1, hoId);
            int result = stmt.executeUpdate();

            if (result > 0) {
                System.out.println("Xóa thông tin hồ cá Koi thành công!");
                request.getSession().setAttribute("successMessage", "Xóa thông tin " + hoName + " thành công!");
                response.sendRedirect("admin.jsp?success=true");
            } else {
                System.out.println("Có lỗi xảy ra khi xóa thông tin hồ cá Koi.");
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xóa thông tin hồ.");
                response.sendRedirect("admin.jsp?success=false");
            }

        } catch (Exception e) {
            System.out.println("Lỗi khi xử lý: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", e.getMessage());
            response.sendRedirect("admin.jsp?success=false");
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}

