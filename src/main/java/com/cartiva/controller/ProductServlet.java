package com.cartiva.controller;

import java.io.IOException;
import com.cartiva.util.DBConnection;
import java.util.ArrayList;
import java.util.List;
import java.sql.PreparedStatement;
import java.sql.*;


import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.ProductDAO;
import com.cartiva.dao.impl.ProductDAOImpl;
import com.cartiva.model.Product;

@WebServlet({"/products","/product"})
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");


        if (idParam != null) {

            int productId = Integer.parseInt(idParam);

            Product product = productDAO.getProductById(productId);

            request.setAttribute("product", product);

            RequestDispatcher rd =
                    request.getRequestDispatcher("/WEB-INF/views/product-details.jsp");

            rd.forward(request, response);
            return;
        }


        String category = request.getParameter("category");
        String keyword = request.getParameter("search");
        String sort = request.getParameter("sort");


        int page = 1;
        int pageSize = 12;
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");
        try { if (pageParam != null) page = Integer.parseInt(pageParam); } catch(Exception e) {}
        try { if (sizeParam != null) pageSize = Integer.parseInt(sizeParam); } catch(Exception e) {}

        int offset = (page - 1) * pageSize;

        List<Product> products = productDAO.getProducts(keyword, category, sort, offset, pageSize);

        int total = productDAO.getProductsCount(keyword, category);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("sort", sort);

        RequestDispatcher rd =
                request.getRequestDispatcher("/WEB-INF/views/products.jsp");

        rd.forward(request, response);
    }

}