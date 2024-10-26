package com.mywebapp;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/ThuocServlet")
@MultipartConfig // Cấu hình để xử lý upload file
public class ThuocServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String ghichu = request.getParameter("ghichu");
        String hansudung = request.getParameter("hansudung");
        String soluong = request.getParameter("soluong");
        String price = request.getParameter("price");
        String imagePath = null; // Lưu đường dẫn hình ảnh

        // Lấy file hình ảnh từ request
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String imageName = imagePart.getSubmittedFileName();
            String serverBasePath = request.getServletContext().getRealPath("");
            File serverImagesDir = new File(serverBasePath + File.separator + "images");
            String localImagesDirPath = "C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images";
            File localImagesDir = new File(localImagesDirPath);

            // Tạo thư mục images trên server nếu chưa tồn tại
            if (!serverImagesDir.exists()) {
                boolean serverDirCreated = serverImagesDir.mkdirs();
                if (!serverDirCreated) {
                    throw new IOException("Không thể tạo thư mục lưu trữ hình ảnh trên server.");
                }
            }

            // Tạo thư mục images trên máy local nếu chưa tồn tại
            if (!localImagesDir.exists()) {
                boolean localDirCreated = localImagesDir.mkdirs();
                if (!localDirCreated) {
                    throw new IOException("Không thể tạo thư mục lưu trữ hình ảnh trên máy local.");
                }
            }

            // Đường dẫn đầy đủ của tệp được tải lên trên server
            String serverUploadPath = serverImagesDir.getPath() + File.separator + imageName;
            // Đường dẫn đầy đủ của tệp được tải lên trên máy local
            String localUploadPath = localImagesDirPath + File.separator + imageName;

            // Ghi tệp vào cả server và local
            try (InputStream inputStream = imagePart.getInputStream();
                 FileOutputStream serverOutputStream = new FileOutputStream(serverUploadPath);
                 FileOutputStream localOutputStream = new FileOutputStream(localUploadPath)) {

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    serverOutputStream.write(buffer, 0, bytesRead);
                    localOutputStream.write(buffer, 0, bytesRead);
                }
            }

            // Lưu đường dẫn tương đối của hình ảnh
            imagePath =  imageName;
        }

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

            // Tìm ID tối đa hiện có trong bảng thuốc
            String maxIdSql = "SELECT COALESCE(MAX(id), 0) AS max_id FROM productsca";
            PreparedStatement maxIdStmt = conn.prepareStatement(maxIdSql);
            ResultSet rs = maxIdStmt.executeQuery();
            int newId = 0;
            if (rs.next()) {
                newId = rs.getInt("max_id") + 1; // Tăng ID lên 1
            }

            // Chuyển đổi chuỗi hansudung thành java.sql.Date
            java.sql.Date sqlDate = null;
            if (hansudung != null && !hansudung.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date parsedDate = dateFormat.parse(hansudung);
                sqlDate = new java.sql.Date(parsedDate.getTime());
            }

            // Thêm thông tin thuốc vào cơ sở dữ liệu
            String sql = "INSERT INTO productsca (id, name, ghichu, image_path, hansudung, soluong, price) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, newId); // Sử dụng ID tự động tìm
            stmt.setString(2, name);
            stmt.setString(3, ghichu);
            stmt.setString(4, imagePath); // Đường dẫn hình ảnh
            stmt.setDate(5, sqlDate);
            stmt.setInt(6, Integer.parseInt(soluong));
            stmt.setDouble(7, Double.parseDouble(price));

            stmt.executeUpdate();
            response.sendRedirect("admin.jsp?success=true");
            request.getSession().setAttribute("successMessage", "Thêm thông tin thuốc điều trị thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=true");
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi thêm thông tin thuốc điều trị.");
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
