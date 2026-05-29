


USE cartiva;


ALTER TABLE reviews
  ADD UNIQUE KEY uq_reviews_user_product (user_id, product_id);

CREATE INDEX idx_reviews_product_created
  ON reviews (product_id, created_at DESC, review_id DESC);

CREATE INDEX idx_reviews_user
  ON reviews (user_id);


ALTER TABLE cart
  ADD UNIQUE KEY uq_cart_user_product (user_id, product_id);

ALTER TABLE wishlist
  ADD UNIQUE KEY uq_wishlist_user_product (user_id, product_id);


CREATE INDEX idx_orders_user_date
  ON orders (user_id, order_date DESC);

CREATE INDEX idx_orders_status_date
  ON orders (status, order_date DESC);

CREATE INDEX idx_order_items_order_product
  ON order_items (order_id, product_id);


CREATE INDEX idx_subscriptions_user_product
  ON subscriptions (user_id, product_id);

CREATE INDEX idx_subscriptions_next_delivery
  ON subscriptions (next_delivery_date);
