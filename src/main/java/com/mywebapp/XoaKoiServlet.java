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

@WebServlet("/XoaKoiServlet")
public class XoaKoiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String koiName = request.getParameter("name_ca");

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

            // Truy vấn thông tin hình ảnh của cá Koi để xóa
            String selectSql = "SELECT id, image_path1, image_path2, image_path3, image_path4 FROM thongtinca WHERE name = ?";
            stmt = conn.prepareStatement(selectSql);
            stmt.setString(1, koiName);
            ResultSet rs = stmt.executeQuery();

            String[] imagePaths = new String[4];
            int koiId = -1;
            if (rs.next()) {
                koiId = rs.getInt("id");
                for (int i = 0; i < 4; i++) {
                    imagePaths[i] = rs.getString("image_path" + (i + 1));
                }
            } else {
                System.out.println("Không tìm thấy cá Koi với tên: " + koiName);
                request.getSession().setAttribute("errorMessage", "Không tìm thấy cá Koi với tên: " + koiName);
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

            // Xóa thông tin cá Koi khỏi cơ sở dữ liệu
            String deleteSql = "DELETE FROM thongtinca WHERE id = ?";
            stmt = conn.prepareStatement(deleteSql);
            stmt.setInt(1, koiId);
            int result = stmt.executeUpdate();

            if (result > 0) {
                System.out.println("Xóa thông tin cá Koi thành công!");
                request.getSession().setAttribute("successMessage", "Xóa thông tin cá " + koiName + " thành công!");
                response.sendRedirect("admin.jsp?success=true");
            } else {
                System.out.println("Có lỗi xảy ra khi xóa thông tin cá Koi.");
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xóa thông tin cá Koi.");
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
