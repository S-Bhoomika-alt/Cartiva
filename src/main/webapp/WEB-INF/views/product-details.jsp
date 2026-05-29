

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cartiva.model.Product, com.cartiva.model.Review, com.cartiva.dao.ReviewDAO, com.cartiva.dao.impl.ReviewDAOImpl, java.util.List" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/product-details.css">

<div class="container product-details-page">
<a href="<%= request.getContextPath() %>/products"
   class="premium-back-button product-details-back-button"
   onclick="if(document.referrer && document.referrer.indexOf('<%= request.getContextPath() %>/products') !== -1){ history.back(); return false; }">
    <span class="back-icon">←</span>
    Back to Products
</a>
<div class="product-details-container">

<%
Product p = (Product) request.getAttribute("product");

if(p != null) {
%>

<div class="product-details-card premium-product-shell">


    <div class="product-image-box premium-product-media">
        <%
            String imgSrc = request.getContextPath() + "/assets/images/default.png";
            String imgUrl = p.getImageUrl();
            if (imgUrl != null && !imgUrl.trim().isEmpty()) {
                String lower = imgUrl.toLowerCase();
                if (lower.startsWith("http://") || lower.startsWith("https://")) {
                    imgSrc = imgUrl;
                } else {
                    String realPath = application.getRealPath("/" + imgUrl);
                    java.io.File f = (realPath != null) ? new java.io.File(realPath) : null;
                    if (f != null && f.exists()) {
                        imgSrc = request.getContextPath() + "/" + imgUrl;
                    } else {
                        String alt = application.getRealPath("/assets/images/" + imgUrl);
                        java.io.File f2 = (alt != null) ? new java.io.File(alt) : null;
                        if (f2 != null && f2.exists()) {
                            imgSrc = request.getContextPath() + "/assets/images/" + imgUrl;
                        }
                    }
                }
            }
        %>
        <div class="product-image-card">
            <span class="image-badge">Fresh pick</span>
            <img src="<%= imgSrc %>" alt="<%= p.getName() %>">
        </div>
        <div class="product-thumbs">
            <span class="thumb active"></span>
            <span class="thumb"></span>
            <span class="thumb"></span>
        </div>
    </div>


    <div class="product-info-box premium-product-info">

    <%
    String error = request.getParameter("error");

    String qtyParam = request.getParameter("quantity");
    int selectedQty = 1;

    if(qtyParam != null){
        try {
            selectedQty = Integer.parseInt(qtyParam);
        } catch(Exception e){}
    }

    if("limit".equals(error)){
    %>
    <p class="product-alert error">
        ⚠ Only <%= p.getStockQuantity() %> items available
    </p>
    <%
    }
    %>

        <div class="product-title-block">
            <p class="product-eyebrow">Premium grocery product</p>
            <h1><%= p.getName() %></h1>
        </div>

        <p class="category product-category-badge">
            <span><%= p.getCategory() %></span>
        </p>

        <p class="description"><%= p.getDescription() %></p>

<%
String unit = "";

if("Fruits".equalsIgnoreCase(p.getCategory()) ||
   "Vegetables".equalsIgnoreCase(p.getCategory())) {
    unit = " / kg";
}
else if("Dairy".equalsIgnoreCase(p.getCategory())) {
    unit = " / L";
}
else if("Snacks".equalsIgnoreCase(p.getCategory())) {
    unit = " / pack";
}
%>

        <div class="price product-price-block">
            <span class="price-currency">&#8377;</span><span><%= p.getPrice() %></span><small><%= unit %></small>
        </div>

        <% if(p.getStockQuantity() > 0) { %>
            <div class="stock stock-panel">
                <div class="stock-row">
                    <span class="stock-badge">In stock</span>
                    <strong><%= p.getStockQuantity() %> available</strong>
                </div>
                <div class="stock-progress">
                    <span style="width:<%= Math.min(100, Math.max(8, p.getStockQuantity() * 10)) %>%;"></span>
                </div>
            </div>
        <% } else { %>
            <div class="stock stock-panel out">
                <div class="stock-row">
                    <span class="stock-badge out">Out of stock</span>
                    <strong>Currently unavailable</strong>
                </div>
                <div class="stock-progress"><span style="width:0%;"></span></div>
            </div>
        <% } %>


        <form action="<%= request.getContextPath() %>/cart" method="get" class="cart-box premium-cart-box">

            <input type="hidden" name="productId" value="<%= p.getProductId() %>">

            <label>Qty:</label>
            <div class="quantity-selector">
                <button type="button" class="qty-step" data-step="-1">−</button>
                <input type="number" name="quantity"
                       value="<%= selectedQty %>"
                       min="1"
                       max="<%= p.getStockQuantity() %>"
                       class="qty-input"
                       style="<%= "limit".equals(error) ? "border:2px solid red;" : "" %>">
                <button type="button" class="qty-step" data-step="1">+</button>
            </div>

            <button type="submit"
                    class="<%= p.getStockQuantity() <= 0 ? "out-of-stock-btn" : "" %>"
                    <%= p.getStockQuantity() <= 0 ? "disabled" : "" %>>
                <%= p.getStockQuantity() <= 0 ? "Out of Stock" : "Add to Cart" %>
            </button>

        </form>


        <% if("Dairy".equalsIgnoreCase(p.getCategory())) { %>

        <div class="sub-box premium-sub-box">

            <form action="<%= request.getContextPath() %>/subscriptions" method="post" class="premium-sub-form">

                <input type="hidden" name="productId" value="<%= p.getProductId() %>">

                <div class="sub-controls">
                    <select name="frequency">
                        <option value="DAILY">Daily</option>
                        <option value="WEEKLY">Weekly</option>
                    </select>

                    <input type="number" name="quantity"
                           value="<%= selectedQty %>"
                           min="1"
                           max="<%= p.getStockQuantity() %>"
                           style="<%= "limit".equals(error) ? "border:2px solid red;" : "" %>">
                </div>

                <button type="submit" class="sub-btn">Subscribe</button>

                <p class="sub-note">
                    Pay on delivery • Cancel anytime
                </p>

            </form>

        </div>

        <% } %>

    </div>

</div>


<div class="reviews-section" style="margin-top:20px;">

    <%
        ReviewDAO rdao = new ReviewDAOImpl();
        double avg = rdao.getAverageRating(p.getProductId());
        List<Review> reviews = rdao.getReviewsByProductId(p.getProductId());
        int currentReviewUserId = -1;
        boolean canCurrentUserReview = false;
        Object reviewUserObj = session.getAttribute("user");
        if (reviewUserObj != null) {
            com.cartiva.model.User reviewUser = (com.cartiva.model.User) reviewUserObj;
            currentReviewUserId = reviewUser.getUserId();
            canCurrentUserReview = rdao.hasDeliveredPurchase(currentReviewUserId, p.getProductId());
        }
    %>

    <div style="display:flex; align-items:center; gap:12px; justify-content:space-between;">
        <h3 style="margin:0;">Reviews & Ratings</h3>
        <div style="display:flex; align-items:center; gap:8px;">
            <div id="avg-stars" style="font-size:18px; color:#f59e0b; display:flex; gap:4px; align-items:center;">
                <%
                   int rounded = (int) Math.round(avg);
                   for(int i=1;i<=5;i++){
                       if(i<=rounded){ %>
                           <svg width="18" height="18" viewBox="0 0 24 24" fill="#f59e0b" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M12 .587l3.668 7.431L23.4 9.748l-5.7 5.556L19.335 24 12 20.202 4.665 24l1.634-8.696L.6 9.748l7.732-1.73L12 .587z"/></svg>
                       <% } else { %>
                           <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="1" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M12 .587l3.668 7.431L23.4 9.748l-5.7 5.556L19.335 24 12 20.202 4.665 24l1.634-8.696L.6 9.748l7.732-1.73L12 .587z"/></svg>
                       <% }
                   }
                %>
            </div>
            <div style="color:#374151; font-weight:700;"> <span id="avg-value"><%= String.format("%.1f", avg) %></span>/5</div>
            <div style="background:#eef2ff; color:#1e3a8a; padding:6px 10px; border-radius:999px; font-weight:700; font-size:13px;" id="review-count-badge">
                <%= (reviews != null ? reviews.size() : 0) %> reviews
            </div>
        </div>
    </div>

    <p class="review-purchase-note">Reviews can be written or edited from your delivered order details.</p>

    <% if (reviews != null && !reviews.isEmpty()) { %>
        <div id="reviews-list" class="reviews-list">
            <% for (Review r : reviews) { %>
                <div class="review-item review-card" id="review-<%= r.getReviewId() %>" data-rating="<%= r.getRating() %>">
                    <strong><%= (r.getUserName() != null ? r.getUserName() : ("User #"+r.getUserId())) %></strong>
                    <span class="rating review-stars" style="margin-left:8px; color:#f59e0b; display:inline-flex; gap:4px; align-items:center;">
                        <% for(int i=1;i<=5;i++){ if(i<=r.getRating()){ %>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="#f59e0b" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M12 .587l3.668 7.431L23.4 9.748l-5.7 5.556L19.335 24 12 20.202 4.665 24l1.634-8.696L.6 9.748l7.732-1.73L12 .587z"/></svg>
                        <% } else { %>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="1" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M12 .587l3.668 7.431L23.4 9.748l-5.7 5.556L19.335 24 12 20.202 4.665 24l1.634-8.696L.6 9.748l7.732-1.73L12 .587z"/></svg>
                        <% } } %>
                    </span>
                    <div class="posted">Posted: <%= (r.getCreatedAt() != null ? r.getCreatedAt().toString().replace('T',' ') : "-") %></div>
                    <p class="review-comment-text review-comment" style="margin-top:6px;"><%= (r.getComment() != null && !r.getComment().isEmpty()) ? r.getComment() : "(No comment)" %></p>
                    <% if (r.getUserId() == currentReviewUserId) { %>
                        <button type="button"
                                class="review-edit-btn"
                                data-review-id="<%= r.getReviewId() %>"
                                data-product-id="<%= p.getProductId() %>"
                                data-rating="<%= r.getRating() %>"
                                data-comment="<%= r.getComment() != null ? r.getComment().replace("\"", "&quot;") : "" %>">
                            Edit Review
                        </button>
                    <% } %>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div id="reviews-list" class="reviews-list">
            <div class="premium-empty-state reviews-empty-state">
                <strong>No reviews yet</strong>
                <span>Customer reviews for this product will appear here.</span>
            </div>
        </div>
    <% } %>

</div>

<div class="modal fade" id="editReviewModal" tabindex="-1" aria-labelledby="editReviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form id="edit-review-form" action="<%= request.getContextPath() %>/review" method="post" onsubmit="return false;">
                <div class="modal-header">
                    <h5 class="modal-title" id="editReviewModalLabel">Edit Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="ajax" value="true">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="productId" id="edit-product-id" value="<%= p.getProductId() %>">
                    <input type="hidden" name="reviewId" id="edit-review-id">
                    <input type="hidden" name="rating" id="edit-rating" value="5">

                    <label>Rating</label>
                    <div class="star-rating-input" data-target="edit-rating" aria-label="Choose rating">
                        <button type="button" data-value="1">★</button>
                        <button type="button" data-value="2">★</button>
                        <button type="button" data-value="3">★</button>
                        <button type="button" data-value="4">★</button>
                        <button type="button" data-value="5">★</button>
                    </div>

                    <label for="edit-comment" style="margin-top:10px;">Comment (optional)</label>
                    <textarea name="comment" id="edit-comment" rows="3" class="form-control" placeholder="Share your experience..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Update Review</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%
} else {
%>

<h3>Product not found</h3>

<%
}
%>

</div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
const CARTIVA_CONTEXT_PATH = '<%= request.getContextPath() %>';
document.querySelectorAll('.quantity-selector').forEach(function(selector){
    var input = selector.querySelector('input[name="quantity"]');
    selector.querySelectorAll('.qty-step').forEach(function(button){
        button.addEventListener('click', function(){
            if(!input) return;
            var current = parseInt(input.value, 10) || 1;
            var min = parseInt(input.getAttribute('min'), 10) || 1;
            var max = parseInt(input.getAttribute('max'), 10) || current;
            var next = current + parseInt(button.getAttribute('data-step'), 10);
            if(next < min) next = min;
            if(max > 0 && next > max) next = max;
            input.value = next;
        });
    });
});
function escapeHtml(s){ if(!s) return ''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#039;'); }

function renderStars(num){
    var n = Math.round(parseFloat(num) || 0);
    var out = '';
    for(var i=1;i<=5;i++){
        if(i<=n){
            out += '<svg width="14" height="14" viewBox="0 0 24 24" fill="#f59e0b" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M12 .587l3.668 7.431L23.4 9.748l-5.7 5.556L19.335 24 12 20.202 4.665 24l1.634-8.696L.6 9.748l7.732-1.73L12 .587z"/></svg>';
        } else {
            out += '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="1" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M12 .587l3.668 7.431L23.4 9.748l-5.7 5.556L19.335 24 12 20.202 4.665 24l1.634-8.696L.6 9.748l7.732-1.73L12 .587z"/></svg>';
        }
    }
    return out;
}

function recalculateVisibleReviewAverage(){
    var cards = Array.from(document.querySelectorAll('.review-card'));
    var total = 0;
    var count = 0;

    cards.forEach(function(card){
        if(card.offsetParent === null) return;
        var rating = parseFloat(card.getAttribute('data-rating')) || 0;
        if(rating > 0){
            total += rating;
            count++;
        }
    });

    var avg = count > 0 ? (total / count) : 0;
    var avgStarsEl = document.getElementById('avg-stars');
    var avgValueEl = document.getElementById('avg-value');
    var countBadge = document.getElementById('review-count-badge');

    if(avgStarsEl) avgStarsEl.innerHTML = renderStars(avg);
    if(avgValueEl) avgValueEl.textContent = avg.toFixed(1);
    if(countBadge) countBadge.textContent = count + (count === 1 ? ' review' : ' reviews');
}

function setStarRating(container, value){
    var rating = parseInt(value, 10) || 5;
    var target = document.getElementById(container.getAttribute('data-target'));
    if(target) target.value = rating;
    container.querySelectorAll('button').forEach(function(star){
        var active = parseInt(star.getAttribute('data-value'), 10) <= rating;
        star.classList.toggle('active', active);
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

function bindReviewEditButtons(){
    document.querySelectorAll('.review-edit-btn').forEach(function(button){
        if(button.dataset.bound === 'true') return;
        button.dataset.bound = 'true';
        button.addEventListener('click', function(){
            document.getElementById('edit-review-id').value = button.getAttribute('data-review-id') || '';
            document.getElementById('edit-product-id').value = button.getAttribute('data-product-id') || document.getElementById('edit-product-id').value;
            document.getElementById('edit-rating').value = button.getAttribute('data-rating') || '5';
            document.getElementById('edit-comment').value = button.getAttribute('data-comment') || '';
            var stars = document.querySelector('#editReviewModal .star-rating-input');
            if(stars) setStarRating(stars, document.getElementById('edit-rating').value);
            var modalEl = document.getElementById('editReviewModal');
            if(window.bootstrap && modalEl){
                bootstrap.Modal.getOrCreateInstance(modalEl).show();
            }
        });
    });
}

document.addEventListener('DOMContentLoaded', function(){
    var editForm = document.getElementById('edit-review-form');
    bindStarInputs();
    bindReviewEditButtons();

    if(editForm) editForm.addEventListener('submit', function(event){
        event.preventDefault();
        event.stopPropagation();
        var action = 'update';
        var productId = document.getElementById('edit-product-id').value || '';
        var reviewId = document.getElementById('edit-review-id').value || '';
        var rating = document.getElementById('edit-rating').value || '';
        var comment = document.getElementById('edit-comment').value || '';
        var data = new URLSearchParams({
            action: action,
            reviewId: reviewId,
            productId: productId,
            rating: rating,
            comment: comment
        });
        console.log('REQUEST BODY', data.toString());

        var btn = editForm.querySelector('button[type="submit"]');
        if(btn) { btn.disabled = true; btn.innerText = 'Updating...'; }

        fetch(CARTIVA_CONTEXT_PATH + '/review', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: data
        }).then(function(res){
            return res.text().then(function(text){
                console.log('RAW RESPONSE', text);
                var json = {};
                try{ json = text ? JSON.parse(text) : {}; } catch(e){ json = {success:false, message:'Invalid JSON response'}; }
                if(!res.ok || !json.success) return Promise.reject(json);
                return json;
            });
        }).then(function(json){
            console.log('REVIEW UPDATE RESPONSE:', json);
            var r = json.review || {};
            var updatedReviewId = r.reviewId || reviewId;
            var updatedRating = r.rating || rating;
            var updatedComment = (typeof r.comment === 'string') ? r.comment : comment;
            updatedComment = updatedComment ? updatedComment.trim() : '';
            var reviewCard = document.getElementById('review-' + updatedReviewId);
            if(reviewCard){
                reviewCard.setAttribute('data-rating', updatedRating);
                var starsEl = reviewCard.querySelector('.review-stars');
                var commentEl = reviewCard.querySelector('.review-comment');
                var editButton = reviewCard.querySelector('.review-edit-btn');
                if(starsEl) starsEl.innerHTML = renderStars(updatedRating);
                if(commentEl) commentEl.textContent = updatedComment || '(No comment)';
                if(editButton){
                    editButton.setAttribute('data-rating', updatedRating);
                    editButton.setAttribute('data-comment', updatedComment || '');
                }
            }
            recalculateVisibleReviewAverage();
            var modalEl = document.getElementById('editReviewModal');
            if(window.bootstrap && modalEl){ bootstrap.Modal.getOrCreateInstance(modalEl).hide(); }
            if(window.CartivaToast) CartivaToast('Review updated successfully', 'success');
        }).catch(function(err){
            if(window.CartivaToast) CartivaToast((err && err.message) ? err.message : 'Failed to update review', 'error');
            else alert((err && err.message) ? err.message : 'Failed to update review');
        }).finally(function(){
            if(btn) { btn.disabled = false; btn.innerText = 'Update Review'; }
        });
    });
});
</script>
