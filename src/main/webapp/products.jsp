<%@ page import="java.util.*, com.cartiva.model.Product" %>

<%@ include file="/WEB-INF/views/partials/header.jsp" %>
<%@ include file="/WEB-INF/views/partials/navbar.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">

    <h2 class="section-title">Fresh Products</h2>

    <div class="product-grid">

        <%
            List<Product> products = (List<Product>) request.getAttribute("products");

            if(products != null) {
                for(Product p : products) {
        %>

        <div class="card">

            <img src="assets/images/<%= p.getImageUrl() %>" alt="product">

            <h3><%= p.getName() %></h3>

            <p class="category"><%= p.getCategory() %></p>

            <p class="price">₹ <%= p.getPrice() %></p>

            <button>Add to Cart</button>

        </div>

        <%
                }
            } else {
        %>
            <p>No products found!</p>
        <%
            }
        %>

    </div>

</div>

<%@ include file="WEB-INF/views/partials/footer.jsp" %>