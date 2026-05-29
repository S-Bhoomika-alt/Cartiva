<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.cartiva.model.Product, com.cartiva.dao.ReviewDAO, com.cartiva.dao.impl.ReviewDAOImpl" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container products-page premium-commerce-page">

<div class="commerce-page-header products-hero-bar">
    <div>
        <span class="admin-breadcrumb">Fresh Market</span>
        <h2 class="section-title">All Products</h2>
        <p>Explore fresh produce, dairy, snacks and daily essentials with fast checkout.</p>
    </div>
</div>

<div class="filter-bar products-filter-bar">

    <form id="filter-form" action="<%= request.getContextPath() %>/products" method="get">

        <select name="category" class="products-native-select" aria-label="Category">
            <option value="" <%= request.getParameter("category") == null || request.getParameter("category").trim().isEmpty() ? "selected" : "" %>>All Categories</option>
            <option value="Fruits" <%= "Fruits".equals(request.getParameter("category")) ? "selected" : "" %>>Fruits</option>
            <option value="Vegetables" <%= "Vegetables".equals(request.getParameter("category")) ? "selected" : "" %>>Vegetables</option>
            <option value="Dairy" <%= "Dairy".equals(request.getParameter("category")) ? "selected" : "" %>>Dairy</option>
            <option value="Snacks" <%= "Snacks".equals(request.getParameter("category")) ? "selected" : "" %>>Snacks</option>
        </select>

        <select name="sort" class="products-native-select" aria-label="Sort">
            <option value="" <%= request.getParameter("sort") == null || request.getParameter("sort").trim().isEmpty() ? "selected" : "" %>>Default</option>
            <option value="highest_rated" <%= "highest_rated".equals(request.getParameter("sort")) ? "selected" : "" %>>Highest Rated</option>
            <option value="best_seller" <%= "best_seller".equals(request.getParameter("sort")) ? "selected" : "" %>>Best Seller</option>
            <option value="price_asc" <%= "price_asc".equals(request.getParameter("sort")) ? "selected" : "" %>>Price Low to High</option>
            <option value="price_desc" <%= "price_desc".equals(request.getParameter("sort")) ? "selected" : "" %>>Price High to Low</option>
            <option value="newest" <%= "newest".equals(request.getParameter("sort")) ? "selected" : "" %>>Newest Products</option>
        </select>


        <input type="text" name="search" placeholder="Search fresh groceries, dairy, snacks..."
               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">


        <button type="submit" class="apply-filter-btn">Apply Filters</button>

    </form>

</div>
<div class="product-grid products-premium-grid">

<%
List<Product> products = (List<Product>) request.getAttribute("products");
com.cartiva.dao.ReviewDAO rdao = new com.cartiva.dao.impl.ReviewDAOImpl();

if(products != null && !products.isEmpty()){
for(Product p : products){

com.cartiva.dao.WishlistDAO wdao = new com.cartiva.dao.impl.WishlistDAOImpl();
com.cartiva.dao.SubscriptionDAO sdao = new com.cartiva.dao.impl.SubscriptionDAOImpl();

boolean isWish = false;
boolean isSub = false;

if(session.getAttribute("user") != null){
    com.cartiva.model.User u = (com.cartiva.model.User) session.getAttribute("user");
    isWish = wdao.isInWishlist(u.getUserId(), p.getProductId());
    isSub = sdao.isAlreadySubscribed(u.getUserId(), p.getProductId());
}
%>

<div class="card product-card premium-horizontal-product-card">

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

    <div class="product-card__media">
        <a href="<%= request.getContextPath() %>/products?id=<%= p.getProductId() %>" class="img-link product-card__image-link">
            <img class="product-img" src="<%= imgSrc %>" alt="<%= p.getName() %>">
        </a>
        <span onclick="toggleWishlist(<%= p.getProductId() %>, this)" class="wish-icon product-card__wishlist">
            <%= isWish ? "❤️" : "🤍" %>
        </span>
    </div>

    <div class="card-body product-card__content">
        <div class="product-card__top">
            <a href="<%= request.getContextPath() %>/products?id=<%= p.getProductId() %>" class="title-link"><h3><%= p.getName() %></h3></a>
            <%
                double prodAvg = rdao.getAverageRating(p.getProductId());
                int prodCount = rdao.getReviewCount(p.getProductId());
            %>
            <div class="rating-container">
                <div class="rating-stars">
                    <%
                        int rounded = (int) Math.round(prodAvg);
                        for(int i=1;i<=5;i++){
                            if(i<=rounded){ %>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="#f59e0b" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M12 .587l3.668 7.431L23.4 9.748l-5.7 5.556L19.335 24 12 20.202 4.665 24l1.634-8.696L.6 9.748l7.732-1.73L12 .587z"/></svg>
                            <% } else { %>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="1" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"><path d="M12 .587l3.668 7.431L23.4 9.748l-5.7 5.556L19.335 24 12 20.202 4.665 24l1.634-8.696L.6 9.748l7.732-1.73L12 .587z"/></svg>
                            <% }
                        }
                    %>
                </div>
                <div class="rating-badge">
                    <%= prodCount %>
                </div>
            </div>

            <div class="product-meta-line">
                <p class="category"><%= p.getCategory() %></p>
                <span class="fresh-badge <%= p.getStockQuantity() <= 0 ? "out-stock-badge" : "" %>">
                    <%= p.getStockQuantity() <= 0 ? "Out of Stock" : "Fresh" %>
                </span>
            </div>
            <span class="price">&#8377;<%= p.getPrice() %></span>
        </div>

        <div class="product-card__middle">
            <form action="<%= request.getContextPath() %>/cart" method="get" class="cart-form">
                <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                <button type="submit"
                        class="add-cart-btn <%= p.getStockQuantity() <= 0 ? "out-of-stock-btn" : "" %>"
                        <%= p.getStockQuantity() <= 0 ? "disabled" : "" %>>
                    <%= p.getStockQuantity() <= 0 ? "Out of Stock" : "Add to Cart" %>
                </button>
            </form>
        </div>


        <% if("Dairy".equalsIgnoreCase(p.getCategory())) { %>
        <div class="sub-box product-card__bottom">
            <% if(isSub){ %>
                <button class="sub-btn sub-btn--disabled" disabled>Subscribed ✔</button>
            <% } else { %>
                <form action="<%= request.getContextPath() %>/subscriptions" method="post" class="subscribe-form">
                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                    <input type="hidden" name="frequency" value="DAILY" id="freq-<%= p.getProductId() %>">

                    <div class="freq-container">
                        <button type="button" class="freq-btn active" onclick="setFreq(this,'DAILY',<%= p.getProductId() %>)">Daily</button>
                        <button type="button" class="freq-btn" onclick="setFreq(this,'WEEKLY',<%= p.getProductId() %>)">Weekly</button>
                    </div>

                    <div class="qty-box">
                        <button type="button" onclick="changeQty(-1,<%= p.getProductId() %>)">-</button>
                        <input type="number" name="quantity" value="1" min="1" id="qty-<%= p.getProductId() %>">
                        <button type="button" onclick="changeQty(1,<%= p.getProductId() %>)">+</button>
                    </div>

                    <button type="submit" class="sub-btn">Subscribe</button>
                    <p class="delivery-note">Pay on delivery • Cancel anytime</p>
                </form>
            <% } %>
        </div>
        <% } %>

    </div>

</div>

<%
}
}else{
%>
<div class="premium-empty-state products-empty-state">
    <strong>No products found</strong>
    <span>Try another category, sort option, or search keyword.</span>
</div>
<%
}
%>

</div>

<div class="premium-pagination-wrapper">

<%
int tp = request.getAttribute("totalPages") != null
? (Integer) request.getAttribute("totalPages")
: 1;

int currentPage = request.getAttribute("currentPage") != null
? (Integer) request.getAttribute("currentPage")
: 1;

int start = Math.max(1, currentPage - 2);
int end = Math.min(tp, currentPage + 2);
%>

<div class="premium-pagination">


    <% if(currentPage > 1){ %>

    <a
    href="<%= request.getContextPath() %>/products?page=<%= currentPage-1 %>"
    class="premium-page-btn nav-page-btn">

    ←

    </a>

    <% } %>


    <% for(int i=start; i<=end; i++){ %>

    <a
    href="<%= request.getContextPath() %>/products?page=<%= i %>"
    class="premium-page-btn <%= (i==currentPage) ? "active-premium-page" : "" %>">

    <%= i %>

    </a>

    <% } %>


    <% if(currentPage < tp){ %>

    <a
    href="<%= request.getContextPath() %>/products?page=<%= currentPage+1 %>"
    class="premium-page-btn nav-page-btn">

    →

    </a>

    <% } %>

</div>

</div>
</div>


<script>
function setFreq(el,value,id){
document.getElementById("freq-"+id).value=value;
el.parentElement.querySelectorAll(".freq-btn").forEach(b=>b.classList.remove("active"));
el.classList.add("active");
}

function changeQty(change,id){
let input=document.getElementById("qty-"+id);
let val=parseInt(input.value)||1;
val+=change;
if(val<1) val=1;
input.value=val;
}
</script>
<script>
function toggleWishlist(productId, el) {
    fetch('<%= request.getContextPath() %>/wishlist?action=toggle&productId=' + productId)
    .then(() => {
        el.innerText = (el.innerText === "🤍") ? "❤️" : "🤍";
    });
}
</script>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
