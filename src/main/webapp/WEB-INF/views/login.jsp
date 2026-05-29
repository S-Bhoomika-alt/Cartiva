<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">

<div class="auth-container premium-auth-page">

    <div class="auth-split-shell">
        <section class="auth-brand-panel">
            <div class="auth-brand-content">
                <span class="auth-kicker">Cartiva Fresh</span>
                <h1>Welcome back to smarter grocery shopping.</h1>
                <p>Track orders, save favourites, and checkout faster with your Cartiva account.</p>
                <div class="auth-feature-list">
                    <span>Fresh daily picks</span>
                    <span>Fast checkout</span>
                    <span>Secure account</span>
                </div>
            </div>
        </section>

    <div class="auth-card premium-auth-card">
        <div class="auth-heading">
            <span>Sign in</span>
            <h2>Login</h2>
        </div>
<%
    String error = request.getParameter("error");

    if ("user_not_found".equals(error)) {
%>
    <p class="auth-message error">User not found</p>
    <a href="${pageContext.request.contextPath}/register" class="auth-inline-action">
        <button type="button" class="auth-secondary-btn">
            Register Now
        </button>
    </a>
<%
    } else if ("invalid_password".equals(error)) {
%>
    <p class="auth-message error">Invalid email or password</p>
<%
    }
%>

        <form action="${pageContext.request.contextPath}/login" method="post" class="premium-auth-form">

            <label class="auth-field">
                <span>Email</span>
                <input type="email" name="email" placeholder="you@example.com" required>
            </label>

            <label class="auth-field password-field">
                <span>Password</span>
                <div class="password-input-wrap">
                    <input type="password" name="password" placeholder="Enter password" required>
                    <button type="button" class="password-toggle" aria-label="Show password">Show</button>
                </div>
            </label>

            <div class="auth-form-row">
                <label class="remember-control">
                    <input type="checkbox">
                    <span>Remember me</span>
                </label>
                <a href="${pageContext.request.contextPath}/forgot-password">
                    Forgot Password?
                </a>
            </div>

            <button type="submit" class="auth-submit-btn">Login</button>

        </form>

        <a href="${pageContext.request.contextPath}/register" class="auth-switch-link">
            Don't have an account? Register
        </a>

    </div>
    </div>

</div>

<script>
document.querySelectorAll(".password-toggle").forEach(function(button){
    button.addEventListener("click", function(){
        const input = button.parentElement.querySelector("input");
        const isHidden = input.type === "password";
        input.type = isHidden ? "text" : "password";
        button.innerText = isHidden ? "Hide" : "Show";
    });
});
</script>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
