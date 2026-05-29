package com.cartiva.controller;

import java.io.IOException;
import com.cartiva.dao.AdminStatsDAO;
import com.cartiva.dao.impl.AdminStatsDAOImpl;
import com.cartiva.dao.ProductDAO;
import com.cartiva.dao.impl.ProductDAOImpl;


import jakarta.servlet.ServletException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request,
	                     HttpServletResponse response)
	        throws ServletException, IOException {

	    AdminStatsDAO statsDAO =
	            new AdminStatsDAOImpl();

	    ProductDAO productDAO =
	            new ProductDAOImpl();
					com.cartiva.dao.ReviewDAO reviewDAO = new com.cartiva.dao.impl.ReviewDAOImpl();

	    request.setAttribute(
	            "totalUsers",
	            statsDAO.getTotalUsers());

	    request.setAttribute(
	            "totalProducts",
	            statsDAO.getTotalProducts());

	    request.setAttribute(
	            "totalOrders",
	            statsDAO.getTotalOrders());

	    request.setAttribute(
	            "totalRevenue",
	            statsDAO.getTotalRevenue());

	    request.setAttribute(
	            "dailyRevenue",
	            statsDAO.getDailyRevenue());

	    request.setAttribute(
	            "monthlyRevenue",
	            statsDAO.getMonthlyRevenue());

	    request.setAttribute(
	            "subscriptionRevenue",
	            statsDAO.getSubscriptionRevenue());

	    request.setAttribute(
	            "lowStock",
	            statsDAO.getLowStockProducts());

	    request.setAttribute(
	            "outOfStock",
	            statsDAO.getOutOfStockProducts());

	    request.setAttribute(
	            "wishlistCount",
	            statsDAO.getTotalWishlistItems());

	    request.setAttribute(
	            "subscriptionCount",
	            statsDAO.getTotalSubscriptions());


	    request.setAttribute(
	            "products",
	            productDAO.getAllProducts());


					int reviewCount = 0;
					try {
						java.util.List<com.cartiva.model.Review> all = reviewDAO.getAllReviews();
						if (all != null) reviewCount = all.size();
					} catch(Exception e) { }

					request.setAttribute("reviewCount", reviewCount);

	    request.getRequestDispatcher(
	            "/WEB-INF/views/admin/dashboard.jsp")
	            .forward(request, response);
	}
}
