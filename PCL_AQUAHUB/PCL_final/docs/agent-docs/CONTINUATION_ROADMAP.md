# Continuation Roadmap - PCL_AQUAHUB

**For Next Agent**: Short, prioritized tasks to continue work.

## PRIORITY 1: Get the app connected and smoke tests passing 🔴
- Objective: Ensure PostgreSQL is running locally and `GET /api/health` returns 200.
- Steps:
  1. Start PostgreSQL and create `aquahub_db` using `database/create_database.sql`.
  2. Apply schema: `database/schema.sql` and `database/sample_data.sql`.
  3. Copy `.env.example` to `backend/.env` and set DB credentials.
  4. Activate venv and run `python backend/app.py`.
  5. Run `pytest -q`.
- Success: `GET /api/health` returns 200 and tests pass.

## PRIORITY 2: Add health-check based CI job 🟠
- Objective: Add a GitHub Actions workflow that runs the Flask app and executes smoke tests.
- Steps:
  1. Create `.github/workflows/ci.yml` with job to setup Python, start a PostgreSQL service, install deps, run migrations, and run `pytest`.

## PRIORITY 3: Improve error handling & config 💡
- Add better DB error messages when env vars missing.
- Fail fast if required env vars are not set.

## PRIORITY 4: Add basic auth endpoints & tests 🟡
- Add login endpoint and minimal tests for authentication flows.

## Short-term quick wins
- Add `README` section describing `GET /api/health` and testing steps.
- Add `backend/.env.example` copy in `backend/` for easier local use.

---
Choose tasks in order and open PRs per small fix. Document assumptions in `ASSUMPTIONS.md` when making choices.