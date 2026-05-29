package com.cartiva.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.OrderDAO;
import com.cartiva.dao.impl.OrderDAOImpl;
import com.cartiva.model.Order;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private OrderDAO dao = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        String type = req.getParameter("type");

        List<Order> orders;
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();

        if (hasKeyword || hasStatus) {
        	orders = dao.searchOrders(keyword, status, type);
        } else {
            orders = dao.getAllOrders();
        }

        req.setAttribute("orders", orders);

        req.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp")
           .forward(req, res);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(req.getParameter("orderId"));
        String action = req.getParameter("action");

        if ("ship".equals(action)) {
            dao.updateOrderStatus(orderId, "SHIPPED");
        }
        else if ("deliver".equals(action)) {
            dao.updateOrderStatus(orderId, "DELIVERED");
        }
        else if ("refund".equals(action)) {
            dao.refundOrder(orderId);
        }

        res.sendRedirect(req.getContextPath() + "/admin/orders?success=true");
    }


}