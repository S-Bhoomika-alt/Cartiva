package com.cartiva.controller;

import java.io.IOException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.cartiva.dao.UserDAO;
import com.cartiva.dao.impl.UserDAOImpl;
import com.cartiva.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/register.jsp")
               .forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String pincode = request.getParameter("pincode");
        String address1 = request.getParameter("address1");
        String address2 = request.getParameter("address2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String country = request.getParameter("country");


        if (name == null || name.trim().length() < 3) {
            response.sendRedirect("register?error=invalid_name");
            return;
        }

        if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            response.sendRedirect("register?error=invalid_email");
            return;
        }

        if (phone == null || !phone.matches("\\d{10}")) {
            response.sendRedirect("register?error=invalid_phone");
            return;
        }

        if (password == null || password.length() < 6) {
            response.sendRedirect("register?error=invalid_password");
            return;
        }
        if (pincode != null && !pincode.isEmpty() && !pincode.matches("\\d{6}")) {
            response.sendRedirect("register?error=invalid_pincode");
            return;
        }

        if (isBlank(address1) || isBlank(address2) || isBlank(city) || isBlank(state) || isBlank(country)) {
            response.sendRedirect("register?error=invalid_address");
            return;
        }

        User user = new User();

        user.setFullName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setPassword(request.getParameter("password"));


        user.setAddressLine1(address1.trim());
        user.setAddressLine2(address2.trim());
        user.setCity(city.trim());
        user.setState(state.trim());
        user.setPincode(request.getParameter("pincode"));
        user.setCountry(country.trim());

        boolean status = userDAO.registerUser(user);

        if (status) {
            response.sendRedirect("login");
        } else {
            response.sendRedirect("register?error=true");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
