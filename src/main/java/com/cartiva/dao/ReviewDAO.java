package com.cartiva.dao;

import java.util.List;
import com.cartiva.model.Review;

public interface ReviewDAO {

    boolean addReview(Review review);

    List<Review> getReviewsByProductId(int productId);

    double getAverageRating(int productId);

    boolean hasUserReviewed(int userId, int productId);

    Review getUserReview(int userId, int productId);

    boolean hasDeliveredPurchase(int userId, int productId);

    boolean updateReview(int reviewId, int userId, int rating, String comment);


    java.util.List<Review> getAllReviews();


    boolean deleteReview(int reviewId);


    int getReviewCount(int productId);

}
