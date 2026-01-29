import React, { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import orderClient from '../../utils/orderClient'
import GoogleMapNavigation from '../../components/vendor/GoogleMapNavigation'

export default function VendorOrderDetail() {
  const { orderId } = useParams()
  const [order, setOrder] = useState(null)
  const navigate = useNavigate()

  useEffect(() => {
    load()
  }, [orderId])

  const load = async () => {
    try {
      const res = await orderClient.get('/' + orderId)
      setOrder(res.data.order)
    } catch (err) {
      console.error(err)
    }
  }

  const markDelivered = async () => {
    const vendor = JSON.parse(localStorage.getItem('vendor'))
    await orderClient.post('/' + orderId + '/complete', { vendorId: vendor.id })
    navigate('/vendor/dashboard')
  }

  if (!order) return <div>Loading...</div>

  return (
    <div className="order-detail">
      <h2>Order #{order.id}</h2>
      <p>Client: {order.client_name} - {order.client_phone}</p>
      <p>Address: {order.delivery_address}</p>
      <p>Type: {order.order_type}</p>
      <p>Quantity: {order.quantity}</p>
      <p>Price: ${order.price} (You earn ${order.vendor_earnings})</p>

      <div style={{ height: 400 }}>
        <GoogleMapNavigation dest={{ lat: order.delivery_lat, lng: order.delivery_lng }} />
      </div>

      <button onClick={markDelivered} className="accept">Mark as Delivered</button>
    </div>
  )
}