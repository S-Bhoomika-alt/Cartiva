<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cartiva.model.Product" %>
<%@ page import="com.cartiva.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<%
    boolean revenueOnlyView = "revenue".equalsIgnoreCase(request.getParameter("view"));
%>

<div class="admin-dashboard premium-admin-dashboard <%= revenueOnlyView ? "revenue-only-dashboard" : "" %>">


    <div class="dashboard-top premium-admin-hero">
        <div>
            <span class="admin-breadcrumb">Admin / Overview</span>
            <h1><%= revenueOnlyView ? "Revenue Analytics" : "Admin Dashboard" %></h1>
            <p><%= revenueOnlyView ? "Track completed order revenue and payment performance." : "Monitor your grocery system analytics" %></p>
        </div>
        <% if(revenueOnlyView) { %>
            <a href="<%= request.getContextPath() %>/admin" class="premium-back-button">
                <span class="back-icon">←</span> Back to Dashboard
            </a>
        <% } %>
    </div>

    <div class="revenue-only-kpi-grid">
        <div class="revenue-kpi-card">
            <span>Total Revenue</span>
            <strong>₹ ${totalRevenue}</strong>
            <small>Delivered and non-refunded orders</small>
        </div>
        <div class="revenue-kpi-card">
            <span>Today</span>
            <strong>₹ ${dailyRevenue}</strong>
            <small>Completed today</small>
        </div>
        <div class="revenue-kpi-card">
            <span>This Month</span>
            <strong>₹ ${monthlyRevenue}</strong>
            <small>Current month revenue</small>
        </div>
        <div class="revenue-kpi-card">
            <span>Subscription Revenue</span>
            <strong>₹ ${subscriptionRevenue}</strong>
            <small>Realized recurring revenue</small>
        </div>
    </div>


    <div class="dashboard-container">

    <a href="<%=request.getContextPath()%>/admin/users"
       class="dashboard-card users stat-link">

        <div>
            <h3>Customers</h3>
            <h1>${totalUsers}</h1>
            <p>View all registered users</p>
        </div>

        <div class="card-icon">👤</div>

    </a>

   <a href="<%=request.getContextPath()%>/admin/products"
   class="dashboard-card products stat-link">

        <div>
            <h3>Products</h3>
            <h1>${totalProducts}</h1>
            <p>Manage product inventory</p>
        </div>

        <div class="card-icon">📦</div>

    </a>

    <a href="<%=request.getContextPath()%>/admin/orders"
       class="dashboard-card orders stat-link">

        <div>
            <h3>Orders</h3>
            <h1>${totalOrders}</h1>
            <p>Manage orders, delivery status and payments</p>
        </div>

        <div class="card-icon">🧾</div>

    </a>

    <a href="<%=request.getContextPath()%>/admin?view=revenue"
       class="dashboard-card revenue stat-link">

        <div>
            <h3>Total Revenue</h3>
            <h1>₹ ${totalRevenue}</h1>
            <p>Delivered, non-refunded orders</p>
            <div class="stat-card-meta">
                <span>Today ₹ ${dailyRevenue}</span>
                <span>This month ₹ ${monthlyRevenue}</span>
            </div>
        </div>

        <div class="card-icon">💰</div>

    </a>

  <a href="<%=request.getContextPath()%>/admin/low-stock"
   class="dashboard-card stock stat-link">
        <div>
            <h3>Low Stock</h3>
            <h1>${lowStock}</h1>
            <p>Products at or below 10 units</p>
            <div class="stat-card-meta">
                <span>${outOfStock} out of stock</span>
            </div>
        </div>

        <div class="card-icon">⚠️</div>

    </a>

    <a href="#wishlist-activity"
       class="dashboard-card wishlist stat-link">

        <div>
            <h3>Wishlist Activity</h3>
            <h1>${wishlistCount}</h1>
            <p>Recent customer saved products</p>
        </div>

        <div class="card-icon">❤️</div>

    </a>

    <a href="<%=request.getContextPath()%>/admin/reviews"
       class="dashboard-card reviews stat-link">

        <div>
            <h3>Product Reviews</h3>
            <h1>${reviewCount}</h1>
            <p>Manage user submitted reviews</p>
        </div>

        <div class="card-icon">⭐</div>

    </a>

    <a href="#subscription-activity"
       class="dashboard-card subscription stat-link">

        <div>
            <h3>Subscriptions</h3>
            <h1>${subscriptionCount}</h1>
            <p>Recurring customer deliveries</p>
        </div>

        <div class="card-icon">🔁</div>

    </a>

</div>
    <div class="admin-insights-grid">

        <section class="revenue-analytics-card">
            <div class="analytics-card-heading">
                <span class="analytics-kicker">Revenue Quality</span>
                <h2>Completed revenue snapshot</h2>
                <p>Only delivered and non-refunded order totals are included.</p>
            </div>

            <div class="revenue-filter-panel" aria-label="Revenue display controls">
                <label>
                    <span>From</span>
                    <input type="date">
                </label>
                <label>
                    <span>To</span>
                    <input type="date">
                </label>
                <label>
                    <span>View</span>
                    <select>
                        <option>Completed revenue</option>
                        <option>Today</option>
                        <option>This month</option>
                    </select>
                </label>
                <button type="button">Refresh View</button>
            </div>

            <div class="revenue-metric-grid">
                <div class="metric-row primary">
                    <span>Total Revenue</span>
                    <strong>₹ ${totalRevenue}</strong>
                    <small class="trend-badge positive">Verified orders</small>
                </div>
                <div class="metric-row">
                    <span>Today</span>
                    <strong>₹ ${dailyRevenue}</strong>
                    <small>Delivered today</small>
                </div>
                <div class="metric-row">
                    <span>This Month</span>
                    <strong>₹ ${monthlyRevenue}</strong>
                    <small>Current month</small>
                </div>
                <div class="metric-row">
                    <span>Subscriptions</span>
                    <strong>₹ ${subscriptionRevenue}</strong>
                    <small>Realized subscription revenue</small>
                </div>
            </div>
        </section>

        <section class="inventory-alert-card">
            <div class="analytics-card-heading">
                <span class="analytics-kicker warning">Inventory Health</span>
                <h2>Stock risk overview</h2>
                <p>Products at 10 units or less are surfaced for restocking.</p>
            </div>

            <div class="inventory-alert-list">
                <div>
                    <span class="stock-status-badge low">Low Stock</span>
                    <strong>${lowStock}</strong>
                    <small>Needs attention</small>
                </div>
                <div>
                    <span class="stock-status-badge out">Out of Stock</span>
                    <strong>${outOfStock}</strong>
                    <small>Immediate action</small>
                </div>
                <a href="<%=request.getContextPath()%>/admin/low-stock" class="inventory-action-link">Review inventory</a>
            </div>
        </section>

        <section class="dashboard-activity-card wishlist-activity-card" id="wishlist-activity">
            <div class="analytics-card-heading">
                <span class="analytics-kicker wishlist">Wishlist Activity</span>
                <h2>Customer saved products</h2>
                <p>Recent wishlist signals from shoppers.</p>
            </div>

            <div class="dashboard-activity-list">
            <%
                boolean hasWishlistActivity = false;
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                        "SELECT w.*, u.full_name, p.name AS product_name " +
                        "FROM wishlist w " +
                        "JOIN users u ON w.user_id = u.user_id " +
                        "JOIN products p ON w.product_id = p.product_id " +
                        "ORDER BY 1 DESC LIMIT 4");
                     ResultSet rs = ps.executeQuery()) {
                    while(rs.next()) {
                        hasWishlistActivity = true;
                        String wishDate = "Recent activity";
                        try {
                            Timestamp ts = rs.getTimestamp("created_at");
                            if(ts != null) {
                                wishDate = ts.toLocalDateTime().toString().replace("T"," ");
                            }
                        } catch(Exception ignored) {}
            %>
                <div class="dashboard-activity-row">
                    <div class="activity-avatar"><%= rs.getString("full_name") != null ? rs.getString("full_name").substring(0,1).toUpperCase() : "C" %></div>
                    <div class="activity-copy">
                        <strong><%= rs.getString("full_name") != null ? rs.getString("full_name") : "Customer" %></strong>
                        <span>Saved <b><%= rs.getString("product_name") %></b> to wishlist</span>
                        <small><%= wishDate %></small>
                    </div>
                    <span class="activity-status-badge saved">Saved</span>
                </div>
            <%
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                }

                if(!hasWishlistActivity) {
            %>
                <div class="premium-empty-state dashboard-mini-empty">
                    <strong>No wishlist activity yet</strong>
                    <span>Saved customer products will appear here.</span>
                </div>
            <%
                }
            %>
            </div>
        </section>

        <section class="dashboard-activity-card subscription-activity-card" id="subscription-activity">
            <div class="analytics-card-heading">
                <span class="analytics-kicker subscription">Subscriptions</span>
                <h2>Recurring delivery activity</h2>
                <p>Active recurring grocery plans and upcoming delivery cadence.</p>
            </div>

            <div class="dashboard-activity-list">
            <%
                boolean hasSubscriptionActivity = false;
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                        "SELECT s.*, u.full_name, p.name AS product_name " +
                        "FROM subscriptions s " +
                        "JOIN users u ON s.user_id = u.user_id " +
                        "JOIN products p ON s.product_id = p.product_id " +
                        "ORDER BY s.start_date DESC LIMIT 4");
                     ResultSet rs = ps.executeQuery()) {
                    while(rs.next()) {
                        hasSubscriptionActivity = true;
                        String frequency = rs.getString("frequency") != null ? rs.getString("frequency") : "DAILY";
                        String status = rs.getString("status") != null ? rs.getString("status") : "ACTIVE";
                        Date startDate = rs.getDate("start_date");
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
                <div class="dashboard-activity-row subscription-row-mini">
                    <div class="activity-avatar subscription-avatar"><%= rs.getString("product_name") != null ? rs.getString("product_name").substring(0,1).toUpperCase() : "S" %></div>
                    <div class="activity-copy">
                        <strong><%= rs.getString("full_name") != null ? rs.getString("full_name") : "Customer" %></strong>
                        <span><b><%= rs.getString("product_name") %></b> · Qty <%= rs.getInt("quantity") %></span>
                        <small>Next delivery: <%= nextDelivery %></small>
                    </div>
                    <div class="activity-badges">
                        <span class="activity-status-badge frequency"><%= frequency %></span>
                        <span class="activity-status-badge <%= status.toLowerCase() %>"><%= status %></span>
                    </div>
                </div>
            <%
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                }

                if(!hasSubscriptionActivity) {
            %>
                <div class="premium-empty-state dashboard-mini-empty">
                    <strong>No subscriptions yet</strong>
                    <span>Recurring customer plans will appear here.</span>
                </div>
            <%
                }
            %>
            </div>
        </section>

    </div>


    <div class="graph-section">

        <h2>System Analytics</h2>

        <div class="graph-item">

            <div class="graph-label">
                <span>Total Users</span>
                <span>${totalUsers}</span>
            </div>

            <div class="bar">
                <div class="fill users-fill"
                     style="width:${totalUsers * 10}px;">
                </div>
            </div>

        </div>

        <div class="graph-item">

            <div class="graph-label">
                <span>Total Products</span>
                <span>${totalProducts}</span>
            </div>

            <div class="bar">
                <div class="fill products-fill"
                     style="width:${totalProducts * 10}px;">
                </div>
            </div>

        </div>

        <div class="graph-item">

            <div class="graph-label">
                <span>Total Orders</span>
                <span>${totalOrders}</span>
            </div>

            <div class="bar">
                <div class="fill orders-fill"
                     style="width:${totalOrders * 10}px;">
                </div>
            </div>

        </div>

        <div class="graph-item">

            <div class="graph-label">
                <span>Subscriptions</span>
                <span>${subscriptionCount}</span>
            </div>

            <div class="bar">
                <div class="fill subscription-fill"
                     style="width:${subscriptionCount * 10}px;">
                </div>
            </div>

        </div>

    </div>


<div class="charts-container">


    <div class="chart-card">

        <h2>Revenue Analytics</h2>

        <div class="chart-wrapper">
            <canvas id="revenueChart"></canvas>
        </div>

    </div>


    <div class="chart-card">

        <h2>Product Stock</h2>

        <div class="chart-wrapper">
            <canvas id="stockChart"></canvas>
        </div>

    </div>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>


const revenueValues = [
parseFloat("${dailyRevenue}") || 0,
parseFloat("${monthlyRevenue}") || 0,
parseFloat("${totalRevenue}") || 0
];

const revenueCtx =
document.getElementById("revenueChart");

new Chart(revenueCtx, {

    type: 'bar',

    data: {

        labels: ['Today', 'This Month', 'Total'],

        datasets: [{

            label: 'Completed Revenue',

            data: revenueValues,

            backgroundColor: ['#10b981', '#14b8a6', '#0f172a'],

            borderRadius: 12,

            borderSkipped: false,

            barPercentage: 0.3,

            categoryPercentage: 0.4
        }]
    },

    options: {

        responsive: true,

        maintainAspectRatio: false,

        plugins: {

            legend: {
                display: true
            }
        },

        scales: {

            y: {

                beginAtZero: true,

                ticks: {
                    color: '#555'
                },

                grid: {
                    color: '#eaeaea'
                }
            },

            x: {

                ticks: {
                    color: '#555'
                },

                grid: {
                    display: false
                }
            }
        }
    }
});


const productNames = [

<%
List<Product> stockProducts =
(List<Product>) request.getAttribute("products");

if(stockProducts != null){

    for(int i = 0; i < stockProducts.size(); i++){
%>

"<%= stockProducts.get(i).getName() %>"

<%= (i < stockProducts.size()-1) ? "," : "" %>

<%
    }
}
%>

];

const productQty = [

<%
if(stockProducts != null){

    for(int i = 0; i < stockProducts.size(); i++){
%>

<%= stockProducts.get(i).getStockQuantity() %>

<%= (i < stockProducts.size()-1) ? "," : "" %>

<%
    }
}
%>

];

const stockCtx =
document.getElementById("stockChart");

const stockData = productQty.length ? productQty : [0];
const stockLabels = productNames.length ? productNames : ['No products'];
const maxStock = Math.max(...stockData);

const minStock = Math.min(...stockData);


const colors = stockData.map(value => {

    if(value<=20){
        return '#ef4444';
    }

    if(value>=100){
        return '#22c55e';
    }

    return '#60a5fa';
});

new Chart(stockCtx, {

    type: 'bar',

    data: {

        labels: stockLabels,

        datasets: [{

            label: 'Stock Quantity',

            data: stockData,

            backgroundColor: colors,

            borderRadius: 12,

            borderSkipped: false
        }]
    },

    options: {

        responsive: true,

        maintainAspectRatio: false,

        plugins: {

            legend: {
                display: true
            }
        },

        scales: {

            y: {

                beginAtZero: true,

                ticks: {
                    color: '#555'
                },

                grid: {
                    color: '#ededed'
                }
            },

            x: {

                ticks: {
                    color: '#555'
                },

                grid: {
                    display: false
                }
            }
        }
    }
});

</script>


<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
