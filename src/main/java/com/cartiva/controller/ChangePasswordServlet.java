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

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/change-password.jsp")
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

        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");


        try {
            User validUser = userDAO.loginUser(user.getEmail(), oldPass);

            if (validUser != null) {
                boolean ok = userDAO.updatePassword(user.getUserId(), newPass);
                if (ok) {
                    session.setAttribute("successMsg", "Password updated successfully!");
                } else {
                    session.setAttribute("errorMsg", "Failed to update password. Try again.");
                }
            } else {
                session.setAttribute("errorMsg", "Incorrect old password!");
            }

        } catch (RuntimeException re) {

            if ("INVALID_PASSWORD".equals(re.getMessage())) {
                session.setAttribute("errorMsg", "Incorrect old password!");
            } else {
                re.printStackTrace();
                session.setAttribute("errorMsg", "An error occurred. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "An error occurred. Please try again.");
        }

        res.sendRedirect("profile");
    }
}