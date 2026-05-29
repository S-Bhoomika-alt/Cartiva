package com.cartiva.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {


	private static final String URL = "jdbc:mysql://localhost:3306/cartiva?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
	private static final String USER = "root";
    private static final String PASSWORD = "BhOoMi@345190";

    public static Connection getConnection() {
        Connection conn = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");


            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("✅ Database Connected Successfully!");

        } catch (ClassNotFoundException e) {
            System.out.println("❌ MySQL Driver Not Found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ Database Connection Failed!");
            e.printStackTrace();
        }

        return conn;
    }
}