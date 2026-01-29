# Issues Found - PCL_AQUAHUB

**Analysis Date**: 2026-01-29

## Critical issues

### 1) No `.env.example` present in repo root
- Severity: 🔴 Critical (configuration missing for reproducible setup)
- Impact: Developers lack a canonical list of required environment variables
- Fix: Add `.env.example` with DB and app var names (I will add one).

### 2) No automated tests
- Severity: 🟠 High
- Impact: regressions are easy; adding at least a smoke test is advised
- Fix: Add minimal pytest-based integration test that verifies `GET /api/users` works with sample DB or a small test DB.

## High priority issues

### 1) No template for backend `.env` and secrets are referenced in README
- Severity: 🟠 High
- Fix: Create `.env.example` and update README accordingly.

### 2) Hardcoded defaults in `backend/app.py`
- Severity: 🟠 Medium
- Details: `DB_CONFIG` defaults to 'your_password' as DB_PASSWORD; prefer failing early and documentation.
- Fix: Use environment variables only and log clearer error when missing.

## Medium/Low

- No CI or Docker for reproducible runs.
- No test data runner script (though `database/sample_data.sql` exists).
- No health/ready endpoint (useful for monitoring); could add `GET /api/health`.
- The `index()` route calls `render_template('index.html')` but there is no `templates/` folder in the repo; this may raise `TemplateNotFound` in some execution environments. Consider serving the static `index.html` explicitly or adding a `templates/` folder.

## Security concerns

- No rate limiting or brute-force protection on auth endpoints.
- Email sending not implemented (README mentions contact forms) — not a security issue but notable.

---
Next action: create `.env.example` and add a smoke test and basic health endpoint.