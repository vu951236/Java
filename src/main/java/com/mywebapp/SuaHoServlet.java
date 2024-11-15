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

@WebServlet("/SuaHoServlet")
@MultipartConfig
public class SuaHoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String oldHoName = request.getParameter("ho_name");
        String newHoName = request.getParameter("new_ho_name");
        String mota = request.getParameter("ho_mota");
        String ghichu = request.getParameter("ho_ghichu");
        String loaiHo = request.getParameter("ho_loai");
        String kichthuoc = request.getParameter("ho_kichthuoc");
        String nhungCayPhu = request.getParameter("ho_nhungcayphu");
        String loaiCaPhuHop = request.getParameter("ho_loaicaphuhop");

        String[] imagePaths = new String[4];
        String[] oldImagePaths = new String[4];

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

            // Truy vấn thông tin hồ cá cũ
            String selectSql = "SELECT id, image_path1, image_path2, image_path3, image_path4 FROM thongtinho WHERE name = ?";
            stmt = conn.prepareStatement(selectSql);
            stmt.setString(1, oldHoName);
            ResultSet rs = stmt.executeQuery();
            int hoId = -1;
            if (rs.next()) {
                hoId = rs.getInt("id");
                for (int i = 0; i < 4; i++) {
                    oldImagePaths[i] = rs.getString("image_path" + (i + 1));
                }
            } else {
                System.out.println("Không tìm thấy hồ cá có tên: " + oldHoName);
                request.getSession().setAttribute("errorMessage", "Không tìm thấy hồ cá có tên: " + oldHoName);
                response.sendRedirect("admin.jsp?success=false");
                return;
            }

            // Xóa ảnh cũ
            String serverBasePath = request.getServletContext().getRealPath("");
            File serverImagesDir = new File(serverBasePath + File.separator + "images");
            String localImagesDirPath = "C:\\Users\\ADMIN\\IdeaProjects\\demo1\\src\\main\\webapp\\images";
            File localImagesDir = new File(localImagesDirPath);

            for (int i = 0; i < oldImagePaths.length; i++) {
                String oldAvatar = oldImagePaths[i];
                if (oldAvatar != null && !oldAvatar.isEmpty()) {
                    String modifiedImagePath = oldAvatar.replace("images/", "");

                    File oldServerFile = new File(serverImagesDir + File.separator + modifiedImagePath);
                    if (oldServerFile.exists()) {
                        oldServerFile.delete();
                    }

                    File oldLocalFile = new File(localImagesDirPath + File.separator + modifiedImagePath);
                    if (oldLocalFile.exists()) {
                        oldLocalFile.delete();
                    }
                }
            }

            // Xử lý ảnh mới
            for (int i = 0; i < imagePaths.length; i++) {
                Part imagePart = request.getPart("ho_image" + (i + 1));
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

            // Tạo câu lệnh SQL động
            StringBuilder updateSql = new StringBuilder("UPDATE thongtinho SET ");
            boolean hasUpdate = false;

            if (newHoName != null && !newHoName.isEmpty()) {
                updateSql.append("name = ?, ");
                hasUpdate = true;
            }
            if (mota != null && !mota.isEmpty()) {
                updateSql.append("mota = ?, ");
                hasUpdate = true;
            }
            if (ghichu != null && !ghichu.isEmpty()) {
                updateSql.append("ghichu = ?, ");
                hasUpdate = true;
            }
            if (loaiHo != null && !loaiHo.isEmpty()) {
                updateSql.append("loai = ?, ");
                hasUpdate = true;
            }
            if (kichthuoc != null && !kichthuoc.isEmpty()) {
                updateSql.append("kichthuoc = ?, ");
                hasUpdate = true;
            }
            if (nhungCayPhu != null && !nhungCayPhu.isEmpty()) {
                updateSql.append("nhungcayphu = ?, ");
                hasUpdate = true;
            }
            if (loaiCaPhuHop != null && !loaiCaPhuHop.isEmpty()) {
                updateSql.append("loaicaphuhop = ?, ");
                hasUpdate = true;
            }

            for (int i = 0; i < 4; i++) {
                updateSql.append("image_path" + (i + 1) + " = ?, ");
                hasUpdate = true;
            }

            // Bỏ dấu phẩy cuối cùng và thêm điều kiện WHERE
            if (!hasUpdate) {
                response.sendRedirect("admin.jsp?success=false");
                return;
            }

            updateSql.setLength(updateSql.length() - 2);
            updateSql.append(" WHERE id = ?");

            stmt = conn.prepareStatement(updateSql.toString());
            int paramIndex = 1;

            if (newHoName != null && !newHoName.isEmpty()) stmt.setString(paramIndex++, newHoName);
            if (mota != null && !mota.isEmpty()) stmt.setString(paramIndex++, mota);
            if (ghichu != null && !ghichu.isEmpty()) stmt.setString(paramIndex++, ghichu);
            if (loaiHo != null && !loaiHo.isEmpty()) stmt.setString(paramIndex++, loaiHo);
            if (kichthuoc != null && !kichthuoc.isEmpty()) stmt.setString(paramIndex++, kichthuoc);
            if (nhungCayPhu != null && !nhungCayPhu.isEmpty()) stmt.setString(paramIndex++, nhungCayPhu);
            if (loaiCaPhuHop != null && !loaiCaPhuHop.isEmpty()) stmt.setString(paramIndex++, loaiCaPhuHop);
            for (int i = 0; i < 4; i++) stmt.setString(paramIndex++, imagePaths[i]);

            stmt.setInt(paramIndex, hoId);

            // Thực hiện cập nhật
            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("Cập nhật thông tin hồ cá thành công!");
                request.getSession().setAttribute("successMessage", "Cập nhật thông tin " + oldHoName + " thành công!");
                response.sendRedirect("admin.jsp?success=true");
            } else {
                System.out.println("Có lỗi xảy ra khi cập nhật thông tin hồ cá.");
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật thông tin hồ.");
                response.sendRedirect("admin.jsp?success=false");
            }

        } catch (Exception e) {
            System.out.println("Lỗi khi xử lý: " + e.getMessage());
            response.getWriter().println("Lỗi: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", e.getMessage());
            response.sendRedirect("admin.jsp?success=false");
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}

