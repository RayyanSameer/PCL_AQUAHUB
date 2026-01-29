import React, { useEffect, useState } from 'react'
import orderClient from '../../utils/orderClient'
import OrderCard from '../../components/vendor/OrderCard'

export default function VendorOrders() {
  const [orders, setOrders] = useState([])

  useEffect(() => {
    loadPending()
  }, [])

  const loadPending = async () => {
    try {
      const res = await orderClient.get('/pending')
      setOrders(res.data.orders)
    } catch (err) {
      console.error(err)
    }
  }

  const onAccept = async (orderId) => {
    const vendor = JSON.parse(localStorage.getItem('vendor'))
    await orderClient.post(`/` + orderId + `/accept`, { vendorId: vendor.id })
    loadPending()
  }

  const onDecline = async (orderId) => {
    await orderClient.post(`/` + orderId + `/decline`)
    loadPending()
  }

  const onNavigate = (order) => {
    // open order detail page
    window.location.href = `/vendor/order/${order.id}`
  }

  return (
    <div className="vendor-orders">
      <h2>Pending Orders</h2>
      <div className="orders-grid">
        {orders.map((o) => (
          <OrderCard key={o.id} order={o} onAccept={() => onAccept(o.id)} onDecline={() => onDecline(o.id)} onNavigate={() => onNavigate(o)} />
        ))}
      </div>
    </div>
  )
}