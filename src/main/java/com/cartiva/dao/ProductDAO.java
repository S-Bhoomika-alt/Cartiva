package com.cartiva.dao;

import java.util.List;
import com.cartiva.model.Product;

public interface ProductDAO {

    boolean addProduct(Product product);

    Product getProductById(int productId);

    List<Product> getAllProducts();

    List<Product> getProductsByCategory(String category);


    java.util.List<Product> getProducts(String keyword, String category, String sort, int offset, int limit);


    int getProductsCount(String keyword, String category);


    List<Product> sortByPrice();

    boolean updateProduct(Product product);

    boolean updateStock(int productId, int quantity);

    boolean deleteProduct(int productId);
    List<Product> searchProducts(String keyword, String category);
    List<Product> getLowStockProducts();
}