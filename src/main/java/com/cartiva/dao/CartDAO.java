package com.cartiva.dao;

import java.util.List;
import com.cartiva.model.Cart;

public interface CartDAO {

    boolean addToCart(int userId, int productId, int quantity);

    boolean removeItem(int userId, int productId);

    boolean updateQuantity(int userId, int productId, int change);

    List<Cart> getCartByUser(int userId);

    void clearCart(int userId);

}