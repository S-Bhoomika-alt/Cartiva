package com.cartiva.controller;

import java.io.IOException;


import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.ProductDAO;
import com.cartiva.dao.impl.ProductDAOImpl;
import com.cartiva.model.Product;

@WebServlet("/admin/add-product")
public class AdminAddProductServlet extends HttpServlet {

    private ProductDAO dao = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/admin/add-product.jsp")
           .forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Product p = new Product();

        p.setName(req.getParameter("name"));
        p.setPrice(new java.math.BigDecimal(req.getParameter("price")));
        p.setCategory(req.getParameter("category"));
        p.setDescription(req.getParameter("description"));
        p.setStockQuantity(Integer.parseInt(req.getParameter("stock")));
        p.setImageUrl(req.getParameter("image"));

        dao.addProduct(p);

        res.sendRedirect("products");
    }
}