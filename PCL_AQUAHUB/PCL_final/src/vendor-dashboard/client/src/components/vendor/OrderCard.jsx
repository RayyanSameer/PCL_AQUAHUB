import React from 'react'

export default function OrderCard({ order, onAccept, onDecline, onNavigate }) {
  return (
    <div className="order-card">
      <h4>Order #{order.id}</h4>
      <p><strong>Client:</strong> {order.client_name}</p>
      <p><strong>Phone:</strong> {order.client_phone}</p>
      <p><strong>Address:</strong> {order.delivery_address}</p>
      <p><strong>Type:</strong> {order.order_type}</p>
      <p><strong>Qty:</strong> {order.quantity}</p>
      <p><strong>Price:</strong> ${order.price} <small>(You: ${order.vendor_earnings})</small></p>
      <div className="card-actions">
        <button className="accept" onClick={onAccept}>Accept</button>
        <button className="decline" onClick={onDecline}>Decline</button>
        <button className="navigate" onClick={onNavigate}>Navigate</button>
      </div>
    </div>
  )
}