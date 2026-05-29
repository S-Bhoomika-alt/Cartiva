package com.cartiva.dao;

import java.util.List;
import com.cartiva.model.Subscription;

public interface SubscriptionDAO {

    boolean addSubscription(int userId, int productId, int quantity, String frequency);

    List<Subscription> getSubscriptionsByUser(int userId);

    boolean cancelSubscription(int subscriptionId);

    boolean updateSubscription(int subscriptionId, int quantity, String frequency);


    boolean isAlreadySubscribed(int userId, int productId);
}