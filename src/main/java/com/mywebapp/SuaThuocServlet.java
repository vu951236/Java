package com.mywebapp;

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
import java.io.File;
import java.io.FileOutputStream;

@WebServlet("/SuaThuocServlet")
@MultipartConfig
public class SuaThuocServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String oldName = request.getParameter("old_name");
        String newName = request.getParameter("new_name");
        String ghichu = request.getParameter("ghichu");
        String hansudung = request.getParameter("hansudung");
        String soluong = request.getParameter("soluong");
        String price = request.getParameter("price");

        String imagePath = null;

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            // Kết nối cơ sở dữ liệu
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

            // Truy vấn thông tin thuốc cũ
            String selectSql = "SELECT image_path FROM productsca WHERE name = ?";
            stmt = conn.prepareStatement(selectSql);
            stmt.setString(1, oldName);
            ResultSet rs = stmt.executeQuery();
            String oldImagePath = null;
            if (rs.next()) {
                oldImagePath = rs.getString("image_path");
            } else {
                System.out.println("Không tìm thấy thuốc với tên: " + oldName);
                request.getSession().setAttribute("errorMessage", "Không tìm thấy thuốc với tên: " + oldName);
                response.sendRedirect("admin.jsp?success=false");
                return;
            }

            // Xử lý hình ảnh mới
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String newImage = imagePart.getSubmittedFileName();

                // Đường dẫn thư mục để lưu ảnh
                String serverBasePath = request.getServletContext().getRealPath("");
                File serverImagesDir = new File(serverBasePath + File.separator + "images");
                if (!serverImagesDir.exists()) {
                    serverImagesDir.mkdirs();
                }

                // Nếu có ảnh mới, xóa ảnh cũ trước
                if (oldImagePath != null && !oldImagePath.isEmpty()) {
                    String modifiedImagePath = oldImagePath.replace("images/", "");

                    // Xóa ảnh trên server
                    File oldServerFile = new File(serverImagesDir, modifiedImagePath);
                    if (oldServerFile.exists()) {
                        if (oldServerFile.delete()) {
                            System.out.println("Đã xóa ảnh cũ: " + oldImagePath);
                        } else {
                            System.out.println("Không thể xóa ảnh cũ: " + oldImagePath);
                        }
                    }

                    // Xóa ảnh trên máy cục bộ
                    String localImagesDirPath = "C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images";
                    File oldLocalFile = new File(localImagesDirPath, modifiedImagePath);
                    if (oldLocalFile.exists()) {
                        if (oldLocalFile.delete()) {
                            System.out.println("Đã xóa ảnh cũ trên máy cục bộ.");
                        } else {
                            System.out.println("Không thể xóa ảnh cũ trên máy cục bộ.");
                        }
                    }
                }

                // Lưu ảnh mới
                File newServerFile = new File(serverImagesDir, newImage);
                String localImagesDirPath = "C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images";
                File newLocalFile = new File(localImagesDirPath, newImage);

                try (InputStream inputStream = imagePart.getInputStream();
                     FileOutputStream serverOutputStream = new FileOutputStream(newServerFile);
                     FileOutputStream localOutputStream = new FileOutputStream(newLocalFile)) {

                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        serverOutputStream.write(buffer, 0, bytesRead);
                        localOutputStream.write(buffer, 0, bytesRead);
                    }
                } catch (IOException e) {
                    System.out.println("Lỗi khi ghi tệp hình ảnh: " + e.getMessage());
                }

                imagePath =  newImage;
            } else {
                imagePath = oldImagePath; // Giữ ảnh cũ nếu không có ảnh mới
            }

            // Chuyển đổi chuỗi hansudung thành java.sql.Date
            java.sql.Date sqlDate = null;
            if (hansudung != null && !hansudung.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date parsedDate = dateFormat.parse(hansudung);
                sqlDate = new java.sql.Date(parsedDate.getTime());
            }

            // Cập nhật thông tin thuốc trong cơ sở dữ liệu
            String updateSql = "UPDATE productsca SET name = ?, ghichu = ?, hansudung = ?, soluong = ?, price = ?, image_path = ? WHERE name = ?";
            stmt = conn.prepareStatement(updateSql);
            stmt.setString(1, newName);
            stmt.setString(2, ghichu);
            stmt.setDate(3, sqlDate);
            stmt.setInt(4, Integer.parseInt(soluong));
            stmt.setDouble(5, Double.parseDouble(price));
            stmt.setString(6, imagePath);
            stmt.setString(7, oldName);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("Cập nhật thuốc thành công.");
                request.getSession().setAttribute("successMessage", "Cập nhật thông tin thuốc " + oldName + " thành công!");
                response.sendRedirect("admin.jsp?success=true");
            } else {
                System.out.println("Cập nhật thuốc thất bại.");
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật thông tin thuốc điều trị.");
                response.sendRedirect("admin.jsp?success=false");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?success=false");
            request.getSession().setAttribute("errorMessage", e.getMessage());
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
