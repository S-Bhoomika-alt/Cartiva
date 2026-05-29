package com.cartiva.dao;

public interface AdminStatsDAO {

    int getTotalUsers();

    int getTotalProducts();

    int getTotalOrders();

    double getTotalRevenue();

    double getDailyRevenue();

    double getMonthlyRevenue();

    double getSubscriptionRevenue();

    int getLowStockProducts();

    int getOutOfStockProducts();

    int getTotalWishlistItems();

    int getTotalSubscriptions();
}
