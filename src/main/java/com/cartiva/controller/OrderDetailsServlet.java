package com.cartiva.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.OrderDAO;
import com.cartiva.dao.OrderItemDAO;
import com.cartiva.dao.impl.OrderDAOImpl;
import com.cartiva.dao.impl.OrderItemDAOImpl;

import com.cartiva.model.Order;
import com.cartiva.model.OrderItem;

@WebServlet("/order-details")
public class OrderDetailsServlet extends HttpServlet {

    private OrderItemDAO orderItemDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderItemDAO = new OrderItemDAOImpl();
        orderDAO = new OrderDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        List<OrderItem> items = orderItemDAO.getItemsByOrderId(orderId);
        Order order = orderDAO.getOrderById(orderId);

        request.setAttribute("items", items);
        request.setAttribute("paymentMode", order.getPaymentMode());
        request.setAttribute("orderStatus", order.getStatus());

        request.getRequestDispatcher("/WEB-INF/views/order-details.jsp")
               .forward(request, response);
    }
}
