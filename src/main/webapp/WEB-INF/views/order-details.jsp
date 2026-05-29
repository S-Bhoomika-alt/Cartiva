<%@ page import="java.util.*, com.cartiva.model.OrderItem, com.cartiva.model.Review, com.cartiva.model.User, com.cartiva.dao.ReviewDAO, com.cartiva.dao.impl.ReviewDAOImpl" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container order-details-page premium-commerce-page">

<div class="order-details-hero">
<div>
<span class="admin-breadcrumb">Account / Orders</span>
<h2 class="section-title">Order Details</h2>
</div>
<a href="<%= request.getContextPath() %>/orders"
   class="back-btn dashboard-back-btn">
    Back to Orders
</a>
</div>
<p class="payment-mode-pill">
    <strong>Payment Mode:</strong>
    <span>
        <%= request.getAttribute("paymentMode") != null
                ? request.getAttribute("paymentMode")
                : "N/A" %>
    </span>
</p>
<div class="account-table-scroll">
<div class="account-table account-order-details-grid">
    <div class="account-table-header">
        <div>Product</div>
        <div>Price</div>
        <div>Quantity</div>
        <div>Total</div>
        <div>Review</div>
    </div>

<%
    List<OrderItem> items = (List<OrderItem>) request.getAttribute("items");
    String orderStatus = request.getAttribute("orderStatus") != null ? request.getAttribute("orderStatus").toString() : "";
    boolean deliveredOrder = "DELIVERED".equalsIgnoreCase(orderStatus);
    User currentUser = (User) session.getAttribute("user");
    ReviewDAO reviewDAO = new ReviewDAOImpl();

    if(items != null && !items.isEmpty()) {
        for(OrderItem i : items) {
            Review userReview = currentUser != null ? reviewDAO.getUserReview(currentUser.getUserId(), i.getProductId()) : null;
%>

    <div class="account-table-row">
        <div class="account-cell product-cell"><%= i.getProductName() %></div>
        <div class="account-cell amount-cell">&#8377;<%= i.getPrice() %></div>
        <div class="account-cell qty-cell"><%= i.getQuantity() %></div>
        <div class="account-cell amount-cell">₹<%= i.getPrice().multiply(new java.math.BigDecimal(i.getQuantity())) %></div>
        <div class="account-cell review-action-cell">
            <% if(deliveredOrder && currentUser != null) { %>
                <button type="button"
                        class="review-order-btn <%= userReview != null ? "edit-review-btn" : "write-review-btn" %>"
                        data-product-id="<%= i.getProductId() %>"
                        data-product-name="<%= i.getProductName() != null ? i.getProductName().replace("\"", "&quot;") : "Product" %>"
                        data-review-id="<%= userReview != null ? userReview.getReviewId() : 0 %>"
                        data-rating="<%= userReview != null ? userReview.getRating() : 5 %>"
                        data-comment="<%= userReview != null && userReview.getComment() != null ? userReview.getComment().replace("\"", "&quot;") : "" %>">
                    <%= userReview != null ? "Edit Review" : "Write Review" %>
                </button>
            <% } else { %>
                <span class="review-unavailable">Available after delivery</span>
            <% } %>
        </div>
    </div>

<%
        }
    } else {
%>

    <div class="premium-empty-state account-empty-state">
        <strong>No items found</strong>
        <span>This order has no product rows to display.</span>
    </div>

<%
    }
%>

</div>
</div>

</div>

<div class="modal fade" id="orderReviewModal" tabindex="-1" aria-labelledby="orderReviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="order-review-form" action="<%= request.getContextPath() %>/review" method="post" onsubmit="return false;">
                <div class="modal-header">
                    <h5 class="modal-title" id="orderReviewModalLabel">Write Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="ajax" value="true">
                    <input type="hidden" name="action" id="order-review-action" value="">
                    <input type="hidden" name="productId" id="order-review-product-id">
                    <input type="hidden" name="reviewId" id="order-review-id">

                    <p class="order-review-product-name" id="order-review-product-name"></p>

                    <label>Rating</label>
                    <input type="hidden" name="rating" id="order-review-rating" value="5">
                    <div class="star-rating-input" data-target="order-review-rating" aria-label="Choose rating">
                        <button type="button" data-value="1">★</button>
                        <button type="button" data-value="2">★</button>
                        <button type="button" data-value="3">★</button>
                        <button type="button" data-value="4">★</button>
                        <button type="button" data-value="5">★</button>
                    </div>

                    <label for="order-review-comment" style="margin-top:10px;">Comment (optional)</label>
                    <textarea name="comment" id="order-review-comment" rows="3" class="form-control"></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Save Review</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
const CARTIVA_CONTEXT_PATH = '<%= request.getContextPath() %>';
function orderReviewToast(message, type){
    if(window.CartivaToast) CartivaToast(message, type || 'success');
    else alert(message);
}

function setStarRating(container, value){
    var rating = parseInt(value, 10) || 5;
    var target = document.getElementById(container.getAttribute('data-target'));
    if(target) target.value = rating;
    container.querySelectorAll('button').forEach(function(star){
        star.classList.toggle('active', parseInt(star.getAttribute('data-value'), 10) <= rating);
    });
}

function bindStarInputs(){
    document.querySelectorAll('.star-rating-input').forEach(function(container){
        if(container.dataset.bound === 'true') return;
        container.dataset.bound = 'true';
        container.querySelectorAll('button').forEach(function(star){
            star.addEventListener('mouseenter', function(){
                var hover = parseInt(star.getAttribute('data-value'), 10) || 0;
                container.querySelectorAll('button').forEach(function(item){
                    item.classList.toggle('hover', parseInt(item.getAttribute('data-value'), 10) <= hover);
                });
            });
            star.addEventListener('click', function(){
                setStarRating(container, star.getAttribute('data-value'));
            });
        });
        container.addEventListener('mouseleave', function(){
            container.querySelectorAll('button').forEach(function(item){ item.classList.remove('hover'); });
        });
        var target = document.getElementById(container.getAttribute('data-target'));
        setStarRating(container, target && target.value ? target.value : 5);
    });
}

document.addEventListener('DOMContentLoaded', function(){
    var modalEl = document.getElementById('orderReviewModal');
    var form = document.getElementById('order-review-form');
    var activeButton = null;
    bindStarInputs();

    document.querySelectorAll('.review-order-btn').forEach(function(button){
        button.addEventListener('click', function(){
            activeButton = button;
            var reviewId = button.getAttribute('data-review-id') || '0';
            document.getElementById('order-review-product-id').value = button.getAttribute('data-product-id') || '';
            document.getElementById('order-review-product-name').innerText = button.getAttribute('data-product-name') || 'Product';
            document.getElementById('order-review-id').value = reviewId !== '0' ? reviewId : '';
            document.getElementById('order-review-action').value = reviewId !== '0' ? 'update' : '';
            document.getElementById('order-review-rating').value = button.getAttribute('data-rating') || '5';
            document.getElementById('order-review-comment').value = button.getAttribute('data-comment') || '';
            document.getElementById('orderReviewModalLabel').innerText = reviewId !== '0' ? 'Edit Review' : 'Write Review';
            var stars = document.querySelector('#orderReviewModal .star-rating-input');
            if(stars) setStarRating(stars, document.getElementById('order-review-rating').value);
            if(window.bootstrap && modalEl) bootstrap.Modal.getOrCreateInstance(modalEl).show();
        });
    });

    if(form) form.addEventListener('submit', function(event){
        event.preventDefault();
        event.stopPropagation();
        var submit = form.querySelector('button[type="submit"]');
        if(submit){ submit.disabled = true; submit.innerText = 'Saving...'; }

        var action = document.getElementById('order-review-action').value || 'create';
        var productId = document.getElementById('order-review-product-id').value || '';
        var reviewId = document.getElementById('order-review-id').value || '';
        var rating = document.getElementById('order-review-rating').value || '';
        var comment = document.getElementById('order-review-comment').value || '';
        var data = new URLSearchParams({
            action: action,
            reviewId: reviewId,
            productId: productId,
            rating: rating,
            comment: comment
        });
        console.log('REQUEST BODY', data.toString());
        fetch(CARTIVA_CONTEXT_PATH + '/review', {
            method:'POST',
            headers:{
                'Accept':'application/json',
                'X-Requested-With':'XMLHttpRequest'
            },
            body:data
        }).then(function(res){
            return res.text().then(function(text){
                console.log('RAW RESPONSE', text);
                var json = {};
                try{ json = text ? JSON.parse(text) : {}; }catch(e){ json = {success:false, message:'Invalid JSON response'}; }
                if(!res.ok || !json.success) return Promise.reject(json);
                return json;
            });
        }).then(function(json){
            console.log('REVIEW UPDATE RESPONSE:', json);
            if(!json.success){
                orderReviewToast(json.message || 'Could not save review', 'error');
                return;
            }
            if(activeButton){
                var savedReview = json.review || {};
                var savedReviewId = savedReview.reviewId || json.reviewId || reviewId || activeButton.getAttribute('data-review-id');
                var savedRating = savedReview.rating || json.rating || rating || '5';
                var savedComment = (typeof savedReview.comment === 'string') ? savedReview.comment : ((typeof json.comment === 'string') ? json.comment : comment);

                activeButton.innerText = 'Edit Review';
                activeButton.classList.remove('write-review-btn');
                activeButton.classList.add('edit-review-btn');
                activeButton.dataset.reviewId = savedReviewId;
                activeButton.dataset.rating = savedRating;
                activeButton.dataset.comment = savedComment || '';
                document.getElementById('order-review-id').value = savedReviewId;
                document.getElementById('order-review-action').value = 'update';
            }
            if(window.bootstrap && modalEl) bootstrap.Modal.getOrCreateInstance(modalEl).hide();
            orderReviewToast('Review saved successfully', 'success');
        }).catch(function(err){
            orderReviewToast((err && err.message) ? err.message : 'Could not save review', 'error');
        }).finally(function(){
            if(submit){ submit.disabled = false; submit.innerText = 'Save Review'; }
        });
    });
});
</script>
