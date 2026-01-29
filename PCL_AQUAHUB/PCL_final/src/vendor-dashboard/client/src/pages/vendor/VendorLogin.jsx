import React, { useState } from 'react'
import axios from 'axios'
import { useNavigate } from 'react-router-dom'

export default function VendorLogin() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState(null)
  const navigate = useNavigate()

  const onSubmit = async (e) => {
    e.preventDefault()
    try {
      const res = await axios.post('http://localhost:4000/api/vendor/login', { email, password })
      const vendor = res.data.vendor
      localStorage.setItem('vendor', JSON.stringify(vendor))
      navigate('/vendor/dashboard')
    } catch (err) {
      console.error(err)
      setError(err.response?.data?.error || 'Login failed')
    }
  }

  return (
    <div className="vendor-login">
      <h2>Vendor Login</h2>
      <form onSubmit={onSubmit}>
        <div>
          <label>Email</label>
          <input value={email} onChange={(e) => setEmail(e.target.value)} />
        </div>
        <div>
          <label>Password</label>
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
        </div>
        {error && <div className="error">{error}</div>}
        <button type="submit">Login</button>
      </form>
    </div>
  )
}