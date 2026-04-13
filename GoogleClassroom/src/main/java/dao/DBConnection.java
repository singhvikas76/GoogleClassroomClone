package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        Connection con = null;

        try {
            System.out.println("Connecting...");

            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/classroom_db",
                "root",
                ""
            );

            System.out.println("Connected ✅");

        } catch (Exception e) {
            System.out.println("Connection Failed ❌");
            e.printStackTrace();
        }
        return con;
    }
}