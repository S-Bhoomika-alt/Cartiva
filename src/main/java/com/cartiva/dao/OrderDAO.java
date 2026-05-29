package com.cartiva.dao;

import java.util.List;

import com.cartiva.model.Order;

public interface OrderDAO {


    int createOrder(int userId, double total, String paymentMode);

    List<Order> getOrdersByUserId(int userId);

    boolean cancelOrder(int orderId);

    Order getOrderById(int orderId);
    List<Order> getAllOrders();
    boolean refundOrder(int orderId);

    boolean updateOrderStatus(int orderId, String status);
    List<Order> searchOrders(String keyword, String status, String type);
}