package com.cartiva.dao.impl;

import java.sql.*;
import java.util.*;

import com.cartiva.dao.OrderItemDAO;
import com.cartiva.model.OrderItem;
import com.cartiva.util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    @Override
    public List<OrderItem> getItemsByOrderId(int orderId) {

        List<OrderItem> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT oi.product_id, oi.quantity, oi.price, p.name " +
                         "FROM order_items oi " +
                         "JOIN products p ON oi.product_id = p.product_id " +
                         "WHERE oi.order_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                OrderItem item = new OrderItem();

                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setProductName(rs.getString("name"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public void addOrderItem(int orderId, int productId, int quantity, double price) {

        try (Connection con = DBConnection.getConnection()) {

        	String check = "SELECT quantity FROM order_items WHERE order_id=? AND product_id=?";
        	PreparedStatement ps1 = con.prepareStatement(check);
        	ps1.setInt(1, orderId);
        	ps1.setInt(2, productId);

        	ResultSet rs = ps1.executeQuery();

        	if (rs.next()) {

        	    String update = "UPDATE order_items SET quantity = quantity + ? WHERE order_id=? AND product_id=?";
        	    PreparedStatement ps2 = con.prepareStatement(update);

        	    ps2.setInt(1, quantity);
        	    ps2.setInt(2, orderId);
        	    ps2.setInt(3, productId);

        	    ps2.executeUpdate();

        	} else {

        	    String insert = "INSERT INTO order_items(order_id, product_id, quantity, price) VALUES(?,?,?,?)";
        	    PreparedStatement ps3 = con.prepareStatement(insert);

        	    ps3.setInt(1, orderId);
        	    ps3.setInt(2, productId);
        	    ps3.setInt(3, quantity);
        	    ps3.setDouble(4, price);

        	    ps3.executeUpdate();
        	}

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}