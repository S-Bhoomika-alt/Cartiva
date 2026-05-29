<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.cartiva.model.Review" %>

<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container admin-feature-page" style="margin-top:30px;">
    <div class="admin-feature-header">
    <span class="admin-breadcrumb">Admin / Reviews</span>
    <h1>Product Reviews</h1>
    </div>

    <a href="<%= request.getContextPath() %>/admin"
       class="premium-back-button admin-review-back-button">
        <span class="back-icon">←</span>
        Back to Dashboard
    </a>

    <p>All reviews submitted by users. Admin can delete inappropriate reviews.</p>

    <%
        List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    %>

    <div class="admin-table-scroll">
    <table class="admin-reviews-table" style="width:100%; border-collapse:collapse; margin-top:12px;">
        <colgroup>
            <col class="col-review-id">
            <col class="col-review-product">
            <col class="col-review-user">
            <col class="col-review-rating">
            <col class="col-review-comment">
            <col class="col-review-date">
            <col class="col-review-action">
        </colgroup>
        <thead>
            <tr style="text-align:left; border-bottom:1px solid #e5e7eb;">
                <th style="padding:8px;">#</th>
                <th style="padding:8px;">Product</th>
                <th style="padding:8px;">User</th>
                <th style="padding:8px;">Rating</th>
                <th style="padding:8px;">Comment</th>
                <th style="padding:8px;">Posted</th>
                <th style="padding:8px;">Actions</th>
            </tr>
        </thead>
        <tbody>
            <% if(reviews != null && !reviews.isEmpty()){
                int idx = 1;
                for(Review r : reviews){ %>
            <tr style="border-bottom:1px solid #f1f5f9;">
                <td style="padding:8px; vertical-align:top;"><%= idx++ %></td>
                <td style="padding:8px; vertical-align:top;"><%= r.getProductName() != null ? r.getProductName() : ("#"+r.getProductId()) %></td>
                <td style="padding:8px; vertical-align:top;"><%= r.getUserName() != null ? r.getUserName() : ("User #"+r.getUserId()) %></td>
                <td style="padding:8px; vertical-align:top; color:#f59e0b; font-weight:700;"><% for(int i=1;i<=5;i++){ if(i<=r.getRating()) out.print('★'); else out.print('☆'); } %></td>
                <td style="padding:8px; vertical-align:top;"><%= r.getComment() %></td>
                <td style="padding:8px; vertical-align:top;"><%= r.getCreatedAt() != null ? r.getCreatedAt().toString().replace('T',' ') : "-" %></td>
                <td style="padding:8px; vertical-align:top;">
                    <form method="post" action="<%= request.getContextPath() %>/admin/reviews/delete" onsubmit="return confirm('Delete this review?');">
                        <input type="hidden" name="reviewId" value="<%= r.getReviewId() %>">
                        <button type="submit" style="background:#ef4444; color:white; border:none; padding:6px 10px; border-radius:6px; cursor:pointer;">Delete</button>
                    </form>
                </td>
            </tr>
            <%    }
            } else { %>
            <tr><td colspan="7" style="padding:12px;">No reviews found.</td></tr>
            <% } %>
        </tbody>
    </table>
    </div>

</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
