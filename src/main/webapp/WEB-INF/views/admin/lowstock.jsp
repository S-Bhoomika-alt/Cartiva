<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cartiva.model.Product" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="admin-dashboard admin-feature-page">

    <div class="dashboard-top premium-admin-hero">
        <span class="admin-breadcrumb">Admin / Inventory</span>
        <h1>Low Stock Products</h1>
        <a href="<%=request.getContextPath()%>/admin"
   class="back-btn dashboard-back-btn">

   ⬅ Back to Dashboard

</a>
        <p>Products at 10 units or below that need restocking</p>
    </div>

    <div class="inventory-table-card">

    <table class="product-table low-stock-table">
        <colgroup>
            <col class="col-stock-id">
            <col class="col-stock-product">
            <col class="col-stock-category">
            <col class="col-stock-health">
        </colgroup>

        <thead>
        <tr>
            <th>ID</th>
            <th>Product</th>
            <th>Category</th>
            <th>Stock Health</th>
        </tr>
        </thead>

        <tbody>

        <%
            List<Product> products =
                (List<Product>)request.getAttribute("lowStockProducts");

            if(products != null && !products.isEmpty()){

                for(Product p : products){
                    int stock = p.getStockQuantity();
                    int stockPercent = stock <= 0 ? 0 : Math.max(0, Math.min(100, stock * 10));
                    String stockClass = stock <= 0 ? "out" : (stock <= 10 ? "low" : "healthy");
                    String stockLabel = stock <= 0 ? "Out of Stock" : (stock <= 10 ? "Low Stock" : "Healthy");
        %>

        <tr>

            <td><%= p.getProductId() %></td>

            <td>
                <div class="inventory-product-cell">
                    <div class="inventory-thumb premium-inventory-thumb">
                        <%
                            String imgSrc = request.getContextPath() + "/assets/images/default.png";
                            String imgUrl = p.getImageUrl();
                            if (imgUrl != null && !imgUrl.trim().isEmpty()) {
                                String lower = imgUrl.toLowerCase();
                                if (lower.startsWith("http://") || lower.startsWith("https://")) {
                                    imgSrc = imgUrl;
                                } else {
                                    String realPath = application.getRealPath("/" + imgUrl);
                                    java.io.File f = (realPath != null) ? new java.io.File(realPath) : null;
                                    if (f != null && f.exists()) {
                                        imgSrc = request.getContextPath() + "/" + imgUrl;
                                    } else {
                                        String alt = application.getRealPath("/assets/images/" + imgUrl);
                                        java.io.File f2 = (alt != null) ? new java.io.File(alt) : null;
                                        if (f2 != null && f2.exists()) {
                                            imgSrc = request.getContextPath() + "/assets/images/" + imgUrl;
                                        }
                                    }
                                }
                            }
                        %>
                        <img src="<%= imgSrc %>"
                             alt="<%= p.getName() %>"
                             onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/assets/images/default.png';">
                    </div>
                    <div>
                        <strong><%= p.getName() %></strong>
                        <small>Product ID #<%= p.getProductId() %></small>
                    </div>
                </div>
            </td>

            <td><%= p.getCategory() %></td>

            <td>
                <div class="stock-cell">
                    <div class="stock-cell-top">
                        <span class="stock-status-badge <%= stockClass %>"><%= stockLabel %></span>
                        <strong><%= stock %> units</strong>
                    </div>
                    <div class="stock-meter">
                        <span class="<%= stockClass %>" style="width:<%= stockPercent %>%;"></span>
                    </div>
                </div>
            </td>

        </tr>

        <%
                }
            } else {
        %>

        <tr>
            <td colspan="4">
                <div class="empty-inventory-state">
                    <h3>Inventory looks healthy</h3>
                    <p>No products are currently at or below the 10-unit low-stock threshold.</p>
                </div>
            </td>
        </tr>

        <%
            }
        %>

        </tbody>

    </table>

    </div>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
