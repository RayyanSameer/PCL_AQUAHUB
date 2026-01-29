// Seed DB with vendors, users (clients), and orders
const db = require('../database');
const bcrypt = require('bcryptjs');

function insertVendor(email, name, vehicle) {
  const pwHash = bcrypt.hashSync('vendor123', 8);
  const stmt = db.prepare('INSERT OR IGNORE INTO vendors (email, password_hash, name, vehicle_type) VALUES (?, ?, ?, ?)');
  stmt.run(email, pwHash, name, vehicle);
}

function insertUser(name, email, phone, lat, lng) {
  const stmt = db.prepare('INSERT INTO users (name, email, phone, lat, lng) VALUES (?, ?, ?, ?, ?)');
  const info = stmt.run(name, email, phone, lat, lng);
  return info.lastInsertRowid;
}

function insertOrder(client_id, vendor_id, order_type, quantity, price, address, lat, lng, status='pending') {
  const vendor_earnings = Math.round(price * 0.8 * 100) / 100;
  const stmt = db.prepare(`INSERT INTO orders (client_id, vendor_id, order_type, quantity, price, vendor_earnings, delivery_address, delivery_lat, delivery_lng, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`);
  const info = stmt.run(client_id, vendor_id, order_type, quantity, price, vendor_earnings, address, lat, lng, status);
  return info.lastInsertRowid;
}

// Create vendors
insertVendor('john@vendor.com', 'John Vendor', 'Truck');
insertVendor('sara@vendor.com', 'Sara Vendor', 'Van');
insertVendor('mike@vendor.com', 'Mike Vendor', 'Motorcycle');
insertVendor('lisa@vendor.com', 'Lisa Vendor', 'Truck');
insertVendor('tom@vendor.com', 'Tom Vendor', 'Van');

// Create clients (San Francisco range approx 37.7-37.8, -122.5 to -122.4)
const clients = [];
clients.push(insertUser('Alice Client', 'alice@example.com', '555-0001', 37.7749, -122.4194));
clients.push(insertUser('Bob Client', 'bob@example.com', '555-0002', 37.7765, -122.4241));
clients.push(insertUser('Carol Client', 'carol@example.com', '555-0003', 37.7700, -122.4313));
clients.push(insertUser('David Client', 'david@example.com', '555-0004', 37.7833, -122.4090));
clients.push(insertUser('Eve Client', 'eve@example.com', '555-0005', 37.7690, -122.4469));

// Create orders: 3 pending (no vendor_id), 1 accepted (vendor 1), 1 delivered (vendor 1)
insertOrder(clients[0], null, 'Water Delivery', 5000, 120.00, '100 Market St', 37.7936, -122.3950, 'pending');
insertOrder(clients[1], null, 'Maintenance', 1, 80.00, '200 Mission St', 37.7880, -122.4016, 'pending');
insertOrder(clients[2], null, 'Emergency Repair', 1, 200.00, '300 Castro St', 37.7600, -122.4350, 'pending');
// accepted by vendor id 1 (John)
insertOrder(clients[3], 1, 'Water Delivery', 3000, 60.00, '400 Folsom St', 37.7840, -122.4012, 'accepted');
// delivered by vendor id 1
const deliveredOrderId = insertOrder(clients[4], 1, 'Water Delivery', 2000, 50.00, '500 Valencia St', 37.7599, -122.4211, 'delivered');

// Add delivery record
const delStmt = db.prepare('INSERT INTO deliveries (order_id, vendor_id, earnings) VALUES (?, ?, ?)');
delStmt.run(deliveredOrderId, 1, Math.round(50.00 * 0.8 * 100) / 100);

console.log('Seed data inserted.');