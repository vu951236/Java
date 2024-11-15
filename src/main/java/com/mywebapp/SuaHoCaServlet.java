package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletContext;

import java.io.*;
import java.sql.*;
import java.util.Properties;

@WebServlet("/SuaHoCa")
@MultipartConfig
public class SuaHoCaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nhận các giá trị từ form
        String hoName = request.getParameter("hoName");
        int hoLength = Integer.parseInt(request.getParameter("hoLength"));
        int hoWidth = Integer.parseInt(request.getParameter("hoWidth"));
        int hoHeight = Integer.parseInt(request.getParameter("hoHeight"));
        int fishCount = Integer.parseInt(request.getParameter("fishCount"));
        int plantCount = Integer.parseInt(request.getParameter("plantCount"));

        // Upload file ảnh hồ cá
        Part filePart = request.getPart("hoImage");
        String fileName = filePart.getSubmittedFileName();

        // Lấy đường dẫn thư mục images trên server một cách động
        ServletContext context = request.getServletContext();
        String serverBasePath = context.getRealPath("");  // Lấy đường dẫn thư mục gốc trên server
        File serverImagesDir = new File(serverBasePath + File.separator + "images");  // Thư mục lưu trữ ảnh trên server

        // Kiểm tra nếu thư mục images chưa tồn tại thì tạo mới
        if (!serverImagesDir.exists()) {
            serverImagesDir.mkdirs();
        }

        // Đường dẫn lưu ảnh trên server
        String serverSavePath = serverImagesDir + File.separator + fileName;

        // Đường dẫn thư mục lưu ảnh trên local
        String localSavePath = "C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images\\" + fileName;  // Sửa lại dấu phân cách đúng

        // Kết nối cơ sở dữ liệu và cập nhật thông tin hồ cá
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Đọc file config.properties
            Properties props = new Properties();
            InputStream input = getServletContext().getResourceAsStream("config.properties"); // Thêm dấu "/" trước đường dẫn
            if (input == null) {
                throw new FileNotFoundException("File config.properties không tìm thấy");
            }
            props.load(input);

            // Lấy các thông tin từ file cấu hình
            String dbHost = props.getProperty("db.host");
            String dbPort = props.getProperty("db.port");
            String dbName = props.getProperty("db.name");
            String user = props.getProperty("db.user");
            String password = props.getProperty("db.password");

            // Tạo URL kết nối
            String dbURL = "jdbc:postgresql://" + dbHost + ":" + dbPort + "/" + dbName;

            // Kết nối tới cơ sở dữ liệu
            conn = DriverManager.getConnection(dbURL, user, password);

            // Lấy thông tin ảnh cũ
            Integer userId = (Integer) request.getSession().getAttribute("user_id");
            String selectSQL = "SELECT ho_image FROM hocacanhan WHERE user_id = ?";
            stmt = conn.prepareStatement(selectSQL);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            String oldImage = null;
            if (rs.next()) {
                oldImage = rs.getString("ho_image");
            }

            // Đóng ResultSet và Statement
            rs.close();
            stmt.close();

            // Xóa ảnh cũ nếu tồn tại trên cả server và local
            if (oldImage != null && !oldImage.isEmpty()) {
                String modifiedImagePath = oldImage.replace("images/", "");
                File oldServerFile = new File(serverImagesDir + File.separator + modifiedImagePath);
                if (oldServerFile.exists()) {
                    oldServerFile.delete();
                }

                File oldLocalFile = new File("C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images\\" + modifiedImagePath);  // Thêm dấu phân cách đúng
                if (oldLocalFile.exists()) {
                    oldLocalFile.delete();
                }
            }

            // Lưu ảnh mới vào thư mục trên server và local
            try (InputStream inputStream = filePart.getInputStream();
                 FileOutputStream fosServer = new FileOutputStream(serverSavePath);
                 FileOutputStream fosLocal = new FileOutputStream(localSavePath)) {

                byte[] buffer = new byte[1024];
                int bytesRead;

                // Vòng lặp đọc dữ liệu từ InputStream và ghi vào cả hai tệp
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    // Ghi vào thư mục trên server
                    fosServer.write(buffer, 0, bytesRead);
                    // Ghi vào thư mục trên máy local
                    fosLocal.write(buffer, 0, bytesRead);
                }

                System.out.println("File đã được upload thành công tại: " + serverSavePath + " và " + localSavePath);
            } catch (IOException e) {
                // Xử lý ngoại lệ
                e.printStackTrace();
            }

            // Cập nhật thông tin hồ cá
            String updateSQL = "UPDATE hocacanhan SET ho_name = ?, ho_length = ?, ho_width = ?, ho_height = ?, fish_count = ?, plant_count = ?, ho_image = ? WHERE user_id = ?";
            stmt = conn.prepareStatement(updateSQL);
            stmt.setString(1, hoName);
            stmt.setInt(2, hoLength);
            stmt.setInt(3, hoWidth);
            stmt.setInt(4, hoHeight);
            stmt.setInt(5, fishCount);
            stmt.setInt(6, plantCount);
            stmt.setString(7, fileName != null ? "images/" + fileName : null);
            stmt.setInt(8, userId);

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("QuanLiHoCa.jsp?success=1");
            } else {
                response.sendRedirect("QuanLiHoCa.jsp?error=1");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("QuanLiHoCa.jsp?error=2");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
