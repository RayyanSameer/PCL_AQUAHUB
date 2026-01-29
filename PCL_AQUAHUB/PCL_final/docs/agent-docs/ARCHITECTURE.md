# Architecture Documentation - PCL_AQUAHUB

**Documentation Date**: 2026-01-29

## High-level architecture

Frontend (static HTML/JS/CSS)  ── HTTP ──▶  Flask backend (`backend/app.py`) ── SQL ──▶ PostgreSQL

- Frontend: static pages (no SPA framework). Pages include registration forms posting JSON with camelCase keys.
- Backend: Flask app provides REST endpoints for registration and user listing. Uses `psycopg2` with parameterized queries.
- Database: PostgreSQL with UUID primary keys and arrays (TEXT[] / INTEGER[]). Triggers ensure `updated_at` timestamps.

## Key components
- `backend/app.py` - Entry point for API. Important endpoints:
  - `GET /` - serves `index.html` (via `render_template`) — note: templates dir not found; server currently serves static pages from root folder.
  - `POST /api/register/customer`
  - `POST /api/register/vendor`
  - `GET /api/users`
- Database files: `database/schema.sql` and `create_database.sql`

## Data model highlights
- `users` table: id (UUID), email, password_hash, user_type ('customer'|'vendor')
- `customer_profiles`, `vendor_profiles`, `vendor_services`, `customer_water_requirements`
- Arrays used for availability and coverage - backend currently writes arrays as-is via parameterized queries

## Integrations & deployment
- `requirements.txt` lists Flask, flask-cors, psycopg2-binary, bcrypt, python-dotenv, gunicorn
- `procfile` present for deploying the Flask app (likely to Heroku or similar)

## Gaps & notes
- No templates directory present though `render_template('index.html')` used; Flask may be configured to find templates if files are arranged appropriately. Verify dev server serves static site correctly.
- No health endpoint exists — suggest adding `GET /api/health` to return DB connectivity status.

---
Recommendation: add a simple health check, add `.env.example`, add minimal tests, and ensure README's setup steps match actual commands (copy of `.env.example` into `backend/.env`).