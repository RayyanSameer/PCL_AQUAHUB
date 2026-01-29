# Testing Guide - PCL_AQUAHUB

## Automated tests
- No tests exist initially. Add pytest for backend and a minimal test that verifies `GET /api/users` and `GET /api/health` (after adding health endpoint).

## Manual testing checklist
- DB setup: run `database/create_database.sql`, `database/schema.sql`, `database/sample_data.sql` in psql
- Start backend: `aquahub_env\Scripts\activate` then `python backend\app.py`
- Smoke tests:
  - `GET http://localhost:5000/api/health` - should return status and DB connectivity
  - `GET http://localhost:5000/api/users` - should return seeded users
  - `POST /api/register/customer` and `POST /api/register/vendor` - ensure validation messages appear on missing required fields

## Test data
- `database/sample_data.sql` contains sample entries for testing.

---
Next step: add a small pytest-based test file to `tests/` to run basic smoke checks.