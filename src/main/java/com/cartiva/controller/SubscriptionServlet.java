package com.cartiva.controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.SubscriptionDAO;
import com.cartiva.dao.impl.SubscriptionDAOImpl;
import com.cartiva.model.User;

@WebServlet("/subscriptions")
public class SubscriptionServlet extends HttpServlet {

    private SubscriptionDAO dao;

    @Override
    public void init() {
        dao = new SubscriptionDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int userId = user.getUserId();

        String action = request.getParameter("action");


        if ("cancel".equals(action)) {
            int subId = Integer.parseInt(request.getParameter("id"));
            dao.cancelSubscription(subId);
            response.sendRedirect("subscriptions");
            return;
        }

        request.setAttribute("subscriptions", dao.getSubscriptionsByUser(userId));

        request.getRequestDispatcher("/WEB-INF/views/subscriptions.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");


        if ("update".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String frequency = request.getParameter("frequency");

            dao.updateSubscription(id, quantity, frequency);

            response.sendRedirect("subscriptions");
            return;
        }


        int userId = user.getUserId();
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String frequency = request.getParameter("frequency");

        dao.addSubscription(userId, productId, quantity, frequency);

        response.sendRedirect("subscriptions");
    }
}