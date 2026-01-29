# Product Requirements Document - PCL_AQUAHUB

**Extracted Date**: 2026-01-29
**Source**: `README.md`, other markdown files in repo

## Application overview
AquaHub is a water delivery and management platform connecting customers with vendors. It supports user registration for customers and vendors, storing customer water requirements and vendor services, and provides static marketing pages and dashboards.

## Core features (extracted)

### User registration (customer)
- Description: Register customers with contact and address details, optional water requirements.
- Critical fields: `email`, `password`, `firstName`, `lastName`, `phone`, `address`, `city`, `state`, `postalCode`.
- Implementation status: ✅ Implemented in `backend/app.py` (`POST /api/register/customer`).
- Location: `backend/app.py`, DB tables: `users`, `customer_profiles`, `customer_water_requirements`.

### Vendor registration
- Description: Register vendor business profile, services, and capacities.
- Critical fields: `email`, `password`, `businessName`, `contactPersonName`, `phone`, `businessAddress`, `city`, `state`, `postalCode`.
- Implementation status: ✅ Implemented in `backend/app.py` (`POST /api/register/vendor`).
- Location: `backend/app.py`, DB tables: `users`, `vendor_profiles`, `vendor_services`.

### Admin / User listing (testing)
- Endpoint: `GET /api/users` returns users with joined profile display.
- Status: ✅ Implemented.

## User flows (high level)

### Flow: Customer registration
1. User fills registration form (frontend) with camelCase fields.
2. Frontend posts JSON to `POST /api/register/customer`.
3. Backend validates, hashes password with bcrypt, inserts records into `users` and `customer_profiles`, optional `customer_water_requirements`.
4. Returns success with `userId` (UUID).

### Flow: Vendor registration
1. Vendor posts JSON to `POST /api/register/vendor`.
2. Backend creates user and vendor profile, inserts services if provided.
3. Returns success with `userId`.

## Non-functional requirements
- Uses PostgreSQL with UUIDs and `uuid-ossp` extension enabled.
- Passwords must be hashed using `bcrypt`.

---
This PRD covers what is discoverable in the repository. I will now run a code analysis to find issues and missing items.