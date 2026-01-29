import React, { useEffect, useState } from 'react'
import vendorClient from '../../utils/vendorClient'

export default function VendorDashboard() {
  const [vendor, setVendor] = useState(null)
  const [earnings, setEarnings] = useState({ totalEarnings: 0, deliveries: [] })

  useEffect(() => {
    const v = JSON.parse(localStorage.getItem('vendor'))
    if (v) {
      setVendor(v)
      loadEarnings(v.id)
    }
  }, [])

  const loadEarnings = async (vendorId) => {
    try {
      const res = await vendorClient.get(`/vendor/${vendorId}/earnings`)
      setEarnings(res.data)
    } catch (err) {
      console.error(err)
    }
  }

  return (
    <div className="vendor-dashboard">
      <h2>Dashboard</h2>
      {vendor ? (
        <div>
          <h3>Welcome, {vendor.name}</h3>
          <div className="stats">
            <div className="card">
              <h4>Total Earnings</h4>
              <p>${earnings.totalEarnings || 0}</p>
            </div>
            <div className="card">
              <h4>Total Deliveries</h4>
              <p>{earnings.deliveries.length}</p>
            </div>
          </div>

          <h3>Recent Deliveries</h3>
          <table className="deliveries-table">
            <thead>
              <tr>
                <th>Date</th>
                <th>Client</th>
                <th>Order Type</th>
                <th>Address</th>
                <th>Earnings</th>
              </tr>
            </thead>
            <tbody>
              {earnings.deliveries.map((d) => (
                <tr key={d.id}>
                  <td>{new Date(d.delivered_at).toLocaleString()}</td>
                  <td>{d.client_name}</td>
                  <td>{d.order_type}</td>
                  <td>{d.delivery_address}</td>
                  <td>${d.earnings}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <p>Not logged in</p>
      )}
    </div>
  )
}