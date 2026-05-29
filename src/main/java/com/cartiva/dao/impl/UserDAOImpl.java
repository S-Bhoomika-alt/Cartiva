package com.cartiva.dao.impl;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.cartiva.dao.UserDAO;
import com.cartiva.model.User;
import com.cartiva.util.DBConnection;
import com.cartiva.util.PasswordUtil;

public class UserDAOImpl implements UserDAO {

	@Override
	public boolean updateUser(User user) {

	    try {
	        Connection conn = DBConnection.getConnection();

	        String sql = "UPDATE users SET full_name=?, phone=?, address_line1=?, address_line2=?, city=?, state=?, pincode=?, country=? WHERE user_id=?";

	        PreparedStatement ps = conn.prepareStatement(sql);

	        ps.setString(1, user.getFullName());
	        ps.setString(2, user.getPhone());
	        ps.setString(3, user.getAddressLine1());
	        ps.setString(4, user.getAddressLine2());
	        ps.setString(5, user.getCity());
	        ps.setString(6, user.getState());
	        ps.setString(7, user.getPincode());
	        ps.setString(8, user.getCountry());
	        ps.setInt(9, user.getUserId());

	        return ps.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}

    @Override
    public User loginUser(String email, String password) {

        if (email == null || password == null) return null;

        try (Connection conn = DBConnection.getConnection()) {

            if (conn == null) {
                System.out.println("DB connection is null in loginUser");
                return null;
            }

            String sql = "SELECT * FROM users WHERE email = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {

                        return null;
                    }

                    String storedHash = rs.getString("password");

                    String providedHash = PasswordUtil.hashPassword(password);

                    if (!providedHash.equals(storedHash)) {
                        throw new RuntimeException("INVALID_PASSWORD");
                    }

                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setPassword(storedHash);
                    user.setAddressLine1(rs.getString("address_line1"));
                    user.setAddressLine2(rs.getString("address_line2"));
                    user.setCity(rs.getString("city"));
                    user.setState(rs.getString("state"));
                    user.setPincode(rs.getString("pincode"));
                    user.setCountry(rs.getString("country"));
                    user.setRole(rs.getString("role"));

                    System.out.println("LOGGED USER ROLE = " + user.getRole());

                    return user;
                }
            }

        } catch (RuntimeException re) {

            throw re;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean updatePasswordByEmail(String email, String newPassword) {

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE users SET password=? WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);


            ps.setString(1, PasswordUtil.hashPassword(newPassword));

            ps.setString(2, email);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public User getUserById(int userId) { return null; }

    @Override
    public User getUserByEmail(String email) {
        if (email == null) return null;

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return null;

            String sql = "SELECT * FROM users WHERE email = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) return null;

                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setPassword(rs.getString("password"));
                    user.setAddressLine1(rs.getString("address_line1"));
                    user.setAddressLine2(rs.getString("address_line2"));
                    user.setCity(rs.getString("city"));
                    user.setState(rs.getString("state"));
                    user.setPincode(rs.getString("pincode"));
                    user.setCountry(rs.getString("country"));
                    user.setRole(rs.getString("role"));

                    return user;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public User getUserByPhone(String phone) { return null; }


    @Override
    public boolean updatePassword(int userId, String newPassword) {

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE users SET password=? WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);


            ps.setString(1, PasswordUtil.hashPassword(newPassword));
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean emailExists(String email) {
        if (email == null) return false;

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;

            String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean phoneExists(String phone) {
        if (phone == null) return false;

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) return false;

            String sql = "SELECT 1 FROM users WHERE phone = ? LIMIT 1";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, phone);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public java.util.List<User> getAllUsers() {

        java.util.List<User> users =
        new java.util.ArrayList<>();

        try {

            Connection conn =
            DBConnection.getConnection();

            String sql =
            "SELECT * FROM users ORDER BY user_id";

            PreparedStatement ps =
            conn.prepareStatement(sql);

            ResultSet rs =
            ps.executeQuery();

            while(rs.next()) {

                User user = new User();

                user.setUserId(
                    rs.getInt("user_id")
                );

                user.setFullName(
                    rs.getString("full_name")
                );

                user.setEmail(
                    rs.getString("email")
                );

                user.setRole(
                    rs.getString("role")
                );

                users.add(user);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return users;
    }
    @Override
    public boolean registerUser(User user) {

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO users (full_name, email, phone, password, address_line1, address_line2, city, state, pincode, country) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());


            ps.setString(4, PasswordUtil.hashPassword(user.getPassword()));

            ps.setString(5, user.getAddressLine1());
            ps.setString(6, user.getAddressLine2());
            ps.setString(7, user.getCity());
            ps.setString(8, user.getState());
            ps.setString(9, user.getPincode());
            ps.setString(10, user.getCountry());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}