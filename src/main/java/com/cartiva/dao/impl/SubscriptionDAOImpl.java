package com.cartiva.dao.impl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.cartiva.dao.SubscriptionDAO;
import com.cartiva.model.Subscription;
import com.cartiva.util.DBConnection;

public class SubscriptionDAOImpl implements SubscriptionDAO {


    @Override
    public boolean isAlreadySubscribed(int userId, int productId) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT * FROM subscriptions WHERE user_id=? AND product_id=? AND status='ACTIVE'";
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


    @Override
    public boolean addSubscription(int userId, int productId, int quantity, String frequency) {

        try (Connection con = DBConnection.getConnection()) {


            if (isAlreadySubscribed(userId, productId)) {
                return false;
            }

            String sql = "INSERT INTO subscriptions (user_id, product_id, quantity, frequency, start_date, status) " +
                         "VALUES (?, ?, ?, ?, CURDATE(), 'ACTIVE')";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setString(4, frequency);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public List<Subscription> getSubscriptionsByUser(int userId) {

        List<Subscription> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT s.*, p.name, p.price " +
                         "FROM subscriptions s " +
                         "JOIN products p ON s.product_id = p.product_id " +
                         "WHERE s.user_id=? AND s.status='ACTIVE'";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Subscription sub = new Subscription();

                sub.setSubscriptionId(rs.getInt("subscription_id"));
                sub.setUserId(rs.getInt("user_id"));
                sub.setProductId(rs.getInt("product_id"));
                sub.setQuantity(rs.getInt("quantity"));
                sub.setFrequency(rs.getString("frequency"));
                sub.setStartDate(rs.getDate("start_date").toLocalDate());
                sub.setStatus(rs.getString("status"));

                sub.setProductName(rs.getString("name"));
                sub.setPrice(rs.getDouble("price"));

                list.add(sub);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    @Override
    public boolean cancelSubscription(int subscriptionId) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE subscriptions SET status='CANCELLED' WHERE subscription_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, subscriptionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean updateSubscription(int subscriptionId, int quantity, String frequency) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE subscriptions SET quantity=?, frequency=? WHERE subscription_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, quantity);
            ps.setString(2, frequency);
            ps.setInt(3, subscriptionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}