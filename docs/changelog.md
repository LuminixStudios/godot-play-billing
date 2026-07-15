# Changelog
All notable changes to this project will be documented in this file.

## [1.4.0] - 2026-06-20
### Changes
- Migrated to Godot 4.7.0.
- Updated Google Play Billing Library to v9.1.0.

## [1.3.2] - 2026-05-26
### Fixed
- Resolved an integer type casting issue between Kotlin and GDScript, improving type compatibility and data handling across the Android plugin bridge.

## [1.3.1] - 2026-01-28
### Changed
- Migrated plugin to Godot 4.6.

## [1.3.0] - 2026-01-22
### Changed
- Updated Google Play Billing Library to 8.3.0
- Added `enable_auto_service_connection` parameter to `start_connection()` (default: `true`)

### Fixed
- Improved billing service reconnect handling