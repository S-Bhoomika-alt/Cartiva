<%@ page import="java.util.*, com.cartiva.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container orders-page premium-commerce-page">

<div class="commerce-page-header">
    <span class="admin-breadcrumb">Account / Orders</span>
    <h2 class="section-title">Your Orders</h2>
    <p>Track purchases, delivery progress and order history in one place.</p>
    <button type="button"
            class="premium-back-button"
            onclick="CartivaGoBack('<%= request.getContextPath() %>/home')">
        <span class="back-icon">←</span>
        Back
    </button>
</div>


<%
    String cancelError = (String) session.getAttribute("cancelError");
    if(cancelError != null){
%>
    <p class="profile-alert error"><%= cancelError %></p>
<%
        session.removeAttribute("cancelError");
    }
%>

<div class="account-table-scroll">
<div class="account-table account-orders-grid">
    <div class="account-table-header">
        <div>Order ID</div>
        <div>Total</div>
        <div>Status</div>
        <div>Date</div>
    </div>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");

    if(orders != null && !orders.isEmpty()){
        for(Order o : orders){

        String status = o.getStatus();
%>

    <div class="account-table-row">
        <div class="account-cell order-id-cell">
            <a href="<%= request.getContextPath() %>/order-details?orderId=<%= o.getOrderId() %>"
               class="account-order-link">
                #<%= o.getOrderId() %>
            </a>
        </div>
        <div class="account-cell amount-cell">&#8377;<%= o.getTotalAmount() %></div>
        <div class="account-cell status-cell">


<div class="status-track status-badge-group">

    <span class="<%= "PLACED".equalsIgnoreCase(o.getStatus()) ? "active" : "" %>">Placed</span>
<span class="<%= "SHIPPED".equalsIgnoreCase(o.getStatus()) ? "active" : "" %>">Shipped</span>
<span class="<%= "DELIVERED".equalsIgnoreCase(o.getStatus()) ? "active" : "" %>">Delivered</span>

</div>


<% if("PLACED".equalsIgnoreCase(status)) { %>
    <a href="<%= request.getContextPath() %>/orders?action=cancel&orderId=<%= o.getOrderId() %>"
       class="cancel-link">
        Cancel Order
    </a>

<% } else if("CANCELLED".equals(status)) { %>

    <span class="cancelled">Cancelled ❌</span>

<% } else if("DELIVERED".equals(status)) { %>

    <span class="delivered">Delivered ✔</span>
    <a href="<%= request.getContextPath() %>/order-details?orderId=<%= o.getOrderId() %>"
       class="cancel-link">
        Write/Edit Reviews
    </a>

<% } %>

        </div>
        <div class="account-cell date-cell"><%= o.getOrderDate().toString().replace("T"," ") %></div>
    </div>

<%
        }
    } else {
%>

    <div class="premium-empty-state account-empty-state">
        <strong>No orders yet</strong>
        <span>Your fresh grocery orders will appear here after checkout.</span>
    </div>

<%
    }
%>

</div>
</div>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
