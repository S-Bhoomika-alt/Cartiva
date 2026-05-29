<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">

<div class="auth-container premium-auth-page register-auth-page">

    <div class="auth-split-shell register-shell">
        <section class="auth-brand-panel">
            <div class="auth-brand-content">
                <span class="auth-kicker">Join Cartiva</span>
                <h1>Create your fresh grocery account.</h1>
                <p>Save addresses, manage subscriptions, and get a premium checkout experience.</p>
                <div class="auth-feature-list">
                    <span>Dairy subscriptions</span>
                    <span>Wishlist sync</span>
                    <span>Order tracking</span>
                </div>
            </div>
        </section>

    <div class="auth-card premium-auth-card register-card">

        <div class="auth-heading">
            <span>Create account</span>
            <h2>Register</h2>
        </div>


        <%
        String error = request.getParameter("error");

        if(error != null){

            String msg = "Registration failed";

            if("invalid_name".equals(error)) msg = "Invalid name (min 3 characters)";
            else if("invalid_email".equals(error)) msg = "Invalid email format";
            else if("invalid_phone".equals(error)) msg = "Phone must be 10 digits";
            else if("invalid_password".equals(error)) msg = "Password must be at least 6 characters";
            else if("invalid_pincode".equals(error)) msg = "Pincode must be exactly 6 digits";
            else if("invalid_address".equals(error)) msg = "Please complete all address fields";
            else if("true".equals(error)) msg = "Email already exists";
        %>
            <p class="auth-message error"><%= msg %></p>
        <%
        }
        %>

        <div class="auth-scroll-panel">

            <form action="${pageContext.request.contextPath}/register"
                  method="post"
                  onsubmit="return validateForm()"
                  class="premium-auth-form register-form-grid">

                <label class="auth-field">
                    <span>Full Name</span>
                    <input type="text" id="name" name="name" placeholder="Full Name" required>
                </label>

                <label class="auth-field">
                    <span>Email</span>
                    <input type="email" id="email" name="email" placeholder="you@example.com" required>
                </label>

                <label class="auth-field">
                    <span>Phone</span>
                    <input type="text" id="phone" name="phone" placeholder="10 digit mobile number"
                       maxlength="10"
                       oninput="this.value=this.value.replace(/\D/g,'')"
                       required>
                </label>

                <label class="auth-field password-field">
                    <span>Password</span>
                    <div class="password-input-wrap">
                        <input type="password" id="password" name="password" placeholder="Create password" required>
                        <button type="button" class="password-toggle" aria-label="Show password">Show</button>
                    </div>
                </label>
                <p id="strengthMsg" class="strength-message"></p>

                <label class="auth-field full-span">
                    <span>Address Line 1</span>
                    <input type="text" id="address1" name="address1" placeholder="House number, street, area" required>
                </label>
                <label class="auth-field full-span">
                    <span>Address Line 2</span>
                    <input type="text" id="address2" name="address2" placeholder="Landmark or apartment" required>
                </label>
                <label class="auth-field">
                    <span>City</span>
                    <input type="text" id="city" name="city" placeholder="City" required>
                </label>
                <label class="auth-field">
                    <span>State</span>
                    <input type="text" id="state" name="state" placeholder="State" required>
                </label>
                <label class="auth-field">
                    <span>Pincode</span>
                    <input type="text"
       id="pincode"
       name="pincode"
       placeholder="Pincode"
       maxlength="6"
       pattern="\d{6}"
       oninput="this.value=this.value.replace(/\D/g,'')"
       required>
                </label>
                <label class="auth-field">
                    <span>Country</span>
                    <input type="text" id="country" name="country" placeholder="Country" required>
                </label>

                <button type="submit" class="auth-submit-btn full-span">Register</button>

            </form>

        </div>

        <a href="${pageContext.request.contextPath}/login" class="auth-switch-link">
            Already have an account? Login
        </a>

    </div>
    </div>

</div>


<script>
function validateForm() {

    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const phone = document.getElementById("phone").value.trim();
    const password = document.getElementById("password").value.trim();
    const pincode = document.getElementById("pincode").value.trim();
    const address1 = document.getElementById("address1").value.trim();
    const address2 = document.getElementById("address2").value.trim();
    const city = document.getElementById("city").value.trim();
    const state = document.getElementById("state").value.trim();
    const country = document.getElementById("country").value.trim();

    if (name.length < 3) {
        alert("Name must be at least 3 characters");
        return false;
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        alert("Invalid email format");
        return false;
    }

    if (!/^\d{10}$/.test(phone)) {
        alert("Phone must be exactly 10 digits");
        return false;
    }

    if (password.length < 6) {
        alert("Password must be at least 6 characters");
        return false;
    }

    if (!/^\d{6}$/.test(pincode)) {
        alert("Pincode must be exactly 6 digits");
        return false;
    }

    if (!address1 || !address2 || !city || !state || !country) {
        alert("Please complete all address fields");
        return false;
    }

    return true;
}
</script>


<script>
const pwd = document.getElementById("password");
const msg = document.getElementById("strengthMsg");

pwd.addEventListener("input", () => {
    const val = pwd.value;

    if (val.length < 6) {
        msg.style.color = "red";
        msg.innerText = "Weak (min 6 chars)";
    } else if (!/[A-Z]/.test(val) || !/[0-9]/.test(val)) {
        msg.style.color = "orange";
        msg.innerText = "Medium (add uppercase + number)";
    } else {
        msg.style.color = "green";
        msg.innerText = "Strong password";
    }
});
</script>

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
