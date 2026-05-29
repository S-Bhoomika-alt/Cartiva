<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container order-success-page premium-commerce-page">

    <div class="order-success-card">
    <div class="success-icon">&#9989;</div>
    <h2>Payment Successful!</h2>

    <p>Your order has been placed successfully </p>

    <a href="<%= request.getContextPath() %>/orders">
        <button>View Orders</button>
    </a>
    </div>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
