const Database = require('better-sqlite3');
const db = new Database('aquahub_vendor.db');

// Enable foreign keys
db.pragma('foreign_keys = ON');

module.exports = db;