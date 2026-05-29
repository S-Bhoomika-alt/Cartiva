package com.cartiva.controller;

import java.io.IOException;
import java.util.List;

import com.cartiva.model.User;
import com.cartiva.model.Order;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.OrderDAO;
import com.cartiva.dao.impl.OrderDAOImpl;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }


        String action = request.getParameter("action");

        if ("cancel".equals(action)) {

            int orderId = Integer.parseInt(request.getParameter("orderId"));

            boolean cancelled = orderDAO.cancelOrder(orderId);

            if (!cancelled) {
                request.getSession().setAttribute("cancelError",
                        "Order already shipped. Cannot cancel.");
            }

            response.sendRedirect("orders");
            return;
        }

        int userId = user.getUserId();
        List<Order> orders = orderDAO.getOrdersByUserId(userId);

        request.setAttribute("orders", orders);

        request.getRequestDispatcher("/WEB-INF/views/orders.jsp")
               .forward(request, response);
    }
}