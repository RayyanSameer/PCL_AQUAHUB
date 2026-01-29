# Vendor Dashboard - Setup & Run

This module is a local simulation for vendor management (Node + SQLite + React).

## Steps
1. Server setup
   - cd `src/vendor-dashboard`
   - npm install
   - npm run db:setup
   - npm run dev (starts Express server on port 4000)

2. Client setup
   - cd `src/vendor-dashboard/client`
   - npm install
   - npm run dev (starts Vite on default :5173)

3. Open `http://localhost:5173` and login at `/vendor/login`.

## Notes
- API server defaults to `http://localhost:4000`.
- Google Maps API key must be set in `src/vendor-dashboard/client/index.html`.
- The SQLite DB will be created as `src/vendor-dashboard/aquahub_vendor.db`.
- All vendor passwords in seed: `vendor123` (hashed with bcryptjs).
