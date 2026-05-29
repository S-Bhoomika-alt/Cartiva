package com.cartiva.controller;

import java.io.IOException;

import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.CartDAO;
import com.cartiva.dao.impl.CartDAOImpl;
import com.cartiva.dao.impl.ProductDAOImpl;
import com.cartiva.dao.ProductDAO;

import com.cartiva.model.Cart;
import com.cartiva.model.Product;
import com.cartiva.model.User;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "true".equalsIgnoreCase(request.getParameter("ajax"));
    }

    private void writeCartJson(HttpServletResponse response, boolean success, String message, int cartCount)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success
                + ",\"message\":\"" + message.replace("\"", "\\\"")
                + "\",\"cartCount\":" + cartCount + "}");
    }

    @Override
    public void init() {
        cartDAO = new CartDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            if (isAjax(request)) {
                writeCartJson(response, false, "Please login to add products to cart.", 0);
                return;
            }
            response.sendRedirect("login");
            return;
        }

        int userId = user.getUserId();
        String productIdParam = request.getParameter("productId");
        String action = request.getParameter("action");

        if ("remove".equals(action)) {

            int productId = Integer.parseInt(productIdParam);


            List<Cart> cartList = cartDAO.getCartByUser(userId);

            int qty = 0;
            for (Cart c : cartList) {
                if (c.getProductId() == productId) {
                    qty = c.getQuantity();
                    break;
                }
            }


            ProductDAO pdao = new ProductDAOImpl();
            pdao.updateStock(productId, qty);

            cartDAO.removeItem(userId, productId);

            response.sendRedirect("cart");
            return;
        }
        if ("update".equals(action)) {

            int productId = Integer.parseInt(productIdParam);
            int change = Integer.parseInt(request.getParameter("change"));

            ProductDAO pdao = new ProductDAOImpl();
            Product product = pdao.getProductById(productId);

            List<Cart> cartList = cartDAO.getCartByUser(userId);

            int currentQty = 0;
            for (Cart c : cartList) {
                if (c.getProductId() == productId) {
                    currentQty = c.getQuantity();
                    break;
                }
            }


            if (change > 0 && product.getStockQuantity() <= 0) {
                response.sendRedirect("cart?error=stock_limit");
                return;
            }

            cartDAO.updateQuantity(userId, productId, change);

            pdao.updateStock(productId, -change);


            response.sendRedirect("cart");
            return;
        }
        if (productIdParam != null && action == null) {

            int productId = Integer.parseInt(productIdParam);

            int quantity = 1;
            String qtyParam = request.getParameter("quantity");

            if (qtyParam != null && !qtyParam.isEmpty()) {
                quantity = Integer.parseInt(qtyParam);
            }


            ProductDAO pdao = new ProductDAOImpl();
            Product product = pdao.getProductById(productId);

            if (product == null || product.getStockQuantity() <= 0) {
                if (isAjax(request)) {
                    writeCartJson(response, false, "This product is currently out of stock.", cartDAO.getCartByUser(userId).size());
                    return;
                }
                response.sendRedirect("products?id=" + productId + "&error=out_of_stock");
                return;
            }


            if (quantity > product.getStockQuantity()) {
                if (isAjax(request)) {
                    writeCartJson(response, false, "Only " + product.getStockQuantity() + " items are available.", cartDAO.getCartByUser(userId).size());
                    return;
                }
                response.sendRedirect("products?id=" + productId + "&error=limit&quantity=" + quantity);
                return;
            }

            cartDAO.addToCart(userId, productId, quantity);


            pdao.updateStock(productId, -quantity);

            List<Cart> updatedCart = cartDAO.getCartByUser(userId);
            request.getSession().setAttribute("cartCount", updatedCart.size());

            if (isAjax(request)) {
                writeCartJson(response, true, "Added to cart successfully", updatedCart.size());
                return;
            }

            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null && !referer.trim().isEmpty() ? referer : "products");
            return;
        }

            List<Cart> cartList = cartDAO.getCartByUser(userId);
        request.setAttribute("cartList", cartList);

        double total = 0;
        for (Cart c : cartList) {
            total += c.getPrice() * c.getQuantity();
        }

        request.getSession().setAttribute("total", total);
        request.getSession().setAttribute("cartCount", cartList.size());

        request.getRequestDispatcher("/WEB-INF/views/cart.jsp")
               .forward(request, response);
    }
}
