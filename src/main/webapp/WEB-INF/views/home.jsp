<%@ page import="java.util.*, com.cartiva.model.Product" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<style>
.hero-btn {
    padding: 12px 22px;
    background: #2e7d32;
    color: white !important;
    border-radius: 8px;
    text-decoration: none !important;
    font-weight: bold;
    margin-right: 10px;
    display: inline-block;
}
.hero-btn:hover { background: #1b5e20; }
.hero-btn.secondary { background: #555; }
</style>

<div class="container home-page">


    <div class="hero">
        <div class="hero-container container">

            <div class="hero-text">
                <h1>Fresh Grocery Delivered Daily</h1>
                <p>Shop fresh fruits, vegetables, dairy and more at best prices.</p>

                <div class="hero-buttons">
                    <a href="<%= request.getContextPath() %>/products" class="hero-btn">
                        Shop Now
                    </a>

                    <a href="#categories" class="hero-btn secondary">
                        Explore
                    </a>
                </div>
            </div>

            <div class="hero-image">
    <img
    src="<%= request.getContextPath() %>/assets/images/delivery-agent.jpg"
    alt="delivery agent"
    style="width:350px; height:250px; object-fit:cover; border-radius:12px;">
        </div>
    </div>
    </div>


<div class="categories" id="categories">
    <h2 class="section-title">Top Categories</h2>

    <div class="category-grid">

        <a href="<%= request.getContextPath() %>/products?category=Fruits" class="category-card">
            <img src="<%= request.getContextPath() %>/assets/images/fruits.jpg" alt="Fruits">
            <h3>Fruits</h3>
        </a>

        <a href="<%= request.getContextPath() %>/products?category=Vegetables" class="category-card">
            <img src="<%= request.getContextPath() %>/assets/images/vegetables.jpg" alt="Vegetables">
            <h3>Vegetables</h3>
        </a>

        <a href="<%= request.getContextPath() %>/products?category=Dairy" class="category-card">
            <img src="<%= request.getContextPath() %>/assets/images/dairy.jpg" alt="Dairy">
            <h3>Dairy</h3>
        </a>

        <a href="<%= request.getContextPath() %>/products?category=Snacks" class="category-card">
            <img src="<%= request.getContextPath() %>/assets/images/snacks.jpg" alt="Snacks">
            <h3>Snacks</h3>
        </a>

    </div>
</div>

    <h2 class="section-title">Latest Products</h2>

    <div class="product-grid home-product-grid">

    <%
        List<Product> products = (List<Product>) request.getAttribute("latestProducts");


        com.cartiva.dao.SubscriptionDAO sdao = new com.cartiva.dao.impl.SubscriptionDAOImpl();

        if(products != null && !products.isEmpty()){
            for(Product p : products){
    %>

        <div class="card home-product-card" style="position:relative;">


            <%
                com.cartiva.dao.WishlistDAO wdao = new com.cartiva.dao.impl.WishlistDAOImpl();
                boolean isWish = false;

                if(session.getAttribute("user") != null){
                    com.cartiva.model.User u = (com.cartiva.model.User) session.getAttribute("user");
                    isWish = wdao.isInWishlist(u.getUserId(), p.getProductId());
                }
            %>

            <span onclick="toggleWishlist(<%= p.getProductId() %>, this)"
                  class="home-wishlist-toggle"
                  style="position:absolute; top:10px; right:10px; font-size:22px; cursor:pointer;">
                <%= isWish ? "❤️" : "🤍" %>
            </span>


            <a href="<%= request.getContextPath() %>/product?id=<%= p.getProductId() %>" class="img-link">
                <img class="product-img" src="<%= request.getContextPath() %>/<%=
                    (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty())
                    ? p.getImageUrl().trim()
                    : "assets/images/default.png"
                    %>" alt="<%= p.getName() %>">
            </a>

            <div class="card-body">
                <a href="<%= request.getContextPath() %>/product?id=<%= p.getProductId() %>" class="title-link"><h3><%= p.getName() %></h3></a>
                <p class="category"><%= p.getCategory() != null ? p.getCategory() : "Fresh Grocery" %></p>
                <p class="price">₹<%= p.getPrice() %></p>


                <form action="<%= request.getContextPath() %>/cart" method="get" class="cart-form">
                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                    <button type="submit"
                            class="<%= p.getStockQuantity() <= 0 ? "out-of-stock-btn" : "" %>"
                            <%= p.getStockQuantity() <= 0 ? "disabled" : "" %>>
                        <%= p.getStockQuantity() <= 0 ? "Out of Stock" : "Add to Cart" %>
                    </button>
                </form>
            </div>


            <% if("Dairy".equalsIgnoreCase(p.getCategory())) { %>

            <div class="sub-box">

            <%
                boolean isSub = false;

                if(session.getAttribute("user") != null){
                    com.cartiva.model.User u = (com.cartiva.model.User) session.getAttribute("user");
                    isSub = sdao.isAlreadySubscribed(u.getUserId(), p.getProductId());
                }
            %>

            <% if(isSub){ %>

                <button type="button" class="sub-btn" style="background:gray;" disabled>
                    Subscribed ✔
                </button>

            <% } else { %>

                <form action="<%= request.getContextPath() %>/subscriptions" method="post">

                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                    <input type="hidden" name="frequency" value="DAILY" id="freq-<%= p.getProductId() %>">

                    <div class="freq-container">
                        <button type="button" class="freq-btn active"
                            onclick="setFreq(this, 'DAILY', <%= p.getProductId() %>)">
                            Daily
                        </button>

                        <button type="button" class="freq-btn"
                            onclick="setFreq(this, 'WEEKLY', <%= p.getProductId() %>)">
                            Weekly
                        </button>
                    </div>

                    <div class="qty-box">
                        <button type="button" onclick="changeQty(-1, <%= p.getProductId() %>)">-</button>

                        <input type="number" name="quantity" value="1" min="1"
                               id="qty-<%= p.getProductId() %>">

                        <button type="button" onclick="changeQty(1, <%= p.getProductId() %>)">+</button>
                    </div>

<button type="submit" class="sub-btn">Subscribe (Pay on Delivery)</button>
<p style="font-size:12px; color:gray; margin-top:4px;">
    Pay on delivery • Cancel anytime
</p>
                </form>

            <% } %>

            </div>

            <% } %>

        </div>

    <%
            }
        } else {
    %>
        <p>No products available</p>
    <%
        }
    %>

    </div>

</div>

<script>
function toggleWishlist(productId, el) {
    fetch('<%= request.getContextPath() %>/wishlist?action=toggle&productId=' + productId)
    .then(() => {
        el.innerText = (el.innerText === "🤍") ? "❤️" : "🤍";
    });
}

function setFreq(el, value, id) {
    document.getElementById("freq-" + id).value = value;
    el.parentElement.querySelectorAll(".freq-btn").forEach(btn => btn.classList.remove("active"));
    el.classList.add("active");
}

function changeQty(change, id) {
    let input = document.getElementById("qty-" + id);
    let val = parseInt(input.value) || 1;
    val += change;
    if (val < 1) val = 1;
    input.value = val;
}
</script>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
