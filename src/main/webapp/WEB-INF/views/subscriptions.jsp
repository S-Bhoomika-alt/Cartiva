<%@ page import="java.util.*, com.cartiva.model.Subscription" %>
<%@ page import="java.sql.*, com.cartiva.model.User, com.cartiva.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container subscriptions-page premium-commerce-page admin-feature-page">
<%
    User currentUser = (User) session.getAttribute("user");
    boolean isAdminSubscriptionView = currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole());
%>

<% if(isAdminSubscriptionView) { %>
    <div class="admin-feature-header">
        <span class="admin-breadcrumb">Admin / Subscriptions</span>
        <h2 class="section-title">Subscription Management</h2>
    </div>

    <a href="<%=request.getContextPath()%>/admin"
       class="back-btn dashboard-back-btn premium-back-button">
       <span class="back-icon">←</span> Back to Dashboard
    </a>

    <div class="admin-subscription-grid">
    <%
        boolean hasSubscriptions = false;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT s.*, u.full_name, p.name AS product_name, p.price " +
                "FROM subscriptions s " +
                "JOIN users u ON s.user_id = u.user_id " +
                "JOIN products p ON s.product_id = p.product_id " +
                "ORDER BY s.start_date DESC, s.subscription_id DESC");
             ResultSet rs = ps.executeQuery()) {
            while(rs.next()) {
                hasSubscriptions = true;
                String frequency = rs.getString("frequency") != null ? rs.getString("frequency") : "DAILY";
                String status = rs.getString("status") != null ? rs.getString("status") : "ACTIVE";
                java.sql.Date startDate = rs.getDate("start_date");
                String nextDelivery = "Upcoming";
                if(startDate != null) {
                    java.time.LocalDate next = startDate.toLocalDate();
                    if("WEEKLY".equalsIgnoreCase(frequency)) {
                        next = next.plusWeeks(1);
                    } else if("MONTHLY".equalsIgnoreCase(frequency)) {
                        next = next.plusMonths(1);
                    } else {
                        next = next.plusDays(1);
                    }
                    nextDelivery = next.toString();
                }
    %>
        <article class="admin-subscription-card">
            <div class="subscription-product-icon">
                <%= rs.getString("product_name") != null ? rs.getString("product_name").substring(0,1).toUpperCase() : "S" %>
            </div>
            <div class="admin-subscription-main">
                <span class="admin-subscription-customer"><%= rs.getString("full_name") != null ? rs.getString("full_name") : "Customer" %></span>
                <h3><%= rs.getString("product_name") %></h3>
                <div class="admin-subscription-meta">
                    <span>Qty <%= rs.getInt("quantity") %></span>
                    <span>₹<%= rs.getDouble("price") %></span>
                    <span>Next <%= nextDelivery %></span>
                </div>
            </div>
            <div class="activity-badges">
                <span class="activity-status-badge frequency"><%= frequency %></span>
                <span class="activity-status-badge <%= status.toLowerCase() %>"><%= status %></span>
            </div>
        </article>
    <%
            }
        } catch(Exception e) {
            e.printStackTrace();
        }

        if(!hasSubscriptions) {
    %>
        <div class="premium-empty-state subscription-empty">
            <strong>No customer subscriptions yet</strong>
            <span>Recurring delivery plans will appear here when customers subscribe.</span>
        </div>
    <%
        }
    %>
    </div>

<% } else { %>
    <div class="admin-feature-header">
        <span class="admin-breadcrumb">Account / Subscriptions</span>
        <h2 class="section-title">🔁 My Subscriptions</h2>
    </div>
    <a href="<%=request.getContextPath()%>/home"
   class="back-btn dashboard-back-btn">

   ⬅ Back to Home

</a>

    <%
        List<Subscription> subs = (List<Subscription>) request.getAttribute("subscriptions");
    %>

    <% if (subs != null && !subs.isEmpty()) { %>

    <div class="customer-table-scroll">
        <div class="subscription-list">
            <div class="subscription-list-header">
                <span>Product</span>
                <span>Price</span>
                <span>Quantity</span>
                <span>Frequency</span>
                <span>Next Delivery</span>
                <span>Actions</span>
            </div>
            <% for (Subscription s : subs) { %>
                <div class="subscription-row">
                    <% String subscriptionFormId = "subscription-update-" + s.getSubscriptionId(); %>
                    <div class="subscription-product-cell">
                        <div class="subscription-product-icon"><%= s.getProductName().substring(0,1).toUpperCase() %></div>
                        <div>
                            <strong><%= s.getProductName() %></strong>
                            <span>Dairy subscription</span>
                        </div>
                    </div>

                    <div class="subscription-price-cell">₹<%= s.getPrice() %></div>

                    <div class="subscription-control-cell">
                        <form id="<%= subscriptionFormId %>" action="subscriptions" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= s.getSubscriptionId() %>">
                            <input type="number" name="quantity" value="<%= s.getQuantity() %>" min="1">
                        </form>
                    </div>

                    <div class="subscription-frequency-cell">
                        <select name="frequency" form="<%= subscriptionFormId %>">
                            <option value="DAILY" <%= s.getFrequency().equals("DAILY") ? "selected" : "" %>>Daily</option>
                            <option value="WEEKLY" <%= s.getFrequency().equals("WEEKLY") ? "selected" : "" %>>Weekly</option>
                        </select>
                    </div>

                    <div class="subscription-delivery-cell">
                        <span><%= s.getFrequency().equals("DAILY") ? "Tomorrow" : "Next Week" %></span>
                    </div>

                    <div class="subscription-actions-cell">
                        <button type="submit" form="<%= subscriptionFormId %>" class="subscription-update-btn">Update</button>
                        <a href="subscriptions?action=cancel&id=<%= s.getSubscriptionId() %>" onclick="return confirm('Cancel this subscription?')" class="subscription-cancel-btn">Cancel</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <% } else { %>
        <div class="premium-empty-state subscription-empty">
            <strong>No subscriptions yet</strong>
            <span>Subscribe to dairy products for effortless recurring deliveries.</span>
        </div>
    <% } %>
<% } %>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
