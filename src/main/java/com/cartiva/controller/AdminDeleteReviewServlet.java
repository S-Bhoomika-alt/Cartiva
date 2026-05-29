package com.cartiva.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.cartiva.dao.ReviewDAO;
import com.cartiva.dao.impl.ReviewDAOImpl;

@WebServlet("/admin/reviews/delete")
public class AdminDeleteReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        reviewDAO = new ReviewDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("reviewId");
        try {
            int id = Integer.parseInt(idStr);
            reviewDAO.deleteReview(id);
        } catch (Exception e) {

            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/reviews");
    }
}
