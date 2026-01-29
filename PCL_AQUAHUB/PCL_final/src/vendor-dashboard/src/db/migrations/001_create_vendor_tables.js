// Run this script with: node src/db/migrations/001_create_vendor_tables.js
const db = require('../database');

const createTables = `
CREATE TABLE IF NOT EXISTS vendors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE,
  password_hash TEXT,
  name TEXT,
  vehicle_type TEXT,
  total_earnings REAL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  email TEXT,
  phone TEXT,
  lat REAL,
  lng REAL
);

CREATE TABLE IF NOT EXISTS orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id INTEGER,
  vendor_id INTEGER,
  order_type TEXT,
  quantity INTEGER,
  price REAL,
  vendor_earnings REAL,
  delivery_address TEXT,
  delivery_lat REAL,
  delivery_lng REAL,
  status TEXT DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  delivered_at DATETIME,
  FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS deliveries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id INTEGER,
  vendor_id INTEGER,
  delivered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  earnings REAL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE
);
`;

try {
  db.exec(createTables);
  console.log('Tables created (or already exist).');
} catch (err) {
  console.error('Error creating tables:', err);
  process.exit(1);
}