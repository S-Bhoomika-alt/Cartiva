<%@ page import="java.util.*, com.cartiva.model.Cart" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container cart-page premium-commerce-page">

<style>
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background: white;
    border-radius: 10px;
    overflow: hidden;
}

th {
    background: #2e7d32;
    color: white;
    padding: 12px;
}

td {
    padding: 12px;
    text-align: center;
}

tr:nth-child(even) {
    background: #f5f5f5;
}

.actions a {
    margin: 0 5px;
    font-weight: bold;
    text-decoration: none;
}

.qty-btn {
    padding: 4px 8px;
    border-radius: 5px;
    background: #e0e0e0;
}
</style>

<div class="commerce-page-header cart-page-header">
    <div>
        <span class="admin-breadcrumb">Checkout Bag</span>
        <h2 class="section-title">Your Cart</h2>
        <p>Review items, adjust quantities and continue securely to payment.</p>
    </div>
    <button type="button"
            class="premium-back-button"
            onclick="window.location.href='<%= request.getContextPath() %>/products'">
        <span class="back-icon">←</span>
        Back
    </button>
</div>

<%
    List<Cart> cartList = (List<Cart>) request.getAttribute("cartList");
    boolean hasCartItems = cartList != null && !cartList.isEmpty();
    double total = 0;
%>

<% if(hasCartItems) { %>
<form id="checkoutForm" action="<%= request.getContextPath() %>/payment" method="get">
<% } %>

<div class="cart-shell">
<div class="cart-items-panel">
<div class="customer-table-scroll">
<table class="cart-table premium-cart-table customer-cart-table">
<colgroup>
    <col class="col-cart-select">
    <col class="col-cart-product">
    <col class="col-cart-price">
    <col class="col-cart-qty">
    <col class="col-cart-action">
</colgroup>

<%
    if(hasCartItems) {
        for(Cart c : cartList) {
            double itemTotal = c.getPrice() * c.getQuantity();
            total += itemTotal;
%>


    <tr class="cart-item-row">
        <td>
            <input type="checkbox"
                   class="checkout-item"
                   name="selectedCartItemIds"
                   value="<%= c.getCartId() %>">
        </td>
        <td class="cart-product-cell">
            <div class="cart-product-media">
                <span><%= c.getName().substring(0,1).toUpperCase() %></span>
            </div>
            <div class="cart-product-info">
                <strong><%= c.getName() %></strong>
                <small>Fresh grocery item</small>
            </div>
        </td>
        <td class="cart-price-cell">
            <span>₹<%= itemTotal %></span>
        </td>

        <td class="cart-qty-cell">
            <div class="cart-qty-control">
            <a class="qty-btn"
               href="cart?action=update&productId=<%= c.getProductId() %>&change=-1">−</a>

            <span><%= c.getQuantity() %></span>

            <a class="qty-btn"
               href="cart?action=update&productId=<%= c.getProductId() %>&change=1">+</a>
            </div>
        </td>

        <td class="actions">
            <a class="cart-remove-btn"
               href="cart?action=remove&productId=<%= c.getProductId() %>">
               Remove
            </a>
        </td>
    </tr>

<%
        }
    } else {
%>


    <tr class="cart-empty-row">
        <td colspan="5">
            <div class="premium-empty-state">
                <strong>Cart is empty</strong>
                <span>Add fresh products to start your order.</span>
            </div>
        </td>
    </tr>

<%
    }
%>

</table>
</div>
</div>


<% if(hasCartItems) { %>
<aside class="cart-summary-card">
    <div class="summary-header">
        <span>Order Summary</span>
        <strong>₹<%= total %></strong>
    </div>
    <div class="summary-row">
        <span>Subtotal</span>
        <span>₹<%= total %></span>
    </div>
    <div class="summary-row">
        <span>Delivery</span>
        <span>Calculated at checkout</span>
    </div>
    <div class="summary-total">
        <span>Total</span>
        <strong>₹<%= total %></strong>
    </div>

    <button type="submit" class="checkout-btn" id="checkoutButton">
        Checkout
    </button>

</aside>
<% } %>
</div>

<% if(hasCartItems) { %>
</form>
<% } %>

</div>

<script>
window.addEventListener("load", function () {

    const form = document.querySelector("form");
    if(!form) return;

    form.addEventListener("submit", function () {

        console.log("===== CHECKOUT PAYLOAD =====");

        const data = new FormData(form);

        for (const pair of data.entries()) {
            console.log(pair[0] + " = " + pair[1]);
        }

        const button = document.getElementById('checkoutButton');
        if(button) {
            button.disabled = true;
            button.innerText = 'Processing...';
        }
    });
});
</script>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
