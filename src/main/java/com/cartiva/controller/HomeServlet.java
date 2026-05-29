package com.cartiva.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.ProductDAO;
import com.cartiva.dao.impl.ProductDAOImpl;
import com.cartiva.model.Product;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> allProducts = productDAO.getAllProducts();

        List<Product> latestProducts = allProducts.size() > 6
                ? allProducts.subList(0, 6)
                : allProducts;

        request.setAttribute("latestProducts", latestProducts);

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/home.jsp");
        rd.forward(request, response);
    }
}