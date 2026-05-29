package com.cartiva.model;

import java.math.BigDecimal;

import java.time.LocalDateTime;


public class Order {

    private int orderId;
    private int userId;
    private BigDecimal totalAmount;
    private String status;
    private int deliverySlotId;
    private String address;
    private LocalDateTime orderDate;
    private String paymentMode;
    private String refundStatus;

    public Order() {}

    public Order(int orderId, int userId, BigDecimal totalAmount, String status,
                 int deliverySlotId, String address, LocalDateTime orderDate) {
        this.orderId = orderId;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.status = status;
        this.deliverySlotId = deliverySlotId;
        this.address = address;
        this.orderDate = orderDate;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getDeliverySlotId() { return deliverySlotId; }
    public void setDeliverySlotId(int deliverySlotId) { this.deliverySlotId = deliverySlotId; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

    public String getRefundStatus() {
        return refundStatus;
    }

    public void setRefundStatus(String refundStatus) {
        this.refundStatus = refundStatus;
    }


}


