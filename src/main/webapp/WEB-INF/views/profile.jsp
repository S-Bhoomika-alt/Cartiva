<%@ page import="com.cartiva.model.User" %>
<%
User user = (User) session.getAttribute("user");

if(user == null){
    response.sendRedirect("login");
    return;
}
%>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container profile-page premium-commerce-page">
<div class="profile-container premium-profile-shell">
<%
String success = (String) session.getAttribute("successMsg");
String error = (String) session.getAttribute("errorMsg");

if(success != null){
%>
    <p class="profile-alert success"><%= success %></p>
<%
    session.removeAttribute("successMsg");
}

if(error != null){
%>
    <p class="profile-alert error"><%= error %></p>
<%
    session.removeAttribute("errorMsg");
}
%>
    <div class="profile-hero">
        <div class="profile-big-avatar">
            <%= user.getFullName().substring(0,1).toUpperCase() %>
        </div>
        <div>
            <h2>My Profile</h2>
            <p>Manage your account, contact details, and delivery address.</p>
        </div>
    </div>

    <form action="profile" method="post" class="profile-form-grid">

        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="full_name" value="<%= user.getFullName() %>" required>
        </div>

        <div class="form-group">
            <label>Email (Cannot be changed)</label>
            <input type="email" value="<%= user.getEmail() %>" readonly>
        </div>

        <div class="form-group">
            <label>Phone</label>
            <input type="text" name="phone" value="<%= user.getPhone() %>">
        </div>

        <div class="form-group">
            <label>Address Line 1</label>
            <input type="text" name="address_line1" value="<%= user.getAddressLine1() %>">
        </div>

        <div class="form-group">
            <label>Address Line 2</label>
            <input type="text" name="address_line2" value="<%= user.getAddressLine2() %>">
        </div>

        <div class="form-group">
            <label>City</label>
            <input type="text" name="city" value="<%= user.getCity() %>">
        </div>

        <div class="form-group">
            <label>State</label>
            <input type="text" name="state" value="<%= user.getState() %>">
        </div>

        <div class="form-group">
            <label>Pincode</label>
            <input type="text" name="pincode" value="<%= user.getPincode() %>">
        </div>

        <div class="form-group">
            <label>Country</label>
            <input type="text" name="country" value="<%= user.getCountry() %>">
        </div>

        <button type="submit" class="btn profile-save-btn">Update Profile</button>

    </form>
</div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
