const fs = require('fs');
const path = require('path');

const dbPath = path.join(__dirname, '..', '..', '..', 'aquahub_vendor.db');

try {
  if (fs.existsSync(dbPath)) {
    fs.unlinkSync(dbPath);
    console.log('Removed existing DB file.');
  }
} catch (err) {
  console.error('Error removing DB file:', err);
}

// Run migrations and seed
require('../migrations/001_create_vendor_tables');
require('./mock_data');

console.log('Database reset and seeded.');