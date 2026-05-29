<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">

<div class="auth-container premium-auth-page forgot-auth-page">
  <div class="auth-card premium-auth-card forgot-password-card">
    <div class="auth-heading">
      <span>Account recovery</span>
      <h2>Reset Password</h2>
    </div>

    <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="premium-auth-form">
        <label class="auth-field">
            <span>Email address</span>
            <input type="email" name="email" placeholder="Enter your email" required>
        </label>
        <label class="auth-field">
            <span>New password</span>
            <input type="password" name="newPassword" placeholder="New password" required>
        </label>
        <button type="submit">Reset Password</button>
    </form>

    <a href="${pageContext.request.contextPath}/login" class="auth-switch-link">Back to Login</a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
