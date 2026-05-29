package com.cartiva.dao;

import java.util.List;
import com.cartiva.model.Product;

public interface WishlistDAO {
	boolean isInWishlist(int userId, int productId);

    boolean addToWishlist(int userId, int productId);

    boolean removeFromWishlist(int userId, int productId);

    List<Product> getWishlistByUser(int userId);
}