package com.cartiva.dao.impl;

import java.sql.*;
import java.util.*;

import com.cartiva.dao.CartDAO;
import com.cartiva.model.Cart;
import com.cartiva.util.DBConnection;

public class CartDAOImpl implements CartDAO {

    @Override
    public boolean removeItem(int userId, int productId) {
        try (Connection con = DBConnection.getConnection()) {

            String sql = "DELETE ci FROM cart_items ci " +
                         "JOIN cart c ON ci.cart_id = c.cart_id " +
                         "WHERE c.user_id=? AND ci.product_id=?";

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
    public boolean updateQuantity(int userId, int productId, int change) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE cart_items ci " +
                         "JOIN cart c ON ci.cart_id = c.cart_id " +
                         "SET ci.quantity = ci.quantity + ? " +
                         "WHERE c.user_id=? AND ci.product_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, change);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            ps.executeUpdate();


            String deleteSql = "DELETE ci FROM cart_items ci " +
                               "JOIN cart c ON ci.cart_id = c.cart_id " +
                               "WHERE c.user_id=? AND ci.product_id=? AND ci.quantity <= 0";

            PreparedStatement ps2 = con.prepareStatement(deleteSql);
            ps2.setInt(1, userId);
            ps2.setInt(2, productId);
            ps2.executeUpdate();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean addToCart(int userId, int productId, int quantity) {

        try (Connection con = DBConnection.getConnection()) {

            int cartId = 0;


            String cartSql = "SELECT cart_id FROM cart WHERE user_id=?";
            PreparedStatement ps = con.prepareStatement(cartSql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cartId = rs.getInt("cart_id");
            } else {

                String insert = "INSERT INTO cart(user_id) VALUES(?)";
                PreparedStatement ps2 = con.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS);
                ps2.setInt(1, userId);
                ps2.executeUpdate();

                ResultSet rs2 = ps2.getGeneratedKeys();
                if (rs2.next()) cartId = rs2.getInt(1);
            }


            String check = "SELECT * FROM cart_items WHERE cart_id=? AND product_id=?";
            PreparedStatement ps3 = con.prepareStatement(check);
            ps3.setInt(1, cartId);
            ps3.setInt(2, productId);

            ResultSet rs3 = ps3.executeQuery();

            if (rs3.next()) {
                String update = "UPDATE cart_items SET quantity = quantity + ? WHERE cart_id=? AND product_id=?";
                PreparedStatement ps4 = con.prepareStatement(update);
                ps4.setInt(1, quantity);
                ps4.setInt(2, cartId);
                ps4.setInt(3, productId);
                ps4.executeUpdate();
            } else {
                String insertItem = "INSERT INTO cart_items(cart_id, product_id, quantity) VALUES(?,?,?)";
                PreparedStatement ps5 = con.prepareStatement(insertItem);
                ps5.setInt(1, cartId);
                ps5.setInt(2, productId);
                ps5.setInt(3, quantity);
                ps5.executeUpdate();
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Cart> getCartByUser(int userId) {

        List<Cart> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT ci.cart_item_id, p.product_id, p.name, p.price, ci.quantity " +
                         "FROM cart c " +
                         "JOIN cart_items ci ON c.cart_id = ci.cart_id " +
                         "JOIN products p ON ci.product_id = p.product_id " +
                         "WHERE c.user_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Cart c = new Cart();
                c.setCartId(rs.getInt("cart_item_id"));
                c.setProductId(rs.getInt("product_id"));
                c.setName(rs.getString("name"));
                c.setPrice(rs.getDouble("price"));
                c.setQuantity(rs.getInt("quantity"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Cart> getCartItemsByIds(int userId, String[] cartItemIds) {

        List<Cart> list = new ArrayList<>();
        List<Integer> selectedIds = normalizeCartItemIds(cartItemIds);

        if (selectedIds.isEmpty()) {
            return list;
        }

        StringJoiner placeholders = new StringJoiner(",");
        for (Integer ignored : selectedIds) {
            placeholders.add("?");
        }

        String sql = "SELECT ci.cart_item_id, p.product_id, p.name, p.price, ci.quantity " +
                     "FROM cart c " +
                     "JOIN cart_items ci ON c.cart_id = ci.cart_id " +
                     "JOIN products p ON ci.product_id = p.product_id " +
                     "WHERE c.user_id=? AND ci.cart_item_id IN (" + placeholders + ")";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            int index = 2;
            for (Integer id : selectedIds) {
                ps.setInt(index++, id);
            }

            System.out.println("CART QUERY RESULT SQL: " + sql);
            System.out.println("SELECTED IDS = " + selectedIds);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Cart c = new Cart();
                c.setCartId(rs.getInt("cart_item_id"));
                c.setProductId(rs.getInt("product_id"));
                c.setName(rs.getString("name"));
                c.setPrice(rs.getDouble("price"));
                c.setQuantity(rs.getInt("quantity"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void clearSelectedCartItems(int userId, String[] cartItemIds) {

        List<Integer> selectedIds = normalizeCartItemIds(cartItemIds);

        if (selectedIds.isEmpty()) {
            return;
        }

        StringJoiner placeholders = new StringJoiner(",");
        for (Integer ignored : selectedIds) {
            placeholders.add("?");
        }

        String sql = "DELETE ci FROM cart_items ci " +
                     "JOIN cart c ON ci.cart_id = c.cart_id " +
                     "WHERE c.user_id=? AND ci.cart_item_id IN (" + placeholders + ")";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            int index = 2;
            for (Integer id : selectedIds) {
                ps.setInt(index++, id);
            }

            int rows = ps.executeUpdate();
            System.out.println("CART ROWS DELETED: " + rows);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private List<Integer> normalizeCartItemIds(String[] cartItemIds) {
        List<Integer> ids = new ArrayList<>();
        Set<Integer> seen = new LinkedHashSet<>();

        if (cartItemIds == null) {
            return ids;
        }

        for (String rawId : cartItemIds) {
            if (rawId == null || rawId.trim().isEmpty()) {
                continue;
            }
            try {
                int id = Integer.parseInt(rawId.trim());
                if (id > 0 && seen.add(id)) {
                    ids.add(id);
                }
            } catch (NumberFormatException e) {
                System.out.println("IGNORING INVALID CART ITEM ID: " + rawId);
            }
        }

        return ids;
    }


    @Override
    public void clearCart(int userId) {

        try (Connection con = DBConnection.getConnection()) {


            String deleteItems =
                "DELETE ci FROM cart_items ci " +
                "JOIN cart c ON ci.cart_id = c.cart_id " +
                "WHERE c.user_id=?";

            PreparedStatement ps1 = con.prepareStatement(deleteItems);
            ps1.setInt(1, userId);
            ps1.executeUpdate();


            String deleteCart = "DELETE FROM cart WHERE user_id=?";
            PreparedStatement ps2 = con.prepareStatement(deleteCart);
            ps2.setInt(1, userId);
            ps2.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
