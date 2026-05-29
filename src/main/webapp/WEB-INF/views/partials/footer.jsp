<%@ page contentType="text/html;charset=UTF-8" %>

<footer class="footer premium-footer">

    <div class="container">

        <div class="footer-grid">

            <div class="footer-brand">
                <span class="footer-kicker">Fresh grocery everyday</span>
                <h2>Cartiva</h2>
                <p>
                    Premium fresh groceries, pantry staples and daily essentials delivered with care.
                </p>
            </div>

            <div class="footer-links">
                <a href="<%= request.getContextPath() %>/home">Home</a>
                <a href="<%= request.getContextPath() %>/products">Products</a>
                <a href="<%= request.getContextPath() %>/wishlist">Wishlist</a>
                <a href="<%= request.getContextPath() %>/orders">Orders</a>
                <a href="<%= request.getContextPath() %>/subscriptions">Subscriptions</a>
            </div>

            <div class="footer-service">
                <strong>Fast, fresh, reliable</strong>
                <span>Quality checked produce</span>
                <span>Secure checkout</span>
                <span>Easy subscriptions</span>
            </div>

        </div>

        <div class="footer-bottom">
            <span>© 2026 Cartiva Grocery. All Rights Reserved.</span>
        </div>

    </div>

</footer>

<script>

function confirmDelete(){
    return confirm(
        "Are you sure you want to delete this product?"
    );
}

function confirmEdit(){
    return confirm(
        "Do you want to edit this product?"
    );
}

function confirmOrderAction(action){
    return confirm(
        "Are you sure you want to " + action + " this order?"
    );
}

function CartivaGoBack(fallbackUrl){
    if(window.history.length > 1){
        window.history.back();
        return;
    }
    window.location.href = fallbackUrl || '<%= request.getContextPath() %>/home';
}

function CartivaToast(message, type){
    let toast = document.querySelector('.cartiva-toast');
    if(!toast){
        toast = document.createElement('div');
        toast.className = 'cartiva-toast';
        document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.classList.remove('success','error','show');
    toast.classList.add(type === 'error' ? 'error' : 'success');
    setTimeout(function(){ toast.classList.add('show'); }, 10);
    clearTimeout(window.__cartivaToastTimer);
    window.__cartivaToastTimer = setTimeout(function(){
        toast.classList.remove('show');
    }, 2600);
}

function CartivaUpdateCartBadge(count){
    const cartLink = document.querySelector('.cart-link');
    if(!cartLink) return;
    let badge = cartLink.querySelector('.cart-badge');
    if(count > 0){
        if(!badge){
            badge = document.createElement('span');
            badge.className = 'cart-badge';
            cartLink.appendChild(badge);
        }
        badge.textContent = count;
    } else if(badge) {
        badge.remove();
    }
}

document.addEventListener('submit', function(e){
    const form = e.target;
    if(!form || !form.matches('form.cart-form, form.cart-box')) return;
    const productInput = form.querySelector('input[name="productId"]');
    const submitButton = form.querySelector('button[type="submit"]');
    if(!productInput || !form.action || form.action.indexOf('/cart') === -1) return;
    e.preventDefault();
    if(submitButton && submitButton.disabled){
        CartivaToast('This product is currently out of stock.', 'error');
        return;
    }
    const params = new URLSearchParams(new FormData(form));
    params.set('ajax', 'true');
    const originalButtonText = submitButton ? submitButton.textContent : '';
    if(submitButton){
        submitButton.disabled = true;
        submitButton.textContent = 'Adding...';
        submitButton.classList.add('cartiva-loading-btn');
    }
    fetch(form.action + '?' + params.toString(), {
        method: 'GET',
        headers: {'X-Requested-With':'XMLHttpRequest'}
    })
    .then(function(res){ return res.json(); })
    .then(function(json){
        CartivaToast(json.message || (json.success ? 'Added to cart successfully' : 'Could not add product'), json.success ? 'success' : 'error');
        if(typeof json.cartCount !== 'undefined') CartivaUpdateCartBadge(json.cartCount);
    })
    .catch(function(){
        CartivaToast('Could not add product. Please try again.', 'error');
    })
    .finally(function(){
        if(submitButton){
            submitButton.disabled = false;
            submitButton.textContent = originalButtonText || 'Add to Cart';
            submitButton.classList.remove('cartiva-loading-btn');
        }
    });
});


window.onload = function(){

    const params =
    new URLSearchParams(window.location.search);

    if(params.get("success")){

        alert("Action completed successfully!");

    }
};

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
