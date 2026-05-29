package com.cartiva.dao.impl;

import com.cartiva.dao.ReviewDAO;

import com.cartiva.model.Review;
import com.cartiva.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {

    @Override
    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (product_id, user_id, rating, comment, created_at) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("ReviewDAO.addReview SQL: " + sql);
            System.out.println("ReviewDAO.addReview params: productId=" + review.getProductId()
                    + ", userId=" + review.getUserId()
                    + ", rating=" + review.getRating()
                    + ", comment=" + review.getComment());
            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.setTimestamp(5, Timestamp.valueOf(review.getCreatedAt() == null ? LocalDateTime.now() : review.getCreatedAt()));

            int rows = ps.executeUpdate();
            System.out.println("ReviewDAO.addReview rows affected: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("ReviewDAO.addReview SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.addReview ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<Review> getReviewsByProductId(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name AS user_name FROM reviews r LEFT JOIN users u ON r.user_id = u.user_id WHERE r.product_id = ? ORDER BY r.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("ReviewDAO.getReviewsByProductId SQL: " + sql);
            System.out.println("ReviewDAO.getReviewsByProductId params: productId=" + productId);
            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setUserName(rs.getString("user_name"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) r.setCreatedAt(ts.toLocalDateTime());

                list.add(r);
            }

        } catch (SQLException e) {
            System.out.println("ReviewDAO.getReviewsByProductId SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.getReviewsByProductId ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name AS user_name, p.name AS product_name FROM reviews r LEFT JOIN users u ON r.user_id = u.user_id LEFT JOIN products p ON r.product_id = p.product_id ORDER BY r.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setUserName(rs.getString("user_name"));
                r.setProductName(rs.getString("product_name"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) r.setCreatedAt(ts.toLocalDateTime());

                list.add(r);
            }

        } catch (SQLException e) {
            System.out.println("ReviewDAO.getAllReviews SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.getAllReviews ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM reviews WHERE review_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("ReviewDAO.deleteReview SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.deleteReview ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public int getReviewCount(int productId) {
        String sql = "SELECT COUNT(*) AS cnt FROM reviews WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("ReviewDAO.getReviewCount SQL: " + sql);
            System.out.println("ReviewDAO.getReviewCount params: productId=" + productId);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("cnt");

        } catch (SQLException e) {
            System.out.println("ReviewDAO.getReviewCount SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.getReviewCount ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(rating) AS avg_rating FROM reviews WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("ReviewDAO.getAverageRating SQL: " + sql);
            System.out.println("ReviewDAO.getAverageRating params: productId=" + productId);
            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }

        } catch (SQLException e) {
            System.out.println("ReviewDAO.getAverageRating SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.getAverageRating ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return 0.0;
    }

    @Override
    public boolean hasUserReviewed(int userId, int productId) {
        String sql = "SELECT COUNT(*) AS cnt FROM reviews WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("ReviewDAO.hasUserReviewed SQL: " + sql);
            System.out.println("ReviewDAO.hasUserReviewed params: userId=" + userId + ", productId=" + productId);
            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt") > 0;
            }

        } catch (SQLException e) {
            System.out.println("ReviewDAO.hasUserReviewed SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.hasUserReviewed ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Review getUserReview(int userId, int productId) {
        String sql = "SELECT r.*, u.full_name AS user_name FROM reviews r " +
                "LEFT JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.user_id = ? AND r.product_id = ? " +
                "ORDER BY r.created_at DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("ReviewDAO.getUserReview SQL: " + sql);
            System.out.println("ReviewDAO.getUserReview params: userId=" + userId + ", productId=" + productId);
            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setUserName(rs.getString("user_name"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) r.setCreatedAt(ts.toLocalDateTime());
                return r;
            }

        } catch (SQLException e) {
            System.out.println("ReviewDAO.getUserReview SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.getUserReview ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean hasDeliveredPurchase(int userId, int productId) {
        String sql = "SELECT COUNT(*) AS cnt " +
                "FROM orders o " +
                "JOIN order_items oi ON o.order_id = oi.order_id " +
                "WHERE o.user_id = ? AND oi.product_id = ? " +
                "AND UPPER(COALESCE(o.status,'')) = 'DELIVERED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("ReviewDAO.hasDeliveredPurchase SQL: " + sql);
            System.out.println("ReviewDAO.hasDeliveredPurchase params: userId=" + userId + ", productId=" + productId);
            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt") > 0;
            }

        } catch (SQLException e) {
            System.out.println("ReviewDAO.hasDeliveredPurchase SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.hasDeliveredPurchase ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateReview(int reviewId, int userId, int rating, String comment) {
        String sql = "UPDATE reviews SET rating = ?, comment = ? WHERE review_id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("ReviewDAO.updateReview SQL: " + sql);
            System.out.println("ReviewDAO.updateReview params: reviewId=" + reviewId
                    + ", userId=" + userId
                    + ", rating=" + rating
                    + ", comment=" + comment);
            ps.setInt(1, rating);
            ps.setString(2, comment == null ? "" : comment.trim());
            ps.setInt(3, reviewId);
            ps.setInt(4, userId);

            int rows = ps.executeUpdate();
            System.out.println("ReviewDAO.updateReview rows affected: " + rows);
            return rows > 0;

        } catch (SQLException e) {
            System.out.println("ReviewDAO.updateReview SQLException: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("ReviewDAO.updateReview ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}
