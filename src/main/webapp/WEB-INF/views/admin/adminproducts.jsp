<%@ page import="java.util.List" %>
<%@ page import="com.cartiva.model.Product" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container admin-feature-page">

<div class="admin-feature-header">
<span class="admin-breadcrumb">Admin / Products</span>
<h2>Manage Products</h2>
</div>

<a href="<%= request.getContextPath() %>/admin" class="back-btn">
    ⬅ Back to Dashboard
</a>

<a href="<%= request.getContextPath() %>/admin/add-product" class="add-btn">
    ➕ Add Product
</a>

<br><br>
<form method="get" action="<%= request.getContextPath() %>/admin/products" class="filter-bar admin-products-filter">

    <input type="text" name="keyword" placeholder="Search product name...">

    <select name="category">
        <option value="">All Categories</option>
        <option value="Fruits">Fruits</option>
        <option value="Vegetables">Vegetables</option>
        <option value="Dairy">Dairy</option>
        <option value="Snacks">Snacks</option>
    </select>

    <button type="submit">Search</button>

</form>

<div class="admin-table-scroll">
<table class="admin-table admin-products-table">
<colgroup>
    <col class="col-product-id">
    <col class="col-product-name">
    <col class="col-product-price">
    <col class="col-product-action">
</colgroup>
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Price</th>
    <th style="text-align:center;">Action</th>
</tr>

<%
List<Product> list = (List<Product>) request.getAttribute("products");

if(list != null){
for(Product p : list){
%>

<tr>
<td><%= p.getProductId() %></td>
<td><%= p.getName() %></td>
<td>₹<%= p.getPrice() %></td>

<td>
    <div class="action-buttons">
        <a href="<%= request.getContextPath() %>/admin/edit-product?id=<%= p.getProductId() %>"
   class="btn edit-btn"
   onclick="return confirmEdit()">
   ✏ Edit
</a>

        <a href="<%= request.getContextPath() %>/admin/delete-product?id=<%= p.getProductId() %>"
   class="btn delete-btn"
   onclick="return confirmDelete()">
   🗑 Delete
</a>
    </div>
</td>
</tr>

<%
}
}
%>

</table>
</div>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
