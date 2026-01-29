# Vendor Dashboard - Testing Checklist

## Setup
1. From repo root, `cd src/vendor-dashboard`
2. `npm install` (installs server dependencies)
3. `npm run db:setup` (creates `aquahub_vendor.db` and seeds mock data)
4. `npm run dev` (starts server at `http://localhost:4000`)
5. In `src/vendor-dashboard/client`, `npm install` and `npm run dev` (starts Vite dev server, default :5173)

## Manual Tests
- [ ] `GET http://localhost:4000/api/ping` returns `{ status: 'ok' }`
- [ ] `GET http://localhost:4000/api/orders/pending` returns the pending orders (3 items)
- [ ] `POST http://localhost:4000/api/orders/:orderId/accept` with `{ vendorId: 1 }` accepts an order
- [ ] `POST http://localhost:4000/api/orders/:orderId/complete` with `{ vendorId: 1 }` marks as delivered and creates delivery record
- [ ] `GET http://localhost:4000/api/vendor/1/earnings` reflects totals and recent delivery

## E2E Tests (Cypress)
- Setup: Ensure server and client are running
  - Server: `cd src/vendor-dashboard && npm run test:e2e:server` (this resets DB and starts the API server)
  - Client: `cd src/vendor-dashboard/client && npm run dev` (Vite server)
- Run Cypress UI: `cd src/vendor-dashboard/client && npm run e2e`
- Run headless: `cd src/vendor-dashboard/client && npm run e2e:run`
- The E2E test `vendor_flow.cy.js` performs a full vendor flow: login, accept order, navigate, mark delivered, and verifies earnings update.

## Frontend checks
- [ ] Navigate to `/vendor/login` on the Vite dev server and login with `john@vendor.com` / `vendor123`
- [ ] Dashboard displays total earnings and delivery history
- [ ] Orders page shows 3 pending orders and Accept/Decline works
- [ ] Order detail shows map and Mark as Delivered updates dashboard

## Notes
- Google Maps requires an API key; replace `YOUR_API_KEY` in `client/index.html` for route display.
- If geolocation is denied, the map will place a destination marker and allow route rendering fallback.
