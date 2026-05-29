<%@ page import="com.cartiva.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
User user = (User) session.getAttribute("user");

if(user == null){
    response.sendRedirect("login");
    return;
}
%>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="auth-container premium-auth-page change-password-page">
    <div class="auth-card premium-auth-card forgot-password-card">
        <div class="auth-heading">
            <span>Security</span>
            <h2>Change Password</h2>
        </div>

        <form action="change-password" method="post" class="premium-auth-form">
            <label class="auth-field">
                <span>Current password</span>
                <input type="password" name="oldPassword" placeholder="Old Password" required>
            </label>
            <label class="auth-field">
                <span>New password</span>
                <input type="password" name="newPassword" placeholder="New Password" required>
            </label>
            <button type="submit">Update Password</button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
