<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">

<div class="auth-container checkout-page premium-commerce-page">
    <div class="auth-card checkout-card">
        <h2>Payment</h2>

        <form action="${pageContext.request.contextPath}/place-order" method="post" class="payment-form">
            <input type="text" placeholder="Card Number" required>
            <div class="payment-card-row">
                <input type="text" placeholder="CVV" required>
                <input type="text" placeholder="Expiry" required>
            </div>

            <button type="submit" class="pay-btn">Pay Now</button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
