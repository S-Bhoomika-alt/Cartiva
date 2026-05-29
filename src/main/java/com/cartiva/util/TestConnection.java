package com.cartiva.util;

import java.sql.Connection;

public class TestConnection {

    public static void main(String[] args) {

        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            System.out.println("🎉 Connection Test Successful!");
        } else {
            System.out.println("⚠️ Connection Test Failed!");
        }
    }
}