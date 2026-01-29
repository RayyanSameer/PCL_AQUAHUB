# Agent Handoff Guide - PCL_AQUAHUB

**For**: Any coding agent (Bolt, Replit, ChatGPT, Gemini, Claude, etc.)
**Date**: 2026-01-29
**Previous Agent**: GitHub Copilot

## What's in this repo (short)
A simple static frontend with a Flask backend supporting customer & vendor registration using PostgreSQL.

## What I did ✅
- Added `.github/copilot-instructions.md` with agent guidance
- Created `docs/agent-docs/` with analysis, PRD, issues, architecture, fixes, tests, decision log, and continuation roadmap
- Added `.env.example` and a basic health endpoint (`GET /api/health`)
- Added minimal smoke tests (`tests/test_smoke.py`) and included `pytest` in `backend/requirements.txt`
- Implemented a self-contained Vendor Dashboard module (Node + SQLite + React) in `src/vendor-dashboard/` with migrations, seeds, server routes, client pages and a docs guide (`docs/VENDOR_DASHBOARD_SETUP.md`)

## How to continue (next steps)
1. Ensure PostgreSQL is running and seed DB with `database/sample_data.sql`.
2. Run `python backend/app.py` and confirm `http://localhost:5000/api/health` returns 200.
3. Implement CI (GitHub Actions) to run smoke tests on PRs.
4. Add more tests (registration flows, DB integration) and a `backend/.env.example` copy.

## Helpful commands
- Install deps: `pip install -r backend/requirements.txt`
- Run app: `python backend/app.py`
- Run tests: `pytest -q`

If anything is unclear, look at `docs/agent-docs/STATE_OF_REPO.md` and `CONTINUATION_ROADMAP.md` for precise next steps.