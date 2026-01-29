# Complete Web Application Analysis

## Technology Stack
- Frontend Framework: Static HTML/CSS/JavaScript (no SPA framework for main site)
  - Version: N/A (static files)
  - State Management: None (main site uses local component/DOM state & localStorage)
  - Routing: Static page routes (e.g., `index.html`, `login.html`, `buyer-dashboard.html`) with one optional SPA (vendor React client under `src/vendor-dashboard/client`)
  - Styling: Plain CSS files (e.g., `styles.css`, page-specific CSS files like `payment.css`, `login.css`). Fonts: Poppins (Google Fonts).
- Vendor Dashboard (local simulation): React (Vite) client
  - Version: (see `src/vendor-dashboard/client/package.json` for exact deps)
  - State Management: React local state / context (client-side)
  - Routing: React Router (client uses SPA routing)
  - HTTP client: axios
- Backend Framework: Flask (Python)
  - Key libs: psycopg2, bcrypt, Flask extensions (flask-cors etc.)
- Database: PostgreSQL (main app) + SQLite for `src/vendor-dashboard` simulation
- Authentication: Passwords hashed with bcrypt; endpoints for customer/vendor registration/login exist (session/token details may need verification)
- Maps Integration: Google Maps (used in vendor UI & maps pages); API key required in `src/vendor-dashboard/client/index.html` and in docs
- HTTP Client (web pages): fetch/XHR in plain JS for the main app; vendor React uses axios
- Package Managers:
  - Python packages: pip, virtualenv (`aquahub_env`) with `requirements.txt`
  - Node packages: npm/yarn for `src/vendor-dashboard` (server + React client)

---

## Directory Structure (high level)
```
PCL_AQUAHUB/
├── PCL_final/                      # main web app
│   ├── backend/                    # Flask API
│   │   ├── app.py
│   │   ├── requirements.txt
│   │   └── .env.example
│   ├── database/                   # SQL schema + sample data
│   │   ├── schema.sql
│   │   ├── create_database.sql
│   │   └── sample_data.sql
│   ├── src/                        # vendor-dashboard (node + react simulation)
│   │   └── vendor-dashboard/
│   │       ├── server/             # Express server + sqlite seeds/migrations
│   │       └── client/             # React (Vite) app
│   ├── assets/                     # images and media
│   ├── index.html                  # Landing page
│   ├── login.html                  # Login (customer/vendor)
│   ├── buyer-dashboard.html        # Customer dashboard
│   ├── vendor-dashboard.html       # Vendor dashboard (static) - also has SPA alternative
│   ├── vendor-available-customers.html
│   ├── vendor-fleet.html
│   ├── vendor-order-detail.html
│   ├── payment.html
│   ├── script.js                   # Main site JS
│   └── styles.css                  # Global styles
└── docs/                           # docs, tests, agent notes
```

(See repo `README.md`, `docs/` and `docs/agent-docs/` for more detailed tree and developer notes.)

---

## Application Architecture

### User Roles Identified
1. Customer Role
   - Can: register/login, place orders (select tanker, quantity, delivery address), view order history, track orders on map, access account/profile settings, make payments, use contact form
   - Cannot: access vendor dashboards, accept/assign orders
   - Screens: `index.html`, `login.html?type=customer`, `buyer-dashboard.html`, `payment.html`, order tracking pages

2. Vendor Role
   - Can: vendor login, view pending available orders, accept/assign orders, manage fleet/trucks, mark deliveries completed, view earnings
   - Cannot: place customer orders
   - Screens: `login.html?type=vendor`, `vendor-dashboard.html`, `vendor-available-customers.html`, `vendor-order-detail.html`, `vendor-fleet.html`

3. Admin Role (not present as a full role in current repo)
   - May be implicit via DB/sql scripts but no explicit admin UI was found

---

## Complete Screen Inventory (mapped to files)

### Customer Screens
1. Splash / Landing Screen
   - Route: `index.html`
   - File: `PCL_final/index.html`
   - Purpose: Marketing landing, app download CTA, hero, testimonials, FAQ
   - Elements: hero CTA (customer/vendor), app download, footer, header navigation
   - Actions: Navigate to `login.html` with type, contact form

2. Customer Login Screen
   - Route: `login.html?type=customer`
   - File: `PCL_final/login.html` (+ `login.js`, styles in `login.css`)
   - Form fields: email/phone, password
   - Buttons: Login, Forgot, Register
   - Validation: client-side checks in `login.js`
   - API Endpoint(s): registration endpoints exist in backend (`/api/register/customer`), login flow implemented in `login.js` to redirect to dashboards

3. Customer Registration Screen
   - Route: `login.html` (signup flows embedded) / dedicated registration modals
   - File: `login.html`, `script.js` handles registration actions
   - API: `POST /api/register/customer`

4. Customer Dashboard / Home
   - Route: `buyer-dashboard.html`
   - File: `PCL_final/buyer-dashboard.html`
   - Sections: header, order history, quick order buttons, nav
   - Actions: Place order, view/tracking

5. Order Placement / Tanker Selection
   - Route: Customer flows accessible via `buyer-dashboard.html` and modals
   - Files: `script.js` handles tanker selection / order flows; `payment.html` handles payment
   - Known Bug: UI shows "0 tankers found" message despite tankers listing — selection/order button sometimes non-functional (observed and already addressed in conversion plan)

6. Order Confirmation
   - Route: `payment.html` and confirmation flows triggered by `script.js` / `payment.js`
   - File: `PCL_final/payment.html`, `payment.js`

7. Order History / My Orders
   - Route: `buyer-dashboard.html` (history list)
   - File: `buyer-dashboard.html`

8. Order Tracking
   - Route: vendor-assigned/ delivery tracking pages (`vendor-order-detail.html`) and map components
   - Files: `vendor-order-detail.html`, `vendor-order-detail.js` (vendor-facing map and completion flow)

9. Profile / Account Settings
   - Route: accessible from dashboards; files are fragments in `buyer-dashboard.html` / `login.js`

### Vendor Screens
1. Vendor Login
   - Route: `login.html?type=vendor`
   - File: `login.html` + vendor JS checks

2. Vendor Dashboard
   - Route: `vendor-dashboard.html`
   - File: `vendor-dashboard.html` (+ `vendor-dashboard.js`)
   - Elements: stats, quick actions, list of assigned orders

3. Vendor Orders List
   - Route: `vendor-available-customers.html` (available/pending orders) and vendor dashboard
   - File: `vendor-available-customers.html`, `vendor-available.js`
   - Actions: Accept/Decline, view details

4. Vendor Order Detail
   - Route: `vendor-order-detail.html`
   - File: `vendor-order-detail.html`, `vendor-order-detail.js`
   - Actions: Start delivery, mark complete, navigation (Google Maps), contact customer

5. Vendor Earnings
   - Route: Part of `vendor-dashboard.html` and vendor micro-UI
   - File: `vendor-dashboard.html`

---

## Data Models (observed / inferred)

### User Model (auth):
- `users` table: id (uuid/int), email, password_hash (bcrypt), created_at
- Related: `customer_profiles`, `vendor_profiles` with profile details (name, phone, address, lat/lng)

### Order Model (observed fields):
- id (uuid), client_id, vendor_id, tanker_id, quantity, price, vendor_earnings, delivery_address, delivery_lat, delivery_lng, status (pending|accepted|in_transit|delivered), created_at, accepted_at, delivered_at

### Tanker Model (used in tanker listing):
- id, name, capacity, price_per_unit, available, vendor_id, image_url

### Vendor Truck / Fleet Model (newer additions)
- `vendor_trucks`: id, vendor_id, truck_name, capacity_liters, is_dispatched, total_earnings

(See `database/schema.sql` for full schemas and indices.)

---

## API Endpoints (mapped from `backend/app.py`)

### Authentication / Registration
- POST `/api/register/customer` — register new customer
- POST `/api/register/vendor` — register new vendor

### Health / Dev
- GET `/api/health` — health check & DB connectivity
- GET `/api/users` — list users (dev)

### Vendor / Orders / Fleet
- POST `/api/vendor/login` — vendor login
- GET `/api/orders/available` — available orders for vendors
- POST `/api/orders/<order_id>/assign` — assign order to vendor/truck
- GET `/api/vendor/<vendor_profile_id>/orders` — vendor orders list
- GET `/api/vendor/<vendor_profile_id>/fleet` — vendor's fleet/trucks
- POST `/api/vendor/<vendor_profile_id>/trucks` — add a truck
- GET `/api/orders/<order_id>` — get order detail
- POST `/api/orders/<order_id>/complete` — mark order delivered and insert into `deliveries`
- GET/PUT/DELETE `/api/trucks/<truck_id>` — truck CRUD

### Customer APIs (inferred / implemented elsewhere)
- GET `/api/tankers` — get tankers (observed in front-end requests)
- POST `/api/orders` — create order
- GET `/api/orders/user/<user_id>` — get orders for a user

Note: Some endpoints are implemented in the Node vendor-simulation module (src/vendor-dashboard/server) for local testing; these are separate from Flask endpoints.

---

## State Management Flow
- Main site: mostly local DOM-driven state + localStorage/sessionStorage for user session and UI toggles.
- Vendor React client: React local state and context; API calls via axios to vendor server or Flask backend depending on workflow.
- Global state slice candidates for Flutter conversion: authentication, current order selection, tanker list, vendor/fleet state, notifications/errors, loading states.

---

## Navigation Flow (simplified)
- Landing (index.html)
  - Customer -> Login -> Buyer Dashboard -> Tanker Selection -> Order Confirmation -> Payment -> Tracking
  - Vendor -> Login -> Vendor Dashboard -> Available Orders -> Order Detail -> Start/Complete delivery -> Earnings/Fleet

---

## UI / UX Patterns
- Color scheme (from README & CSS): primary blue `#007bff`, gradient `#667eea` → `#764ba2`, background `#f8f9fa`, text `#333`
- Typography: Poppins family (weights: 300–700)
- Spacing system: consistent CSS variables and utility classes across pages
- Components: Buttons, cards, CTA hero, accordions (FAQ), toasts/snackbars for feedback
- Animations: CSS transitions for hover, expand/collapse (FAQ) and some SVG water animations on the landing page

---

## Animation Inventory (high-level)
- Hero SVG water animation (landing)
- FAQ accordion expand/collapse
- Hover states for cards and media logos
- Page transitions are primarily simple scroll/anchor-driven

---

## Third-Party Integrations
- Google Maps: used in vendor order detail and navigation; API key referenced in docs and in `src/vendor-dashboard/client/index.html`
- Payments: `payment.html` exists; provider not explicitly embedded in repo (check `payment.js` for integration details)
- Email/contact: contact form uses backend or mail server via Flask (verify in `backend/app.py`)

---

## Tests & Tooling
- Backend: pytest smoke test exists (`tests/test_smoke.py`) and the project contains other pytest tests added by agent (e.g., tests/test_orders.py)
- E2E: Cypress tests for vendor dashboard are present under `src/vendor-dashboard/client/cypress`
- Dev servers: Flask runs on `http://localhost:5000`; vendor simulation server runs on `http://localhost:4000`; React client runs on `:5173` (Vite)

---

## Known Issues & Notes (important for conversion)
- The main web site is static HTML/CSS/JS — it will require careful component mapping for a Flutter port (no single component tree to translate). The vendor dashboard has an SPA in React which is easier to port component-by-component.
- Auth flow details (token vs session) require additional verification on the running server; code shows bcrypt for hashing but token handling needs confirmation.
- Google Maps usage requires the Android API key placement for Flutter (AndroidManifest) and may require enabling billing for route features.
- Payment provider details are not explicit — check `payment.js` and backend for provider-specific endpoints/keys before implementing payments in Flutter.

---

## Next verification steps before coding (Phase 1 completion checklist)
1. Confirm authentication mechanism: session cookie vs JWT (inspect `backend/app.py` auth handlers on running server).
2. Confirm payment gateway provider and test credentials in the repo or deploy environment.
3. List all API response shapes (sample JSON) by running backend locally and hitting endpoints (`/api/tankers`, `/api/orders/available`, `/api/vendor/login`, etc.).
4. Extract exact CSS color variables, font sizes, and spacing units used in `styles.css` and page-specific css files for pixel-perfect Flutter theming.
5. Decide whether vendor-sim `src/vendor-dashboard` will be used as mock API during Flutter development (recommended for local offline testing).

---

## Summary
This repository is a hybrid: a static marketing and customer-facing web app (HTML/CSS/JS) + a Flask/PostgreSQL backend that implements the APIs and data persistence. A fully-featured vendor simulation SPA (React + Express + SQLite) exists for local vendor workflow testing. For a faithful Flutter Android conversion, we should:
- Create a separate Flutter project `PCL_AQUAHUB_FLUTTER/` (do not modify existing files)
- Recreate UI precisely using `AppColors`, `AppTextStyles`, and layout sizes extracted from CSS
- Implement API layer that talks to Flask endpoints; use vendor-sim server for mock data when useful
- Verify and implement payment and Google Maps integrations with Android-specific configuration

---

**Deliverable**: This file is the authoritative web-app analysis to use before creating any Flutter code.

If you want, I can now (phase-by-phase):
- Extract exact color hex codes and typography variables from CSS files next, or
- Generate the initial Flutter project skeleton (ensuring it's created outside `PCL_AQUAHUB/`).

Which would you like to do next?