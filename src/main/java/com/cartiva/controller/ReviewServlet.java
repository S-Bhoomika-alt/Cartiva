package com.cartiva.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.Enumeration;
import java.util.List;
import java.util.Locale;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.cartiva.dao.ReviewDAO;
import com.cartiva.dao.impl.ReviewDAOImpl;
import com.cartiva.model.Review;
import com.cartiva.model.User;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        reviewDAO = new ReviewDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            System.out.println("===== REVIEW REQUEST START =====");
            Enumeration<String> params = request.getParameterNames();
            while (params.hasMoreElements()) {
                String p = params.nextElement();
                System.out.println(p + " = " + request.getParameter(p));
            }
            System.out.println("Request URI: " + request.getRequestURI());
            System.out.println("Method: " + request.getMethod());
            System.out.println("reviewId=" + request.getParameter("reviewId"));
            System.out.println("productId=" + request.getParameter("productId"));
            System.out.println("rating=" + request.getParameter("rating"));
            System.out.println("comment=" + request.getParameter("comment"));
            System.out.println("action=" + request.getParameter("action"));

            Object sessionUser = request.getSession().getAttribute("user");
            if (!(sessionUser instanceof User)) {
                sendJson(response, json(false, "Please log in to review this product"));
                return;
            }

            User user = (User) sessionUser;
            String action = trim(request.getParameter("action"));
            String comment = trim(request.getParameter("comment"));
            String productIdParam = request.getParameter("productId");
            String ratingParam = request.getParameter("rating");
            String reviewIdParam = request.getParameter("reviewId");
            System.out.println("ACTION = " + action);

            if (action == null || action.isBlank()) {
                sendJson(response, json(false, "Review action missing"));
                return;
            }

            if (!"create".equalsIgnoreCase(action) && !"add".equalsIgnoreCase(action) && !"update".equalsIgnoreCase(action)) {
                sendJson(response, json(false, "Invalid review action"));
                return;
            }

            if (productIdParam == null || productIdParam.isBlank()) {
                sendJson(response, json(false, "Product ID missing"));
                return;
            }

            if (ratingParam == null || ratingParam.isBlank()) {
                sendJson(response, json(false, "Rating missing"));
                return;
            }

            int productId = Integer.parseInt(productIdParam.trim());
            int rating = Integer.parseInt(ratingParam.trim());

            if (productId <= 0 || rating < 1 || rating > 5) {
                sendJson(response, json(false, "Invalid review details"));
                return;
            }

            if ("update".equalsIgnoreCase(action)) {
                if (reviewIdParam == null || reviewIdParam.isBlank()) {
                    sendJson(response, json(false, "Review ID missing"));
                    return;
                }

                int reviewId = Integer.parseInt(reviewIdParam.trim());
                if (reviewId <= 0) {
                    sendJson(response, json(false, "Invalid review"));
                    return;
                }

                System.out.println("UPDATE reviewId=" + reviewId);
                System.out.println("UPDATE userId=" + user.getUserId());
                System.out.println("Calling DAO updateReview(reviewId=" + reviewId + ", userId=" + user.getUserId() + ", rating=" + rating + ")");
                boolean updated = reviewDAO.updateReview(reviewId, user.getUserId(), rating, comment);
                System.out.println("UPDATE rows=" + (updated ? 1 : 0));
                System.out.println("DAO RESULT = " + updated);
                if (!updated) {
                    sendJson(response, json(false, "You can edit only your own review"));
                    return;
                }

                sendJson(response, json(true, "Review saved"));
                return;
            }

            System.out.println("Calling DAO hasDeliveredPurchase(userId=" + user.getUserId() + ", productId=" + productId + ")");
            boolean deliveredPurchase = reviewDAO.hasDeliveredPurchase(user.getUserId(), productId);
            System.out.println("DAO RESULT = " + deliveredPurchase);
            if (!deliveredPurchase) {
                sendJson(response, json(false, "You can review only purchased products"));
                return;
            }

            System.out.println("Calling DAO hasUserReviewed(userId=" + user.getUserId() + ", productId=" + productId + ")");
            boolean alreadyReviewed = reviewDAO.hasUserReviewed(user.getUserId(), productId);
            System.out.println("DAO RESULT = " + alreadyReviewed);
            if (alreadyReviewed) {
                sendJson(response, json(false, "You have already reviewed this product"));
                return;
            }

            Review review = new Review();
            review.setProductId(productId);
            review.setUserId(user.getUserId());
            review.setRating(rating);
            review.setComment(comment);
            review.setCreatedAt(LocalDateTime.now());

            System.out.println("Calling DAO addReview(productId=" + productId + ", userId=" + user.getUserId() + ", rating=" + rating + ")");
            boolean added = reviewDAO.addReview(review);
            System.out.println("DAO RESULT = " + added);
            if (!added) {
                sendJson(response, json(false, "Could not add review"));
                return;
            }

            sendJson(response, json(true, "Review saved"));

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("REVIEW ERROR:");
            System.out.println(e.getClass().getName());
            System.out.println(e.getMessage());
            sendJson(response, json(false, e.getMessage()));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        writeJson(response, HttpServletResponse.SC_METHOD_NOT_ALLOWED, json(false, "Review requests must use POST"));
    }

    private void handleAdd(HttpServletResponse response, User user, int productId, int rating, String comment) throws IOException {
        try {
            if (!reviewDAO.hasDeliveredPurchase(user.getUserId(), productId)) {
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, json(false, "You can review only delivered purchased products"));
                return;
            }

            if (reviewDAO.hasUserReviewed(user.getUserId(), productId)) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, json(false, "You have already reviewed this product"));
                return;
            }

            Review review = new Review();
            review.setProductId(productId);
            review.setUserId(user.getUserId());
            review.setRating(rating);
            review.setComment(comment);
            review.setCreatedAt(LocalDateTime.now());

            if (!reviewDAO.addReview(review)) {
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, json(false, "Could not add review"));
                return;
            }

            writeReviewJson(response, productId, 0);
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, json(false, "Could not add review"));
        }
    }

    private void handleUpdate(HttpServletResponse response, User user, int productId, int reviewId, int rating, String comment) throws IOException {
        try {
            if (reviewId <= 0) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, json(false, "Invalid review"));
                return;
            }

            if (!reviewDAO.updateReview(reviewId, user.getUserId(), rating, comment)) {
                writeJson(response, HttpServletResponse.SC_FORBIDDEN, json(false, "You can edit only your own review"));
                return;
            }

            writeReviewJson(response, productId, reviewId);
        } catch (Exception e) {
            e.printStackTrace();
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, json(false, "Could not update review"));
        }
    }

    private void writeReviewJson(HttpServletResponse response, int productId, int preferredReviewId) throws IOException {
        writeJson(response, HttpServletResponse.SC_OK, reviewJson(productId, preferredReviewId, "Review saved"));
    }

    private String reviewJson(int productId, int preferredReviewId, String message) {
        List<Review> allReviews = reviewDAO.getReviewsByProductId(productId);
        Review selected = null;

        if (allReviews != null && !allReviews.isEmpty()) {
            if (preferredReviewId > 0) {
                for (Review review : allReviews) {
                    if (review.getReviewId() == preferredReviewId) {
                        selected = review;
                        break;
                    }
                }
            }
            if (selected == null) {
                selected = allReviews.get(0);
            }
        }

        double avg = reviewDAO.getAverageRating(productId);
        int count = allReviews != null ? allReviews.size() : 0;

        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true");
        json.append(",\"message\":\"").append(escape(message)).append("\"");
        json.append(",\"avg\":").append(String.format(Locale.US, "%.2f", avg));
        json.append(",\"count\":").append(count);
        json.append(",\"review\":");
        if (selected == null) {
            json.append("null");
        } else {
            String userName = selected.getUserName() == null ? ("User #" + selected.getUserId()) : selected.getUserName();
            json.append("{");
            json.append("\"reviewId\":").append(selected.getReviewId()).append(",");
            json.append("\"productId\":").append(selected.getProductId()).append(",");
            json.append("\"userId\":").append(selected.getUserId()).append(",");
            json.append("\"userName\":\"").append(escape(userName)).append("\",");
            json.append("\"rating\":").append(selected.getRating()).append(",");
            json.append("\"comment\":\"").append(escape(selected.getComment())).append("\",");
            json.append("\"createdAt\":\"").append(selected.getCreatedAt() == null ? "" : escape(selected.getCreatedAt().toString())).append("\"");
            json.append("}");
        }
        json.append("}");

        return json.toString();
    }

    private void writeJson(HttpServletResponse response, int status, String json) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        System.out.println("FINAL JSON=" + json);
        response.resetBuffer();
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private void sendJson(HttpServletResponse response, String json) throws IOException {
        System.out.println("RETURNING JSON: " + json);
        response.resetBuffer();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    private String json(boolean success, String message) {
        return "{\"success\":" + success + ",\"message\":\"" + escape(message) + "\"}";
    }

    private int parseInt(String value) {
        if (value == null || value.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private String escape(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "\\n");
    }
}
