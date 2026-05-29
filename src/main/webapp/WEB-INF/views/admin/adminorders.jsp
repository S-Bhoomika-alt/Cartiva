<%@ page import="java.util.*, com.cartiva.model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container admin-feature-page">

    <div class="admin-feature-header">
        <div>
            <span class="admin-breadcrumb">Admin / Orders</span>
            <h2 class="section-title">Manage Orders</h2>
            <p>Review order totals, delivery status and order dates.</p>
        </div>

        <a href="<%= request.getContextPath() %>/admin" class="premium-back-button">
            <span class="back-icon">←</span> Back to Dashboard
        </a>
    </div>

    <div class="table-container">
        <table class="admin-table admin-legacy-orders-table">
            <colgroup>
                <col class="col-legacy-id">
                <col class="col-legacy-user">
                <col class="col-legacy-total">
                <col class="col-legacy-status">
                <col class="col-legacy-date">
            </colgroup>
            <thead>
            <tr>
                <th>ID</th>
                <th>User ID</th>
                <th>Total</th>
                <th>Status</th>
                <th>Date</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Order> orders = (List<Order>) request.getAttribute("orders");

                if(orders != null && !orders.isEmpty()){
                    for(Order o : orders){
            %>
            <tr>
                <td>#<%= o.getOrderId() %></td>
                <td><%= o.getUserId() %></td>
                <td>&#8377;<%= o.getTotalAmount() %></td>
                <td><span class="status placed"><%= o.getStatus() %></span></td>
                <td><%= o.getOrderDate().toString().replace("T"," ") %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5">
                    <div class="premium-empty-state">
                        <strong>No orders found</strong>
                        <span>Customer orders will appear here when available.</span>
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
