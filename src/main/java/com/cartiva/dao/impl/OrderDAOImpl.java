package com.cartiva.dao.impl;

import java.sql.*;


import java.util.*;
import java.util.List;
import java.util.ArrayList;

import com.cartiva.dao.OrderDAO;
import com.cartiva.model.Order;
import com.cartiva.util.DBConnection;
import com.cartiva.dao.ProductDAO;

public class OrderDAOImpl implements OrderDAO {


	@Override
	public int createOrder(int userId, double total, String paymentMode) {

	    int orderId = 0;

	    try (Connection con = DBConnection.getConnection()) {

	    	String sql = "INSERT INTO orders(user_id, total_amount, payment_mode, status) VALUES(?,?,?,?)";	        PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

	        ps.setInt(1, userId);
	        ps.setDouble(2, total);
	        ps.setString(3, paymentMode);
	        ps.setString(4, "PLACED");

	        ps.executeUpdate();

	        ResultSet rs = ps.getGeneratedKeys();

	        if (rs.next()) {
	            orderId = rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return orderId;
	}

    @Override
    public List<Order> getOrdersByUserId(int userId) {

        List<Order> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM orders WHERE user_id=? ORDER BY order_date DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();

                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));                o.setStatus(rs.getString("status"));
                o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                o.setPaymentMode(rs.getString("payment_mode"));
                o.setRefundStatus(rs.getString("refund_status"));

                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Order getOrderById(int orderId) {

        Order o = null;

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM orders WHERE order_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                o = new Order();

                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                o.setPaymentMode(rs.getString("payment_mode"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return o;
    }

    @Override
    public boolean cancelOrder(int orderId) {

        try (Connection con = DBConnection.getConnection()) {


            String itemSql = "SELECT product_id, quantity FROM order_items WHERE order_id=?";
            PreparedStatement ps1 = con.prepareStatement(itemSql);
            ps1.setInt(1, orderId);

            ResultSet rs = ps1.executeQuery();

            ProductDAO pdao = new ProductDAOImpl();


            while (rs.next()) {
                int productId = rs.getInt("product_id");
                int qty = rs.getInt("quantity");

                pdao.updateStock(productId, qty);
            }


            String sql = "UPDATE orders SET status='CANCELLED' WHERE order_id=? AND LOWER(status)='placed'";
            PreparedStatement ps2 = con.prepareStatement(sql);
            ps2.setInt(1, orderId);

            return ps2.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean updateOrderStatus(int orderId, String status) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE orders SET status=? WHERE order_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<Order> searchOrders(String keyword, String status, String type) {

        List<Order> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM orders WHERE 1=1";

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            boolean hasStatus = status != null && !status.trim().isEmpty();

            if (hasKeyword) {

                if ("order".equals(type)) {
                    sql += " AND CAST(order_id AS CHAR) LIKE ?";
                }
                else if ("user".equals(type)) {
                    sql += " AND CAST(user_id AS CHAR) LIKE ?";
                }
                else {
                    sql += " AND (CAST(order_id AS CHAR) LIKE ? OR CAST(user_id AS CHAR) LIKE ?)";
                }
            }

            if (hasStatus) {
                sql += " AND status = ?";
            }

            PreparedStatement ps = con.prepareStatement(sql);

            int index = 1;

            if (hasKeyword) {
                String value = "%" + keyword.trim() + "%";

                if ("all".equals(type) || type == null) {
                    ps.setString(index++, value);
                    ps.setString(index++, value);
                } else {
                    ps.setString(index++, value);
                }
            }

            if (hasStatus) {
                ps.setString(index++, status.trim());
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                o.setPaymentMode(rs.getString("payment_mode"));
                o.setRefundStatus(rs.getString("refund_status"));

                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            String sql = "SELECT * FROM orders ORDER BY order_id DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();

                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                o.setPaymentMode(rs.getString("payment_mode"));
                o.setRefundStatus(rs.getString("refund_status"));
                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    @Override
    public boolean refundOrder(int orderId) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE orders SET status='REFUNDED' WHERE order_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
