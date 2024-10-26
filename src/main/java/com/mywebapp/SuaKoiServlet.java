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

@WebServlet("/SuaKoiServlet")
@MultipartConfig
public class SuaKoiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String oldName = request.getParameter("name_ca");
        String newName = request.getParameter("new_name_ca");
        String ghichu = request.getParameter("ghichu_ca");
        String khainiem = request.getParameter("khainiem_ca");
        String dacdiem = request.getParameter("dacdiem_ca");
        String dinhduong = request.getParameter("dinhduong_ca");
        String phanloai = request.getParameter("phanloai_ca");
        String phanbiet = request.getParameter("phanbiet_ca");

        String[] imagePaths = new String[4];
        String[] oldImagePaths = new String[4];

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
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

            String selectSql = "SELECT id, image_path1, image_path2, image_path3, image_path4 FROM thongtinca WHERE name = ?";
            stmt = conn.prepareStatement(selectSql);
            stmt.setString(1, oldName);
            ResultSet rs = stmt.executeQuery();
            int koiId = -1;
            if (rs.next()) {
                koiId = rs.getInt("id");
                for (int i = 0; i < 4; i++) {
                    oldImagePaths[i] = rs.getString("image_path" + (i + 1));
                }
            } else {
                System.out.println("Không tìm thấy cá Koi có tên: " + oldName);
                request.getSession().setAttribute("errorMessage", "Không tìm thấy cá Koi có tên: " + oldName);
                response.sendRedirect("admin.jsp?success=false");
                return;
            }

            String serverBasePath = request.getServletContext().getRealPath("");
            File serverImagesDir = new File(serverBasePath + File.separator + "images");
            String localImagesDirPath = "C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images";
            File localImagesDir = new File(localImagesDirPath);
            for (int i = 0; i < oldImagePaths.length; i++) {
                String oldAvatar = oldImagePaths[i];
                if (oldAvatar != null && !oldAvatar.isEmpty()) {
                    String modifiedImagePath = oldAvatar.replace("images/", "");

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


            for (int i = 0; i < imagePaths.length; i++) {
                Part imagePart = request.getPart("image_pathca" + (i + 1));
                if (imagePart != null && imagePart.getSize() > 0) {
                    String newImage = imagePart.getSubmittedFileName();


                    String serverUploadPath = serverImagesDir.getPath() + File.separator + newImage;
                    String localUploadPath = localImagesDirPath + File.separator + newImage;

                    try (InputStream inputStream = imagePart.getInputStream();
                         FileOutputStream serverOutputStream = new FileOutputStream(serverUploadPath);
                         FileOutputStream localOutputStream = new FileOutputStream(localUploadPath)) {

                        byte[] buffer = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            serverOutputStream.write(buffer, 0, bytesRead);
                            localOutputStream.write(buffer, 0, bytesRead);
                        }
                    } catch (IOException e) {
                        System.out.println("Lỗi khi ghi tệp hình ảnh: " + e.getMessage());
                    }

                    imagePaths[i] = newImage;
                } else {
                    imagePaths[i] = oldImagePaths[i];
                }
            }

            // Tạo câu lệnh SQL động dựa trên các thông tin được nhập
            StringBuilder updateSql = new StringBuilder("UPDATE thongtinca SET ");
            boolean hasUpdate = false;

            if (newName != null && !newName.isEmpty()) {
                updateSql.append("name = ?, ");
                hasUpdate = true;
            }
            if (ghichu != null && !ghichu.isEmpty()) {
                updateSql.append("ghichu = ?, ");
                hasUpdate = true;
            }
            if (khainiem != null && !khainiem.isEmpty()) {
                updateSql.append("khainiem = ?, ");
                hasUpdate = true;
            }
            if (dacdiem != null && !dacdiem.isEmpty()) {
                updateSql.append("dacdiem = ?, ");
                hasUpdate = true;
            }
            if (dinhduong != null && !dinhduong.isEmpty()) {
                updateSql.append("dinhduong = ?, ");
                hasUpdate = true;
            }
            if (phanloai != null && !phanloai.isEmpty()) {
                updateSql.append("phanloai = ?, ");
                hasUpdate = true;
            }
            if (phanbiet != null && !phanbiet.isEmpty()) {
                updateSql.append("phanbiet = ?, ");
                hasUpdate = true;
            }
            for (int i = 0; i < 4; i++) {
                updateSql.append("image_path" + (i + 1) + " = ?, ");
                hasUpdate = true;
            }

            if (!hasUpdate) {
                response.sendRedirect("admin.jsp?success=false");
                return;
            }

            // Bỏ dấu phẩy cuối cùng và thêm điều kiện WHERE
            updateSql.setLength(updateSql.length() - 2);
            updateSql.append(" WHERE id = ?");

            stmt = conn.prepareStatement(updateSql.toString());

            int paramIndex = 1;
            if (newName != null && !newName.isEmpty()) stmt.setString(paramIndex++, newName);
            if (ghichu != null && !ghichu.isEmpty()) stmt.setString(paramIndex++, ghichu);
            if (khainiem != null && !khainiem.isEmpty()) stmt.setString(paramIndex++, khainiem);
            if (dacdiem != null && !dacdiem.isEmpty()) stmt.setString(paramIndex++, dacdiem);
            if (dinhduong != null && !dinhduong.isEmpty()) stmt.setString(paramIndex++, dinhduong);
            if (phanloai != null && !phanloai.isEmpty()) stmt.setString(paramIndex++, phanloai);
            if (phanbiet != null && !phanbiet.isEmpty()) stmt.setString(paramIndex++, phanbiet);
            for (int i = 0; i < 4; i++) {
                stmt.setString(paramIndex++, imagePaths[i]);
            }
            stmt.setInt(paramIndex, koiId);

            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("Cập nhật thông tin cá Koi thành công!");
                request.getSession().setAttribute("successMessage", "Cập nhật thông tin cá " + oldName + " thành công!");
                response.sendRedirect("admin.jsp?success=true");
            } else {
                System.out.println("Có lỗi xảy ra khi cập nhật thông tin cá Koi.");
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật thông tin cá Koi.");
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
