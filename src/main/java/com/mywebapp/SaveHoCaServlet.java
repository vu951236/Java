package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;

@WebServlet("/SaveHoCa")
@MultipartConfig
public class SaveHoCaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");

        if (userId == null) {
            System.out.println("Lỗi: Bạn chưa đăng nhập. Vui lòng đăng nhập để tiếp tục.");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Đọc thông tin cấu hình từ tệp properties
            Properties props = new Properties();
            try (InputStream input = getServletContext().getResourceAsStream("config.properties")) {
                if (input == null) {
                    throw new IOException("Tệp cấu hình không tồn tại.");
                }
                props.load(input);
            }

            // Lấy thông tin kết nối cơ sở dữ liệu từ tệp cấu hình
            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String dbuser = props.getProperty("db.user");
            String dbpassword = props.getProperty("db.password");

            Class.forName("org.postgresql.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:postgresql://" + host + ":" + port + "/" + dbname, dbuser, dbpassword)) {
                if (conn != null) {
                    System.out.println("Kết nối tới cơ sở dữ liệu thành công!");
                } else {
                    System.out.println("Kết nối tới cơ sở dữ liệu thất bại!");
                }

                // Lấy giá trị từ các tham số form
                String hoName = request.getParameter("hoName");
                String hoLengthStr = request.getParameter("hoLength");
                String hoWidthStr = request.getParameter("hoWidth");
                String hoHeightStr = request.getParameter("hoHeight");
                String fishCountStr = request.getParameter("fishCount");
                String plantCountStr = request.getParameter("plantCount");

                // Kiểm tra và xử lý nếu có ảnh được tải lên
                Part hoImagePart = request.getPart("hoImage");
                String fileName = null;

                if (hoImagePart != null && hoImagePart.getSize() > 0) {
                    fileName = hoImagePart.getSubmittedFileName();

                    // Đường dẫn tới thư mục gốc của ứng dụng trên server (thư mục chứa QuanLiHoCa.jsp)
                    String serverBasePath = getServletContext().getRealPath("");
                    File serverImagesDir = new File(serverBasePath + File.separator + "images");

                    // Đường dẫn tới thư mục images trên máy local
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
                    String serverUploadPath = serverImagesDir.getPath() + File.separator + fileName;

                    // Đường dẫn đầy đủ của tệp được tải lên trên máy local
                    String localUploadPath = localImagesDirPath + File.separator + fileName;

                    // Ghi tệp vào cả server và local
                    try (InputStream inputStream = hoImagePart.getInputStream();
                         FileOutputStream serverOutputStream = new FileOutputStream(serverUploadPath);
                         FileOutputStream localOutputStream = new FileOutputStream(localUploadPath)) {

                        byte[] buffer = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            // Ghi vào thư mục trên server
                            serverOutputStream.write(buffer, 0, bytesRead);
                            // Ghi vào thư mục trên máy local
                            localOutputStream.write(buffer, 0, bytesRead);
                        }
                    }

                    System.out.println("File đã được upload thành công tại: " + serverUploadPath + " và " + localUploadPath);
                }



                if (hoName != null && hoLengthStr != null && hoWidthStr != null && hoHeightStr != null &&
                        fishCountStr != null && plantCountStr != null) {

                    int hoLength = Integer.parseInt(hoLengthStr);
                    int hoWidth = Integer.parseInt(hoWidthStr);
                    int hoHeight = Integer.parseInt(hoHeightStr);
                    int fishCount = Integer.parseInt(fishCountStr);
                    int plantCount = Integer.parseInt(plantCountStr);

                    // Sử dụng try-with-resources cho PreparedStatement
                    try (PreparedStatement stmt = conn.prepareStatement(
                            "INSERT INTO hocacanhan (user_id, ho_name, ho_length, ho_width, ho_height, fish_count, plant_count, ho_image) " +
                                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
                        stmt.setInt(1, userId);
                        stmt.setString(2, hoName);
                        stmt.setInt(3, hoLength);
                        stmt.setInt(4, hoWidth);
                        stmt.setInt(5, hoHeight);
                        stmt.setInt(6, fishCount);
                        stmt.setInt(7, plantCount);
                        stmt.setString(8, fileName != null ? "images/" + fileName : null);

                        int rowsAffected = stmt.executeUpdate();
                        if (rowsAffected > 0) {
                            System.out.println("Lưu thông tin hồ cá thành công!");
                            response.sendRedirect(request.getContextPath() + "/QuanLiHoCa.jsp");
                        } else {
                            System.out.println("Không có hàng nào được lưu.");
                        }
                    }
                } else {
                    System.out.println("Có tham số không hợp lệ!");
                    System.out.println("hoName: " + hoName);
                    System.out.println("hoLengthStr: " + hoLengthStr);
                    System.out.println("hoWidthStr: " + hoWidthStr);
                    System.out.println("hoHeightStr: " + hoHeightStr);
                    System.out.println("fishCountStr: " + fishCountStr);
                    System.out.println("plantCountStr: " + plantCountStr);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi xảy ra: " + e.getMessage());
        }
    }
}
