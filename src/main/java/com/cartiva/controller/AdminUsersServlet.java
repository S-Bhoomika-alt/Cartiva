package com.cartiva.controller;

import java.io.IOException;
import java.util.List;

import com.cartiva.dao.UserDAO;
import com.cartiva.dao.impl.UserDAOImpl;
import com.cartiva.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAOImpl();

        List<User> users = userDAO.getAllUsers();

        request.setAttribute("users", users);

        request.getRequestDispatcher(
            "/WEB-INF/views/admin/users.jsp")
            .forward(request, response);
    }
}