package com.cartiva.controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.ProductDAO;
import com.cartiva.dao.impl.ProductDAOImpl;

@WebServlet("/admin/delete-product")
public class AdminDeleteProductServlet extends HttpServlet {

    private ProductDAO dao = new ProductDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        dao.deleteProduct(id);

        res.sendRedirect(req.getContextPath() + "/admin/products?success=true");
    }
}