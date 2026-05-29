package com.cartiva.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.cartiva.dao.UserDAO;
import com.cartiva.dao.impl.UserDAOImpl;
import com.cartiva.model.User;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
    	HttpSession session = req.getSession();
    	User user = (User) session.getAttribute("user");

    	if(user == null){
    	    res.sendRedirect("login");
    	    return;
    	}

        req.getRequestDispatcher("/WEB-INF/views/profile.jsp")
           .forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if(user == null){
            res.sendRedirect("login");
            return;
        }

        user.setFullName(req.getParameter("full_name"));
        user.setPhone(req.getParameter("phone"));
        user.setAddressLine1(req.getParameter("address_line1"));
        user.setAddressLine2(req.getParameter("address_line2"));
        user.setCity(req.getParameter("city"));
        user.setState(req.getParameter("state"));
        user.setPincode(req.getParameter("pincode"));
        user.setCountry(req.getParameter("country"));

        boolean updated = userDAO.updateUser(user);
        session.setAttribute("user", user);

        if(updated){
            session.setAttribute("successMsg", "Profile updated successfully!");
        }else{
            session.setAttribute("errorMsg", "Failed to update profile!");
        }
        res.sendRedirect("profile");

    }
}