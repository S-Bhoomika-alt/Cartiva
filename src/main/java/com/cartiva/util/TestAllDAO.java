package com.cartiva.util;

import java.util.List;

import com.cartiva.dao.*;
import com.cartiva.dao.impl.*;
import com.cartiva.model.*;

public class TestAllDAO {

    public static void main(String[] args) {


        System.out.println("===== USER TEST =====");

        UserDAO userDAO = new UserDAOImpl();
        User user = userDAO.loginUser("test@gmail.com", "1234");

        if (user != null) {
            System.out.println("User Found: " + user.getFullName());
        } else {
            System.out.println("User not found!");
        }


        System.out.println("\n===== PRODUCT TEST =====");

        ProductDAO productDAO = new ProductDAOImpl();
        List<Product> products = productDAO.getAllProducts();

        for (Product p : products) {
            System.out.println(p.getName() + " | " + p.getCategory() + " | ₹" + p.getPrice());
        }


        System.out.println("\n===== CART TEST =====");

        CartDAO cartDAO = new CartDAOImpl();

        boolean added = cartDAO.addToCart(1, 1, 1);

        if (added) {
            System.out.println("Product added to cart!");
        } else {
            System.out.println("Failed to add product.");
        }


        System.out.println("\n===== ORDER TEST =====");

        OrderDAO orderDAO = new OrderDAOImpl();
        List<Order> orders = orderDAO.getOrdersByUserId(1);

        if (orders != null && !orders.isEmpty()) {
            for (Order o : orders) {
                System.out.println("Order ID: " + o.getOrderId() + " | Total: " + o.getTotalAmount());
            }
        } else {
            System.out.println("No orders yet (expected)");
        }


        System.out.println("\n===== SUBSCRIPTION TEST =====");

        SubscriptionDAO subDAO = new SubscriptionDAOImpl();
        List<Subscription> subs = subDAO.getUserSubscriptions(1);

        if (subs != null && !subs.isEmpty()) {
            for (Subscription s : subs) {
                System.out.println("Subscription ID: " + s.getSubscriptionId());
            }
        } else {
            System.out.println("No subscriptions yet (expected)");
        }

        System.out.println("\n✅ ALL TESTS COMPLETED");
    }
}