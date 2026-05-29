package com.cartiva.controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.ProductDAO;
import com.cartiva.dao.impl.ProductDAOImpl;
import com.cartiva.model.Product;

@WebServlet("/admin/edit-product")
public class AdminEditProductServlet extends HttpServlet {

    private ProductDAO dao = new ProductDAOImpl();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        Product p = dao.getProductById(id);

        req.setAttribute("product", p);

        req.getRequestDispatcher("/WEB-INF/views/admin/edit-product.jsp")
           .forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Product p = new Product();

        p.setProductId(Integer.parseInt(req.getParameter("id")));
        p.setName(req.getParameter("name"));
        p.setPrice(new java.math.BigDecimal(req.getParameter("price")));
        p.setCategory(req.getParameter("category"));
        p.setDescription(req.getParameter("description"));
        p.setStockQuantity(Integer.parseInt(req.getParameter("stock")));
        p.setImageUrl(req.getParameter("image"));

        dao.updateProduct(p);

        res.sendRedirect("products");
    }
}