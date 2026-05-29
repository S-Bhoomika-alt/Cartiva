package com.cartiva.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.cartiva.dao.OrderItemDAO;
import com.cartiva.dao.impl.CartDAOImpl;
import com.cartiva.model.User;
import com.cartiva.model.Cart;
import com.cartiva.dao.OrderDAO;
import com.cartiva.dao.impl.OrderDAOImpl;
import com.cartiva.dao.impl.OrderItemDAOImpl;


@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAOImpl();
    private OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
    private CartDAOImpl cartDAO = new CartDAOImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if(user == null){
            response.sendRedirect("login");
            return;
        }

        String[] selectedIds = request.getParameterValues("selectedCartItemIds");
        System.out.println("PLACE ORDER selectedCartItemIds = " + Arrays.toString(selectedIds));

        session.removeAttribute("selectedCartItemIds");
        session.removeAttribute("checkoutItems");
        session.removeAttribute("checkoutTotal");
        List<Cart> selectedItems = cartDAO.getCartItemsByIds(user.getUserId(), selectedIds);
        if (selectedItems == null || selectedItems.isEmpty()) {
            session.removeAttribute("selectedCartItemIds");
            session.removeAttribute("checkoutItems");
            session.removeAttribute("checkoutTotal");
            response.sendRedirect("cart");
            return;
        }

        System.out.println("FETCHED CHECKOUT ITEMS:");
        for (Cart item : selectedItems) {
            System.out.println(item.getCartId() + " -> " + item.getProductId());
        }

        double total = 0.0;
        for (Cart item : selectedItems) {
            total += item.getPrice() * item.getQuantity();
        }

        int orderId = orderDAO.createOrder(
                user.getUserId(),
                total,
                "COD"
        );

        System.out.println("Order Created ID: " + orderId);

        System.out.println("ORDER PRODUCTS:");
        for (Cart item : selectedItems) {
            System.out.println("ORDER ITEM PRODUCT = " + item.getProductId());
            System.out.println("ORDER PRODUCT ID: " + item.getProductId());
            orderItemDAO.addOrderItem(orderId, item.getProductId(), item.getQuantity(), item.getPrice());
        }

        cartDAO.clearSelectedCartItems(user.getUserId(), selectedIds);
        session.removeAttribute("selectedCartItemIds");
        session.removeAttribute("checkoutItems");
        session.removeAttribute("checkoutTotal");

        response.sendRedirect("orders");
    }
}
