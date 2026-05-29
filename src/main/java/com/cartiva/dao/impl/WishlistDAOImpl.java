package com.cartiva.dao.impl;

import java.sql.*;
import java.util.*;

import com.cartiva.dao.WishlistDAO;
import com.cartiva.model.Product;
import com.cartiva.util.DBConnection;

public class WishlistDAOImpl implements WishlistDAO {

    @Override
    public boolean addToWishlist(int userId, int productId) {
        try (Connection con = DBConnection.getConnection()) {

            String sql = "INSERT INTO wishlist(user_id, product_id) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean removeFromWishlist(int userId, int productId) {
        try (Connection con = DBConnection.getConnection()) {

            String sql = "DELETE FROM wishlist WHERE user_id=? AND product_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Product> getWishlistByUser(int userId) {

        List<Product> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT p.* FROM wishlist w " +
                         "JOIN products p ON w.product_id = p.product_id " +
                         "WHERE w.user_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setCategory(rs.getString("category"));


                p.setImageUrl(rs.getString("image_url"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    @Override
    public boolean isInWishlist(int userId, int productId) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM wishlist WHERE user_id=? AND product_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}