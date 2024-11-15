package com.mywebapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.InputStream;
import java.util.Properties;
import java.io.File;
import java.io.FileOutputStream;
import jakarta.servlet.http.Part;

@WebServlet("/HoServlet")
@MultipartConfig
public class HoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ho_name = request.getParameter("ho_name");
        String ho_mota = request.getParameter("ho_mota");
        String ho_ghichu = request.getParameter("ho_ghichu");
        String ho_loai = request.getParameter("ho_loai");
        String ho_kichthuoc = request.getParameter("ho_kichthuoc");
        String ho_nhungcayphu = request.getParameter("ho_nhungcayphu");
        String ho_loaicaphuhop = request.getParameter("ho_loaicaphuhop");
        String[] imagePaths = new String[4]; // Mảng để lưu đường dẫn hình ảnh

        // Xử lý tải lên hình ảnh
        for (int i = 0; i < imagePaths.length; i++) {
            Part imagePart = request.getPart("ho_image" + (i + 1));
            if (imagePart != null && imagePart.getSize() > 0) {
                String newImage = imagePart.getSubmittedFileName();
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
                String serverUploadPath = serverImagesDir.getPath() + File.separator + newImage;
                // Đường dẫn đầy đủ của tệp được tải lên trên máy local
                String localUploadPath = localImagesDirPath + File.separator + newImage;

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

                // Lưu đường dẫn hình ảnh vào mảng
                imagePaths[i] =  newImage; // Lưu đường dẫn tương đối
            }
        }

        PreparedStatement stmt = null;
        Connection conn = null;

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

            // Lấy ID lớn nhất hiện có
            String maxIdQuery = "SELECT COALESCE(MAX(id), 0) FROM thongtinho";
            PreparedStatement maxIdStmt = conn.prepareStatement(maxIdQuery);
            ResultSet rs = maxIdStmt.executeQuery();
            int newId = 0;

            if (rs.next()) {
                newId = rs.getInt(1) + 1; // Tăng ID lên 1
            }

            // Chèn hồ cá mới vào bảng
            String sql = "INSERT INTO thongtinho (id, name, mota, ghichu, loai, kichthuoc, nhungcayphu, loaicaphuhop, image_path1, image_path2, image_path3, image_path4) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, newId); // Sử dụng ID mới
            stmt.setString(2, ho_name);
            stmt.setString(3, ho_mota);
            stmt.setString(4, ho_ghichu);
            stmt.setString(5, ho_loai);
            stmt.setString(6, ho_kichthuoc);
            stmt.setString(7, ho_nhungcayphu);
            stmt.setString(8, ho_loaicaphuhop);
            // Thiết lập đường dẫn hình ảnh từ mảng imagePaths
            stmt.setString(9, imagePaths[0]);
            stmt.setString(10, imagePaths[1]);
            stmt.setString(11, imagePaths[2]);
            stmt.setString(12, imagePaths[3]);

            int result = stmt.executeUpdate();
            if (result > 0) {
                response.getWriter().println("Thêm thông tin hồ cá thành công!");
                request.getSession().setAttribute("successMessage", "Thêm thông tin hồ thành công!");
                response.sendRedirect("admin.jsp?success=true");
            } else {
                response.getWriter().println("Có lỗi xảy ra khi thêm thông tin hồ cá.");
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi thêm thông tin hồ cá Koi.");
                response.sendRedirect("admin.jsp?success=false");
            }

            // Đóng ResultSet
            rs.close();
            maxIdStmt.close();
        } catch (Exception e) {
            response.getWriter().println("Lỗi: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", e.getMessage());
            response.sendRedirect("admin.jsp?success=false");
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}

