package com.cartiva.controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.WishlistDAO;
import com.cartiva.dao.impl.WishlistDAOImpl;
import com.cartiva.dao.CartDAO;
import com.cartiva.dao.impl.CartDAOImpl;
import com.cartiva.model.User;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private WishlistDAO wishlistDAO;
    private CartDAO cartDAO;

    @Override
    public void init() {
        wishlistDAO = new WishlistDAOImpl();
        cartDAO = new CartDAOImpl();
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
        String productIdParam = request.getParameter("productId");


        if ("toggle".equals(action)) {

            int productId = Integer.parseInt(productIdParam);

            if (wishlistDAO.isInWishlist(userId, productId)) {
                wishlistDAO.removeFromWishlist(userId, productId);
            } else {
                wishlistDAO.addToWishlist(userId, productId);
            }


            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }


        if ("remove".equals(action)) {
            int productId = Integer.parseInt(productIdParam);
            wishlistDAO.removeFromWishlist(userId, productId);

            response.sendRedirect("wishlist");
            return;
        }


        if ("moveToCart".equals(action)) {

            int productId = Integer.parseInt(productIdParam);

            cartDAO.addToCart(userId, productId, 1);
            wishlistDAO.removeFromWishlist(userId, productId);

            response.sendRedirect("wishlist");
            return;
        }


        request.setAttribute("wishlist", wishlistDAO.getWishlistByUser(userId));
        request.getRequestDispatcher("/WEB-INF/views/wishlist.jsp")
               .forward(request, response);
    }
}