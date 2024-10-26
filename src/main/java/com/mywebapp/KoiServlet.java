package com.mywebapp;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import jakarta.servlet.http.Part;

@WebServlet("/KoiServlet")
@MultipartConfig
public class KoiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin từ form
        String name = request.getParameter("name_ca");
        String ghichu = request.getParameter("ghichu_ca");
        String khainiem = request.getParameter("khainiem_ca");
        String dacdiem = request.getParameter("dacdiem_ca");
        String dinhduong = request.getParameter("dinhduong_ca");
        String phanloai = request.getParameter("phanloai_ca");
        String phanbiet = request.getParameter("phanbiet_ca");

        // In ra console để kiểm tra các giá trị
        System.out.println("Tên cá Koi: " + name);
        System.out.println("Ghi chú: " + ghichu);
        System.out.println("Khái niệm: " + khainiem);
        System.out.println("Đặc điểm: " + dacdiem);
        System.out.println("Dinh dưỡng: " + dinhduong);
        System.out.println("Phân loại: " + phanloai);
        System.out.println("Phân biệt: " + phanbiet);

        String[] imagePaths = new String[4]; // Mảng để lưu trữ đường dẫn hình ảnh

        // Lấy và kiểm tra hình ảnh từ request
        for (int i = 0; i < imagePaths.length; i++) {
            Part imagePart = request.getPart("image_pathca" + (i + 1));
            if (imagePart != null && imagePart.getSize() > 0) {
                String newImage = imagePart.getSubmittedFileName();
                String serverBasePath = request.getServletContext().getRealPath("");
                File serverImagesDir = new File(serverBasePath + File.separator + "images");
                String localImagesDirPath = "C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images";
                File localImagesDir = new File(localImagesDirPath);

                // In ra console để kiểm tra việc tải hình ảnh
                System.out.println("Uploading image " + (i + 1) + ": " + newImage);

                // Tạo thư mục images trên server nếu chưa tồn tại
                if (!serverImagesDir.exists()) {
                    boolean serverDirCreated = serverImagesDir.mkdirs();
                    System.out.println("Tạo thư mục trên server: " + serverDirCreated);
                }

                // Tạo thư mục images trên máy local nếu chưa tồn tại
                if (!localImagesDir.exists()) {
                    boolean localDirCreated = localImagesDir.mkdirs();
                    System.out.println("Tạo thư mục trên máy local: " + localDirCreated);
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

                    System.out.println("Uploaded image " + (i + 1) + " to server and local.");
                } catch (IOException e) {
                    System.out.println("Lỗi khi ghi tệp hình ảnh: " + e.getMessage());
                }

                System.out.println("File đã được upload thành công tại: " + serverUploadPath + " và " + localUploadPath);

                // Lưu đường dẫn hình ảnh vào mảng
                imagePaths[i] =  newImage; // Lưu đường dẫn tương đối
            } else {
                System.out.println("Image " + (i + 1) + " is null or empty.");
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

            System.out.println("Đã kết nối đến cơ sở dữ liệu thành công.");

            // Tìm ID tối đa hiện có trong bảng cá Koi
            String maxIdSql = "SELECT COALESCE(MAX(id), 0) AS max_id FROM thongtinca";
            stmt = conn.prepareStatement(maxIdSql);
            ResultSet rs = stmt.executeQuery();

            int newId = 0;
            if (rs.next()) {
                newId = rs.getInt("max_id") + 1; // Tăng ID lên 1
                System.out.println("ID mới: " + newId);
            }

            // Thêm thông tin cá Koi vào cơ sở dữ liệu
            String sql = "INSERT INTO thongtinca (id, name, ghichu, image_path1, image_path2, image_path3, image_path4, khainiem, dacdiem, dinhduong, phanloai, phanbiet) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, newId); // Sử dụng ID tự động tìm
            stmt.setString(2, name);
            stmt.setString(3, ghichu);
            // Thiết lập đường dẫn hình ảnh từ mảng
            stmt.setString(4, imagePaths[0]);
            stmt.setString(5, imagePaths[1]);
            stmt.setString(6, imagePaths[2]);
            stmt.setString(7, imagePaths[3]);
            stmt.setString(8, khainiem);
            stmt.setString(9, dacdiem);
            stmt.setString(10, dinhduong);
            stmt.setString(11, phanloai);
            stmt.setString(12, phanbiet);

            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("Thêm thông tin cá Koi thành công!");
                request.getSession().setAttribute("successMessage", "Thêm thông tin cá Koi thành công!");
                response.sendRedirect("admin.jsp?success=true");
            } else {
                System.out.println("Có lỗi xảy ra khi thêm thông tin cá Koi.");
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi thêm thông tin cá Koi.");
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
