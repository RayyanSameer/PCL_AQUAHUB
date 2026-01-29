import React from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'
import VendorLogin from './pages/vendor/VendorLogin'
import VendorDashboard from './pages/vendor/VendorDashboard'
import VendorOrders from './pages/vendor/VendorOrders'
import VendorOrderDetail from './pages/vendor/VendorOrderDetail'

function App() {
  return (
    <Routes>
      <Route path="/vendor/login" element={<VendorLogin />} />
      <Route path="/vendor/dashboard" element={<VendorDashboard />} />
      <Route path="/vendor/orders" element={<VendorOrders />} />
      <Route path="/vendor/order/:orderId" element={<VendorOrderDetail />} />
      <Route path="/" element={<Navigate to="/vendor/login" replace />} />
    </Routes>
  )
}

export default App
