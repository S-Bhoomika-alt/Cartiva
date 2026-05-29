<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cartiva.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    String currentPath = request.getRequestURI();
    boolean isAdmin = user != null && "ADMIN".equalsIgnoreCase(user.getRole());
%>

<nav class="navbar">
    <div class="container">

        <a href="<%= request.getContextPath() %>/<%= isAdmin ? "admin" : "home" %>" class="logo">
            <img src="<%= request.getContextPath() %>/assets/images/Logo.jpg"
                 class="logo-img"
                 alt="Cartiva Logo">
            <div class="logo-text">
                <div class="brand">Cartiva</div>
                <div class="tagline"><%= isAdmin ? "Admin Command Center" : "Fresh Grocery Everyday" %></div>
            </div>
        </a>

        <div class="nav-links <%= isAdmin ? "admin-nav-links" : "" %>">
            <% if(isAdmin) { %>
                <a href="<%= request.getContextPath() %>/admin"
                   class="<%= currentPath.endsWith("/admin") ? "active-link" : "" %>">Dashboard</a>
                <a href="<%= request.getContextPath() %>/admin/products"
                   class="<%= currentPath.contains("/admin/products") ? "active-link" : "" %>">Products</a>
                <a href="<%= request.getContextPath() %>/admin/orders"
                   class="<%= currentPath.contains("/admin/orders") ? "active-link" : "" %>">Orders</a>
                <a href="<%= request.getContextPath() %>/admin?view=revenue"
                   class="<%= "revenue".equals(request.getParameter("view")) ? "active-link" : "" %>">Revenue</a>
                <a href="<%= request.getContextPath() %>/admin/reviews"
                   class="<%= currentPath.contains("/admin/reviews") ? "active-link" : "" %>">Reviews</a>
                <a href="<%= request.getContextPath() %>/admin/low-stock"
                   class="<%= currentPath.contains("/admin/low-stock") ? "active-link" : "" %>">Low Stock</a>
                <a href="<%= request.getContextPath() %>/admin/users"
                   class="<%= currentPath.contains("/admin/users") ? "active-link" : "" %>">Customers</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/home"
                   class="<%= currentPath.contains("/home") ? "active-link" : "" %>">Home</a>
                <a href="<%= request.getContextPath() %>/products"
                   class="<%= currentPath.contains("/products") ? "active-link" : "" %>">Products</a>
                <a href="<%= request.getContextPath() %>/wishlist"
                   class="<%= currentPath.contains("/wishlist") ? "active-link" : "" %>">Wishlist</a>
                <a href="<%= request.getContextPath() %>/orders"
                   class="<%= currentPath.contains("/orders") ? "active-link" : "" %>">Orders</a>
                <a href="<%= request.getContextPath() %>/subscriptions"
                   class="<%= currentPath.contains("/subscriptions") ? "active-link" : "" %>">Subscriptions</a>

                <a href="<%= request.getContextPath() %>/cart"
                   class="cart-link <%= currentPath.contains("/cart") ? "active-link" : "" %>">
                    Cart
                    <%
                        Integer cartCount = (Integer) session.getAttribute("cartCount");
                        if(cartCount != null && cartCount > 0){
                    %>
                        <span class="cart-badge"><%= cartCount %></span>
                    <% } %>
                </a>
            <% } %>

            <% if(user != null){ %>
                <div class="profile-dropdown">
                    <div class="profile-btn">
                        <div class="profile-avatar admin-profile-avatar">
                            <%= user.getFullName().substring(0,1).toUpperCase() %>
                        </div>
                        <div class="profile-info">
                            <span class="profile-name"><%= user.getFullName() %></span>
                            <span class="profile-role"><%= isAdmin ? "Administrator" : "Customer" %></span>
                        </div>
                    </div>

                    <div class="profile-menu">
                        <% if(isAdmin) { %>
                            <a href="<%= request.getContextPath() %>/admin">Admin Dashboard</a>
                            <a href="<%= request.getContextPath() %>/admin/products">Manage Products</a>
                            <a href="<%= request.getContextPath() %>/admin/orders">Manage Orders</a>
                            <a href="<%= request.getContextPath() %>/admin?view=revenue">Revenue</a>
                        <% } else { %>
                            <a href="<%= request.getContextPath() %>/profile">My Profile</a>
                            <a href="<%= request.getContextPath() %>/orders">My Orders</a>
                            <a href="<%= request.getContextPath() %>/wishlist">Wishlist</a>
                            <a href="<%= request.getContextPath() %>/cart">Cart</a>
                            <a href="<%= request.getContextPath() %>/subscriptions">Subscriptions</a>
                        <% } %>
                        <a href="<%= request.getContextPath() %>/logout" class="logout-link">Logout</a>
                    </div>
                </div>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login">Login</a>
                <a href="<%= request.getContextPath() %>/register">Register</a>
            <% } %>
        </div>
    </div>
</nav>
