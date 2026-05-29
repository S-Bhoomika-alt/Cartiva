package com.cartiva.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.UserDAO;
import com.cartiva.dao.impl.UserDAOImpl;
import com.cartiva.util.PasswordUtil;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
           .forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String newPassword = req.getParameter("newPassword");


        if (email == null || email.isBlank() || newPassword == null || newPassword.isBlank()) {
            System.out.println("ForgotPassword: missing email or password");
            res.sendRedirect("forgot-password?error=missing_fields");
            return;
        }


        if (!userDAO.emailExists(email)) {
            System.out.println("ForgotPassword: email not found -> " + email);
            res.sendRedirect("forgot-password?error=user_not_found");
            return;
        }


        boolean updated = userDAO.updatePasswordByEmail(email, newPassword);

        if (updated) {
            System.out.println("ForgotPassword: password updated for " + email);
            res.sendRedirect("login?reset=success");
        } else {
            System.out.println("ForgotPassword: failed to update password for " + email);
            res.sendRedirect("forgot-password?error=true");
        }
    }
}