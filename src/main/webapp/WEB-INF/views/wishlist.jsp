<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.cartiva.model.Product" %>
<%@ page import="java.sql.*, com.cartiva.model.User, com.cartiva.util.DBConnection" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container wishlist-page premium-commerce-page">
<%
    User currentUser = (User) session.getAttribute("user");
    boolean isAdminWishlistView = currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole());
%>

    <div class="commerce-page-header">
        <span class="admin-breadcrumb"><%= isAdminWishlistView ? "Admin / Wishlist Activity" : "Account / Wishlist" %></span>
        <h2 class="section-title"><%= isAdminWishlistView ? "Customer Wishlist Activity" : "Your Wishlist" %></h2>
        <p><%= isAdminWishlistView ? "Review customer saved products and shopping intent across the store." : "Save favorites and move them to cart when you are ready." %></p>
    </div>
<% if(isAdminWishlistView) { %>
    <a href="<%=request.getContextPath()%>/admin"
       class="back-btn dashboard-back-btn premium-back-button">
       <span class="back-icon">←</span> Back to Dashboard
    </a>

    <div class="admin-activity-feed wishlist-admin-feed">
    <%
        boolean hasActivity = false;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT w.user_id, w.product_id, u.full_name, p.name AS product_name " +
                "FROM wishlist w " +
                "JOIN users u ON w.user_id = u.user_id " +
                "JOIN products p ON w.product_id = p.product_id " +
                "ORDER BY w.user_id DESC, w.product_id DESC");
             ResultSet rs = ps.executeQuery()) {
            while(rs.next()) {
                hasActivity = true;
    %>
        <div class="admin-activity-item">
            <div class="activity-avatar"><%= rs.getString("full_name") != null ? rs.getString("full_name").substring(0,1).toUpperCase() : "C" %></div>
            <div class="activity-copy">
                <strong><%= rs.getString("full_name") != null ? rs.getString("full_name") : "Customer" %></strong>
                <span>Saved <b><%= rs.getString("product_name") %></b> to wishlist</span>
                <small>Wishlist activity · Product #<%= rs.getInt("product_id") %></small>
            </div>
            <span class="activity-status-badge saved">Saved</span>
        </div>
    <%
            }
        } catch(Exception e) {
            e.printStackTrace();
        }

        if(!hasActivity) {
    %>
        <div class="premium-empty-state">
            <strong>No wishlist activity yet</strong>
            <span>Customer saved products will appear here.</span>
        </div>
    <%
        }
    %>
    </div>
<% } else { %>
    <a href="<%=request.getContextPath()%>/products"
   class="back-btn dashboard-back-btn premium-back-button">

   <span class="back-icon">←</span> Back to Products

</a>

    <div class="product-grid">

    <%
        List<Product> wishlist = (List<Product>) request.getAttribute("wishlist");

        if(wishlist != null && !wishlist.isEmpty()){
            for(Product p : wishlist){
    %>

        <div class="card">

            <a href="<%= request.getContextPath() %>/product?id=<%= p.getProductId() %>" class="img-link">
                <img class="product-img" src="<%= (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty())
                        ? request.getContextPath() + "/" + p.getImageUrl()
                        : request.getContextPath() + "/assets/images/default.png" %>"
                     alt="<%= p.getName() %>">
            </a>

            <div class="card-body">
                <a href="<%= request.getContextPath() %>/product?id=<%= p.getProductId() %>" class="title-link"><h3><%= p.getName() %></h3></a>
                <p class="price">₹<%= p.getPrice() %></p>

                <div class="wishlist-actions">
                    <a href="<%= request.getContextPath() %>/wishlist?action=remove&productId=<%= p.getProductId() %>" class="remove-btn">Remove</a>
                    <a href="<%= request.getContextPath() %>/wishlist?action=moveToCart&productId=<%= p.getProductId() %>" class="move-btn">Move to Cart</a>
                </div>
            </div>

        </div>

    <%
            }
        } else {
    %>
        <div class="premium-empty-state">
            <strong>Your wishlist is empty</strong>
            <span>Save products you love and return to them anytime.</span>
        </div>
    <%
        }
    %>

    </div>
<% } %>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
