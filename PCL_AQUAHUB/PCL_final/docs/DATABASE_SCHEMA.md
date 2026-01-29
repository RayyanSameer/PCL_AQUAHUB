# Vendor Dashboard - Database Schema (SQLite)

DB file: `src/vendor-dashboard/aquahub_vendor.db`

Tables:

- vendors
  - id INTEGER PRIMARY KEY
  - email TEXT UNIQUE
  - password_hash TEXT
  - name TEXT
  - vehicle_type TEXT
  - total_earnings REAL DEFAULT 0

- users (clients)
  - id INTEGER PRIMARY KEY
  - name TEXT
  - email TEXT
  - phone TEXT
  - lat REAL
  - lng REAL

- orders
  - id INTEGER PRIMARY KEY
  - client_id INTEGER REFERENCES users(id)
  - vendor_id INTEGER REFERENCES vendors(id)
  - order_type TEXT
  - quantity INTEGER
  - price REAL
  - vendor_earnings REAL
  - delivery_address TEXT
  - delivery_lat REAL
  - delivery_lng REAL
  - status TEXT DEFAULT 'pending'  -- pending, accepted, in_transit, delivered
  - created_at DATETIME
  - delivered_at DATETIME

- deliveries
  - id INTEGER PRIMARY KEY
  - order_id INTEGER REFERENCES orders(id)
  - vendor_id INTEGER REFERENCES vendors(id)
  - delivered_at DATETIME
  - earnings REAL

Notes:
- Vendors receive 80% of order price as `vendor_earnings` (rounded to 2 decimals).
- Delivery history is stored in `deliveries` table for reporting and earnings aggregation.