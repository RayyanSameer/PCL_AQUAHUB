# Engineering Decisions Log - PCL_AQUAHUB

## 2026-01-29 - Add .env.example and health endpoint
**Context**: Missing a canonical `.env.example` and no health endpoint makes automated setups fragile.
**Decision**: Add `.env.example` to repo root and add `GET /api/health` endpoint returning DB connectivity status.
**Reasoning**: Improves setup reproducibility and makes smoke testing possible.
**Implications**: Tests can rely on health endpoint; update README to document usage.

---
Record future decisions here with date, context, options considered, and reasoning.