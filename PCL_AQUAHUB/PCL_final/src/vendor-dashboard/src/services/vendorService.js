const db = require('../db/database');
const bcrypt = require('bcryptjs');

module.exports = {
  login: (email, password) => {
    const stmt = db.prepare('SELECT * FROM vendors WHERE email = ?');
    const vendor = stmt.get(email);
    if (!vendor) return null;
    const ok = bcrypt.compareSync(password, vendor.password_hash);
    if (!ok) return null;
    // do not return password_hash
    delete vendor.password_hash;
    return vendor;
  },

  getVendorById: (vendorId) => {
    const stmt = db.prepare('SELECT id, email, name, vehicle_type, total_earnings FROM vendors WHERE id = ?');
    return stmt.get(vendorId);
  },

  getEarnings: (vendorId) => {
    // Total earnings and delivery history
    const totalStmt = db.prepare('SELECT SUM(earnings) as total FROM deliveries WHERE vendor_id = ?');
    const totalRow = totalStmt.get(vendorId);
    const historyStmt = db.prepare(`SELECT d.id, d.order_id, d.vendor_id, d.delivered_at, d.earnings, o.order_type, o.delivery_address, u.name as client_name
      FROM deliveries d
      JOIN orders o ON o.id = d.order_id
      JOIN users u ON u.id = o.client_id
      WHERE d.vendor_id = ?
      ORDER BY d.delivered_at DESC LIMIT 50`);
    const history = historyStmt.all(vendorId);
    return {
      totalEarnings: totalRow ? totalRow.total || 0 : 0,
      deliveries: history
    };
  }
};