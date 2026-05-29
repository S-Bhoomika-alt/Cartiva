<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.cartiva.model.Cart, com.cartiva.model.User" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">

<%
    User paymentUser = (User) session.getAttribute("user");
    List<Cart> reviewCartList = new ArrayList<Cart>();
    double reviewSubtotal = 0;
    Object checkoutItemsObj = request.getAttribute("checkoutItems");
    String[] selectedCartItemIds = (String[]) request.getAttribute("selectedCartItemIds");
    if(checkoutItemsObj instanceof List<?>) {
        reviewCartList = (List<Cart>) checkoutItemsObj;
    }
    for(Cart item : reviewCartList) {
        reviewSubtotal += item.getPrice() * item.getQuantity();
    }
    double deliveryCharge = reviewSubtotal > 0 ? 0 : 0;
    double reviewTotal = reviewSubtotal + deliveryCharge;
%>

<div class="auth-container payment-page premium-commerce-page">

    <div class="payment-shell">

        <section class="payment-main-card">

        <h2>Payment Gateway</h2>
        <p class="secure-note">Secure checkout with encrypted payment details.</p>

        <div class="payment-method-grid">
            <div class="payment-method-card active">Card</div>
            <div class="payment-method-card">COD</div>
            <div class="payment-method-card muted">UPI</div>
            <div class="payment-method-card muted">Wallet</div>
        </div>

        <form action="${pageContext.request.contextPath}/payment" method="post" onsubmit="return validatePayment()" class="payment-form">
            <% if(selectedCartItemIds != null) {
                for(String selectedCartItemId : selectedCartItemIds) { %>
                    <input type="hidden" name="selectedCartItemIds" value="<%= selectedCartItemId %>">
            <%  }
               } %>


            <input type="text" placeholder="Card Number"
                   id="card" name="card"
                   maxlength="16"
                   pattern="[0-9]{16}"
                   oninput="this.value=this.value.replace(/\D/g,'')"
                   required>


            <input type="text" placeholder="Card Holder Name" required>

            <div class="payment-card-row">


                <input type="text" placeholder="MM/YY"
                       id="expiry" name="expiry"
                       maxlength="5"
                       pattern="(0[1-9]|1[0-2])\/[0-9]{2}"
                       oninput="formatExpiry(this)"
                       required>


                <input type="text" placeholder="CVV"
                       id="cvv" name="cvv"
                       maxlength="3"
                       pattern="[0-9]{3}"
                       oninput="this.value=this.value.replace(/\D/g,'')"
                       required>
            </div>

            <button type="submit" class="pay-btn">Pay Now</button>

        </form>

        <p id="errorMsg" class="payment-error"></p>

        <div class="payment-divider"><span>or</span></div>


        <form action="${pageContext.request.contextPath}/payment" method="post" class="cod-form">
            <input type="hidden" name="cod" value="true">
            <% if(selectedCartItemIds != null) {
                for(String selectedCartItemId : selectedCartItemIds) { %>
                    <input type="hidden" name="selectedCartItemIds" value="<%= selectedCartItemId %>">
            <%  }
               } %>
            <button class="cod-btn">Cash on Delivery</button>
        </form>

        </section>

        <aside class="payment-summary-card">
            <span class="summary-kicker">Amount payable</span>
            <strong>₹<%= request.getAttribute("total") %></strong>
            <p>Review your order details before completing payment.</p>
            <button type="button" class="review-order-toggle" onclick="toggleOrderReview()">
                Review Order
            </button>
            <div class="order-review-panel" id="orderReviewPanel">
                <div class="order-review-heading">
                    <strong>Order Review</strong>
                    <span><%= reviewCartList.size() %> items</span>
                </div>
                <% if(reviewCartList != null && !reviewCartList.isEmpty()) {
                    for(Cart item : reviewCartList) {
                        double lineTotal = item.getPrice() * item.getQuantity();
                %>
                    <div class="order-review-item">
                        <div>
                            <strong><%= item.getName() %></strong>
                            <span>Qty <%= item.getQuantity() %></span>
                        </div>
                        <b>₹<%= lineTotal %></b>
                    </div>
                <%  }
                   } else { %>
                    <div class="premium-empty-state mini-review-empty">
                        <strong>No items in cart</strong>
                        <span>Add products before payment.</span>
                    </div>
                <% } %>
                <div class="order-review-total-row">
                    <span>Subtotal</span>
                    <strong>₹<%= reviewSubtotal %></strong>
                </div>
                <div class="order-review-total-row">
                    <span>Delivery charges</span>
                    <strong><%= deliveryCharge == 0 ? "Free" : "₹" + deliveryCharge %></strong>
                </div>
                <div class="order-review-total-row grand">
                    <span>Total amount</span>
                    <strong>₹<%= reviewTotal %></strong>
                </div>
                <p class="subscription-review-note">Subscriptions, if selected, continue with pay-on-delivery cadence.</p>
            </div>
            <div class="summary-row">
                <span>Payment status</span>
                <span>Pending</span>
            </div>
            <div class="summary-row">
                <span>Security</span>
                <span>Protected</span>
            </div>
        </aside>

    </div>

</div>

<script>

function validatePayment() {

    const card = document.getElementById("card").value;
    const expiry = document.getElementById("expiry").value;
    const cvv = document.getElementById("cvv").value;
    const error = document.getElementById("errorMsg");

    error.innerText = "";


    if (!/^\d{16}$/.test(card)) {
        error.innerText = "Card must be 16 digits";
        return false;
    }


    if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry)) {
        error.innerText = "Expiry must be in MM/YY format";
        return false;
    }


    if (!/^\d{3}$/.test(cvv)) {
        error.innerText = "CVV must be 3 digits";
        return false;
    }

    return true;
}


function formatExpiry(input) {
    let value = input.value.replace(/\D/g, '');

    if (value.length >= 3) {
        value = value.substring(0,2) + "/" + value.substring(2,4);
    }

    input.value = value;
}

function toggleOrderReview(){
    const panel = document.getElementById('orderReviewPanel');
    if(panel) panel.classList.toggle('show');
}

document.querySelectorAll('.payment-form, .cod-form').forEach(function(form){
    form.addEventListener('submit', function(){
        var button = form.querySelector('button[type="submit"], button:not([type])');
        if(button) button.disabled = true;
    });
});
</script>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
