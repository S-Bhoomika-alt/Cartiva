package com.cartiva.dao;

import java.util.List;
import com.cartiva.model.OrderItem;

public interface OrderItemDAO {

    List<OrderItem> getItemsByOrderId(int orderId);

    void addOrderItem(int orderId, int productId, int qty, double price);
}