package com.cartiva.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.OrderDAO;
import com.cartiva.dao.OrderItemDAO;

import com.cartiva.dao.impl.CartDAOImpl;
import com.cartiva.dao.impl.OrderDAOImpl;
import com.cartiva.dao.impl.OrderItemDAOImpl;

import com.cartiva.model.Cart;
import com.cartiva.model.User;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String[] selectedIds = request.getParameterValues("selectedCartItemIds");
        System.out.println("PAYMENT selectedCartItemIds = " + Arrays.toString(selectedIds));
        System.out.println("SESSION checkoutItems = " + session.getAttribute("checkoutItems"));

        if (selectedIds == null || selectedIds.length == 0) {
            session.removeAttribute("selectedCartItemIds");
            session.removeAttribute("checkoutItems");
            session.removeAttribute("checkoutTotal");
            session.removeAttribute("total");
            response.sendRedirect("cart");
            return;
        }

        CartDAOImpl cartDAO = new CartDAOImpl();
        session.removeAttribute("selectedCartItemIds");
        session.removeAttribute("checkoutItems");
        session.removeAttribute("checkoutTotal");
        List<Cart> checkoutItems = cartDAO.getCartItemsByIds(user.getUserId(), selectedIds);

        if (checkoutItems == null || checkoutItems.isEmpty()) {
            session.removeAttribute("selectedCartItemIds");
            session.removeAttribute("checkoutItems");
            session.removeAttribute("checkoutTotal");
            session.removeAttribute("total");
            response.sendRedirect("cart");
            return;
        }

        double total = 0;
        for (Cart item : checkoutItems) {
            total += item.getPrice() * item.getQuantity();
        }

        request.setAttribute("selectedCartItemIds", selectedIds);
        request.setAttribute("checkoutItems", checkoutItems);
        request.setAttribute("total", total);

        request.getRequestDispatcher("/WEB-INF/views/payment.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        int userId = user.getUserId();

        CartDAOImpl cartDAO = new CartDAOImpl();
        OrderDAO orderDAO = new OrderDAOImpl();
        OrderItemDAO itemDAO = new OrderItemDAOImpl();

        String[] selectedIds = request.getParameterValues("selectedCartItemIds");
        System.out.println("PAYMENT selectedCartItemIds = " + Arrays.toString(selectedIds));
        System.out.println("SESSION checkoutItems = " + session.getAttribute("checkoutItems"));

        session.removeAttribute("selectedCartItemIds");
        session.removeAttribute("checkoutItems");
        session.removeAttribute("checkoutTotal");
        List<Cart> cartList = cartDAO.getCartItemsByIds(userId, selectedIds);


        if (cartList == null || cartList.isEmpty()) {
            session.removeAttribute("selectedCartItemIds");
            session.removeAttribute("checkoutItems");
            session.removeAttribute("checkoutTotal");
            session.removeAttribute("total");
            response.sendRedirect("cart");
            return;
        }

        double total = 0;
        for (Cart c : cartList) {
            total += c.getPrice() * c.getQuantity();
        }

        String paymentMode = request.getParameter("cod") != null ? "COD" : "CARD";


        int orderId = orderDAO.createOrder(userId, total, paymentMode);


        System.out.println("ORDER PRODUCTS:");
        for (Cart c : cartList) {
            System.out.println("ORDER ITEM PRODUCT = " + c.getProductId());
            System.out.println("ORDER PRODUCT ID: " + c.getProductId());
            itemDAO.addOrderItem(orderId, c.getProductId(), c.getQuantity(), c.getPrice());
        }

        cartDAO.clearSelectedCartItems(userId, selectedIds);
        session.removeAttribute("selectedCartItemIds");
        session.removeAttribute("checkoutItems");
        session.removeAttribute("checkoutTotal");
        session.removeAttribute("total");


        response.sendRedirect("order-success");
    }
}
