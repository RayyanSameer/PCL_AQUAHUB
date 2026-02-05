# PCL_AQUAHUB Flutter Conversion

This directory will contain the Flutter Android app port of the PCL_AQUAHUB web project. Do not modify files in the original `PCL_AQUAHUB/` repository.

Follow the design and behavior from the web app; all colors, fonts, spacing and interactions will be replicated precisely.

See `docs/WEB_APP_ANALYSIS.md` in the original repo for reference.

## Current progress
- Implemented typed API client (`DioApiService`) and `Health` screen to verify backend connectivity.
- Implemented Customer registration form (`/register`) and provider with tests.
- Implemented Vendor login (`/vendor-login`) and a basic dashboard screen (orders + fleet) with providers and tests.
- Next: improve error handling, add more integration tests and CI.

## Quick navigation
- Health screen: home (default)
- Registration: visit `/register` route
- Vendor login: visit `/vendor-login` route
