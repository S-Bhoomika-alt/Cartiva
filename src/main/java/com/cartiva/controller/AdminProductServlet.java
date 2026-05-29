package com.cartiva.controller;

import java.io.IOException;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.cartiva.dao.ProductDAO;
import com.cartiva.dao.impl.ProductDAOImpl;
import com.cartiva.model.Product;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private ProductDAO dao = new ProductDAOImpl();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");

        List<Product> products;

        if ((keyword != null && !keyword.isEmpty()) ||
            (category != null && !category.isEmpty())) {

            products = dao.searchProducts(keyword, category);

        } else {
            products = dao.getAllProducts();
        }

        req.setAttribute("products", products);

        req.getRequestDispatcher("/WEB-INF/views/admin/adminproducts.jsp")
           .forward(req, res);
    }
}