package com.mywebapp;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.ServletContext; // Import ServletContext

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class MyServletContextListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        // Truyền ServletContext vào phương thức deleteExpiredIds
        scheduler.scheduleAtFixedRate(() -> deleteExpiredIds(sce.getServletContext()), 0, 1, TimeUnit.MINUTES);
        System.out.println("Scheduled task đã được khởi động.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdown();
        }
    }

    private void deleteExpiredIds(ServletContext context) { // Nhận ServletContext làm tham số
        Properties props = new Properties();

        try (InputStream input = context.getResourceAsStream("config.properties")) { // Sử dụng context
            if (input == null) {
                // In ra thông báo lỗi nếu không tìm thấy file
                String path = context.getRealPath("config.properties");
                System.err.println("Không thể tìm thấy file config.properties tại: " + path);
                return;
            }
            props.load(input);

            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String dbuser = props.getProperty("db.user");
            String dbpassword = props.getProperty("db.password");

            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            Class.forName("org.postgresql.Driver");

            try (Connection conn = DriverManager.getConnection(url, dbuser, dbpassword)) {
                String deleteStmt = "DELETE FROM Idadmin WHERE expiration_time < NOW()";
                try (PreparedStatement preparedStatement = conn.prepareStatement(deleteStmt)) {
                    int deletedRows = preparedStatement.executeUpdate();
                    System.out.println("Đã xóa " + deletedRows + " ID hết hạn.");
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi xử lý: " + e.getMessage());
        }
    }
}
