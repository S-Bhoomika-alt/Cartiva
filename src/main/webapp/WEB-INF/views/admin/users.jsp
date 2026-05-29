<%@ page import="java.util.List" %>
<%@ page import="com.cartiva.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="admin-dashboard admin-feature-page">

    <div class="dashboard-top premium-admin-hero admin-customers-hero">
        <div>
            <span class="admin-breadcrumb">Admin / Customers</span>
            <h1>Customers</h1>
            <p>Manage all registered customer accounts</p>
        </div>

        <a href="<%=request.getContextPath()%>/admin"
           class="back-btn">
           ⬅ Back to Dashboard
        </a>
    </div>

    <div class="table-container admin-table-scroll">

        <table class="users-table admin-users-table admin-customers-table">
            <colgroup>
                <col class="col-customer-id">
                <col class="col-customer-name">
                <col class="col-customer-email">
                <col class="col-customer-role">
            </colgroup>

            <thead>

                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Role</th>
                </tr>

            </thead>

            <tbody>

            <%

            List<User> users =
            (List<User>) request.getAttribute("users");

            if(users != null){

                for(User user : users){

            %>

                <tr>

                    <td>
                        <%= user.getUserId() %>
                    </td>

                    <td>
                        <%= user.getFullName() %>
                    </td>

                    <td>
                        <%= user.getEmail() %>
                    </td>

                    <td>

                        <span class="role-badge">

                            <%= user.getRole() %>

                        </span>

                    </td>

                </tr>

            <%
                }
            }
            %>

            </tbody>

        </table>

    </div>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
