package com.cartiva.controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.UserDAO;
import com.cartiva.dao.impl.UserDAOImpl;
import com.cartiva.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");


        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            response.sendRedirect("login?error=missing_fields");
            return;
        }

        try {
            User user = userDAO.loginUser(email, password);

            if (user != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);

                session.setMaxInactiveInterval(30 * 60);

                System.out.println("LoginServlet: user logged in -> " + user.getEmail());
                response.sendRedirect("home");
            } else {

                System.out.println("LoginServlet: user not found -> " + email);
                response.sendRedirect("login?error=user_not_found");
            }

        } catch (RuntimeException e) {
            if ("INVALID_PASSWORD".equals(e.getMessage())) {
                System.out.println("LoginServlet: invalid password for " + email);
                response.sendRedirect("login?error=invalid_password");
            } else {
                e.printStackTrace();
                response.sendRedirect("login?error=true");
            }
        }
    }
}