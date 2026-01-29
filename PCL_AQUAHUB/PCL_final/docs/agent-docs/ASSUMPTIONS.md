# Assumptions Made - PCL_AQUAHUB

**Document Purpose**: Track assumptions made while analyzing and updating repo. Mark [VERIFY] items that need confirmation.

- ASSUMPTION: The backend is meant to be run from the `PCL_final` directory and serves the static frontend. [VERIFY]
- ASSUMPTION: PostgreSQL is used in development on localhost:5432 (per README). [IMPLEMENTED]
- ASSUMPTION: Developers will use included `aquahub_env` virtualenv or create their own venv. [IMPLEMENTED]
- ASSUMPTION: No automated tests exist initially; minimal pytest tests are acceptable. [IMPLEMENTED]
- ASSUMPTION: Email/SMS integrations are not configured and should be stubbed or logged to console in development. [VERIFY]

---
Update this file when you make choices or before making ambiguous decisions.