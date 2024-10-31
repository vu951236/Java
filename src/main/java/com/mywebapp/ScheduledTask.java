package com.mywebapp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;
import java.io.InputStream;

public class ScheduledTask implements Runnable {

    @Override
    public void run() {
        Properties props = new Properties();
        InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties");

        if (input == null) {
            System.out.println("Không thể tìm thấy file config.properties3");
            return;
        }

        Connection conn = null;
        try {
            props.load(input);
            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String dbname = props.getProperty("db.name");
            String dbuser = props.getProperty("db.user");
            String dbpassword = props.getProperty("db.password");

            // Kết nối đến cơ sở dữ liệu
            String url = "jdbc:postgresql://" + host + ":" + port + "/" + dbname;
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, dbuser, dbpassword);

            // Xóa các ID admin hết hạn
            String deleteExpiredIds = "DELETE FROM Idadmin WHERE expiration_time < NOW()";
            PreparedStatement stmt = conn.prepareStatement(deleteExpiredIds);
            int deletedRows = stmt.executeUpdate();
            System.out.println("Đã xóa " + deletedRows + " ID admin hết hạn.");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
                if (input != null) input.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
