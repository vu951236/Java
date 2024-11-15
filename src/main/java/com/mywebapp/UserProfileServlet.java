package com.mywebapp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.mindrot.jbcrypt.BCrypt;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

@WebServlet("/UserProfileServlet")
@MultipartConfig
public class UserProfileServlet extends HttpServlet {

    // Phương thức tải thông tin cấu hình từ file config.properties
    private Properties loadProperties() throws IOException {
        Properties props = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new IOException("Tệp cấu hình không tồn tại.");
            }
            props.load(input);
        }
        System.out.println("Tải cấu hình thành công");
        return props;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        if (username == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Properties props;
        try {
            props = loadProperties();
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Lỗi đọc tệp cấu hình: " + e.getMessage());
            System.out.println("Lỗi đọc tệp cấu hình: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        System.out.println("Đang truy vấn thông tin người dùng: " + username);
        try (Connection conn = DriverManager.getConnection(
                "jdbc:postgresql://" + props.getProperty("db.host") + ":" + props.getProperty("db.port") + "/" + props.getProperty("db.name"),
                props.getProperty("db.user"),
                props.getProperty("db.password"))) {

            String query = "SELECT * FROM users WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, username);
                ResultSet userInfo = stmt.executeQuery();

                if (!userInfo.next()) {
                    request.setAttribute("errorMessage", "Không tìm thấy thông tin người dùng.");
                    System.out.println("Không tìm thấy thông tin người dùng.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }

                System.out.println("Lấy thông tin người dùng thành công: " + username);
                request.setAttribute("fullname", userInfo.getString("fullname"));
                request.setAttribute("email", userInfo.getString("email"));
                request.setAttribute("avatar", userInfo.getString("avatar"));
                request.setAttribute("address", userInfo.getString("address"));
                request.setAttribute("userId", userInfo.getInt("id"));
            }

            request.getRequestDispatcher("Thongtinkhachhang.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            System.out.println("Lỗi SQL trong doGet: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        if (username == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        Properties props;
        try {
            props = loadProperties();
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Lỗi đọc tệp cấu hình: " + e.getMessage());
            System.out.println("Lỗi đọc tệp cấu hình: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        System.out.println("Đang cập nhật thông tin người dùng: " + username);
        try (Connection conn = DriverManager.getConnection(
                "jdbc:postgresql://" + props.getProperty("db.host") + ":" + props.getProperty("db.port") + "/" + props.getProperty("db.name"),
                props.getProperty("db.user"),
                props.getProperty("db.password"))) {

            int userId = Integer.parseInt(request.getParameter("userId"));
            System.out.println("userId: " + userId);

            String newEmail = request.getParameter("email");
            String newPassword = request.getParameter("password");
            String newAddress = request.getParameter("address");
            Part avatarPart = request.getPart("avatar");

            List<String> params = new ArrayList<>();
            StringBuilder sql = new StringBuilder("UPDATE users SET ");
            String newAvatar = null;
            String oldAvatar = null;


            try (PreparedStatement stmt = conn.prepareStatement("SELECT avatar FROM users WHERE id = ?")) {
                stmt.setInt(1, userId); // Gán ID tương ứng
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    oldAvatar = rs.getString("avatar"); // Lấy tên avatar cũ
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (avatarPart != null && avatarPart.getSize() > 0) {
                newAvatar = avatarPart.getSubmittedFileName();

                // Đường dẫn tới thư mục gốc của ứng dụng trên server (thư mục chứa QuanLiHoCa.jsp)
                String serverBasePath = request.getServletContext().getRealPath("");
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
                String serverUploadPath = serverImagesDir.getPath() + File.separator + newAvatar;

                // Đường dẫn đầy đủ của tệp được tải lên trên máy local
                String localUploadPath = localImagesDirPath + File.separator + newAvatar;

                // Xóa ảnh cũ nếu tồn tại trên cả server và local
                if (oldAvatar != null && !oldAvatar.isEmpty()) {
                    String modifiedImagePath = oldAvatar.replace("images/", "");
                    File oldServerFile = new File(serverImagesDir + File.separator + modifiedImagePath);
                    if (oldServerFile.exists()) {
                        oldServerFile.delete();
                    }

                    File oldLocalFile = new File("C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images\\" + modifiedImagePath);  // Thêm dấu phân cách đúng
                    if (oldLocalFile.exists()) {
                        oldLocalFile.delete();
                    }
                }

                // Ghi tệp vào cả server và local
                try (InputStream inputStream = avatarPart.getInputStream();
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
                sql.append("avatar = ?, ");
                params.add("images/" + newAvatar);
                System.out.println("Avatar mới: " + newAvatar);
            }


            if (newEmail != null && !newEmail.isEmpty()) {
                sql.append("email = ?, ");
                params.add(newEmail);
                System.out.println("Email mới: " + newEmail);
            }
            if (newPassword != null && !newPassword.isEmpty()) {
                String hashedPassword = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt());
                sql.append("password = ?, ");
                params.add(hashedPassword);
                System.out.println("Mật khẩu mới đã hash.");
            }
            if (newAddress != null && !newAddress.isEmpty()) {
                sql.append("address = ?, ");
                params.add(newAddress);
                System.out.println("Địa chỉ mới: " + newAddress);
            }

            // Xóa dấu phẩy cuối và thêm điều kiện WHERE
            sql.setLength(sql.length() - 2);
            sql.append(" WHERE id = ?");
            System.out.println("Câu lệnh SQL: " + sql.toString());

            // Cập nhật thông tin người dùng
            try (PreparedStatement updateStmt = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    updateStmt.setString(i + 1, params.get(i));
                    System.out.println("Tham số " + (i+1) + ": " + params.get(i));
                }
                updateStmt.setInt(params.size() + 1, userId);
                updateStmt.executeUpdate();
                System.out.println("Cập nhật thành công");
            }

            response.sendRedirect("Thongtinkhachhang.jsp");
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            System.out.println("Lỗi SQL trong doPost: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
