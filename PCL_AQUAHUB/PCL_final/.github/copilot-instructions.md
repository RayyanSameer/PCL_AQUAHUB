# AquaHub — Copilot Instructions

These instructions are written to help AI coding agents be productive quickly in this repository.
Keep changes small and focused; prefer edits to existing files over large refactors without an issue or tests.

## Big picture (what this repo is)
- Frontend: static HTML/CSS/JS under the repo root (e.g. `index.html`, `script.js`, `styles.css`, `assets/`). No frontend framework.
- Backend: a small Flask service in `backend/app.py` that exposes a few REST endpoints for registration and user listing.
- Database: PostgreSQL schema under `database/` (creates DB, schema and sample data). SQL is used directly (no ORM).

## Architectural notes (important patterns)
- Database access uses `psycopg2` with raw SQL and `RealDictCursor`. Changes to the schema must be reflected in SQL strings in `backend/app.py`.
- IDs are UUIDs (schema uses `uuid_generate_v4()`); creation scripts enable the `uuid-ossp` extension (`database/create_database.sql`).
- Passwords are hashed using `bcrypt` (see `hash_password` / `verify_password` in `backend/app.py`).
- `user_type` is a discriminant column (`'customer'` or `'vendor'`) and many other tables link via `user_id` / `customer_id` / `vendor_id`.
- Vendor and customer records use PostgreSQL arrays (e.g., `TEXT[]`, `INTEGER[]`). Keep serialization consistent when reading/writing these fields.
- There is no test suite present. Prefer adding small, isolated tests or an integration smoke test when changing endpoints.

## How to run locally (developer workflows)
- Recommended Python environment: use the included virtual environment (`aquahub_env/`) or `python -m venv` and install `backend/requirements.txt`.
- Quick start (Windows, repo root):
  1. `setup.bat` (automates some setup when present).
  2. Run DB scripts in `psql`:
     - `\i database/create_database.sql` then `\i database/schema.sql` then `\i database/sample_data.sql`.
  3. Copy `.env` example into backend: `copy backend\.env.example backend\.env` and set DB credentials.
  4. Activate environment: `aquahub_env\Scripts\activate` and run `python backend\app.py` (server runs on port 5000).
- Production: `backend/requirements.txt` includes `gunicorn` and there is a `procfile` for deployment. Prefer using `gunicorn` with workers for production.

## Useful commands & places to look
- App entry: `backend/app.py` (endpoints of interest: `POST /api/register/customer`, `POST /api/register/vendor`, `GET /api/users`).
- DB scripts: `database/create_database.sql`, `database/schema.sql`, `database/sample_data.sql` — ensure `uuid-ossp` extension is available.
- Environment: `backend/.env.example` (copy and fill as `backend/.env`).
- Install deps: `pip install -r backend/requirements.txt`.

## Project-specific conventions and examples
- Request payloads (JS frontend -> backend) use camelCase field names (e.g., `firstName`, `lastName`, `postalCode`) while DB columns use snake_case. Map carefully in code and SQL.
  - Example: `data['firstName']` -> `customer_profiles.first_name` in `backend/app.py`.
- Use raw SQL with parameterized queries (psycopg2 `%s` placeholders) — follow the existing pattern and avoid string interpolation.
- For arrays, send JSON arrays in requests; the backend writes them directly into `TEXT[]` or `INTEGER[]` columns (see `vendor_profiles.service_areas` and `vendor_services.coverage_areas`).
- When adding new migration-like changes, update `database/schema.sql` and include a short `CHANGELOG` entry so reviewers can run the SQL locally.

## Safety & tests
- There are no automated tests; small changes should include a manual integration note (how to exercise endpoints via `curl` or a small Python script) and, when possible, add pytest-based smoke tests.
- A basic health endpoint (`GET /api/health`) and a smoke test (`tests/test_smoke.py`) have been added; run `pytest -q` after installing dependencies to verify smoke checks.
- When touching authentication or password code, run manual checks against the sample data and ensure `bcrypt` hashes verify correctly.

## What to avoid
- Don’t introduce an ORM without a migration plan — the codebase expects raw SQL and existing SQL scripts.
- Avoid large JS framework migrations; the frontend is intentionally simple static assets.

## Good first tasks for automated agents
- Add a small `tests/` directory with a minimal integration test that spins up the Flask app and verifies `GET /api/users` returns the seeded users.
- Add a `backend/.env.example` if missing and document required variables in `README.md` (DB_HOST, DB_NAME, DB_USER, DB_PASSWORD, DB_PORT).

---
If anything in these instructions is unclear or you'd like more detail (examples, tests, or a proposed smoke test), tell me which area to expand and I will iterate. ✅