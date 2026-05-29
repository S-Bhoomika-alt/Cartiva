package com.cartiva.dao.impl;

import java.sql.*;

import java.util.*;

import com.cartiva.dao.ProductDAO;
import com.cartiva.model.Product;
import com.cartiva.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.cartiva.model.Product;
import com.cartiva.util.DBConnection;

public class ProductDAOImpl implements ProductDAO {


    @Override
    public boolean addProduct(Product product) {

        String sql = "INSERT INTO products (name, description, price, unit, stock_quantity, category, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setString(4, product.getUnit());
            ps.setInt(5, product.getStockQuantity());
            ps.setString(6, product.getCategory());
            ps.setString(7, product.getImageUrl());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public List<Product> getAllProducts() {

        List<Product> products = new ArrayList<>();

        try {

            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM products";

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                Product p = new Product();

                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setUnit(rs.getString("unit"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setCategory(rs.getString("category"));
                p.setImageUrl(rs.getString("image_url"));

                products.add(p);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return products;
    }


    @Override
    public List<Product> getProducts(String keyword, String category, String sort, int offset, int limit) {

        List<Product> products = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            StringBuilder sql = new StringBuilder();
            sql.append("SELECT p.* FROM products p ");
            sql.append("LEFT JOIN (SELECT product_id, AVG(rating) AS avg_rating FROM reviews GROUP BY product_id) rv ON p.product_id = rv.product_id ");
            sql.append("LEFT JOIN (SELECT product_id, SUM(quantity) AS total_sold FROM order_items GROUP BY product_id) oi ON p.product_id = oi.product_id ");
            sql.append("WHERE 1=1 ");

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND p.name LIKE ? ");
            }

            if (category != null && !category.trim().isEmpty()) {
                sql.append(" AND p.category = ? ");
            }


            String orderBy = " ORDER BY p.product_id DESC ";

            if ("highest_rated".equals(sort)) {
                orderBy = " ORDER BY COALESCE(rv.avg_rating,0) DESC ";
            } else if ("best_seller".equals(sort)) {
                orderBy = " ORDER BY COALESCE(oi.total_sold,0) DESC ";
            } else if ("price_asc".equals(sort)) {
                orderBy = " ORDER BY p.price ASC ";
            } else if ("price_desc".equals(sort)) {
                orderBy = " ORDER BY p.price DESC ";
            } else if ("newest".equals(sort)) {
                orderBy = " ORDER BY p.product_id DESC ";
            }

            sql.append(orderBy);
            sql.append(" LIMIT ? OFFSET ?");

            PreparedStatement ps = conn.prepareStatement(sql.toString());

            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
            }

            if (category != null && !category.trim().isEmpty()) {
                ps.setString(idx++, category);
            }

            ps.setInt(idx++, limit);
            ps.setInt(idx++, offset);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                Product p = extractProduct(rs);
                products.add(p);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public int getProductsCount(String keyword, String category) {
        int count = 0;
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT COUNT(*) AS cnt FROM products p WHERE 1=1 ";
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql += " AND p.name LIKE ? ";
            }
            if (category != null && !category.trim().isEmpty()) {
                sql += " AND p.category = ? ";
            }

            PreparedStatement ps = conn.prepareStatement(sql);
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
            }
            if (category != null && !category.trim().isEmpty()) {
                ps.setString(idx++, category);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt("cnt");

        } catch(Exception e){ e.printStackTrace(); }
        return count;
    }

    @Override
    public Product getProductById(int productId) {

        String sql = "SELECT * FROM products WHERE product_id = ?";
        Product p = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p = extractProduct(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }


    @Override
    public List<Product> sortByPrice() {

        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY price ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    @Override
    public List<Product> getProductsByCategory(String category) {

        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, category);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    @Override
    public boolean updateProduct(Product product) {

        String sql = "UPDATE products SET name=?, description=?, price=?, unit=?, stock_quantity=?, category=?, image_url=? WHERE product_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setString(4, product.getUnit());
            ps.setInt(5, product.getStockQuantity());
            ps.setString(6, product.getCategory());
            ps.setString(7, product.getImageUrl());
            ps.setInt(8, product.getProductId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean updateStock(int productId, int quantity) {

        String sql =
                "UPDATE products " +
                "SET stock_quantity = GREATEST(COALESCE(stock_quantity,0) + ?, 0) " +
                "WHERE product_id=? " +
                "AND (? >= 0 OR COALESCE(stock_quantity,0) >= ABS(?))";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setInt(4, quantity);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean deleteProduct(int productId) {

        String sql = "DELETE FROM products WHERE product_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    private Product extractProduct(ResultSet rs) throws Exception {

        Product p = new Product();

        p.setProductId(rs.getInt("product_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setUnit(rs.getString("unit"));
        p.setStockQuantity(rs.getInt("stock_quantity"));
        p.setCategory(rs.getString("category"));
        p.setImageUrl(rs.getString("image_url"));

        return p;
    }

    @Override
    public List<Product> searchProducts(String keyword, String category) {

        List<Product> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM products WHERE 1=1";

            if (keyword != null && !keyword.isEmpty()) {
                sql += " AND name LIKE ?";
            }

            if (category != null && !category.isEmpty()) {
                sql += " AND category = ?";
            }

            PreparedStatement ps = con.prepareStatement(sql);

            int index = 1;

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            if (category != null && !category.isEmpty()) {
                ps.setString(index++, category);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setCategory(rs.getString("category"));
                p.setStockQuantity(rs.getInt("stock_quantity"));
                p.setImageUrl(rs.getString("image_url"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    @Override
    public List<Product> getLowStockProducts() {

        List<Product> list = new ArrayList<>();

        try {

            Connection conn = DBConnection.getConnection();

            String sql =
            		"SELECT * FROM products " +
                    "WHERE COALESCE(stock_quantity,0) <= 10 " +
                    "ORDER BY stock_quantity ASC, name ASC";
            PreparedStatement ps =
                conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                Product p = extractProduct(rs);

                list.add(p);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
