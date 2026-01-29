const db = require('../db/database');

module.exports = {
  getPendingOrders: () => {
    const stmt = db.prepare(`SELECT o.*, u.name as client_name, u.phone as client_phone FROM orders o JOIN users u ON u.id = o.client_id WHERE o.status = 'pending' ORDER BY o.created_at DESC`);
    return stmt.all();
  },

  getVendorOrders: (vendorId) => {
    const stmt = db.prepare(`SELECT o.*, u.name as client_name, u.phone as client_phone FROM orders o JOIN users u ON u.id = o.client_id WHERE o.vendor_id = ? AND o.status IN ('accepted', 'in_transit') ORDER BY o.created_at DESC`);
    return stmt.all(vendorId);
  },

  getOrderById: (orderId) => {
    const stmt = db.prepare(`SELECT o.*, u.name as client_name, u.phone as client_phone FROM orders o JOIN users u ON u.id = o.client_id WHERE o.id = ?`);
    return stmt.get(orderId);
  },

  acceptOrder: (orderId, vendorId) => {
    // set vendor_id and status to accepted
    const order = db.prepare('SELECT * FROM orders WHERE id = ?').get(orderId);
    if (!order) return false;
    const update = db.prepare('UPDATE orders SET vendor_id = ?, status = ? WHERE id = ?');
    const info = update.run(vendorId, 'accepted', orderId);
    return info.changes > 0;
  },

  declineOrder: (orderId) => {
    // For now, set status back to 'pending' and vendor_id null (if assigned)
    const upd = db.prepare('UPDATE orders SET vendor_id = NULL, status = ? WHERE id = ?');
    const info = upd.run('pending', orderId);
    return info.changes > 0;
  },

  completeDelivery: (orderId, vendorId) => {
    const order = db.prepare('SELECT * FROM orders WHERE id = ?').get(orderId);
    if (!order) return false;
    const now = new Date().toISOString();
    const upd = db.prepare('UPDATE orders SET status = ?, delivered_at = ? WHERE id = ?');
    const uinfo = upd.run('delivered', now, orderId);
    const earnings = order.vendor_earnings || Math.round(order.price * 0.8 * 100) / 100;
    const ins = db.prepare('INSERT INTO deliveries (order_id, vendor_id, earnings) VALUES (?, ?, ?)');
    ins.run(orderId, vendorId, earnings);
    // update vendor total_earnings
    const updVendor = db.prepare('UPDATE vendors SET total_earnings = total_earnings + ? WHERE id = ?');
    updVendor.run(earnings, vendorId);
    return true;
  }
};