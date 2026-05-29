package com.cartiva.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.cartiva.dao.AdminStatsDAO;
import com.cartiva.util.DBConnection;

public class AdminStatsDAOImpl implements AdminStatsDAO {

    private static final int LOW_STOCK_THRESHOLD = 10;

    private static final String COMPLETED_REVENUE_WHERE =
            "LOWER(COALESCE(status,'')) = 'delivered' " +
            "AND LOWER(COALESCE(refund_status,'')) <> 'refunded' " +
            "AND COALESCE(total_amount,0) > 0";

    @Override
    public int getTotalUsers() {
        return getCount("SELECT COUNT(*) FROM users");
    }

    @Override
    public int getTotalProducts() {
        return getCount("SELECT COUNT(*) FROM products");
    }

    @Override
    public int getTotalOrders() {
        return getCount("SELECT COUNT(*) FROM orders");
    }

    @Override
    public int getLowStockProducts() {
        return getCount(
                "SELECT COUNT(*) FROM products " +
                "WHERE COALESCE(stock_quantity,0) <= " + LOW_STOCK_THRESHOLD);
    }

    @Override
    public int getOutOfStockProducts() {
        return getCount(
                "SELECT COUNT(*) FROM products " +
                "WHERE COALESCE(stock_quantity,0) <= 0");
    }

    @Override
    public int getTotalWishlistItems() {
        return getCount("SELECT COUNT(*) FROM wishlist");
    }

    @Override
    public int getTotalSubscriptions() {
        return getCount(
                "SELECT COUNT(*) FROM subscriptions " +
                "WHERE LOWER(COALESCE(status,'')) = 'active'");
    }

    @Override
    public double getTotalRevenue() {
        return getDouble(
                "SELECT COALESCE(SUM(total_amount),0) AS revenue " +
                "FROM orders WHERE " + COMPLETED_REVENUE_WHERE);
    }

    @Override
    public double getDailyRevenue() {
        return getDouble(
                "SELECT COALESCE(SUM(total_amount),0) AS revenue " +
                "FROM orders WHERE " + COMPLETED_REVENUE_WHERE +
                " AND DATE(order_date) = CURDATE()");
    }

    @Override
    public double getMonthlyRevenue() {
        return getDouble(
                "SELECT COALESCE(SUM(total_amount),0) AS revenue " +
                "FROM orders WHERE " + COMPLETED_REVENUE_WHERE +
                " AND YEAR(order_date) = YEAR(CURDATE()) " +
                "AND MONTH(order_date) = MONTH(CURDATE())");
    }

    @Override
    public double getSubscriptionRevenue() {
        return 0;
    }

    private int getCount(String sql) {

        int count = 0;

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                count = rs.getInt(1);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    private double getDouble(String sql) {

        double value = 0;

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                value = rs.getDouble(1);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return value;
    }
}
