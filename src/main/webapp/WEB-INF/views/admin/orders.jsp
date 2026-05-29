

<%@ page import="java.util.*, com.cartiva.model.Order" %>
<%@ page import="java.sql.*, com.cartiva.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container admin-feature-page">

<%
    String currentStatusFilter = request.getParameter("status") != null ? request.getParameter("status") : "";
    String currentPaymentFilter = request.getParameter("paymentStatus") != null ? request.getParameter("paymentStatus") : "";
    String currentKeyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
%>

<div class="admin-feature-header">
    <div>
        <span class="admin-breadcrumb">Admin / Orders</span>
        <h2>Manage Orders</h2>
        <p>Search, filter and update customer order fulfillment.</p>
    </div>
</div>

<a href="<%= request.getContextPath() %>/admin" class="back-btn">
    ⬅ Back to Dashboard
</a>

<br><br>
<form method="get" action="<%= request.getContextPath() %>/admin/orders" class="filter-bar admin-orders-filter" id="adminOrderFilterForm">

    <input type="text" name="keyword" placeholder="Search by Order ID or User ID" value="<%= currentKeyword %>">
    <select name="paymentStatus" id="adminPaymentSelect" aria-label="Filter orders by payment status">
        <option value="" <%= currentPaymentFilter.isEmpty() ? "selected" : "" %>>All Payment</option>
        <option value="COD" <%= "COD".equalsIgnoreCase(currentPaymentFilter) ? "selected" : "" %>>COD</option>
        <option value="ONLINE" <%= "ONLINE".equalsIgnoreCase(currentPaymentFilter) ? "selected" : "" %>>Online</option>
    </select>
    <select name="status" class="admin-status-select" id="adminStatusSelect" aria-label="Filter orders by status">
        <option value="" <%= currentStatusFilter.isEmpty() ? "selected" : "" %>>All Delivery</option>
        <option value="PLACED" <%= "PLACED".equals(currentStatusFilter) ? "selected" : "" %>>Pending</option>
        <option value="PROCESSING" <%= "PROCESSING".equals(currentStatusFilter) ? "selected" : "" %>>Processing</option>
        <option value="SHIPPED" <%= "SHIPPED".equals(currentStatusFilter) ? "selected" : "" %>>Shipped</option>
        <option value="DELIVERED" <%= "DELIVERED".equals(currentStatusFilter) ? "selected" : "" %>>Delivered</option>
        <option value="CANCELLED" <%= "CANCELLED".equals(currentStatusFilter) ? "selected" : "" %>>Cancelled</option>
        <option value="REFUNDED" <%= "REFUNDED".equals(currentStatusFilter) ? "selected" : "" %>>Refunded</option>
    </select>

    <button type="submit">Search</button>

</form>

<div class="admin-table-scroll">
<table class="admin-table admin-orders-table">
<colgroup>
    <col class="col-order-id">
    <col class="col-customer">
    <col class="col-products">
    <col class="col-payment">
    <col class="col-delivery">
    <col class="col-date">
    <col class="col-amount">
    <col class="col-action">
</colgroup>
<tr>
    <th>Order ID</th>
    <th>Customer</th>
    <th>Products</th>
    <th>Payment Status</th>
    <th>Delivery Status</th>
    <th>Order Date</th>
    <th>Total Amount</th>
    <th>Action</th>
</tr>

<%
List<Order> list = (List<Order>) request.getAttribute("orders");

if(list != null){
for(Order o : list){
%>

<tr data-payment="<%= "COD".equalsIgnoreCase(o.getPaymentMode()) ? "COD" : "ONLINE" %>">
<%
    String customerName = "User #" + o.getUserId();
    String productSummary = "No items";
    try (Connection con = DBConnection.getConnection()) {
        PreparedStatement cps = con.prepareStatement("SELECT full_name FROM users WHERE user_id=?");
        cps.setInt(1, o.getUserId());
        ResultSet crs = cps.executeQuery();
        if(crs.next() && crs.getString("full_name") != null) {
            customerName = crs.getString("full_name");
        }

        PreparedStatement ips = con.prepareStatement(
            "SELECT p.name, oi.quantity FROM order_items oi " +
            "JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id=?");
        ips.setInt(1, o.getOrderId());
        ResultSet irs = ips.executeQuery();
        StringBuilder items = new StringBuilder();
        while(irs.next()) {
            if(items.length() > 0) items.append(", ");
            items.append(irs.getString("name")).append(" x").append(irs.getInt("quantity"));
        }
        if(items.length() > 0) productSummary = items.toString();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<td><strong>#<%= o.getOrderId() %></strong></td>
<td><%= customerName %></td>
<td class="admin-order-products"><%= productSummary %></td>

<td>
<%
String payment = o.getPaymentMode();

if ("COD".equalsIgnoreCase(payment)) {
%>
    <span class="status payment-cod">COD</span>
<%
} else {
%>
    <span class="status payment-online">ONLINE</span>
<%
}
%>
</td>


<td>
<%
String status = o.getStatus();

if("PLACED".equalsIgnoreCase(status)) {
%>
<span class="status placed">Placed</span>

<% } else if("SHIPPED".equalsIgnoreCase(status)) { %>

<span class="status shipped">Shipped</span>

<% } else if("DELIVERED".equalsIgnoreCase(status)) { %>

<span class="status delivered">Delivered</span>

<% } else if("CANCELLED".equalsIgnoreCase(status)) { %>

<span class="status cancelled">Cancelled</span>

<% } else if("REFUNDED".equalsIgnoreCase(status)) { %>

<span class="status refunded">Refunded</span>

<% } else { %>

<span style="color:gray;">Unknown</span>

<% } %>
</td>

<td><%= o.getOrderDate() != null ? o.getOrderDate().toString().replace("T"," ") : "-" %></td>
<td>₹<%= o.getTotalAmount() %></td>


<td>
<div class="action-buttons">

<% if("PLACED".equalsIgnoreCase(status)) { %>

<form action="<%= request.getContextPath() %>/admin/orders" method="post">
    <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
    <input type="hidden" name="action" value="ship">
    <button type="submit" class="btn btn-ship">Ship</button>
</form>

<% } else if("SHIPPED".equalsIgnoreCase(status)) { %>

<form action="<%= request.getContextPath() %>/admin/orders" method="post">
    <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
    <input type="hidden" name="action" value="deliver">
    <button type="submit" class="btn btn-deliver">Deliver</button>
</form>

<% } else if("CANCELLED".equalsIgnoreCase(status)) { %>

<% if(!"COD".equalsIgnoreCase(payment)) { %>
<form action="<%= request.getContextPath() %>/admin/orders" method="post">
    <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
    <input type="hidden" name="action" value="refund">

    <button type="submit" class="btn" style="background:red;"
            onclick="return confirm('confirm refund ?')">
        Refund
    </button>
</form>

<% } else { %>

<span style="color:gray;">No Refund (COD)</span>

<% } %>

<% } else if("DELIVERED".equalsIgnoreCase(status)) { %>

<span style="color:green;">No Action</span>

<% } else if("REFUNDED".equalsIgnoreCase(status)) { %>

<span class="status refunded" style="color:green;">Refunded</span>

<% } %>

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

<script>
document.addEventListener('DOMContentLoaded', function(){
    var paymentSelect = document.getElementById('adminPaymentSelect');
    if(!paymentSelect) return;
    var selectedPayment = paymentSelect.value;
    if(!selectedPayment) return;

    document.querySelectorAll('.admin-orders-table tr[data-payment]').forEach(function(row){
        row.style.display = row.getAttribute('data-payment') === selectedPayment ? '' : 'none';
    });
});
</script>
