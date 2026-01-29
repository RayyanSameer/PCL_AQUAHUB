# Codebase Analysis

## Tech Stack
- Frontend: Static HTML/CSS/JS across repository (no React app present)
- Backend: Flask (Python) in `backend/app.py` exposing register endpoints and user listing
- Database: PostgreSQL SQL scripts in `database/` (no Node/SQLite used)
- Routing: No SPA router in repo; Flask serves pages and static files

## Directory Structure (relevant)
- `PCL_final/`
  - `backend/` — Flask app (`app.py`), `requirements.txt`
  - `database/` — `create_database.sql`, `schema.sql`, `sample_data.sql`
  - `assets/`, `index.html`, `script.js`, `styles.css`
  - `docs/agent-docs/` — analysis and developer docs (added)

## Existing Features
- Customer and vendor registration endpoints implemented in `backend/app.py` using psycopg2 and bcrypt
- Database schema provided for PostgreSQL, with UUIDs and array types
- Static frontend pages for marketing and vendor dashboards (HTML/CSS/JS)

## Integration Points
- New vendor-mgmt dashboard will be added as a self-contained Node+React module under `src/vendor-dashboard/` so it does not interfere with existing Flask backend.
- It will use a local SQLite DB (better-sqlite3) for simulation and will expose REST endpoints from an Express server.

## Plan For Vendor Dashboard
- Add a small Node app at `src/vendor-dashboard/` with:
  - `server/` (Express API)
  - `db/` (better-sqlite3 migrations & seeds)
  - `client/` (React + Vite minimal app with requested pages and components)

This file will be used as the basis for creating migration, seeds, services, and frontend pages for the vendor dashboard.