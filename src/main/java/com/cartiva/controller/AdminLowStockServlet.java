package com.cartiva.controller;

import java.io.IOException;

import com.cartiva.dao.ProductDAO;
import com.cartiva.dao.impl.ProductDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/low-stock")
public class AdminLowStockServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO dao =
            new ProductDAOImpl();

        request.setAttribute(
            "lowStockProducts",
            dao.getLowStockProducts()
        );

        request.getRequestDispatcher(
        	    "/WEB-INF/views/admin/lowstock.jsp"
        	).forward(request, response);
    }
}