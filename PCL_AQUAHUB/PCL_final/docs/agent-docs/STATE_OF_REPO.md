# Current Repository State - PCL_AQUAHUB

**Last Updated**: 2026-01-29
**Updated By**: GitHub Copilot

## Quick Start
### Prerequisites
- Python 3.x
- PostgreSQL

### Installation
1. (Optional) Use provided venv: `aquahub_env\Scripts\activate` (Windows)
2. Install backend deps: `pip install -r backend/requirements.txt`
3. Create database and schema in psql (see `database/` SQL files)
4. Copy `.env.example` to `.env` and update credentials: `copy .env.example backend\.env` and edit as needed

### Run Application
```bash
# Start backend
aquahub_env\Scripts\activate
python backend\app.py
# Backend runs on http://0.0.0.0:5000
```

### Run Tests
```bash
pip install -r backend/requirements.txt
pytest -q
```

## What Works ✅
- Customer and vendor registration endpoints (basic flows)
- `GET /api/users` for listing users
- Static frontend pages are present

## What's Missing / Broken ❌
- No comprehensive automated tests (only smoke test added)
- No CI, Docker, or deployment pipeline
- No email/SMS configured

## Next recommended steps
1. Confirm `.env` values and start PostgreSQL locally
2. Run `database/create_database.sql`, `database/schema.sql`, `database/sample_data.sql`
3. Run smoke tests: `pytest -q`

---
This file is intended as a quick onboarding reference for an agent or human to get the project running locally.